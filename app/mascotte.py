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
        "icone": "🏛️",
        "badge": "🥋 Toge Blanche",
        "desc": "La noble toge blanche ornée d'une écharpe rouge du jeune citoyen.",
        "replique": "Je porte ma fière toge romaine ! Prêt pour le Sénat !",
    },
    "mercure": {
        "id": "mercure",
        "nom": "Ailes de Mercure",
        "prix": 150,
        "icone": "🪽",
        "badge": "🪽 Ailes Divines",
        "desc": "Les sandales et le casque ailés du messager des dieux.",
        "replique": "Grâce aux ailes de Mercure, j'apprends à la vitesse de l'éclair !",
    },
    "imperator": {
        "id": "imperator",
        "nom": "Couronne Impériale",
        "prix": 250,
        "icone": "👑",
        "badge": "👑 Lauriers d'Or",
        "desc": "La couronne de laurier d'or massif des illustres Césars.",
        "replique": "Ave Caesar ! Tous les lauriers de Rome pour ton savoir !",
    },
    "savant": {
        "id": "savant",
        "nom": "Lunettes de Philosophe",
        "prix": 100,
        "icone": "👓",
        "badge": "👓 Savant Romain",
        "desc": "De fines besicles antiques pour lire tous les parchemins anciens sans fatiguer.",
        "replique": "Sapientia et scientia ! Aucun mystère latin ne nous résiste !",
    },
}


def _dessiner_accessoire_costume(im, costume_id):
    """Dessine un ornement visuel adapté sur le portrait de Lupulus selon le costume."""
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
        self.taille = taille
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
        cle_cache = (emotion, cid)
        if cle_cache in self._images_cache:
            return self._images_cache[cle_cache]

        fichier = ASSETS_LUPULUS / f"lupulus_{emotion}.png"
        if not fichier.exists():
            fichier = ASSETS_LUPULUS / "lupulus_normal.png"

        if fichier.exists():
            try:
                if HAS_PIL:
                    im = Image.open(fichier).convert("RGBA")
                    if im.size != (self.taille, self.taille):
                        im = im.resize((self.taille, self.taille), Image.Resampling.LANCZOS)
                    im = _dessiner_accessoire_costume(im, cid)
                    photo = ImageTk.PhotoImage(im)
                else:
                    photo = tk.PhotoImage(file=str(fichier))
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
            self.img_lbl.configure(image=photo)
            self._photo_ref = photo

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
    """Fenêtre interactive de la Penderie de Lupulus (Boutique de Costumes)."""

    def __init__(self, master, app, on_change=None):
        super().__init__(master)
        self.app = app
        self.on_change = on_change
        self.title("👕 La Penderie de Lupulus — Boutique Antique")
        self.configure(bg="#1a1b26")

        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 680, 520)
        self.minsize(500, 420)
        self.transient(master)

        self._apercu_photo = None

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

        self.lbl_sesterces = tk.Label(
            hdr,
            text=f"🪙 Solde : {self._get_sesterces()} Sesterces",
            font=("Georgia", 11, "bold"),
            bg="#24283b",
            fg="#ffd700",
        )
        self.lbl_sesterces.pack(side=tk.RIGHT)

        # 2. Corps principal (Aperçu à gauche, Liste des costumes à droite)
        corps = tk.Frame(self, bg="#1a1b26", padx=12, pady=10)
        corps.pack(fill=tk.BOTH, expand=True)

        # Panneau gauche : Aperçu
        panneau_g = tk.Frame(corps, bg="#1f2335", bd=1, relief="solid", padx=12, pady=12, width=230)
        panneau_g.pack(side=tk.LEFT, fill=tk.BOTH, padx=(0, 10))
        panneau_g.pack_propagate(False)

        tk.Label(
            panneau_g,
            text="🐺 Aperçu en direct",
            font=("Georgia", 11, "bold"),
            bg="#1f2335",
            fg="#e0af68"
        ).pack(pady=(0, 6))

        self.lbl_apercu_img = tk.Label(panneau_g, bg="#1f2335")
        self.lbl_apercu_img.pack(pady=4)

        self.lbl_apercu_badge = tk.Label(
            panneau_g,
            text="",
            font=("Georgia", 9, "bold"),
            bg="#24283b",
            fg="#ffd700",
            bd=1,
            relief="solid",
            padx=6,
            pady=2
        )
        self.lbl_apercu_badge.pack(fill=tk.X, pady=4)

        self.bulle_apercu = tk.Label(
            panneau_g,
            text="",
            font=("Georgia", 9, "italic"),
            bg="#fff8dc",
            fg="#4a2c11",
            wraplength=190,
            justify=tk.CENTER,
            bd=1,
            relief="solid",
            padx=6,
            pady=6
        )
        self.bulle_apercu.pack(fill=tk.BOTH, expand=True, pady=(6, 0))

        # Panneau droit : Liste déroulante des costumes
        panneau_d = tk.Frame(corps, bg="#1a1b26")
        panneau_d.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

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
            canvas.itemconfig(win_id, width=max(100, event.width - 24))
        canvas.bind("<Configure>", _config_canvas)

        canvas.configure(yscrollcommand=scrollbar.set)
        canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        def _on_wheel(e):
            canvas.yview_scroll(int(-1 * (e.delta / 120)), "units")
        canvas.bind_all("<MouseWheel>", _on_wheel)

        # 3. Bouton bas
        btn_barre = tk.Frame(self, bg="#24283b", padx=12, pady=8)
        btn_barre.pack(fill=tk.X)

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

        # 1. Mettre à jour l'aperçu
        c_info = COSTUMES_LUPULUS.get(costume_actuel, COSTUMES_LUPULUS["standard"])
        self.lbl_apercu_badge.configure(text=f"Porté : {c_info.get('badge', c_info['nom'])}")
        self.bulle_apercu.configure(text=f"« {c_info.get('replique', 'Salvete !')} »")

        fichier = ASSETS_LUPULUS / "lupulus_joie.png"
        if not fichier.exists():
            fichier = ASSETS_LUPULUS / "lupulus_normal.png"
        if fichier.exists():
            try:
                if HAS_PIL:
                    im = Image.open(fichier).convert("RGBA")
                    im = im.resize((120, 120), Image.Resampling.LANCZOS)
                    im = _dessiner_accessoire_costume(im, costume_actuel)
                    self._apercu_photo = ImageTk.PhotoImage(im)
                else:
                    self._apercu_photo = tk.PhotoImage(file=str(fichier))
                self.lbl_apercu_img.configure(image=self._apercu_photo)
            except Exception:
                pass

        # 2. Régénérer les cartes de costumes
        for w in self.scroll_frame.winfo_children():
            w.destroy()

        for cid, info in COSTUMES_LUPULUS.items():
            est_porte = (cid == costume_actuel)
            est_possede = (cid in debloques)
            prix = info["prix"]

            bd_col = "#ffd700" if est_porte else ("#2ecc71" if est_possede else "#3b4261")
            carte = tk.Frame(
                self.scroll_frame,
                bg="#24283b",
                highlightthickness=1,
                highlightbackground=bd_col,
                padx=10,
                pady=8
            )
            carte.pack(fill=tk.X, pady=4, padx=2)

            # Icône
            tk.Label(
                carte,
                text=info.get("icone", "👕"),
                font=("", 24),
                bg="#24283b",
                fg="#ffd700"
            ).pack(side=tk.LEFT, padx=(0, 10))

            # Détails
            f_mid = tk.Frame(carte, bg="#24283b")
            f_mid.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

            tk.Label(
                f_mid,
                text=info["nom"],
                font=("Georgia", 11, "bold"),
                bg="#24283b",
                fg="#ffd700" if est_porte else "#c0caf5",
                anchor="w"
            ).pack(fill=tk.X)

            tk.Label(
                f_mid,
                text=info["desc"],
                font=("Georgia", 9),
                bg="#24283b",
                fg="#9aa5ce",
                wraplength=180,
                justify=tk.LEFT,
                anchor="w"
            ).pack(fill=tk.X, pady=(2, 0))

            # Actions & Prix
            f_act = tk.Frame(carte, bg="#24283b")
            f_act.pack(side=tk.RIGHT, padx=(6, 4))

            if est_porte:
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
            elif est_possede:
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
                peut_acheter = (solde >= prix)
                btn_bg = "#e0af68" if peut_acheter else "#414868"
                btn_fg = "#1a1b26" if peut_acheter else "#7a88cf"
                cur = "hand2" if peut_acheter else "arrow"

                tk.Button(
                    f_act,
                    text=f"🪙 Acheter ({prix})",
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

