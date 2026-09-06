"""Interface graphique de PythonLearn (version enrichie)."""

import os
import pathlib
import random
import sys
import tkinter as tk
import webbrowser
from datetime import date
from tkinter import filedialog, font, messagebox, simpledialog, ttk

from app import audio, errors, stats
from app import progress as prog
from app.avatar import AvatarWindow
from app.carte import CarteAventureWindow
from app.cartes_collection import AlbumCartesWindow
from app.chiffre_cesar import ChiffreCesarWindow
from app.circus import CircusMaximusWindow
from app.duel import DuelWindow
from app.editor import CodeEditor
from app.export_pdf import FichesExportDialog
from app.i18n import LANGUES, Translator
from app.icones import charger_icone, get_icones_toolbar
from app.marche_trajan import MarcheTrajanWindow
from app.mascotte import MascotteWidget
from app.mise_a_jour import MiseAJourDialog
from app.musee import MuseeWindow
from app.profils import ProfileDialog
from app.theme import THEME_ORDER, THEMES, assombrir, eclaircir
from app.version import APP_NAME, AUTEUR, DEPOT, __version__
from app.vues_exercices import (
    VueArene,
    VueDecodeur,
    VueOrdre,
    VuePrediction,
    VuePuzzle,
    VueTrou,
    VueTurtle,
)
from app.windows import (
    AccueilWindow,
    BytecodeWindow,
    Celebration,
    ExamWindow,
    FlashcardWindow,
    PaletteWindow,
    SqliteViewerWindow,
    StepWindow,
)
from content import (
    CURRICULUM,
    ajouter_packs,
    exercice_count,
    find_lesson,
    get_exercice,
    get_glossaire,
    hints_for,
    lesson_done,
    lesson_items,
    total_count,
    traduit,
)

try:
    from app.icon import ICON_B64
except Exception:
    ICON_B64 = None


DELAI_SAUVEGARDE_MS = 700
MARGE_BOUTON = 14
LARGEUR_ICONE = 3

_SANS_EDITEUR = ("quiz", "puzzle", "trou", "decodeur", "arene", "predire", "ordre")

LEVEL_BADGE_NAMES = {
    "monde1": "1 · Premiers pas à Rome 🏛️",
    "monde2": "2 · Dans la maison romaine 🏠",
    "monde3": "3 · Les Dieux de l'Olympe ⚡",
    "monde4": "4 · Les Cas & Travaux d'Hercule 🦁",
    "monde5": "5 · Les Verbes au Présent ⚔️",
    "monde6": "6 · Les Gladiateurs & le Colisée 🛡️",
    "monde7": "7 · Détective des Mots & Devises 📜",
}



class PythonLearnApp:
    def __init__(self, root):
        self.root = root
        self.data = prog.load_progress()
        self._incident = prog.dernier_incident()
        self.theme_name = self.data.get("theme", "dark")
        if self.theme_name not in THEMES:
            self.theme_name = "dark"
        self.C = THEMES[self.theme_name]
        self.lang = self.data.get("langue", "fr")
        if self.lang not in LANGUES:
            self.lang = "fr"
        self.tr = Translator(self.lang)
        self._i18n = []
        self.code_size = 11
        self.current = None
        self.exo_index = 0
        self._hints = []
        self._hint_idx = 0
        self.search_query = ""
        self._revision_item = None
        self._ignore_next_select = False
        self._echecs_session = 0
        self._tip = None
        self._tip_row = None
        self.soucis_packs = []          # packs de leçons mal formés
        self._save_after_id = None      # sauvegarde différée en attente
        self._code_en_attente = None    # (item_id, texte) restant à écrire

        self.lesson_level = {}
        for level in CURRICULUM:
            for lesson in level["lessons"]:
                self.lesson_level[lesson["id"]] = level

        audio.set_sound_enabled(self.data.get("sound_enabled", True))
        root.title("Ludus Latinus — L'Aventure Romaine 🏛️")
        sw = root.winfo_screenwidth()
        sh = root.winfo_screenheight()
        w_init = min(1180, max(760, sw - 60))
        h_init = min(780, max(520, sh - 80))
        root.geometry(f"{w_init}x{h_init}")
        root.minsize(min(760, sw - 20), min(500, sh - 40))

        self._init_fonts()
        self._build_layout()
        self.apply_theme()
        self._populate_tree()
        self._refresh_badges()
        self._refresh_status()
        self._select_first_incomplete()

        if self._incident:
            self.root.after(400, self._avertir_incident)
        elif not self.data.get("vu_accueil"):
            self.root.after(300, self._show_welcome)
        elif self.data.get("accueil_au_demarrage", True):
            self.root.after(300, self._show_accueil)

    def _avertir_incident(self):
        """Prévient l'apprenant quand la progression n'a pas pu être lue telle quelle."""
        code, detail = self._incident
        self._incident = None
        cle = ("dlg_incident_restaure" if code == prog.INCIDENT_RESTAURE
               else "dlg_incident_perdu")
        messagebox.showwarning(self.tr("dlg_incident_title"),
                               self.tr(cle, chemin=detail))
        if not self.data.get("vu_accueil"):
            self._show_welcome()

    def _a_propos(self):
        """Fenêtre « À propos » : qui a fait l'application, et sous quelle licence."""
        C = self.C
        win = tk.Toplevel(self.root)
        win.title(self.tr("ap_title"))
        win.configure(bg=C["panel"])
        win.resizable(False, False)
        tk.Frame(win, bg=C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

        tk.Label(win, text="🏛️", bg=C["panel"], font=("", 46)).pack(pady=(18, 0))
        tk.Label(win, text=APP_NAME, bg=C["panel"], fg=C["accent"],
                 font=("", 22, "bold")).pack()
        tk.Label(win, text=self.tr("ap_version", v=__version__),
                 bg=C["panel"], fg=C["muted"]).pack(pady=(2, 12))

        tk.Label(win, text=self.tr("ap_par"), bg=C["panel"], fg=C["muted"],
                 font=("", 9)).pack()
        tk.Label(win, text=AUTEUR, bg=C["panel"], fg=C["fg"],
                 font=("", 15, "bold")).pack(pady=(0, 14))

        tk.Label(win, text=self.tr("ap_desc"), bg=C["panel"], fg=C["fg"],
                 wraplength=380, justify="center").pack(padx=24)
        tk.Label(win, text=self.tr("ap_licence"), bg=C["panel"], fg=C["muted"],
                 font=("", 9)).pack(pady=(14, 4))

        barre = ttk.Frame(win, style="Panel.TFrame")
        barre.pack(pady=(6, 18))
        ttk.Button(barre, text="🔄 Mises à jour",
                   command=self._ouvrir_mise_a_jour).pack(side=tk.LEFT, padx=4)
        ttk.Button(barre, text=self.tr("ap_depot"),
                   command=lambda: webbrowser.open(DEPOT)).pack(side=tk.LEFT, padx=4)
        ttk.Button(barre, text=self.tr("ap_fermer"),
                   command=win.destroy).pack(side=tk.LEFT, padx=4)
        win.bind("<Escape>", lambda e: win.destroy())

    def _ouvrir_mes_lecons(self):
        """Ouvre le dossier des leçons personnelles dans l'explorateur.

        Le dossier est créé au besoin, et garni d'un exemple s'il est vide :
        celui qui découvre la fonction a ainsi tout de suite un fichier à
        modifier, plutôt qu'un dossier vide et une page blanche.
        """
        from content.packs import DOSSIER_PACKS, modele_pack
        try:
            DOSSIER_PACKS.mkdir(parents=True, exist_ok=True)
            exemple = DOSSIER_PACKS / "mon-cours.json"
            if not any(DOSSIER_PACKS.glob("*.json")):
                exemple.write_text(modele_pack(), encoding="utf-8")
        except OSError as exc:
            messagebox.showwarning(self.tr("dlg_lecons_title"), str(exc))
            return

        if not _ouvrir_dossier(DOSSIER_PACKS):
            # Pas d'explorateur disponible : on donne le chemin à recopier.
            messagebox.showinfo(self.tr("dlg_lecons_title"),
                                str(DOSSIER_PACKS))
            return
        messagebox.showinfo(self.tr("dlg_lecons_title"),
                            self.tr("dlg_lecons_msg", dossier=str(DOSSIER_PACKS)))

    def _avertir_packs(self):
        """Signale les leçons ajoutées qui n'ont pas pu être chargées."""
        soucis, self.soucis_packs = self.soucis_packs, []
        if not soucis:
            return
        apercu = "\n".join("• " + souci for souci in soucis[:8])
        if len(soucis) > 8:
            apercu += "\n… et " + str(len(soucis) - 8) + " autre(s)."
        messagebox.showwarning(self.tr("dlg_packs_title"),
                               self.tr("dlg_packs_msg", details=apercu))

    def quitter(self):
        """Ferme l'application après avoir écrit le code encore en attente."""
        self._flush_code()
        self.root.destroy()

    # --------------------------------------------------------------- polices
    def _init_fonts(self):
        from app.polices import get_famille_corps, get_famille_titre
        f_titre = get_famille_titre()
        f_corps = get_famille_corps()

        self.code_font = font.nametofont("TkFixedFont").copy()
        self.code_font.configure(size=self.code_size)
        self.body = font.Font(family=f_corps, size=11)
        self.title_font = font.Font(family=f_titre, size=16, weight="bold")
        self.h2_font = (f_titre, 13, "bold")

    # ---------------------------------------------------------------- layout
    def _tbtn(self, parent, key, command, **kw):
        btn = ttk.Button(parent, text=self.tr(key), command=command, **kw)
        self._i18n.append((btn, key))
        return btn

    def _build_layout(self):
        self.style = ttk.Style()
        try:
            self.style.theme_use("clam")
        except tk.TclError:
            pass

        # barre d'outils supérieure
        toolbar = ttk.Frame(self.root, style="Panel.TFrame")
        toolbar.pack(fill=tk.X, side=tk.TOP)
        self.toolbar = toolbar
        self._boutons_barre = []      # boutons repliables, dans l'ordre
        self._debordement = []        # ceux qui ne tiennent pas, pour le menu
        self._largeur_barre = 0
        self._icones_toolbar = {}     # Références d'icônes romaines 3D

        icones_map = get_icones_toolbar()

        # Pas de largeur fixe : le nom du thème suffit, et la barre est
        # déjà dense.
        self.theme_btn = ttk.Button(toolbar, text="", command=self.cycle_theme)
        self.theme_btn.pack(side=tk.LEFT, padx=4, pady=4)
        self.lang_btn = ttk.Button(toolbar, text=self.tr("tb_lang"), width=6,
                                   command=self.cycle_langue)
        self.lang_btn.pack(side=tk.LEFT, pady=4)
        ttk.Button(toolbar, text="A-", width=3,
                   command=lambda: self._zoom(-1)).pack(side=tk.LEFT, padx=(6, 0), pady=4)
        ttk.Button(toolbar, text="A+", width=3,
                   command=lambda: self._zoom(1)).pack(side=tk.LEFT, padx=(0, 8), pady=4)
        for cle, action in (
            ("tb_accueil", self._show_accueil),
            ("tb_carte", self._ouvrir_carte),
            ("tb_circus", self._ouvrir_circus),
            ("tb_cartes", self._ouvrir_album_cartes),
            ("tb_marche", self._ouvrir_marche_trajan),
            ("tb_cesar", self._ouvrir_chiffre_cesar),
            ("tb_duel", self._ouvrir_duel),
            ("tb_fiches", self._ouvrir_fiches_a4),
            ("tb_profils", self._ouvrir_profils),
            ("tb_maj", self._ouvrir_mise_a_jour),
            ("tb_glossaire", self._show_glossaire),
            ("tb_revision", self._revision),
            ("tb_stats", self._show_stats),
            ("tb_doc", lambda: webbrowser.open("https://fr.wikipedia.org/wiki/Latin")),
            ("tb_brouillon", self._show_sandbox),
            ("tb_reco", self._recommander),
            ("tb_examen", self._mode_examen),
            ("tb_lecons", self._ouvrir_mes_lecons),
        ):
            btn_kw = {}
            if cle in icones_map:
                self._icones_toolbar[cle] = icones_map[cle]
                btn_kw["image"] = icones_map[cle]
                btn_kw["compound"] = tk.LEFT
            bouton = self._tbtn(toolbar, cle, action, **btn_kw)
            self._boutons_barre.append((bouton, cle, action))
            self._infobulle_barre(bouton, cle)

        self._tbtn(toolbar, "tb_reset", self._reset_progress).pack(side=tk.RIGHT, padx=4, pady=4)
        self._tbtn(toolbar, "tb_apropos", self._a_propos).pack(side=tk.RIGHT, pady=4)
        # Bouton de débordement : il n'apparaît que si la place manque.
        self.btn_plus = ttk.Button(toolbar, text="⋯", width=3,
                                   command=self._menu_barre)
        toolbar.bind("<Configure>", self._barre_redimensionnee)
        self._build_header_stats()

        outer = ttk.PanedWindow(self.root, orient=tk.HORIZONTAL)
        self.outer_paned = outer
        outer.pack(fill=tk.BOTH, expand=True, padx=8, pady=(4, 0))

        # --- barre latérale responsive ---
        side = ttk.Frame(outer, style="Panel.TFrame", width=300)
        self.side = side
        self.side_visible = True
        outer.add(side, weight=0)

        side_hdr_box = tk.Frame(side, bg=self.C["panel"])
        side_hdr_box.pack(fill=tk.X, pady=(8, 4), padx=4)

        self.side_header = tk.Label(side_hdr_box, text=self.tr("side_parcours"),
                                    font=self.title_font, anchor="w", bg=self.C["panel"], fg=self.C["heading"])
        self.side_header.pack(side=tk.LEFT, fill=tk.X, expand=True)

        self.btn_collapse_side = tk.Button(
            side_hdr_box, text="◀ Réduire", font=(self.body.cget("family"), 8),
            bg=self.C["editor"], fg=self.C["muted"], relief="flat", padx=6, pady=2, cursor="hand2",
            command=self._toggle_sidebar
        )
        self.btn_collapse_side.pack(side=tk.RIGHT)

        self.search_var = tk.StringVar()
        self.search_entry = tk.Entry(side, textvariable=self.search_var)
        self.search_entry.pack(fill=tk.X, padx=6, pady=(0, 4))
        self.search_entry.bind("<KeyRelease>", self._on_search)

        tree_wrap = ttk.Frame(side, style="Panel.TFrame")
        tree_wrap.pack(fill=tk.BOTH, expand=True, padx=6, pady=4)
        self.tree = ttk.Treeview(tree_wrap, show="tree", selectmode="browse")
        self.tree.column("#0", width=280, minwidth=180, stretch=True)
        sb = ttk.Scrollbar(tree_wrap, orient="vertical", command=self.tree.yview)
        self.tree.configure(yscrollcommand=sb.set)
        self.tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        sb.pack(side=tk.RIGHT, fill=tk.Y)
        self.tree.bind("<<TreeviewSelect>>", self._on_select)
        self.tree.bind("<Motion>", self._tree_tooltip)
        self.tree.bind("<Leave>", lambda e: self._hide_tooltip())

        self.badge_title = tk.Label(side, text=self.tr("side_badges"), anchor="w",
                                    font=(self.body.cget("family"), 10, "bold"))
        self.badge_title.pack(fill=tk.X, padx=4, pady=(2, 0))
        self.badge_bar = tk.Frame(side)
        self.badge_bar.pack(fill=tk.X, padx=6, pady=(2, 8))
        self.badge_labels = {}
        for level in CURRICULUM:
            lbl = tk.Label(self.badge_bar, text="🔒",
                           font=(self.body.cget("family"), 9))
            lbl.pack(side=tk.LEFT, expand=True)
            self.badge_labels[level["id"]] = lbl

        # --- zone principale ---
        main = ttk.PanedWindow(outer, orient=tk.VERTICAL)
        outer.add(main, weight=1)

        top = ttk.Frame(main)
        main.add(top, weight=3)
        top_title_bar = ttk.Frame(top)
        top_title_bar.pack(fill=tk.X, padx=12, pady=(8, 4))

        self.btn_expand_side = tk.Button(
            top_title_bar, text="📚 Parcours", font=(self.body.cget("family"), 9, "bold"),
            bg=self.C["accent"], fg=self.C["sel_fg"], relief="flat", cursor="hand2", padx=8, pady=2,
            command=self._toggle_sidebar
        )
        # N'est affiché que si la barre latérale est repliée

        self.lesson_title = ttk.Label(top_title_bar, text="", style="Title.TLabel")
        self.lesson_title.pack(side=tk.LEFT, fill=tk.X, expand=True)

        self.speak_btn = tk.Button(
            top_title_bar, text="🔊 Écouter", font=(self.body.cget("family"), 9, "bold"),
            relief="flat", cursor="hand2", padx=8, pady=2,
            command=self._prononcer_courant
        )
        self.speak_btn.pack(side=tk.RIGHT, padx=4)

        content_wrap = ttk.Frame(top)
        content_wrap.pack(fill=tk.BOTH, expand=True, padx=12, pady=(0, 4))

        # Mascotte interactive Lupulus le louveteau
        self.mascotte = MascotteWidget(content_wrap, app=self, taille=90, bg=self.C["panel"])
        self.mascotte.pack(side=tk.RIGHT, fill=tk.Y, padx=(10, 0))

        self.content = tk.Text(content_wrap, wrap="word", relief="flat",
                               font=self.body, padx=8, pady=8, height=11,
                               cursor="arrow")
        csb = ttk.Scrollbar(content_wrap, orient="vertical", command=self.content.yview)
        self.content.configure(yscrollcommand=csb.set)
        self.content.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        csb.pack(side=tk.RIGHT, fill=tk.Y)
        self.content.configure(state="disabled")

        # bandeau de succès (superposé)
        self.banner = tk.Label(top, text="", anchor="center")

        self.bottom = ttk.Frame(main)
        main.add(self.bottom, weight=4)
        self._build_exercise_frame()
        self._build_quiz_frame()
        self.vue_puzzle = VuePuzzle(self.bottom, self)
        self.vue_trou = VueTrou(self.bottom, self)
        self.vue_decodeur = VueDecodeur(self.bottom, self)
        self.vue_arene = VueArene(self.bottom, self)
        self.vue_predire = VuePrediction(self.bottom, self)
        self.vue_ordre = VueOrdre(self.bottom, self)
        self.vue_turtle = VueTurtle(self.bottom, self)

        # barre d'état
        status = ttk.Frame(self.root, style="Panel.TFrame")
        status.pack(fill=tk.X, side=tk.BOTTOM)
        self.progress = ttk.Progressbar(status, maximum=total_count(),
                                        length=200, mode="determinate")
        self.progress.pack(side=tk.LEFT, padx=8, pady=6)
        self.status = ttk.Label(status, text="", style="Status.TLabel", anchor="w")
        self.status.pack(side=tk.LEFT, padx=4)

        self.root.bind("<Control-Return>", lambda e: self.run())
        self.root.bind("<Control-p>", lambda e: self._ouvrir_palette())
        self.root.bind("<Control-P>", lambda e: self._ouvrir_palette())
        self.root.bind("<Control-k>", lambda e: self._ouvrir_palette())
        self.root.bind("<Control-K>", lambda e: self._ouvrir_palette())
        self.root.bind("<Control-r>", lambda e: self.reset_code())
        self.root.bind("<Control-R>", lambda e: self.reset_code())
        self.root.bind("<Control-plus>", lambda e: self._zoom(1))
        self.root.bind("<Control-KP_Add>", lambda e: self._zoom(1))
        self.root.bind("<Control-minus>", lambda e: self._zoom(-1))
        self.root.bind("<Control-KP_Subtract>", lambda e: self._zoom(-1))
        self.root.bind("<Control-0>", lambda e: self._zoom(0))

    def _build_header_stats(self):
        """Ruban moderne de gamification & profil en dessous de la barre d'outils."""
        C = self.C
        self.header_strip = tk.Frame(self.root, bg=C["panel"], padx=10, pady=3)
        self.header_strip.pack(fill=tk.X, side=tk.TOP, padx=8, pady=(4, 0))

        left = tk.Frame(self.header_strip, bg=C["panel"])
        left.pack(side=tk.LEFT)

        self.hdr_hero_btn = tk.Button(left, text=" 👦 Marcus", font=(self.body.cget("family"), 9, "bold"),
                                      bg=C["editor"], fg=C["fg"], relief="flat",
                                      padx=6, pady=2, cursor="hand2", command=self._ouvrir_profils)
        self.hdr_hero_btn.pack(side=tk.LEFT, padx=(0, 6))

        self.hdr_streak_lbl = tk.Label(left, text="🔥 0 j", font=(self.body.cget("family"), 9, "bold"),
                                       bg=C["editor"], fg=C["accent"],
                                       padx=8, pady=2, relief="flat")
        self.hdr_streak_lbl.pack(side=tk.LEFT, padx=(0, 6))

        self.hdr_xp_lbl = tk.Label(left, text="🟢 Tiro · Niv. 1 · 0 XP", font=(self.body.cget("family"), 9, "bold"),
                                   bg=C["editor"], fg=C["ok"],
                                   padx=8, pady=2, relief="flat")
        self.hdr_xp_lbl.pack(side=tk.LEFT, padx=(0, 6))

        # Sesterces avec icône romaine 3D
        self._img_sesterce_hdr = charger_icone("icone_sesterce", 20)
        self.hdr_sesterces_lbl = tk.Label(left, text=" 50 Sesterces", font=(self.body.cget("family"), 9, "bold"),
                                          image=self._img_sesterce_hdr, compound=tk.LEFT if self._img_sesterce_hdr else None,
                                          bg=C["editor"], fg="#d4af37",
                                          padx=8, pady=2, relief="flat")
        self.hdr_sesterces_lbl.pack(side=tk.LEFT, padx=(0, 6))

        # Badges / Lauriers avec trophée romain 3D
        self._img_laurier_hdr = charger_icone("icone_laurier", 20)
        self.hdr_badges_lbl = tk.Label(left, text=" 0/7", font=(self.body.cget("family"), 9),
                                       image=self._img_laurier_hdr, compound=tk.LEFT if self._img_laurier_hdr else None,
                                       bg=C["editor"], fg=C["code"],
                                       padx=8, pady=2, relief="flat")
        self.hdr_badges_lbl.pack(side=tk.LEFT, padx=(0, 6))

        right = tk.Frame(self.header_strip, bg=C["panel"])
        right.pack(side=tk.RIGHT)

        # Défi du jour avec icône arène romaine 3D
        self._img_arene_hdr = charger_icone("icone_arene", 20)
        self.hdr_defi_btn = tk.Button(right, text=f" {self.tr('hdr_defi')}", font=(self.body.cget("family"), 9, "bold"),
                                      image=self._img_arene_hdr, compound=tk.LEFT if self._img_arene_hdr else None,
                                      bg=C["accent"], fg=C["sel_fg"], relief="flat",
                                      padx=10, pady=2, cursor="hand2", command=self._lancer_defi_du_jour)
        self.hdr_defi_btn.pack(side=tk.RIGHT, padx=(6, 0))

        # Avatar avec icône médaillon centurion 3D
        self._img_avatar_hdr = charger_icone("icone_profils", 20)
        self.hdr_avatar_btn = tk.Button(right, text=" Mon Avatar", font=(self.body.cget("family"), 9, "bold"),
                                        image=self._img_avatar_hdr, compound=tk.LEFT if self._img_avatar_hdr else None,
                                        bg=C["panel"], fg=C["fg"], relief="flat",
                                        padx=8, pady=2, cursor="hand2", command=self._ouvrir_avatar)
        self.hdr_avatar_btn.pack(side=tk.RIGHT, padx=4)

        # Musée avec amphore / louve romaine 3D
        self._img_musee_hdr = charger_icone("icone_musee", 20)
        self.hdr_musee_btn = tk.Button(right, text=" Musée", font=(self.body.cget("family"), 9, "bold"),
                                       image=self._img_musee_hdr, compound=tk.LEFT if self._img_musee_hdr else None,
                                       bg=C["panel"], fg=C["fg"], relief="flat",
                                       padx=8, pady=2, cursor="hand2", command=self._ouvrir_musee)
        self.hdr_musee_btn.pack(side=tk.RIGHT, padx=4)

        # Son avec cornu / tuba romain 3D
        self._img_tuba_hdr = charger_icone("icone_tuba", 20)
        son_texte = "" if (self._img_tuba_hdr and audio.is_sound_enabled()) else ("🔊" if audio.is_sound_enabled() else "🔇")
        self.hdr_son_btn = tk.Button(right, text=son_texte, font=("Segoe UI Emoji", 10),
                                     image=self._img_tuba_hdr if (self._img_tuba_hdr and audio.is_sound_enabled()) else None,
                                     compound=tk.LEFT,
                                     bg=C["panel"], fg=C["fg"], relief="flat",
                                     padx=6, pady=2, cursor="hand2", command=self._toggle_son)
        self.hdr_son_btn.pack(side=tk.RIGHT, padx=4)

        self.hdr_breadcrumbs_lbl = tk.Label(right, text="", font=(self.body.cget("family"), 9),
                                            bg=C["panel"], fg=C["muted"])
        self.hdr_breadcrumbs_lbl.pack(side=tk.RIGHT, padx=4)

    def _ouvrir_avatar(self):
        AvatarWindow(self.root, self)

    def _ouvrir_musee(self):
        MuseeWindow(self.root, self)

    def _ouvrir_carte(self):
        CarteAventureWindow(self.root, self)

    def _ouvrir_circus(self):
        CircusMaximusWindow(self.root, self)

    def _ouvrir_album_cartes(self):
        AlbumCartesWindow(self.root, self)

    def ouvrir_booster(self, gratuit=False):
        """Ouvre un booster de cartes mythologiques 3D."""
        from app.cartes_collection import PRIX_BOOSTER, BoosterOpeningDialog
        from content.cartes_data import tirage_booster
        if not gratuit:
            sesterces = self.data.get("sesterces", 0)
            if sesterces < PRIX_BOOSTER:
                messagebox.showinfo("Boutique de Cartes", f"Il te faut {PRIX_BOOSTER} Sesterces pour acheter un booster.\nTu en as {sesterces} 🪙.")
                return
            self.ajouter_sesterces(-PRIX_BOOSTER)
        cartes = tirage_booster()
        BoosterOpeningDialog(self.root, self, cartes)

    def _ouvrir_marche_trajan(self):
        MarcheTrajanWindow(self.root, self)

    def _ouvrir_chiffre_cesar(self):
        ChiffreCesarWindow(self.root, self)

    def _ouvrir_duel(self):
        DuelWindow(self.root, self)

    def _ouvrir_fiches_a4(self):
        FichesExportDialog(self.root, self)

    def _toggle_sidebar(self):
        """Replie ou déploie la barre latérale pour maximiser l'espace de lecture."""
        if getattr(self, "side_visible", True):
            self.outer_paned.forget(self.side)
            self.side_visible = False
            self.btn_expand_side.pack(side=tk.LEFT, padx=(0, 8))
        else:
            self.outer_paned.insert(0, self.side, weight=0)
            self.side_visible = True
            self.btn_expand_side.pack_forget()

    def _ouvrir_profils(self):
        ProfileDialog(self.root, self)

    def _ouvrir_mise_a_jour(self):
        MiseAJourDialog(self.root, self)

    def _ouvrir_triomphe(self):
        from app.triomphe import Triomphe5emeDialog
        Triomphe5emeDialog(self.root, self)

    # Réactions interactives de la mascotte Lupulus
    def reagir_succes(self, message=None):
        if hasattr(self, "mascotte") and self.mascotte:
            self.mascotte.reagir_succes(message)

    def reagir_erreur(self, message=None):
        if hasattr(self, "mascotte") and self.mascotte:
            self.mascotte.reagir_erreur(message)

    def reagir_reflexion(self, message=None):
        if hasattr(self, "mascotte") and self.mascotte:
            self.mascotte.reagir_reflexion(message)

    def reagir_triomphe(self, message=None):
        if hasattr(self, "mascotte") and self.mascotte:
            self.mascotte.reagir_triomphe(message)

    def _prononcer_courant(self):
        if not self.current:
            return
        texte = self.current.get("latin") or self.current.get("phrase_latine")
        if not texte:
            t = self.current.get("title", "")
            texte = t.split(":")[-1].strip() if ":" in t else t
        audio.speak_latin(texte)

    def _toggle_son(self):
        nouveau = not audio.is_sound_enabled()
        audio.set_sound_enabled(nouveau)
        self.data["sound_enabled"] = nouveau
        prog.save_progress(self.data)
        if nouveau:
            audio.play_coin()
        self._refresh_header_stats()

    def ajouter_sesterces(self, montant):
        self.data["sesterces"] = self.data.get("sesterces", 0) + montant
        prog.save_progress(self.data)
        self._refresh_header_stats()

    def donnees_niveau(self):
        xp = stats.xp_total(self.data.get("completed", []), self.data.get("badges", []))
        return stats.niveau(xp)

    def _lancer_defi_du_jour(self):
        defi = stats.defi_du_jour(CURRICULUM, date.today())
        if defi:
            self._charger_item(defi["id"])

    def _maj_breadcrumbs(self):
        if not hasattr(self, "hdr_breadcrumbs_lbl"):
            return
        if not self.current:
            self.hdr_breadcrumbs_lbl.configure(text="")
            return
        parcours_titre = ""
        for level in CURRICULUM:
            if any(lecon["id"] == self.current["id"] for lecon in level["lessons"]):
                parcours_titre = self.txt(level, "title")
                break
        lecon_titre = self.txt(self.current, "title")
        n_exo = exercice_count(self.current)
        if n_exo > 1:
            exo_txt = f" › ⚡ {self.exo_index + 1}/{n_exo}"
        else:
            exo_txt = ""
        # Écourter les titres longs pour préserver la lisibilité de la barre
        p_court = parcours_titre if len(parcours_titre) <= 22 else parcours_titre[:20] + "…"
        l_court = lecon_titre if len(lecon_titre) <= 24 else lecon_titre[:22] + "…"
        self.hdr_breadcrumbs_lbl.configure(
            text=f"📁 {p_court} › 📄 {l_court}{exo_txt}"
        )

    def _refresh_header_stats(self):
        if not hasattr(self, "hdr_streak_lbl"):
            return
        C = self.C
        today = date.today()
        s = stats.streak(self.data["historique"], today)
        xp = stats.xp_total(self.data["completed"], self.data["badges"])
        niv_info = stats.niveau(xp)
        nb_badges = len(self.data["badges"])
        total_parcours = len(CURRICULUM)

        genre = prog.get_genre(self.data)
        nom = prog.get_nom_heros(self.data)
        # Préférer le médaillon doré antique 3D
        img_med_name = "avatar_garcon_medaillon_28.png" if genre == "garcon" else "avatar_fille_medaillon_28.png"
        img_p = pathlib.Path(__file__).resolve().parent.parent / "assets" / "images" / img_med_name
        if not img_p.exists():
            img_name = "avatar_garcon_28.png" if genre == "garcon" else "avatar_fille_28.png"
            img_p = pathlib.Path(__file__).resolve().parent.parent / "assets" / "images" / img_name
        if hasattr(self, "hdr_hero_btn"):
            if img_p.exists():
                try:
                    self._hero_hdr_img = tk.PhotoImage(file=str(img_p))
                    self.hdr_hero_btn.configure(
                        image=self._hero_hdr_img,
                        text=f" {nom}",
                        compound="left",
                        bg=C["editor"],
                        fg=C["fg"],
                    )
                except Exception:
                    self.hdr_hero_btn.configure(
                        image="",
                        text=f" {'👦' if genre == 'garcon' else '👧'} {nom}",
                        bg=C["editor"],
                        fg=C["fg"],
                    )
            else:
                self.hdr_hero_btn.configure(
                    image="",
                    text=f" {'👦' if genre == 'garcon' else '👧'} {nom}",
                    bg=C["editor"],
                    fg=C["fg"],
                )

        self.hdr_streak_lbl.configure(
            text=self.tr("hdr_streak", n=s),
            bg=C["editor"], fg=C["accent"]
        )
        rang_titre = niv_info.get("rang_titre", "Tiro")
        rang_icone = niv_info.get("rang_icone", "🟢")
        self.hdr_xp_lbl.configure(
            text=f"{rang_icone} {rang_titre} · Niv. {niv_info['niveau']} · {xp} XP",
            bg=C["editor"], fg=C["ok"]
        )
        # Sesterces avec icône romaine 3D
        if getattr(self, "_img_sesterce_hdr", None):
            self.hdr_sesterces_lbl.configure(
                image=self._img_sesterce_hdr, compound=tk.LEFT,
                text=f" {self.data.get('sesterces', 0)} Sesterces",
                bg=C["editor"]
            )
        else:
            self.hdr_sesterces_lbl.configure(
                text=f"🪙 {self.data.get('sesterces', 0)} Sesterces",
                bg=C["editor"]
            )
        # Lauriers avec trophée romain 3D
        if getattr(self, "_img_laurier_hdr", None):
            self.hdr_badges_lbl.configure(
                image=self._img_laurier_hdr, compound=tk.LEFT,
                text=f" {nb_badges}/{total_parcours}",
                bg=C["editor"], fg=C["code"]
            )
        else:
            self.hdr_badges_lbl.configure(
                text=self.tr("hdr_badges", n=nb_badges, total=total_parcours),
                bg=C["editor"], fg=C["code"]
            )
        if getattr(self, "_img_arene_hdr", None):
            self.hdr_defi_btn.configure(
                image=self._img_arene_hdr, compound=tk.LEFT,
                text=f" {self.tr('hdr_defi')}",
                bg=C["accent"], fg=C["sel_fg"], activebackground=assombrir(C["accent"], 0.2)
            )
        else:
            self.hdr_defi_btn.configure(
                text=self.tr("hdr_defi"),
                bg=C["accent"], fg=C["sel_fg"], activebackground=assombrir(C["accent"], 0.2)
            )
        self.hdr_avatar_btn.configure(bg=C["panel"], fg=C["fg"])
        self.hdr_musee_btn.configure(bg=C["panel"], fg=C["fg"])
        if audio.is_sound_enabled():
            if getattr(self, "_img_tuba_hdr", None):
                self.hdr_son_btn.configure(image=self._img_tuba_hdr, text="", bg=C["panel"], fg=C["fg"])
            else:
                self.hdr_son_btn.configure(image="", text="🔊", bg=C["panel"], fg=C["fg"])
        else:
            self.hdr_son_btn.configure(image="", text="🔇", bg=C["panel"], fg=C["fg"])
        self.header_strip.configure(bg=C["panel"])
        self.hdr_breadcrumbs_lbl.configure(bg=C["panel"], fg=C["muted"])
        self._maj_breadcrumbs()

    def _animer_confettis(self):
        """Anime une cascade de confettis vectoriels sur l'interface lors d'une réussite."""
        try:
            cv = tk.Canvas(self.root, bg=self.C["panel"], highlightthickness=0)
            cv.place(relx=0, rely=0, relwidth=1, relheight=1)
            couleurs = [self.C["accent"], self.C["ok"], self.C["code"], self.C["heading"],
                        "#ff5555", "#50fa7b", "#ffb86c", "#8be9fd", "#bd93f9"]
            particules = []
            w = self.root.winfo_width() or 800
            for _ in range(45):
                px = random.randint(20, max(40, w - 20))
                py = random.randint(-80, 20)
                vx = random.uniform(-1.5, 1.5)
                vy = random.uniform(3.5, 7.5)
                taille = random.randint(6, 11)
                c = random.choice(couleurs)
                pid = cv.create_rectangle(px, py, px + taille, py + taille, fill=c, outline="")
                particules.append({"id": pid, "x": px, "y": py, "vx": vx, "vy": vy, "w": taille})

            def step(frame=0):
                if frame > 45 or not cv.winfo_exists():
                    try:
                        cv.destroy()
                    except Exception:
                        pass
                    return
                for p in particules:
                    p["x"] += p["vx"]
                    p["y"] += p["vy"]
                    p["vy"] += 0.15
                    try:
                        cv.coords(p["id"], p["x"], p["y"], p["x"] + p["w"], p["y"] + p["w"])
                    except Exception:
                        pass
                self.root.after(25, lambda: step(frame + 1))

            step(0)
        except Exception:
            pass

    def _barre_redimensionnee(self, event):
        """Ne recalcule que si la largeur a réellement changé.

        Replacer les boutons déclenche un nouvel événement « Configure » :
        sans ce garde-fou, on bouclerait indéfiniment.
        """
        if event.width == self._largeur_barre:
            return
        self._largeur_barre = event.width
        self.root.after_idle(self._ajuster_barre)

    @staticmethod
    def _icone_de(libelle):
        """Première partie d'un libellé quand c'est une icône (« 🏠 Accueil » -> « 🏠 »)."""
        morceaux = libelle.split()
        if morceaux and not morceaux[0][0].isalnum():
            return morceaux[0]
        return libelle

    def _ajuster_barre(self):
        """Adapte la barre à la largeur de la fenêtre, en trois temps.

        La barre s'est enrichie au fil des versions. En fenêtre étroite,
        les derniers boutons sortaient simplement de l'écran, sans aucun
        moyen de les atteindre — ni menu, ni défilement.

        On essaie donc, dans l'ordre :
          1. les libellés complets, les plus clairs pour un débutant ;
          2. les icônes seules, avec le nom en infobulle ;
          3. le menu « ⋯ » pour ce qui ne tient toujours pas.
        """
        if not self.toolbar.winfo_exists():
            return
        largeur = self.toolbar.winfo_width()
        if largeur <= 1:                     # fenêtre pas encore dessinée
            return

        # Place prise par ce qui n'est pas repliable (thème, langue, zoom à
        # gauche ; réinitialiser et à propos à droite).
        occupe = 0
        for enfant in self.toolbar.winfo_children():
            repliable = any(enfant is b for b, _, _ in self._boutons_barre)
            if repliable or enfant is self.btn_plus:
                continue
            occupe += enfant.winfo_reqwidth() + MARGE_BOUTON
        disponible = largeur - occupe - (self.btn_plus.winfo_reqwidth() + MARGE_BOUTON)

        for bouton, _, _ in self._boutons_barre:
            bouton.pack_forget()

        # Faut-il passer en icônes seules ? On compare la largeur totale
        # des libellés complets à la place réellement disponible.
        for bouton, cle, _ in self._boutons_barre:
            bouton.configure(text=self.tr(cle), width=0)
        # Tk ne recalcule la largeur demandée qu'au prochain temps mort :
        # sans cela on mesurerait encore l'ancien libellé.
        self.toolbar.update_idletasks()
        entier = sum(b.winfo_reqwidth() + MARGE_BOUTON
                     for b, _, _ in self._boutons_barre)
        if entier > disponible:
            # Le thème ttk impose une largeur minimale identique à tous les
            # boutons : changer le texte ne suffit pas, il faut aussi fixer
            # « width », exprimé en caractères.
            for bouton, cle, _ in self._boutons_barre:
                if cle in getattr(self, "_icones_toolbar", {}):
                    bouton.configure(text="", width=0)
                else:
                    bouton.configure(text=self._icone_de(self.tr(cle)),
                                     width=LARGEUR_ICONE)
            self.toolbar.update_idletasks()

        self._debordement = []
        utilise = 0
        for bouton, cle, action in self._boutons_barre:
            besoin = bouton.winfo_reqwidth() + MARGE_BOUTON
            if utilise + besoin <= disponible:
                bouton.pack(side=tk.LEFT, padx=3, pady=4)
                utilise += besoin
            else:
                self._debordement.append((cle, action))

        if self._debordement:
            self.btn_plus.pack(side=tk.RIGHT, padx=4, pady=4)
        else:
            self.btn_plus.pack_forget()

    def _infobulle_barre(self, bouton, cle):
        """Affiche le nom complet au survol : une icône seule ne dit pas tout."""
        def entrer(_e=None):
            if bouton.cget("text") == self.tr(cle):
                return                      # libellé complet : rien à ajouter
            self._masquer_infobulle()
            self._bulle = tk.Toplevel(self.root)
            self._bulle.overrideredirect(True)
            self._bulle.attributes("-topmost", True)
            tk.Label(self._bulle, text=self.tr(cle), bg=self.C["panel"],
                     fg=self.C["fg"], padx=8, pady=3,
                     borderwidth=1, relief="solid").pack()
            self._bulle.geometry(
                f"+{bouton.winfo_rootx()}+{bouton.winfo_rooty() + bouton.winfo_height() + 2}")

        bouton.bind("<Enter>", entrer)
        bouton.bind("<Leave>", lambda e: self._masquer_infobulle())

    def _masquer_infobulle(self):
        bulle = getattr(self, "_bulle", None)
        if bulle is not None and bulle.winfo_exists():
            bulle.destroy()
        self._bulle = None

    def _menu_barre(self):
        """Ouvre le menu des boutons qui n'ont pas trouvé leur place."""
        menu = tk.Menu(self.root, tearoff=0)
        for cle, action in self._debordement:
            menu.add_command(label=self.tr(cle), command=action)
        try:
            menu.tk_popup(self.btn_plus.winfo_rootx(),
                          self.btn_plus.winfo_rooty()
                          + self.btn_plus.winfo_height())
        finally:
            menu.grab_release()

    def _build_exercise_frame(self):
        self.exo_frame = ttk.Frame(self.bottom)
        self.exo_tabs = ttk.Frame(self.exo_frame)
        self.exo_tabs.pack(fill=tk.X, padx=12, pady=(6, 0))
        self.tab_buttons = []

        self.mode_label = ttk.Label(self.exo_frame, text="", style="Mode.TLabel",
                                    wraplength=760, justify="left")
        self.mode_label.pack(anchor="w", padx=12, pady=(4, 0))

        self.enonce = ttk.Label(self.exo_frame, text="", style="Muted.TLabel",
                                wraplength=700, justify="left")
        self.enonce.pack(anchor="w", padx=12, pady=(2, 2))

        ed_wrap = ttk.Frame(self.exo_frame)
        ed_wrap.pack(fill=tk.BOTH, expand=True, padx=12)
        self.editor = CodeEditor(ed_wrap, self.code_font,
                                 on_change=self._on_code_change,
                                 on_syntax=self._maj_syntaxe)
        self.editor.pack(fill=tk.BOTH, expand=True)

        self.syntax_label = ttk.Label(self.exo_frame, text="", style="Muted.TLabel")
        self.syntax_label.pack(anchor="w", padx=12)

        btns = ttk.Frame(self.exo_frame)
        btns.pack(fill=tk.X, padx=12, pady=6)
        self._tbtn(btns, "btn_run", self.run, style="Primary.TButton").pack(side=tk.LEFT)
        self._tbtn(btns, "btn_check", self.check, style="Primary.TButton").pack(side=tk.LEFT, padx=6)
        self._tbtn(btns, "btn_step", self._pas_a_pas).pack(side=tk.LEFT)
        self._tbtn(btns, "btn_hint", self.show_hint).pack(side=tk.LEFT, padx=6)
        self._tbtn(btns, "btn_solution", self.show_solution).pack(side=tk.LEFT)
        self._tbtn(btns, "btn_export", self._exporter_py).pack(side=tk.LEFT, padx=6)
        self._tbtn(btns, "tb_bytecode", self._ouvrir_bytecode).pack(side=tk.LEFT)
        self._tbtn(btns, "btn_note", self._editer_note).pack(side=tk.LEFT, padx=6)
        self.fav_btn = ttk.Button(btns, text=self.tr("fav_non"), width=3,
                                  command=self._toggle_favori)
        self.fav_btn.pack(side=tk.LEFT, padx=6)
        ttk.Button(btns, text="↺", width=3, command=self.reset_code).pack(side=tk.LEFT)
        self.feedback = ttk.Label(btns, text="", style="TLabel")
        self.feedback.pack(side=tk.LEFT, padx=10)

        con_wrap = ttk.Frame(self.exo_frame)
        con_wrap.pack(fill=tk.BOTH, expand=True, padx=12, pady=(0, 4))
        self.console = tk.Text(con_wrap, wrap="word", relief="flat",
                               font=self.code_font, height=6, padx=10, pady=8,
                               state="disabled")
        consb = ttk.Scrollbar(con_wrap, orient="vertical", command=self.console.yview)
        self.console.configure(yscrollcommand=consb.set)
        self.console.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        consb.pack(side=tk.RIGHT, fill=tk.Y)

    def _build_quiz_frame(self):
        self.quiz_frame = ttk.Frame(self.bottom)
        self.quiz_question = ttk.Label(self.quiz_frame, text="", style="Title.TLabel",
                                       wraplength=720, justify="left")
        self.quiz_question.pack(anchor="w", padx=16, pady=(16, 10))
        self.quiz_var = tk.IntVar(value=-1)
        self.quiz_options = ttk.Frame(self.quiz_frame)
        self.quiz_options.pack(anchor="w", padx=24)
        self.quiz_radios = []
        self._tbtn(self.quiz_frame, "quiz_validate", self.check_quiz).pack(
            anchor="w", padx=16, pady=12)
        self.quiz_feedback = ttk.Label(self.quiz_frame, text="", style="TLabel",
                                       wraplength=720, justify="left")
        self.quiz_feedback.pack(anchor="w", padx=16)

        # Adaptation dynamique du saut de ligne lors du redimensionnement d'écran
        def _sur_configure_bottom(event):
            w = max(240, event.width - 40)
            try:
                self.mode_label.configure(wraplength=w)
                self.enonce.configure(wraplength=w)
                self.feedback.configure(wraplength=w)
                self.quiz_question.configure(wraplength=w)
                self.quiz_feedback.configure(wraplength=w)
            except Exception:
                pass
        self.bottom.bind("<Configure>", _sur_configure_bottom)

    # ----------------------------------------------------------------- thème
    def apply_theme(self):
        C = self.C
        self.root.configure(bg=C["bg"])
        s = self.style
        s.configure("TFrame", background=C["bg"])
        s.configure("Panel.TFrame", background=C["panel"])
        s.configure("TLabel", background=C["bg"], foreground=C["fg"])
        s.configure("Muted.TLabel", background=C["bg"], foreground=C["muted"])
        s.configure("Mode.TLabel", background=C["bg"], foreground=C["accent"],
                    font=(self.body.cget("family"), 10, "bold"))
        s.configure("Title.TLabel", background=C["bg"], foreground=C["fg"],
                    font=self.title_font)
        s.configure("Status.TLabel", background=C["panel"], foreground=C["muted"])

        # Boutons plats et modernes, avec effet de survol.
        survol = eclaircir(C["panel"], 0.10) if self.theme_name != "light" \
            else assombrir(C["panel"], 0.06)
        s.configure("TButton", font=self.body, relief="flat", borderwidth=0,
                    padding=(11, 6), background=C["panel"], foreground=C["fg"],
                    focuscolor=C["panel"], bordercolor=C["panel"],
                    lightcolor=C["panel"], darkcolor=C["panel"])
        s.map("TButton",
              background=[("pressed", assombrir(C["panel"], 0.10)),
                          ("active", survol)],
              foreground=[("disabled", C["muted"])])
        # Boutons primaires (Exécuter / Vérifier) en couleur d'accent.
        s.configure("Primary.TButton", background=C["accent"], foreground=C["sel_fg"],
                    font=(self.body.cget("family"), 10, "bold"), padding=(13, 6),
                    borderwidth=0, relief="flat", focuscolor=C["accent"],
                    bordercolor=C["accent"], lightcolor=C["accent"],
                    darkcolor=C["accent"])
        s.map("Primary.TButton",
              background=[("pressed", assombrir(C["accent"], 0.22)),
                          ("active", assombrir(C["accent"], 0.10))])
        s.configure("TButton", font=self.body)
        s.configure("TEntry", fieldbackground=C["editor"], foreground=C["fg"])
        s.configure("Treeview", background=C["panel"], fieldbackground=C["panel"],
                    foreground=C["fg"], rowheight=29, borderwidth=0)
        s.map("Treeview", background=[("selected", C["accent"])],
              foreground=[("selected", C["sel_fg"])])
        s.configure("TProgressbar", background=C["accent"], troughcolor=C["bg"],
                    borderwidth=0, thickness=10, bordercolor=C["bg"],
                    lightcolor=C["accent"], darkcolor=C["accent"])
        s.configure("Niv.Horizontal.TProgressbar", background=C["ok"],
                    troughcolor=C["panel"], borderwidth=0, thickness=12,
                    lightcolor=C["ok"], darkcolor=C["ok"])

        self.content.configure(bg=C["bg"], fg=C["fg"], insertbackground=C["fg"])
        self.console.configure(bg=C["console"], fg=C["fg"], insertbackground=C["fg"])
        self.editor.apply_theme(C)
        self.search_entry.configure(bg=C["editor"], fg=C["fg"], insertbackground=C["fg"],
                                    relief="flat")
        self.side_header.configure(bg=C["panel"], fg=C["accent"])
        self.badge_title.configure(bg=C["panel"], fg=C["muted"])
        self.badge_bar.configure(bg=C["panel"])
        self.banner.configure(bg=C["panel"], fg=C["fg"])

        self._configure_text_tags()
        self.console.tag_configure("ok", foreground=C["ok"])
        self.console.tag_configure("err", foreground=C["err"])
        self.console.tag_configure("muted", foreground=C["muted"])
        self.console.tag_configure("hint", foreground=C["accent"])
        self.console.tag_configure("var", foreground=C["builtin"])
        self.tree.tag_configure("done", foreground=C["ok"])
        self.tree.tag_configure("level", foreground=C["heading"])

        self.vue_puzzle.appliquer_theme(C)
        self.vue_trou.appliquer_theme(C)
        self.vue_decodeur.appliquer_theme(C)
        self.vue_arene.appliquer_theme(C)
        self.vue_predire.appliquer_theme(C)
        self.vue_ordre.appliquer_theme(C)
        self.vue_turtle.appliquer_theme(C)

        label = self.C["label_en"] if self.lang == "en" else self.C["label"]
        self.theme_btn.configure(text=self.tr("tb_theme", label=label))
        self._refresh_badges()
        self._refresh_header_stats()

    def cycle_langue(self):
        i = (LANGUES.index(self.lang) + 1) % len(LANGUES)
        self.lang = LANGUES[i]
        self.tr.set(self.lang)
        prog.set_langue(self.data, self.lang)
        self._apply_language()

    def _apply_language(self):
        for widget, key in self._i18n:
            try:
                widget.configure(text=self.tr(key))
            except tk.TclError:
                pass
        self.lang_btn.configure(text=self.tr("tb_lang"))
        self.side_header.configure(text=self.tr("side_parcours"))
        self.badge_title.configure(text=self.tr("side_badges"))
        label = self.C["label_en"] if self.lang == "en" else self.C["label"]
        self.theme_btn.configure(text=self.tr("tb_theme", label=label))
        self._refresh_status()
        self._refresh_header_stats()
        self.vue_predire.traduire()
        self.vue_ordre.traduire()
        self.vue_turtle.traduire()
        self._retraduire_lecon()
        self._ajuster_barre()      # les libellés changent de longueur
        if self.current and self.current.get("type") not in ("quiz", "predire", "ordre"):
            self.editor._verifier_syntaxe()

    def _retraduire_lecon(self):
        """Met la leçon affichée dans la nouvelle langue, immédiatement.

        Sans cela, changer de langue ne touchait que les boutons : le
        titre, l'énoncé et le cours restaient dans l'ancienne langue
        jusqu'au prochain changement de leçon.

        On ne recharge pas la leçon : cela viderait la console et
        effacerait le retour de la dernière vérification.
        """
        self._populate_tree()
        lecon = self.current
        if not lecon:
            return

        # L'arbre vient d'être reconstruit : on y resélectionne la leçon.
        for noeud, candidate in self.item_to_lesson.items():
            if candidate is lecon:
                self._ignore_next_select = True
                self.tree.selection_set(noeud)
                self.tree.see(noeud)
                break

        self.lesson_title.configure(text=self.txt(lecon, "title"))
        self._render_content(self.txt(lecon, "content"))

        if lecon.get("type") == "quiz":
            self._load_quiz(lecon)
        elif lecon.get("type") not in ("predire", "ordre"):
            multi = exercice_count(lecon) > 1
            exo = get_exercice(lecon, self.exo_index)
            if multi:
                self.enonce.configure(text=self.txt(exo, "prompt"))
            self._hints = hints_for(lecon, exo if multi else None, self.lang)
            self._hint_idx = 0

    def cycle_theme(self):
        i = (THEME_ORDER.index(self.theme_name) + 1) % len(THEME_ORDER)
        self.theme_name = THEME_ORDER[i]
        self.C = THEMES[self.theme_name]
        prog.set_theme(self.data, self.theme_name)
        self.apply_theme()

    def _zoom(self, delta):
        if delta == 0:
            self.code_size = 11
            body_size = 11
        else:
            self.code_size = max(8, min(24, self.code_size + delta))
            actuelle = self.body.cget("size")
            body_size = max(9, min(20, actuelle + delta))
        self.code_font.configure(size=self.code_size)
        self.body.configure(size=body_size)
        self._configure_text_tags()
        self.editor.refresh_font()
        self.editor.highlight()
        if self.current:
            self._render_content(self.txt(self.current, "content"))

    def _configure_text_tags(self):
        C = self.C
        self.content.tag_configure("h2", foreground=C["heading"], font=self.h2_font,
                                   spacing1=8, spacing3=4)
        self.content.tag_configure("body", foreground=C["fg"], spacing3=4, font=self.body)
        self.content.tag_configure("code", foreground=C["code"], background=C["code_bg"],
                                   font=self.code_font, lmargin1=16, lmargin2=16,
                                   spacing1=2, spacing3=2)
        self.content.tag_configure("inline", foreground=C["code"], font=self.code_font)
        self.content.tag_configure("bullet", foreground=C["fg"], lmargin1=16, lmargin2=30)
        self.content.tag_configure("bold", font=(self.body.cget("family"), 11, "bold"))
        self.content.tag_configure("tip_title", foreground=C["accent"], font=(self.body.cget("family"), 10, "bold"), spacing1=8, lmargin1=12, lmargin2=12)
        self.content.tag_configure("tip_body", foreground=C["fg"], lmargin1=16, lmargin2=16, spacing3=4, font=self.body)
        self.content.tag_configure("warn_title", foreground=C["err"], font=(self.body.cget("family"), 10, "bold"), spacing1=8, lmargin1=12, lmargin2=12)
        self.content.tag_configure("warn_body", foreground=C["fg"], lmargin1=16, lmargin2=16, spacing3=4, font=self.body)
        self.content.tag_configure("note_title", foreground=C["ok"], font=(self.body.cget("family"), 10, "bold"), spacing1=8, lmargin1=12, lmargin2=12)
        self.content.tag_configure("note_body", foreground=C["fg"], lmargin1=16, lmargin2=16, spacing3=4, font=self.body)

    # ---------------------------------------------------------------- arbre
    def _on_search(self, _e):
        self.search_query = self.search_var.get().strip().lower()
        self._populate_tree()

    def _tree_tooltip(self, e):
        row = self.tree.identify_row(e.y)
        if not row:
            self._hide_tooltip()
            return
        if row == self._tip_row:
            return
        self._hide_tooltip()
        self._tip_row = row
        texte = self.tree.item(row, "text").strip()
        if not texte:
            return
        self._tip = tk.Toplevel(self.tree)
        self._tip.overrideredirect(True)
        self._tip.attributes("-topmost", True)
        self._tip.geometry(f"+{e.x_root + 16}+{e.y_root + 12}")
        tk.Label(self._tip, text=texte, bg=self.C["panel"], fg=self.C["fg"],
                 relief="solid", borderwidth=1, padx=6, pady=2,
                 font=self.body).pack()

    def _hide_tooltip(self):
        if self._tip:
            self._tip.destroy()
            self._tip = None
        self._tip_row = None

    def _populate_tree(self):
        self.tree.delete(*self.tree.get_children())
        self.item_to_lesson = {}
        q = self.search_query
        for level in CURRICULUM:
            lessons = [lecon for lecon in level["lessons"]
                       if not q or q in self.txt(lecon, "title").lower()]
            if q and not lessons:
                continue
            done = sum(1 for lecon in level["lessons"]
                       if lesson_done(lecon, self.data["completed"]))
            total = len(level["lessons"])
            badge = " 🏅" if level["id"] in self.data["badges"] else ""
            parent = self.tree.insert(
                "", "end", open=True, tags=("level",),
                text=f"  {self.txt(level, 'title')}  ({done}/{total}){badge}")
            for lesson in lessons:
                d = lesson_done(lesson, self.data["completed"])
                if d:
                    icone = "✓"
                elif lesson.get("type") == "quiz":
                    icone = "?"
                elif lesson.get("mode") == "debug":
                    icone = "🐞"
                elif lesson.get("mode") == "trous":
                    icone = "✏"
                else:
                    icone = "•"
                suffixe = self._suffixe_lecon(lesson)
                node = self.tree.insert(parent, "end",
                                        text=f"  {icone} {self.txt(lesson, 'title')}{suffixe}",
                                        tags=("done",) if d else ())
                self.item_to_lesson[node] = lesson

    def _suffixe_lecon(self, lesson):
        """Petits marqueurs en fin de titre : ★ favori, 📝 note."""
        suffixe = ""
        if lesson.get("id") in self.data["favoris"]:
            suffixe += "  ★"
        if lesson.get("id") in self.data["notes"]:
            suffixe += " 📝"
        return suffixe

    def _refresh_badges(self):
        C = self.C
        for level in CURRICULUM:
            lbl = self.badge_labels[level["id"]]
            earned = level["id"] in self.data["badges"]
            lbl.configure(text="🏅" if earned else "🔒", bg=C["panel"],
                          fg=C["accent"] if earned else C["muted"])

    def _select_first_incomplete(self):
        for node, lesson in self.item_to_lesson.items():
            if not lesson_done(lesson, self.data["completed"]):
                self.tree.selection_set(node)
                self.tree.see(node)
                return
        if self.item_to_lesson:
            self.tree.selection_set(next(iter(self.item_to_lesson)))

    def _on_select(self, _e):
        if self._ignore_next_select:
            self._ignore_next_select = False
            return
        sel = self.tree.selection()
        if not sel:
            return
        lesson = self.item_to_lesson.get(sel[0])
        if lesson:
            self._load_lesson(lesson)

    # -------------------------------------------------------------- chargement
    def txt(self, element, champ, defaut=""):
        """Champ d'une leçon dans la langue de l'interface.

        Le contenu pédagogique est écrit en français ; ce raccourci sert
        la traduction quand elle existe, et le français sinon.
        """
        return traduit(element, champ, self.lang, defaut)

    def _load_lesson(self, lesson):
        self._flush_code()          # le code de la leçon quittée part sur disque
        self.current = lesson
        self.exo_index = 0
        self._revision_item = None
        self._echecs_session = 0
        self.lesson_title.configure(text=self.txt(lesson, "title"))
        self._maj_favori_btn()
        self._render_content(self.txt(lesson, "content"))
        if hasattr(self, "mascotte") and self.mascotte:
            titre = self.txt(lesson, "title")
            if "·" in titre:
                titre = titre.split("·")[-1].strip()
            self.mascotte.set_emotion("normal", f"Salvete ! Découvrons ensemble : {titre} !")
        self._masquer_cadres()
        type_lecon = lesson.get("type")
        if type_lecon == "quiz":
            self.quiz_frame.pack(fill=tk.BOTH, expand=True)
            self._load_quiz(lesson)
        elif type_lecon == "puzzle":
            self.vue_puzzle.afficher()
            self.vue_puzzle.charger(lesson)
        elif type_lecon == "trou":
            self.vue_trou.afficher()
            self.vue_trou.charger(lesson)
        elif type_lecon == "decodeur":
            self.vue_decodeur.afficher()
            self.vue_decodeur.charger(lesson)
        elif type_lecon == "arene":
            self.vue_arene.afficher()
            self.vue_arene.charger(lesson)
        elif type_lecon == "predire":
            self.vue_predire.afficher()
            self.vue_predire.charger(lesson)
        elif type_lecon == "ordre":
            self.vue_ordre.afficher()
            self.vue_ordre.charger(lesson)
        elif type_lecon == "turtle":
            self.vue_turtle.afficher()
            self.vue_turtle.charger(lesson)
        else:
            self.exo_frame.pack(fill=tk.BOTH, expand=True)
            self._build_exo_tabs()
            self._load_exercice(0)
        self._maj_breadcrumbs()

    def _masquer_cadres(self):
        """Retire de l'affichage toutes les vues, avant d'en montrer une."""
        self.exo_frame.pack_forget()
        self.quiz_frame.pack_forget()
        self.vue_puzzle.masquer()
        self.vue_trou.masquer()
        self.vue_decodeur.masquer()
        self.vue_arene.masquer()
        self.vue_predire.masquer()
        self.vue_ordre.masquer()
        self.vue_turtle.masquer()

    def _maj_favori_btn(self):
        if not self.current:
            return
        actif = self.current.get("id") in self.data["favoris"]
        self.fav_btn.configure(text=self.tr("fav_oui" if actif else "fav_non"))

    def _toggle_favori(self):
        if not self.current:
            return
        actif = prog.toggle_favori(self.data, self.current["id"])
        self.fav_btn.configure(text=self.tr("fav_oui" if actif else "fav_non"))
        self._populate_tree()

    def _mode_examen(self):
        quizzes = [lesson for level in CURRICULUM for lesson in level["lessons"]
                   if lesson.get("type") == "quiz"]
        if not quizzes:
            return
        questions = random.sample(quizzes, min(10, len(quizzes)))
        ExamWindow(self.root, self, questions, self.C)

    def _editer_note(self):
        if not self.current:
            return
        C = self.C
        cid = self.current["id"]
        win = tk.Toplevel(self.root)
        win.title(self.tr("note_title"))
        win.configure(bg=C["bg"])
        win.geometry("460x320")
        tk.Label(win, text=self.tr("note_intro"), bg=C["bg"], fg=C["muted"],
                 anchor="w").pack(fill=tk.X, padx=12, pady=(10, 4))
        txt = tk.Text(win, wrap="word", relief="flat", font=self.body,
                      bg=C["console"], fg=C["fg"], padx=8, pady=6)
        txt.pack(fill=tk.BOTH, expand=True, padx=12)
        txt.insert("1.0", self.data["notes"].get(cid, ""))

        def enregistrer():
            prog.set_note(self.data, cid, txt.get("1.0", "end").strip())
            self._populate_tree()
            win.destroy()
        ttk.Button(win, text=self.tr("note_save"),
                   command=enregistrer).pack(pady=10)
        txt.focus_set()

    def _ordre_item_ids(self):
        ids = []
        for level in CURRICULUM:
            for lesson in level["lessons"]:
                ids.extend(lesson_items(lesson))
        return ids

    def _recommander(self):
        dus = stats.dus(self.data["srs"], date.today(), self.data["completed"])
        action, item_id = stats.prochaine_action(
            self._ordre_item_ids(), self.data["completed"], dus)
        if action == "termine":
            messagebox.showinfo(self.tr("reco_title"), self.tr("reco_termine"))
            return
        self._charger_item(item_id)
        cle = "reco_revision" if action == "revision" else "reco_nouvelle"
        if action == "revision":
            self._revision_item = item_id
        self.feedback.configure(text=self.tr(cle), foreground=self.C["accent"])

    def _build_exo_tabs(self):
        for b in self.tab_buttons:
            b.destroy()
        self.tab_buttons = []
        n = exercice_count(self.current)
        if n <= 1:
            return
        items = lesson_items(self.current)
        for i in range(n):
            done = items[i] in self.data["completed"]
            pastille = "●" if done else ("◆" if i == self.exo_index else "○")
            lbl_text = f"{pastille} {self.tr('crumb_exo')} {i + 1}"
            style_name = "Primary.TButton" if i == self.exo_index else "TButton"
            b = ttk.Button(self.exo_tabs, text=lbl_text, style=style_name,
                           command=lambda idx=i: self._load_exercice(idx))
            b.pack(side=tk.LEFT, padx=(0, 6))
            self.tab_buttons.append(b)

    def _load_exercice(self, index):
        self._flush_code()          # idem entre deux exercices d'un projet
        self.exo_index = index
        exo = get_exercice(self.current, index)
        item_id = lesson_items(self.current)[index]
        self.enonce.configure(
            text=self.txt(exo, "prompt") if exercice_count(self.current) > 1 else "")
        mode = exo.get("mode") or self.current.get("mode")
        if mode == "debug":
            self.mode_label.configure(text=self.tr("mode_debug"))
        elif mode == "trous":
            self.mode_label.configure(text=self.tr("mode_trous"))
        else:
            self.mode_label.configure(text="")
        saved = self.data["code"].get(item_id)
        self.editor.set_text(saved if saved is not None else exo.get("starter", ""))
        self._hints = hints_for(self.current,
                                exo if exercice_count(self.current) > 1 else None,
                                self.lang)
        self._hint_idx = 0
        self.feedback.configure(text="")
        self._clear_console()
        self._hide_banner()
        self._build_exo_tabs()
        self._maj_breadcrumbs()

    def _load_quiz(self, lesson):
        self.quiz_var.set(-1)
        self.quiz_question.configure(text=self.txt(lesson, "question"))
        for r in self.quiz_radios:
            r.destroy()
        self.quiz_radios = []
        for i, opt in enumerate(self.txt(lesson, "options", [])):
            r = ttk.Radiobutton(self.quiz_options, text=opt, value=i,
                                variable=self.quiz_var)
            r.pack(anchor="w", pady=3)
            self.quiz_radios.append(r)
        self.quiz_feedback.configure(text="")

    def _render_content(self, text):
        self.content.configure(state="normal")
        self.content.delete("1.0", tk.END)
        in_code = False
        for line in text.splitlines():
            sline = line.strip()
            if sline == "```" or sline.startswith("```"):
                in_code = not in_code
                continue
            if in_code:
                self.content.insert(tk.END, line + "\n", "code")
            elif line.startswith("## "):
                self.content.insert(tk.END, line[3:] + "\n", "h2")
            elif line.startswith("> [!TIP]") or line.startswith("💡 ") or line.startswith("💡"):
                titre = self.tr("callout_tip")
                corps = line.replace("> [!TIP]", "").replace("💡", "").strip()
                self.content.insert(tk.END, f"{titre}\n", "tip_title")
                if corps:
                    self._insert_inline(corps + "\n", "tip_body")
            elif line.startswith("> [!WARNING]") or line.startswith("⚠️ ") or line.startswith("⚠️"):
                titre = self.tr("callout_warn")
                corps = line.replace("> [!WARNING]", "").replace("⚠️", "").strip()
                self.content.insert(tk.END, f"{titre}\n", "warn_title")
                if corps:
                    self._insert_inline(corps + "\n", "warn_body")
            elif line.startswith("> [!NOTE]") or line.startswith("📌 ") or line.startswith("📌"):
                titre = self.tr("callout_note")
                corps = line.replace("> [!NOTE]", "").replace("📌", "").strip()
                self.content.insert(tk.END, f"{titre}\n", "note_title")
                if corps:
                    self._insert_inline(corps + "\n", "note_body")
            elif line.startswith("- "):
                self.content.insert(tk.END, "•  ", "bullet")
                self._insert_inline(line[2:] + "\n", "bullet")
            else:
                self._insert_inline(line + "\n", "body")
        self.content.configure(state="disabled")

    def _insert_inline(self, text, base_tag):
        for i, part in enumerate(text.split("`")):
            if i % 2 == 1:
                self.content.insert(tk.END, part, "inline")
            else:
                for j, seg in enumerate(part.split("**")):
                    tags = (base_tag, "bold") if j % 2 == 1 else base_tag
                    self.content.insert(tk.END, seg, tags)

    # -------------------------------------------------------------- console
    def _clear_console(self):
        self.console.configure(state="normal")
        self.console.delete("1.0", tk.END)
        self.console.configure(state="disabled")

    def _write(self, text, tag=None):
        self.console.configure(state="normal")
        self.console.insert(tk.END, text, tag or ())
        self.console.configure(state="disabled")
        self.console.see(tk.END)

    # ---------------------------------------------------------- bandeau succès
    def _show_banner(self, text, color):
        self.banner.configure(text=text, bg=color, fg="#ffffff")
        self._banner_anim(0)
        self.root.after(2600, self._hide_banner)

    def _banner_anim(self, etape):
        """Petit glissement d'entrée de la bannière (8 images)."""
        n = 8
        if etape > n:
            return
        rely = -0.06 + 0.06 * (etape / n)
        self.banner.place(relx=0.5, rely=rely, anchor="n", relwidth=0.7)
        self.root.after(16, lambda: self._banner_anim(etape + 1))

    def _hide_banner(self):
        self.banner.place_forget()

    # -------------------------------------------------------------- actions
    def _on_code_change(self):
        """Mémorise le code en cours et programme son écriture sur disque.

        On retient l'identifiant de l'exercice MAINTENANT : si l'apprenant
        change de leçon avant la fin du délai, le code partira bien dans
        l'exercice où il a été tapé, et pas dans le suivant.
        """
        if not self.current or self.current.get("type") in _SANS_EDITEUR:
            return
        item_id = lesson_items(self.current)[self.exo_index]
        self._code_en_attente = (item_id, self.editor.get())
        if self._save_after_id is not None:
            self.root.after_cancel(self._save_after_id)
        self._save_after_id = self.root.after(DELAI_SAUVEGARDE_MS, self._flush_code)

    def _flush_code(self):
        """Écrit sans attendre le code en attente (idempotent).

        Appelé par la minuterie, mais aussi avant tout changement de leçon,
        avant d'exécuter ou de vérifier, et à la fermeture de l'application.
        """
        if self._save_after_id is not None:
            self.root.after_cancel(self._save_after_id)
            self._save_after_id = None
        if self._code_en_attente is None:
            return
        item_id, texte = self._code_en_attente
        self._code_en_attente = None
        prog.store_code(self.data, item_id, texte)

    def run(self):
        if not self.current or self.current.get("type") in _SANS_EDITEUR:
            return
        from app.runner import inspecter, run_code
        self._flush_code()
        self._clear_console()
        self._avertir_zombies()
        result, ns = run_code(self.editor.get())
        if result.output:
            self._write(result.output)
        if result.error:
            self._write(self._message_erreur(result, result.error) + "\n", "err")
            conseil = errors.expliquer(result.error, self.lang)
            if conseil:
                self._write("💡 " + conseil + "\n", "hint")
        elif not result.output:
            self._write(self.tr("con_no_output") + "\n", "muted")
        if not result.error:
            variables = inspecter(ns)
            if variables:
                self._write("\n" + self.tr("con_vars") + "\n", "var")
                for nom, rep in variables:
                    self._write(f"{nom} = {rep}\n", "var")
        self.feedback.configure(text="")

    def check(self):
        if not self.current or self.current.get("type") in _SANS_EDITEUR:
            return
        from app.runner import run_exercise
        self._flush_code()
        exo = get_exercice(self.current, self.exo_index)
        self._clear_console()
        self._avertir_zombies()
        mode = exo.get("mode") or self.current.get("mode")
        if mode == "trous" and "____" in self.editor.get():
            self._write(self.tr("trous_restants") + "\n", "muted")
            self.feedback.configure(text=self.tr("fb_fail"), foreground=self.C["err"])
            return
        result, success, message = run_exercise(
            self.editor.get(), check_code=exo.get("check"),
            expected_output=exo.get("expected_output"), stdin_lines=exo.get("stdin"))
        if result.output:
            self._write(result.output)
        item_id = lesson_items(self.current)[self.exo_index]
        if success:
            self._write("\n" + message + "\n", "ok")
            self.feedback.configure(text=self.tr("fb_ok"), foreground=self.C["ok"])
            self._echecs_session = 0
            self._mark_done(item_id)
            self._apres_reussite(item_id)
            self._show_banner(self.tr("banner_exo"), self.C["ok"])
        else:
            self._write("\n" + self._message_erreur(result, message) + "\n", "err")
            if exo.get("expected_output") is not None:
                self._afficher_diff(str(exo["expected_output"]).strip(),
                                    result.output.strip())
            conseil = errors.expliquer(message, self.lang)
            if conseil:
                self._write("💡 " + conseil + "\n", "hint")
            if self._revision_item == item_id:
                stats.planifier(self.data["srs"], item_id, date.today(), reussi=False)
                prog.save_progress(self.data)
                self._revision_item = None
                self._refresh_status()
            prog.enregistrer_echec(self.data, item_id)
            self._echecs_session += 1
            if self._echecs_session >= 2 and self._hints:
                self._write("\n" + self.tr("nudge_indice") + "\n", "hint")
            self.feedback.configure(text=self.tr("fb_fail"), foreground=self.C["err"])

    def valider_item(self, item_id, message_banniere=None):
        """Enregistre la réussite d'un item, quel que soit son type."""
        self._echecs_session = 0
        self._mark_done(item_id)
        self._apres_reussite(item_id)
        self.reagir_succes()
        if message_banniere:
            self._show_banner(message_banniere, self.C["ok"])
        self._animer_confettis()

    def _apres_reussite(self, item_id):
        """Enregistre l'activité du jour et planifie la prochaine révision."""
        today = date.today()
        prog.enregistrer_activite(self.data, today.isoformat())
        reussi_revision = (self._revision_item == item_id)
        stats.planifier(self.data["srs"], item_id, today, reussi=True)
        prog.save_progress(self.data)
        if reussi_revision:
            self._revision_item = None
        self._refresh_status()

    def _avertir_zombies(self):
        """Signale qu'une exécution précédente tourne encore en arrière-plan.

        Cela n'arrive que pour une boucle infinie qui attrape tout et refuse
        de s'arrêter. Mieux vaut le dire que laisser l'apprenant se demander
        pourquoi son application ralentit.
        """
        from app.runner import zombies_actifs
        restantes = zombies_actifs()
        if restantes:
            self._write(self.tr("con_zombie", n=restantes) + "\n", "muted")

    def _message_erreur(self, result, defaut):
        """Texte d'erreur à afficher, traduit quand nous le maîtrisons.

        Les messages venant de Python restent tels quels — apprendre à les
        lire fait partie du programme. Seuls les nôtres, comme l'arrêt pour
        cause de boucle infinie, suivent la langue de l'interface.
        """
        if result.timed_out:
            return self.tr("err_timeout")
        return defaut

    def _afficher_diff(self, attendu, obtenu):
        """Montre côte à côte la sortie attendue et la sortie obtenue."""
        la, lo = attendu.split("\n"), obtenu.split("\n")
        premiere = None
        for i in range(max(len(la), len(lo))):
            a = la[i] if i < len(la) else None
            o = lo[i] if i < len(lo) else None
            if a != o:
                premiere = i + 1
                break
        self._write("\n" + self.tr("con_compare") + "\n", "muted")
        self._write(self.tr("con_expected") + "\n", "muted")
        self._write((attendu or "(rien)") + "\n", "ok")
        self._write(self.tr("con_obtained") + "\n", "muted")
        self._write((obtenu or "(rien)") + "\n", "err")
        if premiere:
            self._write(self.tr("con_first_diff", n=premiere) + "\n", "muted")

    def check_quiz(self):
        if not self.current or self.current.get("type") != "quiz":
            return
        choix = self.quiz_var.get()
        if choix < 0:
            self.quiz_feedback.configure(text=self.tr("quiz_choose"),
                                         foreground=self.C["muted"])
            return
        if choix == self.current.get("answer"):
            audio.play_correct()
            self.ajouter_sesterces(10)
            self.reagir_succes()
            self.quiz_feedback.configure(
                text="✨ " + self.tr("quiz_good") + " " + self.txt(self.current, "explanation"),
                foreground=self.C["ok"])
            nouveau = self.current["id"] not in self.data["completed"]
            self._mark_done(self.current["id"])
            if nouveau:
                prog.enregistrer_activite(self.data, date.today().isoformat())
                self._refresh_status()
            self._show_banner(self.tr("banner_quiz") + " +10 Sesterces 🪙", self.C["ok"])
            self._animer_confettis()
        else:
            audio.play_wrong()
            self.reagir_erreur()
            self.quiz_feedback.configure(text=self.tr("quiz_bad"),
                                         foreground=self.C["err"])

    def show_hint(self):
        self.reagir_reflexion()
        if not self._hints:
            self._write(self.tr("con_no_hint") + "\n", "muted")
            return
        if self._hint_idx >= len(self._hints):
            self._write(self.tr("con_no_more_hint") + "\n", "muted")
            return
        self._write(self.tr("con_hint", i=self._hint_idx + 1, n=len(self._hints),
                            texte=self._hints[self._hint_idx]) + "\n", "hint")
        self._hint_idx += 1

    def show_solution(self):
        exo = get_exercice(self.current, self.exo_index)
        sol = exo.get("solution")
        if not sol:
            messagebox.showinfo(self.tr("dlg_solution_title"), self.tr("dlg_solution_none"))
            return
        if messagebox.askyesno(self.tr("dlg_solution_title"),
                               self.tr("dlg_solution_confirm")):
            self.editor.set_text(sol)
            self._on_code_change()

    def reset_code(self):
        if not self.current:
            return
        if messagebox.askyesno(self.tr("dlg_reset_exo_title"),
                               self.tr("dlg_reset_exo_msg"),
                               parent=self.root):
            exo = get_exercice(self.current, self.exo_index)
            self.editor.set_text(exo.get("starter", ""))
            self._on_code_change()
            self.feedback.configure(text="")
            self._clear_console()

    def _ouvrir_palette(self):
        items = []
        for level in CURRICULUM:
            level_title = self.txt(level, "title")
            for lesson in level["lessons"]:
                lid = lesson.get("id")
                ltitle = self.txt(lesson, "title")
                display = f"[{level_title}] {ltitle}"
                searchable = f"{level_title} {ltitle} {lid} {self.txt(lesson, 'content', '')}"
                items.append((lid, display, searchable))
        PaletteWindow(self.root, self, items, self.C, on_select=self._charger_item)

    def _exporter_badge_svg(self):
        resume = stats.resume_accueil(self.data, CURRICULUM)
        svg_code = stats.badge_svg(
            streak=resume["serie"],
            termines=resume["faits"],
            total=resume["total"],
            lang=self.lang
        )
        chemin = filedialog.asksaveasfilename(
            parent=self.root,
            title=self.tr("dlg_badge_title"),
            defaultextension=".svg",
            filetypes=[("SVG (*.svg)", "*.svg"), ("All files", "*.*")],
            initialfile="luduslatinus-badge.svg"
        )
        if chemin:
            try:
                pathlib.Path(chemin).write_text(svg_code, encoding="utf-8")
                messagebox.showinfo(self.tr("dlg_badge_title"), self.tr("dlg_badge_ok"))
            except Exception as e:
                messagebox.showerror(self.tr("dlg_export_title"), str(e))

    def _maj_syntaxe(self, err):
        if err is None:
            self.syntax_label.configure(text=self.tr("syntax_ok"),
                                        foreground=self.C["ok"])
        else:
            self.syntax_label.configure(
                text=self.tr("syntax_err", n=err.lineno or "?", msg=err.msg),
                foreground=self.C["err"])

    def _exporter_py(self):
        if not self.current or self.current.get("type") in _SANS_EDITEUR:
            return
        chemin = filedialog.asksaveasfilename(
            defaultextension=".py", initialfile=f"{self.current['id']}.py",
            filetypes=[("Fichier Python", "*.py"), ("Tous les fichiers", "*.*")])
        if not chemin:
            return
        try:
            pathlib.Path(chemin).write_text(self.editor.get(), encoding="utf-8")
            self.feedback.configure(text=self.tr("fb_exported"), foreground=self.C["ok"])
        except Exception:
            messagebox.showinfo(self.tr("dlg_export_title"), self.tr("dlg_export_fail"))

    def _ouvrir_bytecode(self):
        code = self.editor.get()
        BytecodeWindow(self.root, self, code, self.C)

    def _ouvrir_sqlite(self):
        code = self.editor.get()
        SqliteViewerWindow(self.root, self, code, self.C)

    def _exporter_anki_tsv(self):
        tsv = stats.export_anki_tsv(get_glossaire(self.lang), CURRICULUM, lang=self.lang)
        chemin = filedialog.asksaveasfilename(
            parent=self.root,
            title=self.tr("dlg_anki_title"),
            defaultextension=".tsv",
            filetypes=[("TSV (Anki)", "*.tsv"), ("All files", "*.*")],
            initialfile="luduslatinus_anki.tsv"
        )
        if chemin:
            try:
                pathlib.Path(chemin).write_text(tsv, encoding="utf-8")
                messagebox.showinfo(self.tr("dlg_anki_title"), self.tr("dlg_anki_ok"))
            except Exception as e:
                messagebox.showerror(self.tr("dlg_export_title"), str(e))

    def _pas_a_pas(self):
        if not self.current or self.current.get("type") in _SANS_EDITEUR:
            return
        from app.runner import tracer
        exo = get_exercice(self.current, self.exo_index)
        etapes, err = tracer(self.editor.get(), stdin_lines=exo.get("stdin"))
        vraies = [e for e in etapes if e.get("ligne") is not None]
        if not vraies:
            messagebox.showinfo(self.tr("dlg_step_title"),
                                err or self.tr("step_nothing"))
            return
        StepWindow(self.root, self, etapes, self.C, err)

    # --------------------------------------------------- progression / badges
    def _mark_done(self, item_id):
        if item_id in self.data["completed"]:
            return
        prog.mark_completed(self.data, item_id)
        self._populate_tree()
        if self.current and exercice_count(self.current) > 1:
            self._build_exo_tabs()
        self._refresh_status()
        self._check_level_badge(item_id.split("#")[0])

    def _check_level_badge(self, lesson_id):
        level = self.lesson_level[lesson_id]
        if all(lesson_done(lecon, self.data["completed"])
               for lecon in level["lessons"]):
            if prog.award_badge(self.data, level["id"]):
                self._populate_tree()
                self._refresh_badges()
                self._refresh_status()
                nom = LEVEL_BADGE_NAMES.get(level["id"], level["title"])
                nb = len([b for b in self.data["badges"] if not b.startswith("triomphe")])
                tous_mondes_termines = all(
                    all(lesson_done(les, self.data["completed"]) for les in lvl["lessons"])
                    for lvl in CURRICULUM
                )
                if tous_mondes_termines:
                    if "triomphe_5eme" not in self.data["badges"]:
                        prog.award_badge(self.data, "triomphe_5eme")
                        self.ajouter_sesterces(200)
                    self.reagir_triomphe("Triomphe absolu ! Tous les mondes de Rome sont conquis !")
                    self._animer_confettis()
                    from app.triomphe import Triomphe5emeDialog
                    self.root.after(300, lambda: Triomphe5emeDialog(self.root, self))
                else:
                    msg = f"Parcours « {nom} » terminé ! Badge {nb}/{len(CURRICULUM)}."
                    self.reagir_triomphe(f"Optime ! Tu as décroché le badge {nom} !")
                    Celebration(self.root, msg, self.C,
                                on_cert=lambda lid=level["id"]: self._generer_certificat(lid))
                    self._animer_confettis()

    def _refresh_status(self):
        done = len(self.data["completed"])
        total = total_count()
        # ne compte que les items réellement existants
        valides = set()
        for level in CURRICULUM:
            for lesson in level["lessons"]:
                valides.update(lesson_items(lesson))
        done = len([i for i in self.data["completed"] if i in valides])
        pct = round(100 * done / total) if total else 0
        self.progress.configure(value=done)
        today = date.today()
        s = stats.streak(self.data["historique"], today)
        auj = self.data["historique"].get(today.isoformat(), 0)
        obj = self.data.get("objectif_quotidien", 3)
        n_dus = len(stats.dus(self.data["srs"], today, set(self.data["completed"])))
        cible = "✓" if auj >= obj else f"{auj}/{obj}"
        niv = stats.niveau(stats.xp_total(self.data["completed"], self.data["badges"]))["niveau"]
        self.status.configure(text=self.tr(
            "status", niv=niv, done=done, total=total, pct=pct,
            b=len(self.data["badges"]), n=len(CURRICULUM), s=s, cible=cible, dus=n_dus))
        self._refresh_header_stats()

    def _reset_progress(self):
        if messagebox.askyesno(self.tr("dlg_reset_title"), self.tr("dlg_reset_msg")):
            theme = self.theme_name
            langue = self.lang
            prog.reset_progress()
            self.data = prog.load_progress()
            self.data["theme"] = theme
            self.data["langue"] = langue
            self.data["vu_accueil"] = True
            prog.save_progress(self.data)
            self._populate_tree()
            self._refresh_badges()
            self._refresh_status()
            self._select_first_incomplete()

    def _show_welcome(self):
        C = self.C
        win = tk.Toplevel(self.root)
        win.title("🏛️ Ludus Latinus — Bienvenue Jeune Héros !")
        win.configure(bg=C["panel"])
        win.resizable(False, False)

        # Centrage à l'écran
        w, h = 640, 580
        sw = win.winfo_screenwidth()
        sh = win.winfo_screenheight()
        win.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")

        # Liseré supérieur
        tk.Frame(win, bg=C["accent"], height=6).pack(fill=tk.X, side=tk.TOP)

        # En-tête avec logo centurion
        hdr_frame = tk.Frame(win, bg=C["panel"])
        hdr_frame.pack(fill=tk.X, padx=20, pady=(14, 6))

        logo_path = pathlib.Path(__file__).resolve().parent.parent / "assets" / "images" / "logo_centurion_64.png"
        if logo_path.exists():
            try:
                win._logo_img = tk.PhotoImage(file=str(logo_path))
                tk.Label(hdr_frame, image=win._logo_img, bg=C["panel"]).pack(side=tk.LEFT, padx=(0, 14))
            except Exception:
                tk.Label(hdr_frame, text="🏛️", font=("", 32), bg=C["panel"]).pack(side=tk.LEFT, padx=(0, 14))
        else:
            tk.Label(hdr_frame, text="🏛️", font=("", 32), bg=C["panel"]).pack(side=tk.LEFT, padx=(0, 14))

        title_box = tk.Frame(hdr_frame, bg=C["panel"])
        title_box.pack(side=tk.LEFT, fill=tk.BOTH)
        tk.Label(title_box, text=self.tr("wel_title"), font=(self.title_font.cget("family"), 17, "bold"),
                 bg=C["panel"], fg=C["accent"]).pack(anchor="w")
        tk.Label(title_box, text="L'Aventure Romaine · Choisis ton Héros pour commencer",
                 font=(self.body.cget("family"), 10), bg=C["panel"], fg=C["muted"]).pack(anchor="w")

        # Présentation
        tk.Label(
            win,
            text="Tu t'apprêtes à explorer 7 Mondes fabuleux de la Rome Antique et affronter les légendes du Colisée !\n"
                 "Avant de débuter ta quête, choisis le héros que tu souhaites incarner :",
            font=(self.body.cget("family"), 10),
            bg=C["panel"], fg=C["fg"], justify="center"
        ).pack(padx=20, pady=(4, 12))

        # Cartes Marcus / Julia
        cards_frame = tk.Frame(win, bg=C["panel"])
        cards_frame.pack(fill=tk.X, padx=30, pady=4)
        cards_frame.columnconfigure(0, weight=1)
        cards_frame.columnconfigure(1, weight=1)

        current_genre = [prog.get_genre(self.data)]

        card_boy = tk.Frame(cards_frame, bg=C["editor"], padx=14, pady=10, highlightthickness=3)
        card_boy.grid(row=0, column=0, padx=10, sticky="nsew")

        card_girl = tk.Frame(cards_frame, bg=C["editor"], padx=14, pady=10, highlightthickness=3)
        card_girl.grid(row=0, column=1, padx=10, sticky="nsew")

        img_dir = pathlib.Path(__file__).resolve().parent.parent / "assets" / "images"
        p_boy = img_dir / "avatar_garcon_140.png"
        p_girl = img_dir / "avatar_fille_140.png"

        if p_boy.exists():
            try:
                win._boy_img = tk.PhotoImage(file=str(p_boy))
                tk.Label(card_boy, image=win._boy_img, bg=C["editor"]).pack(pady=4)
            except Exception:
                tk.Label(card_boy, text="👦", font=("", 48), bg=C["editor"]).pack(pady=4)
        else:
            tk.Label(card_boy, text="👦", font=("", 48), bg=C["editor"]).pack(pady=4)

        if p_girl.exists():
            try:
                win._girl_img = tk.PhotoImage(file=str(p_girl))
                tk.Label(card_girl, image=win._girl_img, bg=C["editor"]).pack(pady=4)
            except Exception:
                tk.Label(card_girl, text="👧", font=("", 48), bg=C["editor"]).pack(pady=4)
        else:
            tk.Label(card_girl, text="👧", font=("", 48), bg=C["editor"]).pack(pady=4)

        tk.Label(card_boy, text="👦 Marcus", font=(self.body.cget("family"), 13, "bold"),
                 bg=C["editor"], fg=C["accent"]).pack(pady=(4, 1))
        tk.Label(card_boy, text="Le Jeune Centurion", font=(self.body.cget("family"), 9, "italic"),
                 bg=C["editor"], fg=C["muted"]).pack()
        tk.Label(card_boy, text="Brave et déterminé au Colisée !", font=(self.body.cget("family"), 8),
                 bg=C["editor"], fg=C["fg"]).pack(pady=(2, 6))

        btn_boy = tk.Button(card_boy, text="Choisir Marcus", font=(self.body.cget("family"), 10, "bold"),
                            relief="flat", padx=10, pady=4, cursor="hand2")
        btn_boy.pack(fill=tk.X)

        tk.Label(card_girl, text="👧 Julia", font=(self.body.cget("family"), 13, "bold"),
                 bg=C["editor"], fg=C["accent"]).pack(pady=(4, 1))
        tk.Label(card_girl, text="L'Intrépide Gladiatrice", font=(self.body.cget("family"), 9, "italic"),
                 bg=C["editor"], fg=C["muted"]).pack()
        tk.Label(card_girl, text="Vive, agile et perspicace !", font=(self.body.cget("family"), 8),
                 bg=C["editor"], fg=C["fg"]).pack(pady=(2, 6))

        btn_girl = tk.Button(card_girl, text="Choisir Julia", font=(self.body.cget("family"), 10, "bold"),
                             relief="flat", padx=10, pady=4, cursor="hand2")
        btn_girl.pack(fill=tk.X)

        def maj_selection(nouveau_genre, play_sfx=True):
            current_genre[0] = nouveau_genre
            if nouveau_genre == "garcon":
                prog.set_genre(self.data, "garcon")
                prog.set_nom_heros(self.data, "Marcus")
                card_boy.configure(highlightbackground=C["accent"], highlightcolor=C["accent"])
                card_girl.configure(highlightbackground=C["panel"], highlightcolor=C["panel"])
                btn_boy.configure(text="✓ Marcus sélectionné", bg=C["accent"], fg=C["sel_fg"])
                btn_girl.configure(text="Choisir Julia", bg=C["panel"], fg=C["fg"])
            else:
                prog.set_genre(self.data, "fille")
                prog.set_nom_heros(self.data, "Julia")
                card_girl.configure(highlightbackground=C["accent"], highlightcolor=C["accent"])
                card_boy.configure(highlightbackground=C["panel"], highlightcolor=C["panel"])
                btn_girl.configure(text="✓ Julia sélectionnée", bg=C["accent"], fg=C["sel_fg"])
                btn_boy.configure(text="Choisir Marcus", bg=C["panel"], fg=C["fg"])
            if play_sfx:
                audio.play_coin()

        btn_boy.configure(command=lambda: maj_selection("garcon"))
        btn_girl.configure(command=lambda: maj_selection("fille"))
        card_boy.bind("<Button-1>", lambda e: maj_selection("garcon"))
        card_girl.bind("<Button-1>", lambda e: maj_selection("fille"))
        maj_selection(current_genre[0], play_sfx=False)

        def demarrer():
            prog.marquer_accueil_vu(self.data)
            prog.save_progress(self.data)
            self._refresh_header_stats()
            audio.play_fanfare()
            win.destroy()
            if self.data.get("accueil_au_demarrage", True):
                self._show_accueil()

        start_btn = tk.Button(
            win,
            text=f"⚔️ {self.tr('wel_start')} !",
            font=(self.body.cget("family"), 12, "bold"),
            bg="#d4af37", fg="#1a1409",
            activebackground="#f3e5ab", activeforeground="#1a1409",
            padx=22, pady=8, relief="flat", cursor="hand2",
            command=demarrer
        )
        start_btn.pack(pady=(16, 8))

    def _show_accueil(self):
        """Ouvre le tableau de bord : où j'en suis, par quoi je reprends."""
        resume = stats.resume_accueil(self.data, self._ordre_item_ids(),
                                      date.today())
        AccueilWindow(self.root, self, resume, self.C)

    def titre_de_item(self, item_id):
        """Titre lisible d'un item, pour l'afficher hors de sa leçon."""
        lecon = find_lesson(item_id.split("#")[0])
        if lecon is None:
            return item_id
        if "#" in item_id:
            rang = int(item_id.split("#")[1]) + 1
            return f"{lecon['title']} ({rang})"
        return self.txt(lecon, "title")

    def charger_depuis_accueil(self, item_id):
        """Ouvre l'exercice choisi depuis l'écran d'accueil."""
        self._charger_item(item_id)

    def _show_glossaire(self):
        C = self.C
        win = tk.Toplevel(self.root)
        win.title(self.tr("tb_glossaire").strip("📖 "))
        win.configure(bg=C["panel"])
        win.geometry("560x520")
        tk.Label(win, text=self.tr("gl_title"), bg=C["panel"], fg=C["accent"],
                 font=self.title_font).pack(pady=(12, 6))
        outils = ttk.Frame(win, style="Panel.TFrame")
        outils.pack(pady=(0, 6))
        ttk.Button(outils, text=self.tr("gl_cards"),
                   command=self._ouvrir_flashcards).pack(side=tk.LEFT, padx=4)
        ttk.Button(outils, text=self.tr("gl_cheatsheet"),
                   command=self._ouvrir_antiseche).pack(side=tk.LEFT, padx=4)
        var = tk.StringVar()
        entry = tk.Entry(win, textvariable=var, bg=C["editor"], fg=C["fg"],
                         insertbackground=C["fg"], relief="flat")
        entry.pack(fill=tk.X, padx=14, pady=(0, 8))
        txt = tk.Text(win, wrap="word", bg=C["bg"], fg=C["fg"], relief="flat",
                      padx=10, pady=8, font=self.body)
        txt.pack(fill=tk.BOTH, expand=True, padx=14, pady=(0, 14))
        txt.tag_configure("terme", foreground=C["heading"],
                          font=(self.body.cget("family"), 11, "bold"), spacing1=8)

        def remplir(*_):
            f = var.get().strip().lower()
            txt.configure(state="normal")
            txt.delete("1.0", tk.END)
            for terme, definition in get_glossaire(self.lang):
                if not f or f in terme.lower() or f in definition.lower():
                    txt.insert(tk.END, terme + "\n", "terme")
                    txt.insert(tk.END, definition + "\n")
            txt.configure(state="disabled")
        var.trace_add("write", remplir)
        remplir()

    def _ouvrir_antiseche(self):
        from content.cheatsheet import get_cheatsheet
        html = stats.cheatsheet_html(self.tr("cheat_title"), get_cheatsheet(self.lang),
                                     auteur=AUTEUR, lang=self.lang)
        try:
            fichier = prog.DATA_DIR / "antiseche.html"
            prog.DATA_DIR.mkdir(parents=True, exist_ok=True)
            fichier.write_text(html, encoding="utf-8")
            webbrowser.open(fichier.as_uri())
        except Exception:
            messagebox.showinfo(self.tr("cheat_title"), self.tr("cheat_fail"))

    def _ouvrir_flashcards(self):
        cartes = list(get_glossaire(self.lang))
        if not cartes:
            return
        FlashcardWindow(self.root, self, cartes, self.C)

    def _revision(self):
        today = date.today()
        completed = set(self.data["completed"])
        # ne révise que des exercices (pas les quiz)
        ids_exercices = set()
        for level in CURRICULUM:
            for lesson in level["lessons"]:
                if lesson.get("type") != "quiz":
                    ids_exercices.update(lesson_items(lesson))
        dus = [i for i in stats.dus(self.data["srs"], today, completed)
               if i in ids_exercices]
        if dus:
            self._charger_item(random.choice(dus))
            self.feedback.configure(text=self.tr("fb_revision_due", n=len(dus)),
                                    foreground=self.C["accent"])
            return
        # sinon exercice au hasard parmi les réussis
        faits = list(completed & ids_exercices)
        if not faits:
            self.feedback.configure(text=self.tr("fb_revision_none"),
                                    foreground=self.C["muted"])
            return
        self._charger_item(random.choice(faits))
        self.feedback.configure(text=self.tr("fb_revision_random"),
                                foreground=self.C["muted"])

    def _charger_item(self, item_id):
        lid = item_id.split("#")[0]
        lesson = find_lesson(lid)
        if lesson is None:
            return
        for node, lecon in self.item_to_lesson.items():
            if lecon["id"] == lid:
                if self.tree.selection() != (node,):
                    self._ignore_next_select = True
                    self.tree.selection_set(node)
                    self.tree.see(node)
                break
        self._load_lesson(lesson)
        if "#" in item_id:
            self._load_exercice(int(item_id.split("#")[1]))
        self._revision_item = item_id

    def _exporter_progression(self):
        chemin = filedialog.asksaveasfilename(
            defaultextension=".json", filetypes=[("JSON", "*.json")],
            initialfile="python-learn-progression.json")
        if not chemin:
            return
        try:
            pathlib.Path(chemin).write_text(prog.exporter_json(self.data),
                                            encoding="utf-8")
            messagebox.showinfo(self.tr("st_title").strip("📊 "),
                                self.tr("dlg_export_ok"))
        except Exception:
            messagebox.showinfo(self.tr("dlg_export_title"), self.tr("dlg_export_fail"))

    def _importer_progression(self, win=None):
        chemin = filedialog.askopenfilename(filetypes=[("JSON", "*.json")])
        if not chemin:
            return
        try:
            texte = pathlib.Path(chemin).read_text(encoding="utf-8")
            nouveau = prog.importer_json(texte)
        except Exception:
            messagebox.showinfo(self.tr("st_title").strip("📊 "),
                                self.tr("dlg_import_err"))
            return
        self.data = nouveau
        self.theme_name = self.data.get("theme", self.theme_name)
        if self.theme_name not in THEMES:
            self.theme_name = "dark"
        self.C = THEMES[self.theme_name]
        self.lang = self.data.get("langue", self.lang)
        if self.lang not in LANGUES:
            self.lang = "fr"
        self.tr.set(self.lang)
        prog.save_progress(self.data)
        self.apply_theme()
        self._apply_language()
        self._populate_tree()
        self._refresh_badges()
        self._refresh_status()
        self._select_first_incomplete()
        messagebox.showinfo(self.tr("st_title").strip("📊 "), self.tr("dlg_import_ok"))
        if win is not None:
            win.destroy()

    def _generer_certificat(self, level_id):
        nom = self.data.get("nom") or ""
        if not nom:
            nom = simpledialog.askstring(
                self.tr("dlg_cert_title"), self.tr("dlg_cert_prompt"),
                parent=self.root) or self.tr("dlg_cert_default")
            prog.set_nom(self.data, nom)
        parcours = LEVEL_BADGE_NAMES.get(level_id, level_id)
        html = stats.certificat_html(nom, parcours,
                                     date.today().strftime("%d/%m/%Y"),
                                     auteur=AUTEUR, lang=self.lang)
        dossier = prog.DATA_DIR / "certificats"
        try:
            dossier.mkdir(parents=True, exist_ok=True)
            fichier = dossier / f"certificat_{level_id}.html"
            fichier.write_text(html, encoding="utf-8")
            webbrowser.open(fichier.as_uri())
        except Exception:
            messagebox.showinfo(self.tr("dlg_cert_title"), self.tr("dlg_cert_fail"))

    def _show_stats(self):
        C = self.C
        today = date.today()
        win = tk.Toplevel(self.root)
        win.configure(bg=C["bg"])
        win.geometry("520x600")
        win.title(self.tr("st_title").strip("📊 "))
        tk.Label(win, text=self.tr("st_title"), bg=C["bg"], fg=C["accent"],
                 font=self.title_font).pack(pady=(14, 8))

        s = stats.streak(self.data["historique"], today)
        record = stats.meilleur_streak(self.data["historique"])
        total_faits = len(self.data["completed"])
        auj = self.data["historique"].get(today.isoformat(), 0)
        obj = self.data.get("objectif_quotidien", 3)
        n_dus = len(stats.dus(self.data["srs"], today, set(self.data["completed"])))
        xp = stats.xp_total(self.data["completed"], self.data["badges"])
        niv = stats.niveau(xp)
        hebdo = stats.cette_semaine(self.data["historique"], today)
        obj_h = self.data.get("objectif_hebdo", 15)
        for t in [self.tr("st_niveau", niv=niv["niveau"], dans=niv["dans_niveau"],
                          pour=niv["pour_suivant"]),
                  self.tr("st_streak", n=s),
                  self.tr("st_record", n=record),
                  self.tr("st_total", n=total_faits),
                  self.tr("st_today", auj=auj, obj=obj),
                  self.tr("st_hebdo", n=hebdo, obj=obj_h),
                  self.tr("st_due", n=n_dus)]:
            tk.Label(win, text=t, bg=C["bg"], fg=C["fg"], anchor="w").pack(
                fill=tk.X, padx=28, pady=2)

        nivbar = ttk.Progressbar(win, style="Niv.Horizontal.TProgressbar",
                                 maximum=niv["pour_suivant"], length=320)
        nivbar.pack(pady=(2, 8))
        nivbar["value"] = niv["dans_niveau"]

        objrow = tk.Frame(win, bg=C["bg"])
        objrow.pack(pady=8)
        tk.Label(objrow, text=self.tr("st_objective"), bg=C["bg"],
                 fg=C["muted"]).pack(side=tk.LEFT)
        obj_var = tk.IntVar(value=obj)
        tk.Label(objrow, textvariable=obj_var, bg=C["bg"], fg=C["fg"],
                 width=3).pack(side=tk.LEFT, padx=6)

        def maj(delta):
            n = max(1, obj_var.get() + delta)
            obj_var.set(n)
            prog.set_objectif(self.data, n)
            self._refresh_status()
        tk.Button(objrow, text="–", command=lambda: maj(-1)).pack(side=tk.LEFT)
        tk.Button(objrow, text="+", command=lambda: maj(1)).pack(side=tk.LEFT, padx=4)

        hrow = tk.Frame(win, bg=C["bg"])
        hrow.pack(pady=(0, 4))
        tk.Label(hrow, text=self.tr("st_hebdo_label"), bg=C["bg"],
                 fg=C["muted"]).pack(side=tk.LEFT)
        objh_var = tk.IntVar(value=obj_h)
        tk.Label(hrow, textvariable=objh_var, bg=C["bg"], fg=C["fg"],
                 width=3).pack(side=tk.LEFT, padx=6)

        def maj_h(delta):
            n = max(1, objh_var.get() + delta)
            objh_var.set(n)
            prog.set_objectif_hebdo(self.data, n)
        tk.Button(hrow, text="–", command=lambda: maj_h(-1)).pack(side=tk.LEFT)
        tk.Button(hrow, text="+", command=lambda: maj_h(1)).pack(side=tk.LEFT, padx=4)

        iorow = tk.Frame(win, bg=C["bg"])
        iorow.pack(pady=(2, 6))
        ttk.Button(iorow, text=self.tr("st_export"),
                   command=self._exporter_progression).pack(side=tk.LEFT, padx=4)
        ttk.Button(iorow, text=self.tr("st_import"),
                   command=lambda: self._importer_progression(win)).pack(side=tk.LEFT, padx=4)
        ttk.Button(iorow, text=self.tr("tb_badge"),
                   command=self._exporter_badge_svg).pack(side=tk.LEFT, padx=4)
        ttk.Button(iorow, text=self.tr("tb_anki"),
                   command=self._exporter_anki_tsv).pack(side=tk.LEFT, padx=4)

        tk.Label(win, text=self.tr("st_7days"), bg=C["bg"], fg=C["muted"]).pack(pady=(8, 0))
        cv = tk.Canvas(win, width=470, height=150, bg=C["panel"], highlightthickness=0)
        cv.pack(pady=6)
        donnees = stats.sept_jours(self.data["historique"], today)
        maxv = max([v for _, v in donnees] + [1])
        bw, gap, x = 50, 16, 16
        for label, v in donnees:
            hh = int(110 * v / maxv) if v else 0
            cv.create_rectangle(x, 124 - hh, x + bw, 124, fill=C["accent"], outline="")
            cv.create_text(x + bw / 2, 138, text=label, fill=C["muted"], font=("", 8))
            if v:
                cv.create_text(x + bw / 2, 116 - hh, text=str(v), fill=C["fg"], font=("", 8))
            x += bw + gap

        if self.data["badges"]:
            tk.Label(win, text=self.tr("st_certs"), bg=C["bg"],
                     fg=C["muted"]).pack(pady=(8, 2))
            cert = tk.Frame(win, bg=C["bg"])
            cert.pack(fill=tk.X, padx=28)
            for lid in self.data["badges"]:
                if lid == "triomphe_5eme":
                    tk.Button(cert, text="👑 Grand Triomphe de Rome (Programme 5ème)", anchor="w",
                              bg="#c59b27", fg="#ffffff", font=(self.body.cget("family"), 9, "bold"),
                              relief="flat", padx=6, pady=3,
                              command=self._ouvrir_triomphe).pack(fill=tk.X, pady=3)
                    continue
                nom = LEVEL_BADGE_NAMES.get(lid, lid)
                tk.Button(cert, text=f"🎓 {nom}", anchor="w",
                          command=lambda parcours=lid:
                              self._generer_certificat(parcours)).pack(
                    fill=tk.X, pady=2)

    def _show_sandbox(self):
        """Éditeur libre, sans exercice ni vérification, pour expérimenter."""
        C = self.C
        win = tk.Toplevel(self.root)
        win.title(self.tr("sb_title"))
        win.configure(bg=C["bg"])
        win.geometry("720x600")

        tk.Label(win, text=self.tr("sb_intro"),
                 bg=C["bg"], fg=C["muted"], anchor="w").pack(fill=tk.X, padx=10, pady=(8, 2))

        ed = CodeEditor(win, self.code_font)
        ed.pack(fill=tk.BOTH, expand=True, padx=10)
        ed.apply_theme(C)
        ed.set_text(self.tr("sb_starter"))

        con = tk.Text(win, height=8, wrap="word", relief="flat", font=self.code_font,
                      bg=C["console"], fg=C["fg"], padx=10, pady=8, state="disabled")
        con.tag_configure("err", foreground=C["err"])
        con.tag_configure("var", foreground=C["builtin"])
        con.tag_configure("hint", foreground=C["accent"])
        con.tag_configure("muted", foreground=C["muted"])

        def lancer():
            from app.runner import inspecter, run_code
            con.configure(state="normal")
            con.delete("1.0", tk.END)
            result, ns = run_code(ed.get(), safe=True)   # bac à sable durci
            if result.output:
                con.insert(tk.END, result.output)
            if result.error:
                con.insert(tk.END,
                           self._message_erreur(result, result.error) + "\n",
                           "err")
                conseil = errors.expliquer(result.error, self.lang)
                if conseil:
                    con.insert(tk.END, "💡 " + conseil + "\n", "hint")
            elif not result.output:
                con.insert(tk.END, self.tr("con_no_output") + "\n", "muted")
            if not result.error:
                variables = inspecter(ns)
                if variables:
                    con.insert(tk.END, "\n" + self.tr("con_vars") + "\n", "var")
                    for nom, rep in variables:
                        con.insert(tk.END, f"{nom} = {rep}\n", "var")
            con.configure(state="disabled")
            con.see(tk.END)

        barre = ttk.Frame(win)
        barre.pack(fill=tk.X, padx=10, pady=6)
        ttk.Button(barre, text=self.tr("sb_run"), command=lancer).pack(side=tk.LEFT)
        ttk.Button(barre, text=self.tr("sb_clear"),
                   command=lambda: ed.set_text("")).pack(side=tk.LEFT, padx=6)
        con.pack(fill=tk.BOTH, expand=True, padx=10, pady=(0, 10))
        win.bind("<Control-Return>", lambda e: lancer())
        ed.focus_editor()


def _ouvrir_dossier(chemin):
    """Ouvre un dossier dans l'explorateur de fichiers du système.

    Renvoie False si aucun explorateur n'a pu être lancé — auquel cas
    l'appelant se rabat sur l'affichage du chemin.
    """
    import subprocess
    try:
        if sys.platform == "win32":
            os.startfile(str(chemin))                      # noqa: S606
        elif sys.platform == "darwin":
            subprocess.run(["open", str(chemin)], check=True)
        else:
            subprocess.run(["xdg-open", str(chemin)], check=True)
        return True
    except Exception:
        return False


def _splash(root):
    """Petit écran d'accueil (avec fondu) affiché le temps du démarrage."""
    C = THEMES["dark"]
    sp = tk.Toplevel(root)
    sp.overrideredirect(True)
    w, h = 460, 300
    sw, sh = sp.winfo_screenwidth(), sp.winfo_screenheight()
    sp.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")
    sp.configure(bg=C["panel"])
    # liseré d'accent en haut
    tk.Frame(sp, bg=C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

    logo_path = pathlib.Path(__file__).resolve().parent.parent / "assets" / "images" / "logo_centurion_120.png"
    if logo_path.exists():
        try:
            sp._logo_img = tk.PhotoImage(file=str(logo_path))
            tk.Label(sp, image=sp._logo_img, bg=C["panel"]).pack(pady=(20, 4))
        except Exception:
            tk.Label(sp, text="🏛️", bg=C["panel"], font=("", 50)).pack(pady=(24, 2))
    else:
        tk.Label(sp, text="🏛️", bg=C["panel"], font=("", 50)).pack(pady=(24, 2))

    tk.Label(sp, text=APP_NAME, bg=C["panel"], fg=C["accent"],
             font=("", 24, "bold")).pack()
    tk.Label(sp, text="L'Aventure Romaine pour collégiens", bg=C["panel"],
             fg=C["muted"], font=("", 11)).pack(pady=(2, 0))
    tk.Label(sp, text="par " + AUTEUR, bg=C["panel"], fg=C["muted"],
             font=("", 9)).pack(pady=(8, 0))
    try:
        sp.attributes("-topmost", True)
        sp.attributes("-alpha", 0.0)
    except tk.TclError:
        pass

    def _fondu(a=0.0):
        try:
            sp.attributes("-alpha", min(1.0, a))
        except tk.TclError:
            return
        if a < 1.0:
            sp.after(20, lambda: _fondu(a + 0.12))
    _fondu()
    return sp


def launch():
    # Les leçons ajoutées par l'utilisateur doivent être connues AVANT que
    # l'interface ne construise sa liste de parcours.
    _, soucis_packs = ajouter_packs()

    root = tk.Tk()
    root.withdraw()

    assets_dir = pathlib.Path(__file__).resolve().parent.parent / "assets"
    ico_path = assets_dir / "icon.ico"
    png_path = assets_dir / "images" / "logo_centurion_64.png"

    if sys.platform == "win32" and ico_path.exists():
        try:
            root.iconbitmap(str(ico_path))
        except Exception:
            pass

    if png_path.exists():
        try:
            icon = tk.PhotoImage(file=str(png_path))
            root.iconphoto(True, icon)
            root._icon_ref = icon
        except Exception:
            pass
    elif ICON_B64:
        try:
            icon = tk.PhotoImage(data=ICON_B64)
            root.iconphoto(True, icon)
            root._icon_ref = icon
        except Exception:
            pass
    sp = _splash(root)
    root.update()
    app = PythonLearnApp(root)
    app.soucis_packs = soucis_packs
    root.protocol("WM_DELETE_WINDOW", app.quitter)
    if soucis_packs:
        root.after(900, app._avertir_packs)

    def _demarrer():
        def _sortie(a=1.0):
            try:
                sp.attributes("-alpha", max(0.0, a))
            except tk.TclError:
                a = 0
            if a > 0:
                sp.after(18, lambda: _sortie(a - 0.15))
            else:
                sp.destroy()
                root.deiconify()
        _sortie()
    root.after(1100, _demarrer)
    root.mainloop()


LudusLatinusApp = PythonLearnApp

