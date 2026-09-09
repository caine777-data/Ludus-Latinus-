"""
Gestionnaire d'interface pour le Multi-Profils de Ludus Latinus.
Permet à plusieurs joueurs (enfants, parents) de jouer sur le même ordinateur
avec des sauvegardes, sesterces et héros indépendants.
"""

import tkinter as tk
from pathlib import Path
from tkinter import messagebox, simpledialog, ttk

from app import audio
from app import progress as prog


class ProfileDialog(tk.Toplevel):
    """Fenêtre de sélection et de gestion des profils de joueurs."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🏛️ Qui joue aujourd'hui ? — Profils de Rome")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        w, h = 640, 520
        sw = self.winfo_screenwidth()
        sh = self.winfo_screenheight()
        self.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")

        # Liseré d'or supérieur
        tk.Frame(self, bg=self.C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=20, pady=12)
        hdr.pack(fill=tk.X)
        tk.Label(hdr, text="🏛️ Citoyens de Rome", font=(app.title_font.cget("family"), 18, "bold"),
                 bg=self.C["panel"], fg=self.C["accent"]).pack(anchor="w")
        tk.Label(hdr, text="Choisis ton profil pour reprendre ton voyage ou crée un nouveau héros :",
                 font=(app.body.cget("family"), 10), bg=self.C["panel"], fg=self.C["muted"]).pack(anchor="w")

        # Zone centrale défilante des profils
        cards_container = tk.Frame(self, bg=self.C["panel"])
        cards_container.pack(fill=tk.BOTH, expand=True, padx=24, pady=8)

        self.list_frame = tk.Frame(cards_container, bg=self.C["panel"])
        self.list_frame.pack(fill=tk.BOTH, expand=True)

        self._img_refs = []
        self._refresh_profiles_list()

        # Barre inférieure : Bouton Nouveau Profil et Fermer
        bottom_bar = tk.Frame(self, bg=self.C["panel"], padx=20, pady=14)
        bottom_bar.pack(fill=tk.X, side=tk.BOTTOM)

        btn_new = tk.Button(
            bottom_bar,
            text="➕ Créer un Nouveau Héros",
            font=(app.body.cget("family"), 11, "bold"),
            bg="#d4af37", fg="#1a1409",
            activebackground="#f3e5ab", activeforeground="#1a1409",
            padx=16, pady=6, relief="flat", cursor="hand2",
            command=self._nouveau_profil
        )
        btn_new.pack(side=tk.LEFT)

        btn_cloud = tk.Button(
            bottom_bar,
            text="🏛️ Compte & Cloud",
            font=(app.body.cget("family"), 10, "bold"),
            bg="#2e6f40", fg="#ffffff",
            activebackground="#3e8f54",
            padx=12, pady=5, relief="flat", cursor="hand2",
            command=self._ouvrir_compte
        )
        btn_cloud.pack(side=tk.LEFT, padx=(10, 0))

        btn_close = ttk.Button(bottom_bar, text="Fermer", command=self.destroy)
        btn_close.pack(side=tk.RIGHT)

    def _ouvrir_compte(self):
        from app.compte import CompteDialog
        CompteDialog(self, self.app)

    def _refresh_profiles_list(self):
        for w in self.list_frame.winfo_children():
            w.destroy()
        self._img_refs.clear()

        profils = prog.lister_profils()
        img_dir = Path(__file__).resolve().parent.parent / "assets" / "images"

        for p in profils:
            card = tk.Frame(self.list_frame, bg=self.C["editor"], padx=12, pady=10, highlightthickness=2)
            card.pack(fill=tk.X, pady=6)

            is_active = p.get("actif", False)
            if is_active:
                card.configure(highlightbackground=self.C["accent"], highlightcolor=self.C["accent"])
            else:
                card.configure(highlightbackground=self.C["panel"], highlightcolor=self.C["panel"])

            # Portrait (Médaillon antique doré)
            genre = p.get("genre", "garcon")
            med_file = "avatar_garcon_medaillon_48.png" if genre == "garcon" else "avatar_fille_medaillon_48.png"
            img_path = img_dir / med_file
            if not img_path.exists():
                img_path = img_dir / ("avatar_garcon_40.png" if genre == "garcon" else "avatar_fille_40.png")

            if img_path.exists():
                try:
                    photo = tk.PhotoImage(file=str(img_path))
                    self._img_refs.append(photo)
                    lbl_pic = tk.Label(card, image=photo, bg=self.C["editor"])
                    lbl_pic.pack(side=tk.LEFT, padx=(4, 12))
                except Exception:
                    tk.Label(card, text="👦" if genre == "garcon" else "👧", font=("Segoe UI Emoji", 20),
                             bg=self.C["editor"]).pack(side=tk.LEFT, padx=(4, 12))
            else:
                tk.Label(card, text="👦" if genre == "garcon" else "👧", font=("Segoe UI Emoji", 20),
                         bg=self.C["editor"]).pack(side=tk.LEFT, padx=(4, 12))

            # Infos joueur
            info_frame = tk.Frame(card, bg=self.C["editor"])
            info_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

            nom_txt = f"{p['nom']} ({p['nom_heros']})"
            if is_active:
                nom_txt += "  ★ Profil Actif"

            tk.Label(info_frame, text=nom_txt, font=(self.app.body.cget("family"), 12, "bold"),
                     bg=self.C["editor"], fg=self.C["accent"] if is_active else self.C["fg"]).pack(anchor="w")

            stats_txt = f"🪙 {p.get('sesterces', 50)} Sesterces  •  📚 {p.get('faits', 0)} leçons  •  🏆 {p.get('badges', 0)} badges"
            tk.Label(info_frame, text=stats_txt, font=(self.app.body.cget("family"), 9),
                     bg=self.C["editor"], fg=self.C["muted"]).pack(anchor="w", pady=(2, 0))

            # Boutons Jouer / Supprimer
            btn_frame = tk.Frame(card, bg=self.C["editor"])
            btn_frame.pack(side=tk.RIGHT, padx=6)

            if not is_active:
                btn_play = tk.Button(
                    btn_frame,
                    text="⚔️ Jouer",
                    font=(self.app.body.cget("family"), 9, "bold"),
                    bg=self.C["accent"], fg=self.C["sel_fg"],
                    padx=12, pady=3, relief="flat", cursor="hand2",
                    command=lambda pid=p["id"]: self._choisir_profil(pid)
                )
                btn_play.pack(side=tk.LEFT, padx=4)

            if len(profils) > 1:
                btn_del = tk.Button(
                    btn_frame,
                    text="🗑️",
                    font=("Segoe UI Emoji", 10),
                    bg=self.C["panel"], fg=self.C["err"],
                    padx=6, pady=2, relief="flat", cursor="hand2",
                    command=lambda pid=p["id"], n=p["nom"]: self._supprimer_profil(pid, n)
                )
                btn_del.pack(side=tk.LEFT, padx=2)

    def _choisir_profil(self, profile_id):
        prog.definir_profil_actif(profile_id)
        self.app.data = prog.load_progress(profile_id)
        self.app._refresh_badges()
        self.app._refresh_status()
        self.app._refresh_header_stats()
        self.app._populate_tree()
        audio.play_coin()
        self.destroy()

    def _nouveau_profil(self):
        nom = simpledialog.askstring(
            "Nouveau Citoyen de Rome",
            "Entre le prénom ou pseudonyme du joueur :",
            parent=self
        )
        if not nom or not nom.strip():
            return

        clean_nom = nom.strip()

        # Demande du genre
        win_choix = tk.Toplevel(self)
        win_choix.title("Choix du Héros")
        win_choix.configure(bg=self.C["panel"])
        win_choix.geometry("380x200")
        win_choix.resizable(False, False)

        tk.Label(win_choix, text=f"Quel héros {clean_nom} souhaite-t-il incarner ?",
                 font=(self.app.body.cget("family"), 11, "bold"),
                 bg=self.C["panel"], fg=self.C["accent"]).pack(pady=(16, 12))

        bframe = tk.Frame(win_choix, bg=self.C["panel"])
        bframe.pack(pady=10)

        def _valider(genre, heros):
            win_choix.destroy()
            pid = prog.creer_profil(clean_nom, genre=genre, nom_heros=heros)
            self._choisir_profil(pid)

        btn_m = tk.Button(
            bframe, text="👦 Marcus (Garçon)",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg=self.C["editor"], fg=self.C["fg"], padx=10, pady=6, relief="flat", cursor="hand2",
            command=lambda: _valider("garcon", "Marcus")
        )
        btn_m.pack(side=tk.LEFT, padx=8)

        btn_j = tk.Button(
            bframe, text="👧 Julia (Fille)",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg=self.C["editor"], fg=self.C["fg"], padx=10, pady=6, relief="flat", cursor="hand2",
            command=lambda: _valider("fille", "Julia")
        )
        btn_j.pack(side=tk.LEFT, padx=8)

    def _supprimer_profil(self, profile_id, nom):
        if messagebox.askyesno("Supprimer le profil", f"Es-tu sûr de vouloir effacer le profil de {nom} et sa progression ?"):
            prog.supprimer_profil(profile_id)
            self._refresh_profiles_list()
            # Si c'était le profil actif, recharger le nouveau profil actif
            self.app.data = prog.load_progress()
            self.app._refresh_badges()
            self.app._refresh_status()
            self.app._refresh_header_stats()
            self.app._populate_tree()
