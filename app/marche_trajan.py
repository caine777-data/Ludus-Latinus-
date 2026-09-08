"""
Module du Mini-Jeu « Le Marché de Trajan » (Chiffres Romains et Calcul de Sesterces).
Permet aux élèves de maîtriser les chiffres romains (I, V, X, L, C, D, M)
et le calcul mental à travers des transactions au cœur du Forum romain.
"""

from pathlib import Path
import random
import tkinter as tk

try:
    from PIL import Image, ImageTk
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

from app import audio
from app.polices import police_corps, police_titre
from app.theme import est_sombre

ASSETS_IMAGES = Path(__file__).resolve().parent.parent / "assets" / "images"

# Valeurs des chiffres romains
VALEURS_ROMAINES = [
    (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
    (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
    (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
]


def arabe_en_romain(nombre):
    """Convertit un entier (1 à 3999) en chiffres romains."""
    if not isinstance(nombre, int) or nombre <= 0 or nombre > 3999:
        return ""
    resultat = []
    n = nombre
    for val, lettre in VALEURS_ROMAINES:
        while n >= val:
            resultat.append(lettre)
            n -= val
    return "".join(resultat)


def romain_en_arabe(texte):
    """Convertit une chaîne en chiffres romains en entier décimal."""
    if not texte:
        return 0
    t = texte.strip().upper()
    valeurs = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}
    total = 0
    prev = 0
    for c in reversed(t):
        val = valeurs.get(c, 0)
        if val < prev:
            total -= val
        else:
            total += val
            prev = val
    return total


ARTICLES_MARCHE = [
    {"nom": "Amphore d'huile d'olive", "prix": 25, "latin": "Amphora olei", "emoji": "🏺"},
    {"nom": "Toge en laine de Toscane", "prix": 40, "latin": "Toga lanea", "emoji": "👘"},
    {"nom": "Panier de figues et dattes", "prix": 14, "latin": "Ficus et dactyli", "emoji": "🧺"},
    {"nom": "Flacon de parfum de Tyr", "prix": 65, "latin": "Unguentum Tyrium", "emoji": "🧪"},
    {"nom": "Glaive en bois de gladiateur", "prix": 18, "latin": "Rudis lignea", "emoji": "🗡️"},
    {"nom": "Rouleau de papyrus", "prix": 32, "latin": "Volumen papyri", "emoji": "📜"},
    {"nom": "Statue de Minerve en bronze", "prix": 85, "latin": "Statua Minervae", "emoji": "🦉"},
    {"nom": "Boîte d'épices d'Orient", "prix": 50, "latin": "Aromata orientalia", "emoji": "🧰"},
]


class MarcheTrajanWindow(tk.Toplevel):
    """Fenêtre interactive du Marché de Trajan."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        from app.theme import THEMES, est_sombre
        self.C = getattr(app, "C", None) or THEMES["Rome Impériale"]

        self.title("🏺 Le Marché de Trajan — Chiffres Romains & Sesterces")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 880, 680, min_w=720, min_h=500)

        bg_def = self.C.get("bg", "#faf4e8")
        self.configure(bg=bg_def)

        self.sombre = est_sombre(bg_def)
        self.c_etal = "#24283b" if self.sombre else "#faf4e8"
        self.c_card = "#1a1b26" if self.sombre else "#ffffff"
        self.c_saisie = "#181a24" if self.sombre else "#fcf8f0"
        self.c_fg_primary = "#ffffff" if self.sombre else self.C.get("fg", "#222222")
        self.c_fg_accent = "#ffd700" if self.sombre else self.C.get("heading", "#7c1d1d")
        self.c_tile_bg = "#d4af37" if self.sombre else "#fbf7ed"
        self.c_tile_fg = "#1a1b26" if self.sombre else "#8c1d1d"

        self._photo_mercator = None
        if HAS_PIL:
            p = ASSETS_IMAGES / "lupulus" / "lupulus_savant.png"
            if not p.exists():
                p = ASSETS_IMAGES / "lupulus_savant_180.png"
            if p.exists():
                try:
                    im = Image.open(p).convert("RGBA")
                    im = im.resize((54, 54), Image.Resampling.LANCZOS)
                    self._photo_mercator = ImageTk.PhotoImage(im)
                except Exception:
                    self._photo_mercator = None

        self.score_session = 0
        self.article_courant = None
        self.mode = "composer"  # "composer", "rendu", "eclair"
        self.proposition_romaine = ""

        self._build_ui()
        self._bind_raccourcis()
        self._nouveau_defi()

    def _bind_raccourcis(self):
        for lettre in ["I", "V", "X", "L", "C", "D", "M"]:
            self.bind(f"<Key-{lettre.lower()}>", lambda e, let=lettre: self._ajouter_lettre(let))
            self.bind(f"<Key-{lettre.upper()}>", lambda e, let=lettre: self._ajouter_lettre(let))
        self.bind("<BackSpace>", lambda e: self._effacer_lettre())
        self.bind("<Return>", lambda e: self._verifier_reponse())

    def _build_ui(self):
        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=14, pady=10)
        hdr.pack(fill=tk.X)

        left_hdr = tk.Frame(hdr, bg=self.C["panel"])
        left_hdr.pack(side=tk.LEFT)

        tk.Label(left_hdr, text="🏺 LE MARCHÉ DE TRAJAN", font=police_titre(16),
                 bg=self.C["panel"], fg=self.c_fg_accent).pack(anchor=tk.W)
        self.lbl_soustitre = tk.Label(
            left_hdr,
            text="Gaius Mercator t'attend à son étal du Forum ! Maîtrise les chiffres romains.",
            font=police_corps(10, italique=True), bg=self.C["panel"], fg=self.C["muted"]
        )
        self.lbl_soustitre.pack(anchor=tk.W)

        right_hdr = tk.Frame(hdr, bg=self.C["panel"])
        right_hdr.pack(side=tk.RIGHT)

        self.lbl_score = tk.Label(
            right_hdr, text=f"Score : {self.score_session} pts | 🪙 {self.app.data.get('sesterces', 0)} Sesterces",
            font=police_corps(10, gras=True), bg=self.c_card, fg="#d4af37" if self.sombre else self.C["code"],
            padx=10, pady=5, relief="ridge"
        )
        self.lbl_score.pack(side=tk.RIGHT)

        # Onglets de mode
        barre_modes = tk.Frame(self, bg=self.C["panel"], padx=10, pady=4)
        barre_modes.pack(fill=tk.X)

        self.btn_mode_composer = tk.Button(
            barre_modes, text="1. Composer le Prix (I, V, X...)", font=police_corps(9, gras=True),
            bg=self.C["accent"], fg=self.C["sel_fg"], relief="flat", padx=10, pady=3,
            command=lambda: self._changer_mode("composer")
        )
        self.btn_mode_composer.pack(side=tk.LEFT, padx=4)

        self.btn_mode_rendu = tk.Button(
            barre_modes, text="2. Rendu de Monnaie", font=police_corps(9),
            bg=self.C["editor"], fg=self.C["fg"], relief="flat", padx=10, pady=3,
            command=lambda: self._changer_mode("rendu")
        )
        self.btn_mode_rendu.pack(side=tk.LEFT, padx=4)

        self.btn_mode_eclair = tk.Button(
            barre_modes, text="3. Défi Éclair du Forum", font=police_corps(9),
            bg=self.C["editor"], fg=self.C["fg"], relief="flat", padx=10, pady=3,
            command=lambda: self._changer_mode("eclair")
        )
        self.btn_mode_eclair.pack(side=tk.LEFT, padx=4)

        # Étal du marchand
        self.etal_frame = tk.Frame(self, bg=self.c_etal, bd=2, relief="groove", padx=20, pady=16)
        self.etal_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=14)

        # En-tête du marchand avec vignette Lupulus / Gaius Mercator
        bandeau_marchand = tk.Frame(self.etal_frame, bg=self.c_etal)
        bandeau_marchand.pack(fill=tk.X, pady=(0, 10))

        if self._photo_mercator:
            lbl_pic = tk.Label(bandeau_marchand, image=self._photo_mercator, bg=self.c_etal, bd=2, relief="ridge")
            lbl_pic.pack(side=tk.LEFT, padx=(0, 12))

        self.lbl_marchand = tk.Label(
            bandeau_marchand,
            text="Gaius Mercator : « Salve, jeune citoyen ! Que désires-tu aujourd'hui ? »",
            font=police_corps(11, gras=True), bg=self.c_etal, fg=self.c_fg_accent,
            wraplength=640, justify=tk.LEFT
        )
        self.lbl_marchand.pack(side=tk.LEFT, fill=tk.X, expand=True)

        # Carte de l'article en vente
        self.article_box = tk.Frame(self.etal_frame, bg=self.c_card, bd=2, relief="groove", padx=16, pady=12)
        self.article_box.pack(fill=tk.X, padx=30, pady=10)

        # Médaillon de l'article avec cadre
        box_med = tk.Frame(self.article_box, bg=self.c_card, bd=2, relief="ridge", padx=8, pady=4)
        box_med.pack(side=tk.LEFT, padx=(0, 16))

        self.lbl_art_emoji = tk.Label(box_med, text="🏺", font=("Segoe UI Emoji", 34), bg=self.c_card)
        self.lbl_art_emoji.pack()

        info_art = tk.Frame(self.article_box, bg=self.c_card)
        info_art.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.lbl_art_nom = tk.Label(info_art, text="Article", font=police_titre(13), bg=self.c_card, fg=self.c_fg_primary)
        self.lbl_art_nom.pack(anchor=tk.W)

        row_latin = tk.Frame(info_art, bg=self.c_card)
        row_latin.pack(anchor=tk.W, pady=(2, 0))
        self.lbl_art_latin = tk.Label(row_latin, text="Nom latin", font=police_corps(10, italique=True),
                                      bg=self.c_card, fg="#10b981" if self.sombre else "#2d8a4e")
        self.lbl_art_latin.pack(side=tk.LEFT)
        self.btn_art_audio = tk.Button(
            row_latin, text="🔊 Écouter", font=police_corps(8, gras=True),
            bg=self.c_etal, fg=self.c_fg_accent, activebackground=self.C["accent"], activeforeground=self.C["sel_fg"],
            relief="flat", padx=6, pady=1, cursor="hand2",
            command=self._ecouter_latin
        )
        self.btn_art_audio.pack(side=tk.LEFT, padx=(8, 0))

        self.lbl_art_consigne = tk.Label(info_art, text="Consigne", font=police_corps(10), bg=self.c_card, fg=self.c_fg_primary)
        self.lbl_art_consigne.pack(anchor=tk.W, pady=(4, 0))

        # Zone de réponse
        self.reponse_frame = tk.Frame(self.etal_frame, bg=self.c_etal)
        self.reponse_frame.pack(fill=tk.X, pady=6)

        # Affichage saisie chiffres romains
        self.zone_saisie = tk.Label(
            self.reponse_frame, text="", font=("Palatino Linotype", 22, "bold"),
            bg=self.c_saisie, fg=self.c_fg_accent, width=16, bd=2, relief="sunken"
        )
        self.zone_saisie.pack(pady=6)

        # Boutons tuiles romaines (I, V, X, L, C, D, M) avec valeur décimale
        self.tuiles_frame = tk.Frame(self.reponse_frame, bg=self.c_etal)
        self.tuiles_frame.pack(pady=6)

        TUILES_INFO = [
            ("I", "1"), ("V", "5"), ("X", "10"), ("L", "50"),
            ("C", "100"), ("D", "500"), ("M", "1000")
        ]

        self.btn_tuiles = []
        for lettre, val_dec in TUILES_INFO:
            b = tk.Button(
                self.tuiles_frame, text=f"{lettre}\n{val_dec}", font=("Palatino Linotype", 11, "bold"),
                bg=self.c_tile_bg, fg=self.c_tile_fg, activebackground="#f59e0b",
                width=4, height=2, cursor="hand2", relief="raised", bd=2,
                command=lambda let=lettre: self._ajouter_lettre(let)
            )
            b.pack(side=tk.LEFT, padx=3)
            self.btn_tuiles.append(b)

        btn_effacer = tk.Button(
            self.tuiles_frame, text="⌫\nEffacer", font=police_corps(9, gras=True),
            bg="#e74c3c", fg="#ffffff", activebackground="#c0392b",
            height=2, padx=8, relief="raised", bd=2, cursor="hand2",
            command=self._effacer_lettre
        )
        btn_effacer.pack(side=tk.LEFT, padx=6)

        # Entrée numérique pour le mode rendu
        self.entree_num = tk.Entry(self.reponse_frame, font=("Georgia", 14), width=10, justify="center")

        # Bouton Valider
        self.btn_valider = tk.Button(
            self.etal_frame, text="✓ Valider la Transaction (Entrée)", font=police_titre(12),
            bg="#27ae60", fg="#ffffff", padx=20, pady=6, cursor="hand2",
            command=self._verifier_reponse
        )
        self.btn_valider.pack(pady=10)

        self.lbl_feedback = tk.Label(self.etal_frame, text="", font=police_corps(11, gras=True), bg=self.c_etal)
        self.lbl_feedback.pack()

    def _ecouter_latin(self):
        """Prononce le terme latin de l'article en vente."""
        if self.article_courant and "latin" in self.article_courant:
            audio.speak_latin(self.article_courant["latin"])

    def _changer_mode(self, mode):
        audio.play_parchemin()
        self.mode = mode
        self.btn_mode_composer.configure(bg=self.C["accent"] if mode == "composer" else self.C["editor"],
                                        fg=self.C["sel_fg"] if mode == "composer" else self.C["fg"])
        self.btn_mode_rendu.configure(bg=self.C["accent"] if mode == "rendu" else self.C["editor"],
                                     fg=self.C["sel_fg"] if mode == "rendu" else self.C["fg"])
        self.btn_mode_eclair.configure(bg=self.C["accent"] if mode == "eclair" else self.C["editor"],
                                      fg=self.C["sel_fg"] if mode == "eclair" else self.C["fg"])
        self._nouveau_defi()

    def _ajouter_lettre(self, lettre):
        audio.play_click()
        self.proposition_romaine += lettre
        self.zone_saisie.configure(text=self.proposition_romaine)

    def _effacer_lettre(self):
        audio.play_click()
        self.proposition_romaine = self.proposition_romaine[:-1]
        self.zone_saisie.configure(text=self.proposition_romaine)

    def _nouveau_defi(self):
        self.proposition_romaine = ""
        self.zone_saisie.configure(text="")
        self.lbl_feedback.configure(text="")
        self.article_courant = random.choice(ARTICLES_MARCHE)

        self.lbl_art_emoji.configure(text=self.article_courant["emoji"])
        self.lbl_art_nom.configure(text=self.article_courant["nom"])
        self.lbl_art_latin.configure(text=f"« {self.article_courant['latin']} »")

        if self.mode == "composer":
            self.tuiles_frame.pack(pady=6)
            self.zone_saisie.pack(pady=6)
            self.entree_num.pack_forget()
            prix = self.article_courant["prix"]
            self.lbl_art_consigne.configure(
                text=f"Prix demandé : {prix} Sesterces. Compose ce montant en chiffres romains !"
            )
            self.lbl_marchand.configure(
                text=f"🧔 Gaius Mercator : « Cet article vaut {prix} sesterces. Paie-moi en chiffres romains ! »"
            )
        elif self.mode == "rendu":
            self.tuiles_frame.pack_forget()
            self.zone_saisie.pack_forget()
            self.entree_num.delete(0, tk.END)
            self.entree_num.pack(pady=6)
            prix = self.article_courant["prix"]
            # Client donne un montant rond supérieur (ex: 50 ou 100)
            palier = 50 if prix < 40 else 100
            self.donne = palier
            self.rendu_attendu = palier - prix
            self.lbl_art_consigne.configure(
                text=f"Prix : {prix} Sesterces ({arabe_en_romain(prix)}). Le client donne {palier} Sesterces ({arabe_en_romain(palier)}).\nCombien de sesterces dois-tu lui rendre ?"
            )
            self.lbl_marchand.configure(
                text=f"🧔 Gaius Mercator : « Voici {arabe_en_romain(palier)} ({palier} sesterces). Rends-moi la monnaie exacte ! »"
            )
        else:  # eclair
            self.tuiles_frame.pack(pady=6)
            self.zone_saisie.pack(pady=6)
            self.entree_num.pack_forget()
            nb = random.randint(5, 120)
            self.nombre_eclair = nb
            self.lbl_art_consigne.configure(
                text=f"Conversion éclair ! Traduis le nombre décimal : {nb} en chiffres romains !"
            )
            self.lbl_marchand.configure(
                text=f"🧔 Gaius Mercator : « Vite, écris {nb} en chiffres romains avant la fermeture du marché ! »"
            )

    def _verifier_reponse(self):
        succes = False
        if self.mode == "composer":
            attendu = arabe_en_romain(self.article_courant["prix"])
            if self.proposition_romaine == attendu:
                succes = True
                msg = f"✓ Bravo ! {self.article_courant['prix']} s'écrit bien {attendu} !"
            else:
                msg = f"Pas tout à fait... Attendu : {attendu} (tu as écrit {self.proposition_romaine})."
        elif self.mode == "rendu":
            saisie = self.entree_num.get().strip()
            if saisie.isdigit() and int(saisie) == self.rendu_attendu:
                succes = True
                msg = f"✓ Parfait ! {self.donne} - {self.article_courant['prix']} = {self.rendu_attendu} Sesterces !"
            else:
                msg = f"Erreur de calcul ! Rendu exact : {self.rendu_attendu} Sesterces."
        else:  # eclair
            attendu = arabe_en_romain(self.nombre_eclair)
            if self.proposition_romaine == attendu:
                succes = True
                msg = f"✓ Éclair ! {self.nombre_eclair} = {attendu} !"
            else:
                msg = f"Erreur ! {self.nombre_eclair} s'écrit {attendu}."

        if succes:
            self.lbl_feedback.configure(text=msg, fg="#2ecc71")
            self.score_session += 10
            # Récompense sesterces
            self.app.ajouter_sesterces(5)
            try:
                from app.succes import incrementer_stat_succes
                incrementer_stat_succes(self.app, "marche_transactions")
            except Exception:
                pass
            if self.score_session in (50, 100):
                audio.play_fanfare()
            else:
                audio.play_coin()
            self.lbl_score.configure(
                text=f"Score : {self.score_session} pts | 🪙 {self.app.data.get('sesterces', 0)} Sesterces"
            )
            self.after(1600, self._nouveau_defi)
        else:
            self.lbl_feedback.configure(text=msg, fg="#e74c3c")
            audio.play_wrong()
