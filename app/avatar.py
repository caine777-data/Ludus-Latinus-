"""
Fenêtre de personnalisation de l'Avatar Romain et Boutique antique.
Permet au collégien d'équiper son personnage avec les Sesterces gagnés.
"""

import tkinter as tk
from pathlib import Path
from tkinter import messagebox, ttk

from app import audio
from app import progress as prog

BOUTIQUE = {
    "toge": [
        {"id": "lin_blanc", "nom": "Toge de lin blanc", "prix": 0, "icone": "🥋", "desc": "La tenue des apprentis romains."},
        {"id": "praetexta", "nom": "Toge bordée de pourpre", "prix": 30, "icone": "👘", "desc": "Portée par les jeunes nobles romains."},
        {"id": "imperiale", "nom": "Toge impériale dorée", "prix": 80, "icone": "👑", "desc": "Réservée aux plus grands triomphateurs !"},
    ],
    "couronne": [
        {"id": "aucune", "nom": "Aucune", "prix": 0, "icone": "👤", "desc": "Tête nue."},
        {"id": "laurier_bronze", "nom": "Lauriers de bronze", "prix": 25, "icone": "🥉", "desc": "Récompense des premiers exploits."},
        {"id": "laurier_or", "nom": "Couronne de lauriers d'or", "prix": 60, "icone": "🌿", "desc": "Le symbole absolu de la victoire antique."},
    ],
    "accessoire": [
        {"id": "stylet", "nom": "Stylet d'écolier", "prix": 0, "icone": "✏️", "desc": "Pour écrire sur la cire."},
        {"id": "parchemin", "nom": "Parchemin de sage", "prix": 20, "icone": "📜", "desc": "Les parchemins des orateurs du Sénat."},
        {"id": "gladius", "nom": "Glaive (Gladius)", "prix": 45, "icone": "⚔️", "desc": "L'arme mythique des légionnaires."},
        {"id": "scutum", "nom": "Bouclier Scutum", "prix": 70, "icone": "🛡️", "desc": "Le bouclier d'élite de la légion."},
    ]
}

class AvatarWindow(tk.Toplevel):
    def __init__(self, parent, app):
        super().__init__(parent)
        self.app = app
        self.title("Mon Héros Romain & Boutique du Forum 🏛️")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 680, 680, min_w=580, min_h=480)
        self.configure(bg=app.C["bg"])
        self.transient(parent)

        self._img_ref = None
        self._build_ui()

    def _build_ui(self):
        C = self.app.C
        data = self.app.data
        sesterces = data.get("sesterces", 0)
        genre = prog.get_genre(data)
        nom_heros = prog.get_nom_heros(data)

        # 1. En-tête
        hdr = tk.Frame(self, bg=C["panel"], padx=18, pady=12)
        hdr.pack(fill=tk.X)

        tk.Label(hdr, text="🏛️ Mon Héros Romain", font=(self.app.title_font.cget("family"), 14, "bold"),
                 bg=C["panel"], fg=C["heading"]).pack(side=tk.LEFT)

        self.lbl_sesterces = tk.Label(hdr, text=f"🪙 {sesterces} Sesterces",
                                      font=(self.app.body.cget("family"), 12, "bold"),
                                      bg=C["panel"], fg="#d4af37")
        self.lbl_sesterces.pack(side=tk.RIGHT)

        # 2. Sélecteur Garçon / Fille
        selector_frame = tk.Frame(self, bg=C["bg"], pady=6)
        selector_frame.pack(fill=tk.X)

        tk.Label(selector_frame, text="Choisis ton personnage :",
                 font=(self.app.body.cget("family"), 10, "bold"),
                 bg=C["bg"], fg=C["fg"]).pack(side=tk.LEFT, padx=(20, 10))

        btn_boy = tk.Button(
            selector_frame, text="👦 Marcus (Garçon)",
            font=(self.app.body.cget("family"), 10, "bold" if genre == "garcon" else "normal"),
            bg=C["accent"] if genre == "garcon" else C["panel"],
            fg=C["sel_fg"] if genre == "garcon" else C["fg"],
            relief="raised" if genre == "garcon" else "groove",
            bd=2, padx=10, pady=3, cursor="hand2",
            command=lambda: self._changer_genre("garcon")
        )
        btn_boy.pack(side=tk.LEFT, padx=6)

        btn_girl = tk.Button(
            selector_frame, text="👧 Julia (Fille)",
            font=(self.app.body.cget("family"), 10, "bold" if genre == "fille" else "normal"),
            bg=C["accent"] if genre == "fille" else C["panel"],
            fg=C["sel_fg"] if genre == "fille" else C["fg"],
            relief="raised" if genre == "fille" else "groove",
            bd=2, padx=10, pady=3, cursor="hand2",
            command=lambda: self._changer_genre("fille")
        )
        btn_girl.pack(side=tk.LEFT, padx=6)

        # 3. Portrait 3D & Statut
        visu_frame = tk.Frame(self, bg=C["bg"], pady=6)
        visu_frame.pack(fill=tk.X)

        card = tk.Frame(visu_frame, bg=C["panel"], bd=3, relief="groove", padx=16, pady=10,
                        highlightthickness=2, highlightbackground="#d4af37")
        card.pack()

        med_filename = "avatar_fille_medaillon_180.png" if genre == "fille" else "avatar_garcon_medaillon_180.png"
        img_path = Path(__file__).resolve().parent.parent / "assets" / "images" / med_filename
        if not img_path.exists():
            img_filename = "avatar_fille_180.png" if genre == "fille" else "avatar_garcon_180.png"
            img_path = Path(__file__).resolve().parent.parent / "assets" / "images" / img_filename

        self.portrait_lbl = tk.Label(card, bg=C["panel"])
        if img_path.exists():
            try:
                self._img_ref = tk.PhotoImage(file=str(img_path))
                self.portrait_lbl.configure(image=self._img_ref)
            except Exception:
                self.portrait_lbl.configure(text="👦" if genre == "garcon" else "👧", font=("Segoe UI Emoji", 50))
        else:
            self.portrait_lbl.configure(text="👦" if genre == "garcon" else "👧", font=("Segoe UI Emoji", 50))
        self.portrait_lbl.pack()

        # Équipement résumé en badges
        self.avatar_gear = tk.Label(card, text="", font=("Segoe UI Emoji", 12),
                                    bg=C["panel"], fg=C["fg"])
        self.avatar_gear.pack(pady=(4, 0))

        niv_data = self.app.donnees_niveau()
        self.nom_titre = tk.Label(
            visu_frame,
            text=f"{nom_heros} • {niv_data.get('rang_icone', '🟢')} {niv_data.get('rang_titre', 'Tiro')} (Niveau {niv_data.get('niveau', 1)})",
            font=(self.app.body.cget("family"), 11, "bold"),
            bg=C["bg"], fg=C["fg"]
        )
        self.nom_titre.pack(pady=(4, 0))

        # 4. Boutique : Onglets
        notebook = ttk.Notebook(self)
        notebook.pack(fill=tk.BOTH, expand=True, padx=16, pady=8)

        for cat_key, cat_titre in [("toge", "Toges 🥋"), ("couronne", "Couronnes 🌿"), ("accessoire", "Équipement ⚔️")]:
            tab = ttk.Frame(notebook)
            notebook.add(tab, text=cat_titre)
            self._remplir_categorie(tab, cat_key)

        self._rafraichir_gear()

    def _changer_genre(self, nouveau_genre):
        prog.set_genre(self.app.data, nouveau_genre)
        audio.play_correct()
        self.app._refresh_header_stats()
        self._reconstruire()

    def _remplir_categorie(self, parent, cat_key):
        items = BOUTIQUE[cat_key]
        avatar = self.app.data.get("avatar", {})
        possedes = self.app.data.setdefault("avatar_possedes", ["lin_blanc", "aucune", "stylet"])
        equipe = avatar.get(cat_key)
        C = self.app.C
        from app.theme import est_sombre
        sombre = est_sombre(C.get("bg", "#faf6ee"))

        c_card = C.get("editor", "#ffffff")
        c_bd = "#d4af37" if sombre else "#ded3bf"
        c_fg = C.get("fg", "#2c2621")
        c_desc = "#a9b1d6" if sombre else "#666666"

        for item in items:
            is_equipped = (item["id"] == equipe)
            bd_highlight = "#2ecc71" if is_equipped else c_bd

            frame = tk.Frame(parent, bg=c_card, bd=1, relief="solid",
                             highlightthickness=2 if is_equipped else 1,
                             highlightbackground=bd_highlight, padx=10, pady=6)
            frame.pack(fill=tk.X, padx=8, pady=4)

            tk.Label(frame, text=item["icone"], font=("Segoe UI Emoji", 20), bg=c_card).pack(side=tk.LEFT, padx=(0, 10))

            info = tk.Frame(frame, bg=c_card)
            info.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

            tk.Label(info, text=item["nom"], font=(self.app.body.cget("family"), 10, "bold"),
                     bg=c_card, fg=c_fg, anchor="w").pack(anchor="w")
            tk.Label(info, text=item["desc"], font=(self.app.body.cget("family"), 9),
                     bg=c_card, fg=c_desc, anchor="w").pack(anchor="w")

            btn_zone = tk.Frame(frame, bg=c_card)
            btn_zone.pack(side=tk.RIGHT)

            item_id = item["id"]
            if is_equipped:
                lbl = tk.Label(btn_zone, text="✓ Équipé", font=(self.app.body.cget("family"), 10, "bold"),
                               bg=c_card, fg="#27ae60")
                lbl.pack()
            elif item_id in possedes or item["prix"] == 0:
                b = ttk.Button(btn_zone, text="Équiper",
                               command=lambda k=cat_key, i=item_id: self._equiper(k, i))
                b.pack()
            else:
                b = ttk.Button(btn_zone, text=f"Acheter ({item['prix']} 🪙)",
                               command=lambda k=cat_key, it=item: self._acheter(k, it))
                b.pack()

    def _rafraichir_gear(self):
        avatar = self.app.data.get("avatar", {})
        t_id = avatar.get("toge", "lin_blanc")
        t_icon = next((x["icone"] for x in BOUTIQUE["toge"] if x["id"] == t_id), "🥋")
        c_id = avatar.get("couronne", "aucune")
        c_icon = next((x["icone"] for x in BOUTIQUE["couronne"] if x["id"] == c_id), "")
        if c_icon in ("", "👤"):
            c_icon = "🏛️"
        a_id = avatar.get("accessoire", "stylet")
        a_icon = next((x["icone"] for x in BOUTIQUE["accessoire"] if x["id"] == a_id), "✏️")

        self.avatar_gear.configure(text=f"Tenue : {c_icon} Couronne   {t_icon} Toge   {a_icon} Arme")
        self.lbl_sesterces.configure(text=f"🪙 {self.app.data.get('sesterces', 0)} Sesterces")

    def _equiper(self, cat, item_id):
        self.app.data.setdefault("avatar", {})[cat] = item_id
        prog.save_progress(self.app.data)
        audio.play_correct()
        self._reconstruire()

    def _acheter(self, cat, item):
        prix = item["prix"]
        solde = self.app.data.get("sesterces", 0)
        if solde < prix:
            messagebox.showinfo(
                "Sesterces insuffisants",
                f"Il te manque {prix - solde} Sesterces pour acheter cet objet !\nRéussis d'autres leçons pour en gagner !"
            )
            return

        self.app.data["sesterces"] = solde - prix
        possedes = self.app.data.setdefault("avatar_possedes", ["lin_blanc", "aucune", "stylet"])
        if item["id"] not in possedes:
            possedes.append(item["id"])
        self.app.data.setdefault("avatar", {})[cat] = item["id"]
        prog.save_progress(self.app.data)
        audio.play_coin()
        self._reconstruire()

    def _reconstruire(self):
        for widget in self.winfo_children():
            widget.destroy()
        self._build_ui()

