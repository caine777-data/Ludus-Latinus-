"""
Éditeur de code Tkinter autonome : numéros de ligne, coloration
syntaxique, et confort d'édition (auto-fermeture, indentation de bloc,
commentaire rapide).
"""

import keyword
import re
import tkinter as tk

_KW = set(keyword.kwlist)
_BUILTINS = {
    "print", "len", "range", "int", "str", "float", "bool", "list", "dict",
    "set", "tuple", "sum", "min", "max", "input", "open", "sorted",
    "enumerate", "zip", "map", "filter", "abs", "round", "type", "isinstance",
    "super", "all", "any", "Path", "json", "math", "random", "os", "sys",
}
_RE_WORD = re.compile(r"\b[A-Za-z_]\w*\b")
_RE_NUM = re.compile(r"\b\d+\.?\d*\b")
_RE_STR = re.compile(r"(['\"])(?:\\.|(?!\1).)*\1")
_RE_DEF = re.compile(r"^\s*(def|class)\s+(\w+)")


class CodeEditor(tk.Frame):
    def __init__(self, master, font, on_change=None, on_syntax=None, **kw):
        super().__init__(master, **kw)
        self.font = font
        self.on_change = on_change
        self.on_syntax = on_syntax
        self._popup = None
        self._C = None

        self.gutter = tk.Text(self, width=4, padx=6, takefocus=0, border=0,
                              state="disabled", font=font, cursor="arrow")
        self.gutter.pack(side=tk.LEFT, fill=tk.Y)

        self.text = tk.Text(self, wrap="none", relief="flat", font=font,
                            padx=8, pady=8, undo=True, border=0)
        self.scroll = tk.Scrollbar(self, orient="vertical", command=self._yview)
        self.text.configure(yscrollcommand=self._on_scroll)
        self.scroll.pack(side=tk.RIGHT, fill=tk.Y)
        self.text.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.text.bind("<KeyRelease>", self._on_key)
        self.text.bind("<ButtonRelease-1>", self._maj_ligne_courante)
        self.text.bind("<Return>", self._on_return)
        self.text.bind("<Tab>", self._on_tab)
        self.text.bind("<Shift-Tab>", self._on_shift_tab)
        try:
            self.text.bind("<ISO_Left_Tab>", self._on_shift_tab)
        except Exception:
            pass
        self.text.bind("<Control-slash>", self._on_comment)
        self.text.bind("<Control-space>", self._autocomplete)
        self.text.bind("<Control-f>", self.toggle_search)
        self.text.bind("<Control-F>", self.toggle_search)
        for o, c in [("(", ")"), ("[", "]"), ("{", "}")]:
            self.text.bind(o, self._auto_pair(o, c))
        for q in ("\"", "'"):
            self.text.bind(q, self._auto_pair(q, q))

        self._search_bar = None
        self._search_matches = []
        self._search_idx = -1

    # ----- contenu
    def get(self):
        return self.text.get("1.0", "end-1c")

    def set_text(self, code):
        self.text.delete("1.0", tk.END)
        self.text.insert("1.0", code)
        self.text.edit_reset()
        self.highlight()
        self._update_gutter()
        self._verifier_syntaxe()
        self._maj_ligne_courante()

    def focus_editor(self):
        self.text.focus_set()

    # ----- thème & police
    def apply_theme(self, C):
        self._C = C
        self.configure(bg=C["editor"])
        self.text.configure(bg=C["editor"], fg=C["fg"], insertbackground=C["fg"],
                            selectbackground=C["accent"])
        self.gutter.configure(bg=C["code_bg"], fg=C["muted"])
        self.gutter.tag_configure("gutter_active", foreground=C["accent"])
        self.text.tag_configure("kw", foreground=C["kw"])
        self.text.tag_configure("builtin", foreground=C["builtin"])
        self.text.tag_configure("num", foreground=C["num"])
        self.text.tag_configure("deff", foreground=C["deff"])
        self.text.tag_configure("str", foreground=C["str"])
        self.text.tag_configure("com", foreground=C["com"])
        self.text.tag_configure("errline", underline=True, foreground=C["err"])
        self.text.tag_configure("pasapas", background=C["accent"], foreground=C["sel_fg"])
        self.text.tag_configure("search_match", background=C.get("code_bg", "#343746"), foreground=C.get("code", "#ffd479"))
        self.text.tag_configure("search_current", background=C.get("accent", "#4d8bf0"), foreground=C.get("sel_fg", "#ffffff"))
        self.text.tag_configure("curline", background=C.get("curline", C["code_bg"]))
        self.text.tag_lower("curline")  # sous la coloration et les autres surlignages
        if self._search_bar:
            self._search_bar.configure(bg=C.get("panel", "#272935"))
            self._search_entry.configure(bg=C.get("editor", "#15161c"), fg=C.get("fg", "#ffffff"), insertbackground=C.get("fg", "#ffffff"))
            self._search_lbl_count.configure(bg=C.get("panel", "#272935"), fg=C.get("muted", "#9aa0b4"))
        self.highlight()
        self._maj_ligne_courante()

    def toggle_search(self, _e=None):
        """Ouvre ou focalise la barre de recherche dans l'éditeur (Ctrl+F)."""
        if self._search_bar is None:
            self._build_search_bar()
        self._search_bar.pack(side=tk.TOP, fill=tk.X, before=self.text)
        self._search_entry.focus_set()
        self._search_entry.select_range(0, tk.END)
        self._on_search_query()
        return "break"

    def _build_search_bar(self):
        C = self._C or {}
        bar = tk.Frame(self, bg=C.get("panel", "#272935"), padx=8, pady=4)
        lbl = tk.Label(bar, text="🔍", bg=C.get("panel", "#272935"), fg=C.get("muted", "#9aa0b4"))
        lbl.pack(side=tk.LEFT, padx=(0, 4))
        self._search_var = tk.StringVar()
        entry = tk.Entry(bar, textvariable=self._search_var, bg=C.get("editor", "#15161c"),
                         fg=C.get("fg", "#ffffff"), insertbackground=C.get("fg", "#ffffff"),
                         relief="flat", font=self.font)
        entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=4, ipady=2)

        lbl_count = tk.Label(bar, text="", bg=C.get("panel", "#272935"), fg=C.get("muted", "#9aa0b4"),
                             font=(self.font.cget("family"), 9))
        lbl_count.pack(side=tk.LEFT, padx=6)

        btn_prev = tk.Button(bar, text="▲", command=self._find_prev, relief="flat",
                             bg=C.get("panel", "#272935"), fg=C.get("fg", "#ffffff"),
                             activebackground=C.get("curline", "#343746"), activeforeground=C.get("fg", "#ffffff"),
                             padx=4, pady=0)
        btn_prev.pack(side=tk.LEFT, padx=1)

        btn_next = tk.Button(bar, text="▼", command=self._find_next, relief="flat",
                             bg=C.get("panel", "#272935"), fg=C.get("fg", "#ffffff"),
                             activebackground=C.get("curline", "#343746"), activeforeground=C.get("fg", "#ffffff"),
                             padx=4, pady=0)
        btn_next.pack(side=tk.LEFT, padx=1)

        btn_close = tk.Button(bar, text="✕", command=self._close_search, relief="flat",
                              bg=C.get("panel", "#272935"), fg=C.get("muted", "#9aa0b4"),
                              activebackground=C.get("curline", "#343746"), activeforeground=C.get("err", "#ff5555"),
                              padx=4, pady=0)
        btn_close.pack(side=tk.LEFT, padx=(4, 0))

        self._search_bar = bar
        self._search_entry = entry
        self._search_lbl_count = lbl_count
        self._search_var.trace_add("write", self._on_search_query)
        entry.bind("<Return>", lambda e: self._find_next())
        entry.bind("<Shift-Return>", lambda e: self._find_prev())
        entry.bind("<Escape>", lambda e: self._close_search())

    def _close_search(self):
        if self._search_bar:
            self._search_bar.pack_forget()
        self.text.tag_remove("search_match", "1.0", "end")
        self.text.tag_remove("search_current", "1.0", "end")
        self._search_matches = []
        self._search_idx = -1
        self.text.focus_set()

    def _on_search_query(self, *args):
        self.text.tag_remove("search_match", "1.0", "end")
        self.text.tag_remove("search_current", "1.0", "end")
        self._search_matches = []
        self._search_idx = -1
        q = self._search_var.get() if hasattr(self, "_search_var") else ""
        if not q:
            if hasattr(self, "_search_lbl_count"):
                self._search_lbl_count.configure(text="")
            return

        start = "1.0"
        while True:
            pos = self.text.search(q, start, stopindex=tk.END, nocase=True)
            if not pos:
                break
            end = f"{pos}+{len(q)}c"
            self._search_matches.append((pos, end))
            self.text.tag_add("search_match", pos, end)
            start = end

        total = len(self._search_matches)
        if total > 0:
            self._search_idx = 0
            self._highlight_current_match()
        else:
            self._search_lbl_count.configure(text="0")

    def _find_next(self):
        if not self._search_matches:
            return
        self._search_idx = (self._search_idx + 1) % len(self._search_matches)
        self._highlight_current_match()

    def _find_prev(self):
        if not self._search_matches:
            return
        self._search_idx = (self._search_idx - 1) % len(self._search_matches)
        self._highlight_current_match()

    def _highlight_current_match(self):
        self.text.tag_remove("search_current", "1.0", "end")
        if 0 <= self._search_idx < len(self._search_matches):
            pos, end = self._search_matches[self._search_idx]
            self.text.tag_add("search_current", pos, end)
            self.text.see(pos)
            self._search_lbl_count.configure(text=f"{self._search_idx + 1}/{len(self._search_matches)}")


    def refresh_font(self):
        self.gutter.configure(font=self.font)
        self.text.configure(font=self.font)

    # ----- défilement synchronisé
    def _on_scroll(self, *args):
        self.scroll.set(*args)
        self.gutter.yview_moveto(args[0])

    def _yview(self, *args):
        self.text.yview(*args)
        self.gutter.yview(*args)

    def _update_gutter(self):
        n = int(self.text.index("end-1c").split(".")[0])
        self.gutter.configure(state="normal")
        self.gutter.delete("1.0", tk.END)
        self.gutter.insert("1.0", "\n".join(str(i) for i in range(1, n + 1)))
        self.gutter.configure(state="disabled")
        self.gutter.yview_moveto(self.text.yview()[0])
        try:
            ligne = int(self.text.index("insert").split(".")[0])
            self.gutter.tag_add("gutter_active", f"{ligne}.0", f"{ligne}.end")
        except Exception:
            pass

    # ----- coloration
    def highlight(self):
        t = self.text
        for tag in ("kw", "builtin", "num", "deff", "str", "com"):
            t.tag_remove(tag, "1.0", "end")
        lignes = t.get("1.0", "end-1c").split("\n")
        for i, ligne in enumerate(lignes, start=1):
            for m in _RE_WORD.finditer(ligne):
                w = m.group()
                if w in _KW:
                    tag = "kw"
                elif w in _BUILTINS:
                    tag = "builtin"
                else:
                    continue
                t.tag_add(tag, f"{i}.{m.start()}", f"{i}.{m.end()}")
            for m in _RE_NUM.finditer(ligne):
                t.tag_add("num", f"{i}.{m.start()}", f"{i}.{m.end()}")
            md = _RE_DEF.match(ligne)
            if md:
                t.tag_add("deff", f"{i}.{md.start(2)}", f"{i}.{md.end(2)}")
            for m in _RE_STR.finditer(ligne):
                t.tag_add("str", f"{i}.{m.start()}", f"{i}.{m.end()}")
            h = ligne.find("#")
            if h != -1 and "str" not in t.tag_names(f"{i}.{h}"):
                t.tag_add("com", f"{i}.{h}", f"{i}.end")

    # ----- événements
    def _on_key(self, _e=None):
        self.highlight()
        self._update_gutter()
        self._verifier_syntaxe()
        self._maj_ligne_courante()
        if self.on_change:
            self.on_change()

    def _maj_ligne_courante(self, _e=None):
        """Surligne discrètement la ligne où se trouve le curseur et sa gouttière."""
        self.text.tag_remove("curline", "1.0", "end")
        self.gutter.tag_remove("gutter_active", "1.0", "end")
        try:
            ligne = int(self.text.index("insert").split(".")[0])
            self.text.tag_add("curline", f"{ligne}.0", f"{ligne + 1}.0")
            self.gutter.tag_add("gutter_active", f"{ligne}.0", f"{ligne}.end")
        except Exception:
            pass

    def _verifier_syntaxe(self):
        """Compile le code en arrière-plan et souligne la ligne fautive."""
        self.text.tag_remove("errline", "1.0", "end")
        err = None
        code = self.get()
        if code.strip():
            try:
                compile(code, "<editeur>", "exec")
            except SyntaxError as e:
                err = e
        if err and err.lineno:
            try:
                self.text.tag_add("errline", f"{err.lineno}.0", f"{err.lineno}.end")
            except tk.TclError:
                pass
        if self.on_syntax:
            self.on_syntax(err)

    # ----- autocomplétion
    def _autocomplete(self, _e=None):
        idx = self.text.index("insert")
        line, col = (int(x) for x in idx.split("."))
        avant = self.text.get(f"{line}.0", f"{line}.{col}")
        m = re.search(r"[A-Za-z_]\w*$", avant)
        prefixe = m.group() if m else ""
        if not prefixe:
            return "break"
        mots = set(_KW) | set(_BUILTINS)
        mots.update(_RE_WORD.findall(self.get()))
        cands = sorted(w for w in mots if w.startswith(prefixe) and w != prefixe)
        if not cands:
            return "break"
        if len(cands) == 1:
            self._inserer_completion(prefixe, cands[0])
        else:
            self._popup_completion(prefixe, cands)
        return "break"

    def _inserer_completion(self, prefixe, mot):
        self.text.delete(f"insert-{len(prefixe)}c", "insert")
        self.text.insert("insert", mot)
        self._on_key()

    def _popup_completion(self, prefixe, cands):
        self._fermer_popup()
        try:
            bbox = self.text.bbox("insert")
        except tk.TclError:
            bbox = None
        pop = tk.Toplevel(self.text)
        pop.overrideredirect(True)
        if bbox:
            x = self.text.winfo_rootx() + bbox[0]
            y = self.text.winfo_rooty() + bbox[1] + bbox[3]
            pop.geometry(f"+{x}+{y}")
        C = self._C or {}
        lb = tk.Listbox(pop, height=min(6, len(cands)),
                        bg=C.get("panel", "white"), fg=C.get("fg", "black"),
                        selectbackground=C.get("accent", "#4d8bf0"),
                        highlightthickness=0, activestyle="none")
        for c in cands:
            lb.insert("end", c)
        lb.selection_set(0)
        lb.pack()
        self._popup = pop
        self._popup_list = lb
        self._popup_prefix = prefixe
        lb.bind("<Return>", self._valider_popup)
        lb.bind("<Double-Button-1>", self._valider_popup)
        lb.bind("<Escape>", lambda e: (self._fermer_popup(), self.text.focus_set()))
        lb.focus_set()

    def _valider_popup(self, _e=None):
        if self._popup and self._popup_list.curselection():
            mot = self._popup_list.get(self._popup_list.curselection()[0])
            self._inserer_completion(self._popup_prefix, mot)
        self._fermer_popup()
        self.text.focus_set()
        return "break"

    def _fermer_popup(self):
        if self._popup:
            self._popup.destroy()
            self._popup = None

    def _on_return(self, _e):
        ligne = self.text.get("insert linestart", "insert")
        indent = len(ligne) - len(ligne.lstrip(" "))
        if ligne.rstrip().endswith(":"):
            indent += 4
        self.text.insert(tk.INSERT, "\n" + " " * indent)
        self._on_key()
        return "break"

    def _selection_lines(self):
        try:
            first = int(self.text.index("sel.first").split(".")[0])
            last = int(self.text.index("sel.last").split(".")[0])
            return first, last
        except tk.TclError:
            return None

    def _on_tab(self, _e):
        sel = self._selection_lines()
        if sel is None:
            self.text.insert(tk.INSERT, "    ")
            return "break"
        for ln in range(sel[0], sel[1] + 1):
            self.text.insert(f"{ln}.0", "    ")
        self._on_key()
        return "break"

    def _on_shift_tab(self, _e):
        sel = self._selection_lines()
        lignes = sel if sel else (int(self.text.index("insert").split(".")[0]),) * 2
        for ln in range(lignes[0], lignes[1] + 1):
            debut = self.text.get(f"{ln}.0", f"{ln}.4")
            enlever = len(debut) - len(debut.lstrip(" "))
            enlever = min(4, enlever) if debut.strip() == "" else len(debut[:4]) - len(debut[:4].lstrip(" "))
            n = 0
            while n < 4 and self.text.get(f"{ln}.0", f"{ln}.1") == " ":
                self.text.delete(f"{ln}.0", f"{ln}.1")
                n += 1
        self._on_key()
        return "break"

    def _on_comment(self, _e):
        sel = self._selection_lines()
        lignes = sel if sel else (int(self.text.index("insert").split(".")[0]),) * 2
        # commenter si au moins une ligne non commentée, sinon décommenter
        commenter = False
        for ln in range(lignes[0], lignes[1] + 1):
            contenu = self.text.get(f"{ln}.0", f"{ln}.end")
            if contenu.strip() and not contenu.lstrip().startswith("#"):
                commenter = True
                break
        for ln in range(lignes[0], lignes[1] + 1):
            contenu = self.text.get(f"{ln}.0", f"{ln}.end")
            if not contenu.strip():
                continue
            if commenter:
                self.text.insert(f"{ln}.0", "# ")
            else:
                i = contenu.find("#")
                if i != -1:
                    fin = i + 2 if contenu[i:i + 2] == "# " else i + 1
                    self.text.delete(f"{ln}.{i}", f"{ln}.{fin}")
        self._on_key()
        return "break"

    def _auto_pair(self, ouvrant, fermant):
        def handler(_e):
            self.text.insert("insert", ouvrant + fermant)
            self.text.mark_set("insert", "insert-1c")
            self._on_key()
            return "break"
        return handler
