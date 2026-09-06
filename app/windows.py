"""
Fenêtres secondaires de l'application.

Chacune reçoit l'application principale (`app`) et la palette du thème
courant (`C`) : elles ne connaissent donc ni le curriculum, ni la
progression, ce qui les rend déplaçables et lisibles isolément.

  Celebration      confettis après un parcours terminé
  StepWindow       exécution pas-à-pas, ligne par ligne
  ExamWindow       examen chronométré
  FlashcardWindow  cartes de révision recto/verso
"""

import random
import tkinter as tk
from tkinter import ttk

from app import progress as prog


class Celebration(tk.Toplevel):
    """Petite fenêtre festive avec confettis animés."""

    def __init__(self, master, message, C, on_cert=None):
        super().__init__(master)
        self.title("Bravo !")
        self.configure(bg=C["panel"])
        w, h = 440, 320
        self.geometry(f"{w}x{h}")
        self.canvas = tk.Canvas(self, width=w, height=160, bg=C["panel"],
                                highlightthickness=0)
        self.canvas.pack()
        tk.Label(self, text="🏅", bg=C["panel"], font=("", 30)).pack()
        tk.Label(self, text=message, bg=C["panel"], fg=C["fg"], wraplength=400,
                 justify="center").pack(pady=6)
        barre = tk.Frame(self, bg=C["panel"])
        barre.pack(pady=6)
        if on_cert:
            tk.Button(barre, text="🎓 Certificat",
                      command=lambda: (on_cert(), self.destroy())).pack(side=tk.LEFT, padx=4)
        tk.Button(barre, text="Super !", command=self.destroy).pack(side=tk.LEFT, padx=4)
        couleurs = [C["accent"], C["ok"], C["code"], C["err"], C["heading"]]
        self.parts = []
        for _ in range(45):
            x = random.randint(0, w)
            y = random.randint(-170, 0)
            r = self.canvas.create_rectangle(
                x, y, x + 6, y + 11, fill=random.choice(couleurs), outline="")
            self.parts.append((r, random.uniform(2.5, 6)))
        self._tick_id = None
        self._close_id = None
        self._tick(0)
        self._close_id = self.after(5000, lambda: self.winfo_exists() and self.destroy())

    def _tick(self, n):
        if n > 70 or not self.winfo_exists():
            return
        for r, sp in self.parts:
            self.canvas.move(r, 0, sp)
        self._tick_id = self.after(40, lambda: self._tick(n + 1))

    def destroy(self):
        if hasattr(self, "_tick_id") and self._tick_id:
            try:
                self.after_cancel(self._tick_id)
            except Exception:
                pass
            self._tick_id = None
        if hasattr(self, "_close_id") and self._close_id:
            try:
                self.after_cancel(self._close_id)
            except Exception:
                pass
            self._close_id = None
        super().destroy()


class StepWindow(tk.Toplevel):
    """Rejoue une exécution étape par étape, en surlignant la ligne courante."""

    def __init__(self, master, app, etapes, C, err=None):
        super().__init__(master)
        self.app = app
        self.etapes = etapes
        self.i = 0
        self.title(app.tr("step_title"))
        self.configure(bg=C["bg"])
        self.geometry("520x540")
        self.entete = tk.Label(self, bg=C["bg"], fg=C["accent"],
                               font=(self.app.body.cget("family"), 12, "bold"))
        self.entete.pack(pady=(12, 6))
        nav = tk.Frame(self, bg=C["bg"])
        nav.pack()
        tk.Button(nav, text=app.tr("step_prev"), command=self.prec).pack(side=tk.LEFT, padx=4)
        tk.Button(nav, text=app.tr("step_next"), command=self.suiv).pack(side=tk.LEFT, padx=4)
        tk.Label(self, text=app.tr("step_vars"), bg=C["bg"],
                 fg=C["muted"]).pack(anchor="w", padx=16, pady=(10, 0))
        self.vars_txt = tk.Text(self, height=8, wrap="word", bg=C["console"], fg=C["fg"],
                                relief="flat", font=app.code_font, padx=8, pady=6)
        self.vars_txt.pack(fill=tk.BOTH, expand=True, padx=16, pady=4)
        tk.Label(self, text=app.tr("step_out"), bg=C["bg"], fg=C["muted"]).pack(
            anchor="w", padx=16)
        self.out_txt = tk.Text(self, height=5, wrap="word", bg=C["console"], fg=C["fg"],
                               relief="flat", font=app.code_font, padx=8, pady=6)
        self.out_txt.pack(fill=tk.BOTH, expand=True, padx=16, pady=(4, 12))
        if err:
            tk.Label(self, text=err, bg=C["bg"], fg=C["err"], wraplength=480).pack(
                padx=16, pady=(0, 8))
        self.protocol("WM_DELETE_WINDOW", self.fermer)
        self.bind("<Right>", lambda e: self.suiv())
        self.bind("<Left>", lambda e: self.prec())
        self._afficher()

    def prec(self):
        if self.i > 0:
            self.i -= 1
            self._afficher()

    def suiv(self):
        if self.i < len(self.etapes) - 1:
            self.i += 1
            self._afficher()

    def _afficher(self):
        e = self.etapes[self.i]
        ligne = e["ligne"]
        suffixe = (self.app.tr("step_line", l=ligne) if ligne
                   else self.app.tr("step_end"))
        self.entete.configure(
            text=self.app.tr("step_label", i=self.i + 1, n=len(self.etapes)) + suffixe)
        ed = self.app.editor.text
        ed.tag_remove("pasapas", "1.0", "end")
        if ligne:
            try:
                ed.tag_add("pasapas", f"{ligne}.0", f"{ligne}.end")
                ed.see(f"{ligne}.0")
            except tk.TclError:
                pass
        self.vars_txt.delete("1.0", tk.END)
        if e["vars"]:
            for nom, rep in e["vars"]:
                self.vars_txt.insert(tk.END, f"{nom} = {rep}\n")
        else:
            self.vars_txt.insert(tk.END, self.app.tr("step_no_vars") + "\n")
        self.out_txt.delete("1.0", tk.END)
        self.out_txt.insert(tk.END, e["sortie"] or self.app.tr("step_no_out"))

    def fermer(self):
        try:
            self.app.editor.text.tag_remove("pasapas", "1.0", "end")
        except Exception:
            pass
        self.destroy()

class ExamWindow(tk.Toplevel):
    """Examen chronométré : enchaîne des questions de quiz et affiche le score."""
    DUREE = 300  # secondes (5 minutes)

    def __init__(self, master, app, questions, C):
        super().__init__(master)
        self.app = app
        self.tr = app.tr
        self.questions = questions
        self.C = C
        self.i = 0
        self.bons = 0
        self.valide = False
        self.restant = self.DUREE
        self.title(self.tr("ex_title"))
        self.configure(bg=C["bg"])
        self.geometry("560x440")

        barre = tk.Frame(self, bg=C["bg"])
        barre.pack(fill=tk.X, padx=16, pady=(12, 4))
        self.compteur = tk.Label(barre, bg=C["bg"], fg=C["muted"],
                                 font=(app.body.cget("family"), 10, "bold"))
        self.compteur.pack(side=tk.LEFT)
        self.chrono = tk.Label(barre, bg=C["bg"], fg=C["accent"],
                               font=(app.body.cget("family"), 11, "bold"))
        self.chrono.pack(side=tk.RIGHT)

        self.q_label = tk.Label(self, bg=C["bg"], fg=C["fg"], wraplength=520,
                                justify="left", font=(app.body.cget("family"), 12))
        self.q_label.pack(anchor="w", padx=16, pady=(8, 6))
        self.var = tk.IntVar(value=-1)
        self.opts_frame = tk.Frame(self, bg=C["bg"])
        self.opts_frame.pack(fill=tk.X, padx=16)
        self.retour = tk.Label(self, bg=C["bg"], fg=C["muted"], wraplength=520,
                               justify="left")
        self.retour.pack(anchor="w", padx=16, pady=6)

        nav = tk.Frame(self, bg=C["bg"])
        nav.pack(side=tk.BOTTOM, pady=12)
        self.btn_valider = ttk.Button(nav, text=self.tr("ex_valider"),
                                      command=self._valider)
        self.btn_valider.pack(side=tk.LEFT, padx=4)
        self.btn_suivant = ttk.Button(nav, text=self.tr("ex_suivant"),
                                      command=self._suivant)

        self._afficher()
        self._tic()

    def _tic(self):
        m, s = divmod(max(0, self.restant), 60)
        self.chrono.configure(text=self.tr("ex_time", m=m, s=s))
        if self.restant <= 0:
            self._terminer(temps_ecoule=True)
            return
        self.restant -= 1
        self._after_id = self.after(1000, self._tic)

    def _afficher(self):
        q = self.questions[self.i]
        self.valide = False
        self.var.set(-1)
        self.retour.configure(text="")
        self.compteur.configure(text=self.tr("ex_q", i=self.i + 1, n=len(self.questions)))
        self.q_label.configure(text=q["question"])
        for w in self.opts_frame.winfo_children():
            w.destroy()
        for idx, opt in enumerate(q["options"]):
            tk.Radiobutton(self.opts_frame, text=opt, variable=self.var, value=idx,
                           bg=self.C["bg"], fg=self.C["fg"], selectcolor=self.C["panel"],
                           activebackground=self.C["bg"], anchor="w",
                           font=self.app.body).pack(fill=tk.X, anchor="w")
        self.btn_suivant.pack_forget()
        self.btn_valider.pack(side=tk.LEFT, padx=4)

    def _valider(self):
        if self.var.get() < 0 or self.valide:
            return
        self.valide = True
        q = self.questions[self.i]
        if self.var.get() == q["answer"]:
            self.bons += 1
            self.retour.configure(text=self.tr("quiz_good") + q.get("explanation", ""),
                                  fg=self.C["ok"])
        else:
            bonne = q["options"][q["answer"]]
            self.retour.configure(text=f"{self.tr('quiz_bad')}  ✓ {bonne}",
                                  fg=self.C["err"])
        self.btn_valider.pack_forget()
        self.btn_suivant.pack(side=tk.LEFT, padx=4)

    def _suivant(self):
        if self.i + 1 >= len(self.questions):
            self._terminer()
        else:
            self.i += 1
            self._afficher()

    def _terminer(self, temps_ecoule=False):
        try:
            self.after_cancel(self._after_id)
        except Exception:
            pass
        for w in list(self.winfo_children()):
            w.destroy()
        from datetime import date as _date
        prog.enregistrer_activite(self.app.data, _date.today().isoformat())
        self.app._refresh_status()
        titre = self.tr("ex_temps") if temps_ecoule else self.tr("ex_termine")
        tk.Label(self, text=titre, bg=self.C["bg"], fg=self.C["accent"],
                 font=(self.app.body.cget("family"), 16, "bold")).pack(pady=(40, 10))
        tk.Label(self, text=self.tr("ex_score", bons=self.bons, total=len(self.questions)),
                 bg=self.C["bg"], fg=self.C["fg"],
                 font=(self.app.body.cget("family"), 22, "bold")).pack(pady=10)
        ttk.Button(self, text=self.tr("ex_fermer"), command=self.destroy).pack(pady=16)

    def destroy(self):
        if hasattr(self, "_after_id") and self._after_id:
            try:
                self.after_cancel(self._after_id)
            except Exception:
                pass
            self._after_id = None
        super().destroy()


class FlashcardWindow(tk.Toplevel):
    """Révision en cartes : recto (terme) / verso (définition)."""

    def __init__(self, master, app, cartes, C):
        super().__init__(master)
        self.app = app
        self.tr = app.tr
        self.C = C
        self.cartes = list(cartes)
        random.shuffle(self.cartes)
        self.i = 0
        self.face = False  # False = recto, True = verso
        self.title(self.tr("fc_title"))
        self.configure(bg=C["bg"])
        self.geometry("520x420")

        self.compteur = tk.Label(self, bg=C["bg"], fg=C["muted"],
                                 font=(app.body.cget("family"), 10, "bold"))
        self.compteur.pack(pady=(12, 4))
        self.face_label = tk.Label(self, bg=C["bg"], fg=C["accent"],
                                   font=(app.body.cget("family"), 10))
        self.face_label.pack()

        self.carte = tk.Label(self, bg=C["panel"], fg=C["fg"], wraplength=440,
                              justify="center", font=(app.body.cget("family"), 15),
                              width=44, height=8)
        self.carte.pack(fill=tk.BOTH, expand=True, padx=20, pady=12)
        self.carte.bind("<Button-1>", lambda e: self._retourner())

        def _sur_config(e):
            if e.widget == self:
                try:
                    self.carte.configure(wraplength=max(200, e.width - 40))
                except Exception:
                    pass
        self.bind("<Configure>", _sur_config)

        nav = tk.Frame(self, bg=C["bg"])
        nav.pack(pady=10)
        self.btn_flip = ttk.Button(nav, text=self.tr("fc_flip"), command=self._retourner)
        self.btn_flip.pack(side=tk.LEFT, padx=4)
        self.btn_next = ttk.Button(nav, text=self.tr("fc_next"), command=self._suivant)
        self.btn_next.pack(side=tk.LEFT, padx=4)
        self._afficher()

    def _afficher(self):
        self.face = False
        terme, _ = self.cartes[self.i]
        self.compteur.configure(text=self.tr("fc_progress", i=self.i + 1, n=len(self.cartes)))
        self.face_label.configure(text=self.tr("fc_recto"))
        self.carte.configure(text=terme)

    def _retourner(self):
        self.face = not self.face
        terme, definition = self.cartes[self.i]
        self.face_label.configure(text=self.tr("fc_verso" if self.face else "fc_recto"))
        self.carte.configure(text=definition if self.face else terme)

    def _suivant(self):
        if self.i + 1 >= len(self.cartes):
            self._terminer()
        else:
            self.i += 1
            self._afficher()

    def _terminer(self):
        for w in list(self.winfo_children()):
            w.destroy()
        tk.Label(self, text=self.tr("fc_done"), bg=self.C["bg"], fg=self.C["accent"],
                 font=(self.app.body.cget("family"), 18, "bold")).pack(pady=(60, 16))
        nav = tk.Frame(self, bg=self.C["bg"])
        nav.pack()
        ttk.Button(nav, text=self.tr("fc_replay"), command=self._rejouer).pack(side=tk.LEFT, padx=4)
        ttk.Button(nav, text=self.tr("fc_close"), command=self.destroy).pack(side=tk.LEFT, padx=4)

    def _rejouer(self):
        self.destroy()
        FlashcardWindow(self.master, self.app, self.cartes, self.C)


class AccueilWindow(tk.Toplevel):
    """Tableau de bord d'ouverture : où j'en suis, et par quoi je reprends.

    Sans lui, l'application s'ouvre directement sur un exercice : on ne
    sait ni où l'on en est, ni ce qu'on avait raté la dernière fois. Tout
    ce qui est affiché ici vient de stats.resume_accueil().
    """

    def __init__(self, master, app, resume, C):
        super().__init__(master)
        self.app = app
        self.C = C
        self.title(app.tr("acc_titre"))
        self.configure(bg=C["panel"])
        self.resizable(False, False)
        tk.Frame(self, bg=C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

        premiere_fois = resume["faits"] == 0
        tk.Label(self, text=app.tr("acc_bienvenue" if premiere_fois else "acc_retour"),
                 bg=C["panel"], fg=C["accent"], font=("", 19, "bold")).pack(pady=(16, 2))

        # --- la ligne de chiffres : série, niveau, révisions dues ---------
        chiffres = tk.Frame(self, bg=C["panel"])
        chiffres.pack(pady=(6, 12))
        niv = resume["niveau"]
        cases = [
            ("🔥", str(resume["serie"]), app.tr("acc_serie")),
            (niv.get("rang_icone", "🟢"), niv.get("rang_titre", "Tiro"), f"Niveau {niv['niveau']}"),
            ("🪙", str(app.data.get("sesterces", 0)), "Sesterces"),
            ("🎯", f"{resume['aujourdhui']}/{resume['objectif']}", app.tr("acc_jour")),
        ]
        if resume["revisions"]:
            cases.append(("🔁", str(resume["revisions"]), app.tr("acc_revisions")))
        for icone, valeur, legende in cases:
            case = tk.Frame(chiffres, bg=C["panel"])
            case.pack(side=tk.LEFT, padx=10)
            tk.Label(case, text=icone, bg=C["panel"], font=("Segoe UI Emoji", 16)).pack()
            tk.Label(case, text=valeur, bg=C["panel"], fg=C["fg"],
                     font=("", 13, "bold")).pack()
            tk.Label(case, text=legende, bg=C["panel"], fg=C["muted"],
                     font=("", 8)).pack()

        # --- progression -------------------------------------------------
        faits, total = resume["faits"], max(1, resume["total"])
        tk.Label(self, text=app.tr("acc_progression", faits=faits, total=resume["total"]),
                 bg=C["panel"], fg=C["muted"], font=("", 9)).pack()
        barre = ttk.Progressbar(self, length=380, maximum=total, value=faits)
        barre.pack(pady=(4, 14), padx=24)

        # --- reprendre ---------------------------------------------------
        quoi, item = resume["prochaine"]
        principal = ttk.Frame(self, style="Panel.TFrame")
        principal.pack(pady=(0, 8))
        if item is not None:
            cle = "acc_revision" if quoi == "revision" else "acc_reprendre"
            ttk.Button(principal, text=app.tr(cle),
                       style="Primary.TButton",
                       command=lambda i=item: self._aller(i)).pack()
        else:
            tk.Label(self, text=app.tr("acc_termine"), bg=C["panel"], fg=C["ok"],
                     wraplength=380, justify="center").pack(pady=4)

        from app.stats import defi_du_jour
        from content import CURRICULUM
        defi = defi_du_jour(CURRICULUM)
        if defi:
            fait = defi["id"] in app.data.get("completed", [])
            symb = "✓ " if fait else "⚡ "
            title = defi["title_en"] if getattr(app, "lang", "fr") == "en" else defi["title"]
            lbl_btn = f"{symb}{app.tr('acc_defi')} : {title}"
            ttk.Button(principal, text=lbl_btn,
                       command=lambda i=defi["id"]: self._aller(i)).pack(pady=(6, 0))

        # --- rattrapage ciblé --------------------------------------------
        if resume["difficiles"]:
            tk.Label(self, text=app.tr("acc_difficiles"), bg=C["panel"],
                     fg=C["muted"], font=("", 9)).pack(pady=(12, 4))
            for item_id, echecs in resume["difficiles"]:
                titre = app.titre_de_item(item_id)
                ttk.Button(self, text=app.tr("acc_refaire", titre=titre, n=echecs),
                           command=lambda i=item_id: self._aller(i)).pack(
                    fill=tk.X, padx=40, pady=2)

        # --- pied --------------------------------------------------------
        pied = tk.Frame(self, bg=C["panel"])
        pied.pack(pady=(16, 14))
        self.au_demarrage = tk.BooleanVar(
            value=app.data.get("accueil_au_demarrage", True))
        tk.Checkbutton(pied, text=app.tr("acc_au_demarrage"),
                       variable=self.au_demarrage, command=self._basculer,
                       bg=C["panel"], fg=C["muted"], selectcolor=C["editor"],
                       activebackground=C["panel"], activeforeground=C["fg"],
                       font=("", 8), borderwidth=0,
                       highlightthickness=0).pack(side=tk.LEFT, padx=8)
        ttk.Button(pied, text=app.tr("acc_fermer"),
                   command=self.destroy).pack(side=tk.LEFT, padx=8)

        self.bind("<Escape>", lambda e: self.destroy())
        self.transient(master)

    def _aller(self, item_id):
        self.destroy()
        self.app.charger_depuis_accueil(item_id)

    def _basculer(self):
        prog.set_accueil_au_demarrage(self.app.data, self.au_demarrage.get())


class PaletteWindow(tk.Toplevel):
    """Palette de commandes rapide (Ctrl+P / Ctrl+K) : sauter directement à une leçon."""

    def __init__(self, master, app, items, C, on_select):
        super().__init__(master)
        self.app = app
        self.C = C
        self.items = list(items)  # list of (id, label_display, searchable_text)
        self.on_select = on_select
        self.filtres = list(self.items)

        self.title(app.tr("palette_title"))
        self.configure(bg=C["panel"])
        self.geometry("560x420")
        self.resizable(True, True)

        header = tk.Frame(self, bg=C["panel"])
        header.pack(fill=tk.X, padx=16, pady=(14, 6))

        tk.Label(header, text=app.tr("palette_prompt"), bg=C["panel"], fg=C["muted"],
                 anchor="w", font=(app.body.cget("family"), 9)).pack(fill=tk.X)

        self.query_var = tk.StringVar()
        self.entry = tk.Entry(header, textvariable=self.query_var, bg=C["editor"],
                              fg=C["fg"], insertbackground=C["fg"], relief="flat",
                              font=(app.body.cget("family"), 12))
        self.entry.pack(fill=tk.X, pady=(6, 2), ipady=4)
        self.entry.focus_set()

        self.listbox = tk.Listbox(self, bg=C["editor"], fg=C["fg"],
                                  selectbackground=C["accent"], selectforeground=C["sel_fg"],
                                  relief="flat", highlightthickness=0,
                                  font=(app.body.cget("family"), 10))
        self.listbox.pack(fill=tk.BOTH, expand=True, padx=16, pady=8)

        self.query_var.trace_add("write", self._on_type)
        self.entry.bind("<Return>", lambda e: self._valider())
        self.listbox.bind("<Double-Button-1>", lambda e: self._valider())
        self.listbox.bind("<Return>", lambda e: self._valider())
        self.entry.bind("<Down>", self._focus_list)
        self.entry.bind("<Up>", self._focus_list)
        self.bind("<Escape>", lambda e: self.destroy())

        self._remplir()
        self.transient(master)

    def _focus_list(self, event):
        if self.listbox.size() > 0:
            self.listbox.focus_set()
            if not self.listbox.curselection():
                self.listbox.selection_set(0)

    def _on_type(self, *args):
        q = self.query_var.get().strip().lower()
        if not q:
            self.filtres = list(self.items)
        else:
            self.filtres = [it for it in self.items if q in it[2].lower()]
        self._remplir()

    def _remplir(self):
        self.listbox.delete(0, tk.END)
        for _, label, _ in self.filtres:
            self.listbox.insert(tk.END, label)
        if self.filtres:
            self.listbox.selection_set(0)

    def _valider(self):
        sel = self.listbox.curselection()
        if sel and sel[0] < len(self.filtres):
            item_id = self.filtres[sel[0]][0]
            self.destroy()
            self.on_select(item_id)


class BytecodeWindow(tk.Toplevel):
    """Affiche le désassemblage Bytecode CPython du code courant avec explications."""

    def __init__(self, master, app, code_source, C):
        super().__init__(master)
        self.title("⚙ " + app.tr("tb_bytecode"))
        self.geometry("720x540")
        self.configure(bg=C["bg"])

        top = tk.Frame(self, bg=C["bg"], padx=14, pady=10)
        top.pack(fill=tk.X)
        tk.Label(top, text="⚙ " + app.tr("bytecode_title"),
                 bg=C["bg"], fg=C["heading"], font=(app.body.cget("family"), 12, "bold")).pack(anchor="w")
        tk.Label(top, text=app.tr("bytecode_sub"),
                 bg=C["bg"], fg=C["muted"], font=app.body).pack(anchor="w", pady=(2, 0))

        wrap = tk.Frame(self, bg=C["bg"], padx=14, pady=(0, 14))
        wrap.pack(fill=tk.BOTH, expand=True)

        txt = tk.Text(wrap, wrap="none", bg=C["editor"], fg=C["fg"],
                      insertbackground=C["fg"], relief="flat", font=app.code_font, padx=10, pady=10)
        ysb = ttk.Scrollbar(wrap, orient="vertical", command=txt.yview)
        xsb = ttk.Scrollbar(wrap, orient="horizontal", command=txt.xview)
        txt.configure(yscrollcommand=ysb.set, xscrollcommand=xsb.set)

        txt.grid(row=0, column=0, sticky="nsew")
        ysb.grid(row=0, column=1, sticky="ns")
        xsb.grid(row=1, column=0, sticky="ew")
        wrap.grid_rowconfigure(0, weight=1)
        wrap.grid_columnconfigure(0, weight=1)

        import dis
        import io
        try:
            compiled = compile(code_source, "<editeur>", "exec")
            buf = io.StringIO()
            dis.dis(compiled, file=buf)
            txt.insert(tk.END, buf.getvalue())
        except Exception as e:
            txt.insert(tk.END, f"Impossible de compiler le code :\n{e}")

        txt.configure(state="disabled")
        self.bind("<Escape>", lambda e: self.destroy())
        self.transient(master)


class SqliteViewerWindow(tk.Toplevel):
    """Explorateur graphique de bases de données SQLite en mémoire ou sur disque."""

    def __init__(self, master, app, code_or_path, C):
        super().__init__(master)
        self.title("🗄 " + app.tr("tb_sqlite"))
        self.geometry("780x560")
        self.configure(bg=C["bg"])
        self.app = app
        self.C = C

        top = tk.Frame(self, bg=C["bg"], padx=14, pady=10)
        top.pack(fill=tk.X)
        tk.Label(top, text="🗄 " + app.tr("sqlite_viewer_title"),
                 bg=C["bg"], fg=C["heading"], font=(app.body.cget("family"), 12, "bold")).pack(anchor="w")

        import sqlite3
        self.conn = sqlite3.connect(":memory:")
        try:
            if isinstance(code_or_path, str):
                if code_or_path.endswith(".db") or code_or_path.endswith(".sqlite"):
                    self.conn = sqlite3.connect(code_or_path)
                else:
                    scope = {"sqlite3": sqlite3, "conn": self.conn}
                    try:
                        exec(code_or_path, scope)
                    except Exception:
                        pass
        except Exception:
            pass

        tables_row = tk.Frame(self, bg=C["bg"], padx=14, pady=4)
        tables_row.pack(fill=tk.X)
        tk.Label(tables_row, text=app.tr("sqlite_table_label"), bg=C["bg"],
                 fg=C["muted"], font=app.body).pack(side=tk.LEFT, padx=(0, 6))

        self.table_var = tk.StringVar()
        self.cb_tables = ttk.Combobox(tables_row, textvariable=self.table_var, state="readonly")
        self.cb_tables.pack(side=tk.LEFT, fill=tk.X, expand=True)
        self.cb_tables.bind("<<ComboboxSelected>>", self._charger_table)

        tree_wrap = tk.Frame(self, bg=C["bg"], padx=14, pady=8)
        tree_wrap.pack(fill=tk.BOTH, expand=True)
        self.tree = ttk.Treeview(tree_wrap, show="headings")
        ysb = ttk.Scrollbar(tree_wrap, orient="vertical", command=self.tree.yview)
        xsb = ttk.Scrollbar(tree_wrap, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=ysb.set, xscrollcommand=xsb.set)

        self.tree.grid(row=0, column=0, sticky="nsew")
        ysb.grid(row=0, column=1, sticky="ns")
        xsb.grid(row=1, column=0, sticky="ew")
        tree_wrap.grid_rowconfigure(0, weight=1)
        tree_wrap.grid_columnconfigure(0, weight=1)

        self._lister_tables()
        self.bind("<Escape>", lambda e: self.destroy())
        self.transient(master)

    def _lister_tables(self):
        try:
            cur = self.conn.cursor()
            cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
            tables = [row[0] for row in cur.fetchall() if not row[0].startswith("sqlite_")]
            self.cb_tables["values"] = tables
            if tables:
                self.cb_tables.current(0)
                self._charger_table()
        except Exception:
            pass

    def _charger_table(self, *args):
        table = self.table_var.get()
        if not table:
            return
        self.tree.delete(*self.tree.get_children())
        try:
            cur = self.conn.cursor()
            cur.execute(f"PRAGMA table_info('{table}');")
            cols = [row[1] for row in cur.fetchall()]
            self.tree["columns"] = cols
            for col in cols:
                self.tree.heading(col, text=col)
                self.tree.column(col, width=120, anchor="center")

            cur.execute(f"SELECT * FROM '{table}' LIMIT 200;")
            for row in cur.fetchall():
                self.tree.insert("", tk.END, values=row)
        except Exception:
            pass


