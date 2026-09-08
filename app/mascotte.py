"""
Module de la Mascotte Interactive Lupulus le Louveteau.
Fournit un compagnon d'apprentissage interactif et expressif
qui réagit aux actions de l'élève (succès, hésitation, erreur, triomphe)
avec des bulles de dialogues latines et des animations d'émotions.
"""

import random
import tkinter as tk
from pathlib import Path

try:
    from PIL import Image, ImageTk
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

ASSETS_LUPULUS = Path(__file__).resolve().parent.parent / "assets" / "images" / "lupulus"

# Citations et répliques interactives de Lupulus
REPLIQUES_CLIC = [
    "Salvete ! Je suis Lupulus, ton guide dans la Rome antique !",
    "Vaf ! Vaf ! Ad astra per aspera !",
    "Savais-tu que la Louve a nourri Romulus et Rémus ?",
    "Gratias tibi ago ! Continuons notre aventure !",
    "Tu as l'étoffe d'un futur consul romain !",
    "Le savais-tu ? 'Lupus' signifie loup en latin !",
]

CITATIONS_SUCCES = [
    "Optime ! C'est une réponse digne d'un sénateur !",
    "Eugepae ! Victoire pour Rome !",
    "Macte animo ! Tu progresses à pas de géant !",
    "Bravo ! Même le Minotaure n'aurait pu rivaliser !",
    "Splendide ! Les dieux de l'Olympe te sourient !",
]

CITATIONS_ERREUR = [
    "Errare humanum est ! Courage, réessaie !",
    "Ne faiblis pas, jeune héros : analyse bien la consigne !",
    "Un légionnaire ne renonce jamais ! Tu vas y arriver !",
    "Regarde l'indice, il t'éclairera la voie !",
]

CITATIONS_REFLEXION = [
    "Cogito... prends tout ton temps pour bien analyser !",
    "Quel cas ou quelle terminaison convient le mieux ?",
    "Pense à la règle des déclinaisons !",
]

CITATIONS_TRIOMPHE = [
    "Victoria aeterna ! Tu as conquis les 10 Mondes !",
    "Le Sénat et le Peuple de Rome t'acclament !",
    "Tu mérites la plus éclatante couronne de lauriers !",
]

COSTUMES_LUPULUS = {
    "standard": {
        "id": "standard",
        "nom": "Toge Classique",
        "prix": 0,
        "categorie": "toge",
        "icone": "🏛️",
        "badge": "🥋 Toge Blanche",
        "desc": "La noble toge blanche ornée d'une écharpe rouge du jeune citoyen.",
        "replique": "Je porte ma fière toge romaine ! Prêt pour le Forum !",
    },
    "centurion": {
        "id": "centurion",
        "nom": "Centurion de la Légion",
        "prix": 200,
        "categorie": "armure",
        "icone": "⚔️",
        "badge": "⚔️ Centurion Romain",
        "desc": "Casque étincelant à fière crête rouge, cuirasse dorée et glaive de parade.",
        "replique": "Par Mars ! Avec cette armure et mon casque à crête, les légions nous saluent !",
    },
    "mercure": {
        "id": "mercure",
        "nom": "Ailes de Mercure",
        "prix": 150,
        "categorie": "divinite",
        "icone": "🪽",
        "badge": "🪽 Ailes Divines",
        "desc": "Casque ailé d'or massif, ailes divines et sandales du messager des dieux.",
        "replique": "Grâce aux ailes de Mercure, j'apprends à la vitesse de l'éclair !",
    },
    "imperator": {
        "id": "imperator",
        "nom": "Couronne Impériale",
        "prix": 250,
        "categorie": "toge",
        "icone": "👑",
        "badge": "👑 Lauriers d'Or",
        "desc": "Toge pourpre impériale brodée de fils d'or et couronne de laurier des Césars.",
        "replique": "Ave Caesar ! Tous les lauriers de Rome pour ton savoir !",
    },
    "savant": {
        "id": "savant",
        "nom": "Lunettes de Philosophe",
        "prix": 100,
        "categorie": "savoir",
        "icone": "👓",
        "badge": "👓 Savant Romain",
        "desc": "De fines besicles antiques dorées, toge d'orateur et rouleau de papyrus antique.",
        "replique": "Sapientia et scientia ! Aucun mystère latin ne nous résiste !",
    },
    "gladiateur": {
        "id": "gladiateur",
        "nom": "Gladiateur Mirmillon",
        "prix": 180,
        "categorie": "armure",
        "icone": "🛡️",
        "badge": "🛡️ Champion de l'Arène",
        "desc": "Casque d'arène à visière ornée d'un poisson, manica en cuir et bouclier rond.",
        "replique": "Ave Caesar, morituri te salutant ! Prêt pour le Colisée !",
    },
}


def _dessiner_accessoire_costume(im, costume_id):
    """Dessine un ornement visuel de repli si aucune illustration dédiée n'est disponible."""
    if costume_id == "standard" or not HAS_PIL:
        return im
    try:
        from PIL import ImageDraw
        w, h = im.size
        overlay = im.copy()
        draw = ImageDraw.Draw(overlay)

        if costume_id == "imperator":
            y_couronne = int(h * 0.18)
            x_centre = int(w * 0.5)
            r_x = int(w * 0.28)
            r_y = int(h * 0.08)
            draw.arc(
                [x_centre - r_x, y_couronne - r_y, x_centre + r_x, y_couronne + r_y],
                start=200, end=340, fill="#ffd700", width=max(2, int(w * 0.03))
            )
            for dx in (-int(w * 0.22), -int(w * 0.12), 0, int(w * 0.12), int(w * 0.22)):
                draw.ellipse(
                    [x_centre + dx - int(w * 0.03), y_couronne - int(h * 0.04),
                     x_centre + dx + int(w * 0.03), y_couronne + int(h * 0.02)],
                    fill="#ffec8b", outline="#d4af37"
                )

        elif costume_id == "mercure":
            draw.polygon(
                [(int(w * 0.22), int(h * 0.25)), (int(w * 0.08), int(h * 0.14)), (int(w * 0.12), int(h * 0.28))],
                fill="#ffffff", outline="#ffd700"
            )
            draw.polygon(
                [(int(w * 0.78), int(h * 0.25)), (int(w * 0.92), int(h * 0.14)), (int(w * 0.88), int(h * 0.28))],
                fill="#ffffff", outline="#ffd700"
            )

        elif costume_id == "savant":
            y_yeux = int(h * 0.44)
            r_verre = int(w * 0.09)
            x_g = int(w * 0.38)
            x_d = int(w * 0.62)
            draw.ellipse(
                [x_g - r_verre, y_yeux - r_verre, x_g + r_verre, y_yeux + r_verre],
                outline="#ffd700", width=max(2, int(w * 0.025))
            )
            draw.ellipse(
                [x_d - r_verre, y_yeux - r_verre, x_d + r_verre, y_yeux + r_verre],
                outline="#ffd700", width=max(2, int(w * 0.025))
            )
            draw.line(
                [(x_g + r_verre, y_yeux), (x_d - r_verre, y_yeux)],
                fill="#ffd700", width=max(2, int(w * 0.025))
            )
        return overlay
    except Exception:
        return im


class MascotteWidget(tk.Frame):
    """Widget affichant Lupulus avec sa bulle de dialogue dynamique et son costume."""

    def __init__(self, master, app=None, taille=100, **kw):
        super().__init__(master, **kw)
        self.app = app
        from app.responsive import obtenir_facteur_echelle
        scale = obtenir_facteur_echelle(master)
        self.taille = max(60, int(round(taille * scale)))
        self.emotion_actuelle = "normal"
        self._images_cache = {}
        self._reset_timer = None

        self.costume_actuel = "standard"
        if self.app and hasattr(self.app, "data") and isinstance(self.app.data, dict):
            self.costume_actuel = self.app.data.get("lupulus_costume", "standard")

        bg_col = self.cget("bg") if self.cget("bg") else "#24283b"
        self.configure(bg=bg_col)

        # 1. Bulle de dialogue supérieure
        self.bulle_frame = tk.Frame(self, bg="#fff8dc", bd=1, relief="solid", padx=8, pady=4)
        self.bulle_frame.pack(side=tk.TOP, fill=tk.X, padx=4, pady=(0, 4))

        self.bulle_lbl = tk.Label(
            self.bulle_frame,
            text="Salvete ! Clique sur moi !",
            font=("Georgia", 9, "italic"),
            bg="#fff8dc",
            fg="#4a2c11",
            wraplength=190,
            justify=tk.LEFT
        )
        self.bulle_lbl.pack(fill=tk.BOTH, expand=True)

        def _sur_config_bulle(event):
            w = max(100, event.width - 16)
            try:
                self.bulle_lbl.configure(wraplength=w)
            except Exception:
                pass
        self.bulle_frame.bind("<Configure>", _sur_config_bulle)

        # 2. Conteneur image cliquable
        self.img_lbl = tk.Label(self, bg=bg_col, cursor="hand2")
        self.img_lbl.pack(side=tk.TOP)
        self.img_lbl.bind("<Button-1>", self._sur_clic_mascotte)

        # 3. Barre de costume et accès Penderie
        self.barre_costume = tk.Frame(self, bg=bg_col)
        self.barre_costume.pack(side=tk.TOP, fill=tk.X, pady=(4, 0))

        c_info = COSTUMES_LUPULUS.get(self.costume_actuel, COSTUMES_LUPULUS["standard"])
        self.lbl_costume = tk.Label(
            self.barre_costume,
            text=c_info.get("badge", c_info["nom"]),
            font=("Georgia", 8, "bold"),
            bg="#1f2335",
            fg="#ffd700",
            bd=1,
            relief="solid",
            padx=4,
            pady=1,
            cursor="hand2"
        )
        self.lbl_costume.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(2, 2))
        self.lbl_costume.bind("<Button-1>", lambda e: self.ouvrir_penderie())

        self.btn_costume = tk.Button(
            self.barre_costume,
            text="👕",
            font=("Georgia", 8, "bold"),
            bg="#3b4261",
            fg="#ffffff",
            activebackground="#414868",
            relief="flat",
            cursor="hand2",
            padx=4,
            pady=1,
            command=self.ouvrir_penderie
        )
        self.btn_costume.pack(side=tk.RIGHT, padx=(0, 2))

        self.set_emotion("normal")

    def rafraichir_costume(self):
        """Met à jour le costume affiché à partir des données de l'application."""
        if self.app and hasattr(self.app, "data") and isinstance(self.app.data, dict):
            self.costume_actuel = self.app.data.get("lupulus_costume", "standard")
        c_info = COSTUMES_LUPULUS.get(self.costume_actuel, COSTUMES_LUPULUS["standard"])
        self.lbl_costume.configure(text=c_info.get("badge", c_info["nom"]))
        self.set_emotion(self.emotion_actuelle)

    def ouvrir_penderie(self):
        """Ouvre le dialogue de la penderie de Lupulus."""
        PenderieLupulusDialog(self.winfo_toplevel(), self.app, on_change=self.rafraichir_costume)

    def _charger_image(self, emotion, costume_id=None):
        cid = costume_id or self.costume_actuel
        cle_cache = (emotion, cid, self.taille)
        if cle_cache in self._images_cache:
            return self._images_cache[cle_cache]

        fichier = None
        # 1. Si costume spécifique équipé, chercher l'illustration haute définition dédiée
        if cid and cid != "standard":
            f_costume = ASSETS_LUPULUS / f"lupulus_{cid}.png"
            if not f_costume.exists() and cid == "savant":
                f_costume = ASSETS_LUPULUS / "lupulus_philosophe.png"
            if f_costume.exists():
                fichier = f_costume

        # 2. Sinon, utiliser l'image de l'émotion demandée
        if not fichier or not fichier.exists():
            fichier = ASSETS_LUPULUS / f"lupulus_{emotion}.png"
            if not fichier.exists():
                fichier = ASSETS_LUPULUS / "lupulus_normal.png"

        if fichier and fichier.exists():
            try:
                if HAS_PIL:
                    im = Image.open(fichier).convert("RGBA")
                    if im.size != (self.taille, self.taille):
                        im = im.resize((self.taille, self.taille), Image.Resampling.LANCZOS)
                    # Si c'est l'image standard et qu'on a un ancien costume sans fichier dédié
                    if cid and not (ASSETS_LUPULUS / f"lupulus_{cid}.png").exists() and cid != "standard":
                        im = _dessiner_accessoire_costume(im, cid)
                    photo = ImageTk.PhotoImage(im, master=self)
                else:
                    photo = tk.PhotoImage(file=str(fichier), master=self)
                self._images_cache[cle_cache] = photo
                return photo
            except Exception:
                pass
        return None

    def set_emotion(self, emotion, texte=None, duree_ms=4000):
        """Change l'expression de Lupulus et met à jour sa bulle de parole."""
        self.emotion_actuelle = emotion
        photo = self._charger_image(emotion)
        if photo:
            try:
                self.img_lbl.configure(image=photo)
                self._photo_ref = photo
            except Exception:
                pass

        if texte:
            self.dire(texte, duree_ms)

    def dire(self, texte, duree_ms=4000):
        """Affiche un message dans la bulle de parole avec réinitialisation automatique."""
        self.bulle_lbl.configure(text=texte)
        if self._reset_timer:
            self.after_cancel(self._reset_timer)
        if duree_ms > 0:
            self._reset_timer = self.after(duree_ms, self._reinitialiser_bulle)

    def _reinitialiser_bulle(self):
        self.emotion_actuelle = "normal"
        photo = self._charger_image("normal")
        if photo:
            self.img_lbl.configure(image=photo)
            self._photo_ref = photo
        self.bulle_lbl.configure(text="Prêt pour l'épreuve suivante !")

    def reagir_succes(self, message=None):
        """Réaction joyeuse lors d'une réussite."""
        citation = message or random.choice(CITATIONS_SUCCES)
        self.set_emotion("joie", citation, duree_ms=4500)

    def reagir_erreur(self, message=None):
        """Réaction d'aide et réconfort lors d'une erreur."""
        citation = message or random.choice(CITATIONS_ERREUR)
        self.set_emotion("aide", citation, duree_ms=5000)

    def reagir_reflexion(self, message=None):
        """Réaction pensive."""
        citation = message or random.choice(CITATIONS_REFLEXION)
        self.set_emotion("reflexion", citation, duree_ms=4000)

    def reagir_triomphe(self, message=None):
        """Réaction grandiose de victoire finale."""
        citation = message or random.choice(CITATIONS_TRIOMPHE)
        self.set_emotion("triomphe", citation, duree_ms=6000)

    def _sur_clic_mascotte(self, event=None):
        replique = random.choice(REPLIQUES_CLIC)
        self.dire(f"🐾 Lupulus : « {replique} »", duree_ms=4000)
        try:
            from app import audio
            audio.play_coin()
        except Exception:
            pass

    def destroy(self):
        if self._reset_timer:
            try:
                self.after_cancel(self._reset_timer)
            except Exception:
                pass
            self._reset_timer = None
        super().destroy()


class PenderieLupulusDialog(tk.Toplevel):
    """Fenêtre interactive de la Penderie de Lupulus (Boutique de Costumes & Atelier Romain)."""

    def __init__(self, master, app, on_change=None):
        super().__init__(master)
        self.app = app
        self.on_change = on_change
        self.title("👕 La Penderie de Lupulus — Boutique Antique")
        self.configure(bg="#1a1b26")

        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 760, 560)
        self.minsize(620, 460)
        self.transient(master)

        self._apercu_photo = None
        self.costume_selectionne = self._get_costume_actuel()
        self.filtre_cat = "tous"

        from app import audio
        audio.play_click()

        # 1. En-tête antique
        hdr = tk.Frame(self, bg="#24283b", padx=16, pady=12)
        hdr.pack(fill=tk.X)

        tk.Label(
            hdr,
            text="👕 LA PENDERIE DE LUPULUS",
            font=("Georgia", 16, "bold"),
            bg="#24283b",
            fg="#ffd700",
        ).pack(side=tk.LEFT)

        f_solde = tk.Frame(hdr, bg="#24283b")
        f_solde.pack(side=tk.RIGHT)

        self.lbl_sesterces = tk.Label(
            f_solde,
            text=f"🪙 Solde : {self._get_sesterces()} Sesterces",
            font=("Georgia", 11, "bold"),
            bg="#1f2335",
            fg="#ffd700",
            bd=1,
            relief="solid",
            padx=8,
            pady=3
        )
        self.lbl_sesterces.pack(side=tk.RIGHT)

        # 2. Corps principal (Podium à gauche, Catalogue à droite)
        corps = tk.Frame(self, bg="#1a1b26", padx=14, pady=10)
        corps.pack(fill=tk.BOTH, expand=True)

        # Panneau gauche : Podium d'essayage en direct
        self.panneau_g = tk.Frame(corps, bg="#1f2335", bd=2, relief="solid", padx=14, pady=12, width=260)
        self.panneau_g.pack(side=tk.LEFT, fill=tk.BOTH, padx=(0, 12))
        self.panneau_g.pack_propagate(False)

        tk.Label(
            self.panneau_g,
            text="🐺 PODIUM D'ESSAYAGE",
            font=("Georgia", 11, "bold"),
            bg="#1f2335",
            fg="#ffd700"
        ).pack(pady=(0, 6))

        self.lbl_apercu_img = tk.Label(self.panneau_g, bg="#1f2335")
        self.lbl_apercu_img.pack(pady=4)

        self.lbl_apercu_badge = tk.Label(
            self.panneau_g,
            text="",
            font=("Georgia", 10, "bold"),
            bg="#24283b",
            fg="#ffd700",
            bd=1,
            relief="solid",
            padx=8,
            pady=3
        )
        self.lbl_apercu_badge.pack(fill=tk.X, pady=4)

        self.bulle_apercu = tk.Label(
            self.panneau_g,
            text="",
            font=("Georgia", 9, "italic"),
            bg="#fff8dc",
            fg="#4a2c11",
            wraplength=220,
            justify=tk.CENTER,
            bd=1,
            relief="solid",
            padx=8,
            pady=8
        )
        self.bulle_apercu.pack(fill=tk.X, pady=4)

        # Bouton d'action principal sous l'aperçu
        self.btn_action_podium = tk.Button(
            self.panneau_g,
            text="",
            font=("Georgia", 10, "bold"),
            relief="flat",
            cursor="hand2",
            padx=12,
            pady=6
        )
        self.btn_action_podium.pack(side=tk.BOTTOM, fill=tk.X, pady=(6, 0))

        # Panneau droit : Filtres de catégories + Liste de costumes
        panneau_d = tk.Frame(corps, bg="#1a1b26")
        panneau_d.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        # Barre de filtres
        filtres_frame = tk.Frame(panneau_d, bg="#1a1b26")
        filtres_frame.pack(fill=tk.X, pady=(0, 8))

        self._btn_filtres = {}
        categories = [
            ("tous", "🏛️ Tous"),
            ("armure", "⚔️ Armures"),
            ("toge", "🥋 Toges"),
            ("savoir", "📜 Savoirs"),
        ]
        for cat_id, cat_nom in categories:
            b = tk.Button(
                filtres_frame,
                text=cat_nom,
                font=("Georgia", 9, "bold"),
                bg="#24283b" if cat_id != "tous" else "#ffd700",
                fg="#c0caf5" if cat_id != "tous" else "#1a1b26",
                activebackground="#ffd700",
                relief="flat",
                cursor="hand2",
                padx=8,
                pady=3,
                command=lambda c=cat_id: self._filtrer_categorie(c)
            )
            b.pack(side=tk.LEFT, padx=(0, 6))
            self._btn_filtres[cat_id] = b

        canvas = tk.Canvas(panneau_d, bg="#1a1b26", highlightthickness=0)
        from tkinter import ttk
        scrollbar = ttk.Scrollbar(panneau_d, orient="vertical", command=canvas.yview)
        self.scroll_frame = tk.Frame(canvas, bg="#1a1b26")

        self.scroll_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )
        win_id = canvas.create_window((0, 0), window=self.scroll_frame, anchor="nw")

        def _config_canvas(event):
            canvas.itemconfig(win_id, width=max(100, event.width - 16))
        canvas.bind("<Configure>", _config_canvas)

        canvas.configure(yscrollcommand=scrollbar.set)
        canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        def _on_wheel(e):
            canvas.yview_scroll(int(-1 * (e.delta / 120)), "units")
        self.bind("<MouseWheel>", _on_wheel)

        # 3. Barre inférieure
        btn_barre = tk.Frame(self, bg="#24283b", padx=16, pady=8)
        btn_barre.pack(fill=tk.X)

        self.lbl_stats_costumes = tk.Label(
            btn_barre,
            text="",
            font=("Georgia", 9, "bold"),
            bg="#24283b",
            fg="#9aa5ce"
        )
        self.lbl_stats_costumes.pack(side=tk.LEFT)

        tk.Button(
            btn_barre,
            text="Fermer (Échap)",
            font=("Georgia", 10, "bold"),
            bg="#414868",
            fg="#ffffff",
            activebackground="#565f89",
            relief="flat",
            cursor="hand2",
            padx=16,
            pady=4,
            command=self.destroy
        ).pack(side=tk.RIGHT)

        self.bind("<Escape>", lambda e: self.destroy())

        self._rafraichir_tout()

    def _filtrer_categorie(self, cat_id):
        self.filtre_cat = cat_id
        for cid, btn in self._btn_filtres.items():
            if cid == cat_id:
                btn.configure(bg="#ffd700", fg="#1a1b26")
            else:
                btn.configure(bg="#24283b", fg="#c0caf5")
        try:
            from app import audio
            audio.play_click()
        except Exception:
            pass
        self._rafraichir_tout()

    def _selectionner_costume(self, cid):
        self.costume_selectionne = cid
        try:
            from app import audio
            audio.play_click()
        except Exception:
            pass
        self._rafraichir_tout()

    def _get_sesterces(self):
        if self.app and hasattr(self.app, "data") and isinstance(self.app.data, dict):
            return self.app.data.get("sesterces", 0)
        return 0

    def _get_costume_actuel(self):
        if self.app and hasattr(self.app, "data") and isinstance(self.app.data, dict):
            return self.app.data.get("lupulus_costume", "standard")
        return "standard"

    def _get_costumes_debloques(self):
        if self.app and hasattr(self.app, "data") and isinstance(self.app.data, dict):
            debloques = self.app.data.setdefault("lupulus_costumes_debloques", ["standard"])
            if "standard" not in debloques:
                debloques.append("standard")
            return debloques
        return ["standard"]

    def _rafraichir_tout(self):
        solde = self._get_sesterces()
        costume_actuel = self._get_costume_actuel()
        debloques = self._get_costumes_debloques()

        self.lbl_sesterces.configure(text=f"🪙 Solde : {solde} Sesterces")
        self.lbl_stats_costumes.configure(
            text=f"🥋 Collection : {len(debloques)}/{len(COSTUMES_LUPULUS)} costumes acquis"
        )

        # 1. Mettre à jour le podium avec le costume sélectionné
        sel_id = self.costume_selectionne or costume_actuel
        sel_info = COSTUMES_LUPULUS.get(sel_id, COSTUMES_LUPULUS["standard"])

        est_porte = (sel_id == costume_actuel)
        est_possede = (sel_id in debloques)
        prix = sel_info["prix"]

        prefixe = "Porté : " if est_porte else "Essayage : "
        self.lbl_apercu_badge.configure(text=f"{prefixe}{sel_info.get('badge', sel_info['nom'])}")
        self.bulle_apercu.configure(text=f"« {sel_info.get('replique', 'Salvete !')} »")

        # Chargement de l'illustration HD du costume
        fichier = ASSETS_LUPULUS / f"lupulus_{sel_id}_180.png"
        if not fichier.exists():
            fichier = ASSETS_LUPULUS / f"lupulus_{sel_id}.png"
        if not fichier.exists() and sel_id == "savant":
            fichier = ASSETS_LUPULUS / "lupulus_philosophe_180.png"
        if not fichier.exists():
            fichier = ASSETS_LUPULUS / "lupulus_normal_180.png"

        if fichier.exists():
            try:
                if HAS_PIL:
                    im = Image.open(fichier).convert("RGBA")
                    im = im.resize((150, 150), Image.Resampling.LANCZOS)
                    self._apercu_photo = ImageTk.PhotoImage(im)
                else:
                    self._apercu_photo = tk.PhotoImage(file=str(fichier))
                self.lbl_apercu_img.configure(image=self._apercu_photo)
            except Exception:
                pass

        # Configuration du bouton d'action principal sous l'aperçu
        if est_porte:
            self.btn_action_podium.configure(
                text="✔ Déjà porté sur Lupulus",
                bg="#1f2335",
                fg="#2ecc71",
                state="disabled"
            )
        elif est_possede:
            self.btn_action_podium.configure(
                text="✨ Enfiler ce costume",
                bg="#ffd700",
                fg="#1a1b26",
                state="normal",
                command=lambda: self._equiper(sel_id)
            )
        else:
            peut_acheter = (solde >= prix)
            txt = f"🪙 Acheter pour {prix} HS" if peut_acheter else f"🪙 {prix} HS requis"
            self.btn_action_podium.configure(
                text=txt,
                bg="#e0af68" if peut_acheter else "#414868",
                fg="#1a1b26" if peut_acheter else "#9aa5ce",
                state="normal" if peut_acheter else "disabled",
                command=lambda: self._acheter(sel_id)
            )

        # 2. Régénérer les cartes de costumes dans le catalogue
        for w in self.scroll_frame.winfo_children():
            w.destroy()

        for cid, info in COSTUMES_LUPULUS.items():
            cat = info.get("categorie", "tous")
            if self.filtre_cat != "tous" and cat != self.filtre_cat and not (self.filtre_cat == "savoir" and cat == "divinite"):
                continue

            est_carte_portee = (cid == costume_actuel)
            est_carte_selectionnee = (cid == sel_id)
            est_carte_possedee = (cid in debloques)
            prix_c = info["prix"]

            # Bordure dynamique
            if est_carte_selectionnee:
                bd_col = "#38bdf8"
                bg_carte = "#2a324b"
            elif est_carte_portee:
                bd_col = "#ffd700"
                bg_carte = "#24283b"
            elif est_carte_possedee:
                bd_col = "#2ecc71"
                bg_carte = "#24283b"
            else:
                bd_col = "#3b4261"
                bg_carte = "#1f2335"

            carte = tk.Frame(
                self.scroll_frame,
                bg=bg_carte,
                highlightthickness=2 if est_carte_selectionnee else 1,
                highlightbackground=bd_col,
                padx=10,
                pady=8,
                cursor="hand2"
            )
            carte.pack(fill=tk.X, pady=4, padx=2)
            carte.bind("<Button-1>", lambda e, c=cid: self._selectionner_costume(c))

            # Icône
            lbl_ico = tk.Label(
                carte,
                text=info.get("icone", "👕"),
                font=("", 24),
                bg=bg_carte,
                fg="#ffd700"
            )
            lbl_ico.pack(side=tk.LEFT, padx=(0, 10))
            lbl_ico.bind("<Button-1>", lambda e, c=cid: self._selectionner_costume(c))

            # Détails
            f_mid = tk.Frame(carte, bg=bg_carte)
            f_mid.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
            f_mid.bind("<Button-1>", lambda e, c=cid: self._selectionner_costume(c))

            lbl_titre = tk.Label(
                f_mid,
                text=info["nom"],
                font=("Georgia", 11, "bold"),
                bg=bg_carte,
                fg="#ffd700" if (est_carte_portee or est_carte_selectionnee) else "#c0caf5",
                anchor="w"
            )
            lbl_titre.pack(fill=tk.X)
            lbl_titre.bind("<Button-1>", lambda e, c=cid: self._selectionner_costume(c))

            lbl_desc = tk.Label(
                f_mid,
                text=info["desc"],
                font=("Georgia", 9),
                bg=bg_carte,
                fg="#9aa5ce",
                wraplength=210,
                justify=tk.LEFT,
                anchor="w"
            )
            lbl_desc.pack(fill=tk.X, pady=(2, 0))
            lbl_desc.bind("<Button-1>", lambda e, c=cid: self._selectionner_costume(c))

            # Actions & Prix
            f_act = tk.Frame(carte, bg=bg_carte)
            f_act.pack(side=tk.RIGHT, padx=(6, 4))
            f_act.bind("<Button-1>", lambda e, c=cid: self._selectionner_costume(c))

            if est_carte_portee:
                tk.Label(
                    f_act,
                    text="✔ Porté",
                    font=("Georgia", 9, "bold"),
                    bg="#1f2335",
                    fg="#2ecc71",
                    bd=1,
                    relief="solid",
                    padx=8,
                    pady=3
                ).pack(anchor="e")
            elif est_carte_possedee:
                tk.Button(
                    f_act,
                    text="🥋 Porter",
                    font=("Georgia", 9, "bold"),
                    bg="#d4af37",
                    fg="#1a1b26",
                    activebackground="#ffec8b",
                    relief="flat",
                    cursor="hand2",
                    padx=10,
                    pady=2,
                    command=lambda c=cid: self._equiper(c)
                ).pack(anchor="e")
            else:
                peut_acheter = (solde >= prix_c)
                btn_bg = "#e0af68" if peut_acheter else "#414868"
                btn_fg = "#1a1b26" if peut_acheter else "#7a88cf"
                cur = "hand2" if peut_acheter else "arrow"

                tk.Button(
                    f_act,
                    text=f"🪙 {prix_c} HS",
                    font=("Georgia", 9, "bold"),
                    bg=btn_bg,
                    fg=btn_fg,
                    relief="flat",
                    cursor=cur,
                    padx=8,
                    pady=2,
                    state="normal" if peut_acheter else "disabled",
                    command=lambda c=cid: self._acheter(c)
                ).pack(anchor="e")

    def _equiper(self, costume_id):
        """Équipe le costume sélectionné."""
        if self.app and hasattr(self.app, "data") and isinstance(self.app.data, dict):
            self.app.data["lupulus_costume"] = costume_id
            try:
                from app import progress as prog
                prog.save_progress(self.app.data)
            except Exception:
                pass

        self.costume_selectionne = costume_id

        try:
            from app import audio
            audio.play_coin()
        except Exception:
            pass

        if self.on_change:
            try:
                self.on_change()
            except Exception:
                pass

        self._rafraichir_tout()

    def _acheter(self, costume_id):
        """Achète le costume avec les sesterces de l'élève et l'équipe immédiatement."""
        info = COSTUMES_LUPULUS.get(costume_id)
        if not info:
            return

        prix = info["prix"]
        solde = self._get_sesterces()
        if solde < prix:
            return

        if self.app and hasattr(self.app, "ajouter_sesterces"):
            self.app.ajouter_sesterces(-prix)
        elif self.app and hasattr(self.app, "data"):
            self.app.data["sesterces"] = solde - prix

        debloques = self._get_costumes_debloques()
        if costume_id not in debloques:
            debloques.append(costume_id)

        self._equiper(costume_id)

        try:
            from app import audio
            audio.play_fanfare()
        except Exception:
            pass


