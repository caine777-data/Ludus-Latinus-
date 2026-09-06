"""
Module du Mini-Jeu « Le Marché de Trajan » (Chiffres Romains et Calcul de Sesterces).
Permet aux élèves de maîtriser les chiffres romains (I, V, X, L, C, D, M)
et le calcul mental à travers des transactions au cœur du Forum romain.
"""

import random
import tkinter as tk

from app import audio
from app.polices import police_corps, police_titre

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
        self.C = app.C

        self.title("🏺 Le Marché de Trajan — Chiffres Romains & Sesterces")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 860, 650, min_w=680, min_h=480)
        self.configure(bg=self.C["bg"])

        self.score_session = 0
        self.article_courant = None
        self.mode = "composer"  # "composer", "rendu", "eclair"
        self.proposition_romaine = ""

        self._build_ui()
        self._nouveau_defi()

    def _build_ui(self):
        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=14, pady=10)
        hdr.pack(fill=tk.X)

        left_hdr = tk.Frame(hdr, bg=self.C["panel"])
        left_hdr.pack(side=tk.LEFT)

        tk.Label(left_hdr, text="🏺 LE MARCHÉ DE TRAJAN", font=police_titre(16),
                 bg=self.C["panel"], fg="#ffd700").pack(anchor=tk.W)
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
            font=police_corps(10, gras=True), bg="#1f2335", fg="#d4af37", padx=8, pady=4, relief="ridge"
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
        self.etal_frame = tk.Frame(self, bg="#24283b", bd=2, relief="ridge", padx=20, pady=16)
        self.etal_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=16)

        self.lbl_marchand = tk.Label(
            self.etal_frame,
            text="🧔 Gaius Mercator : « Salve, jeune citoyen ! Que désires-tu aujourd'hui ? »",
            font=police_corps(11, gras=True), bg="#24283b", fg="#ffd700"
        )
        self.lbl_marchand.pack(pady=(0, 10))

        # Carte de l'article en vente
        self.article_box = tk.Frame(self.etal_frame, bg="#1a1b26", bd=2, relief="groove", padx=16, pady=12)
        self.article_box.pack(fill=tk.X, padx=40, pady=10)

        self.lbl_art_emoji = tk.Label(self.article_box, text="🏺", font=("Segoe UI Emoji", 36), bg="#1a1b26")
        self.lbl_art_emoji.pack(side=tk.LEFT, padx=(0, 16))

        info_art = tk.Frame(self.article_box, bg="#1a1b26")
        info_art.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.lbl_art_nom = tk.Label(info_art, text="Article", font=police_titre(13), bg="#1a1b26", fg="#ffffff")
        self.lbl_art_nom.pack(anchor=tk.W)
        self.lbl_art_latin = tk.Label(info_art, text="Nom latin", font=police_corps(10, italique=True), bg="#1a1b26", fg="#2ecc71")
        self.lbl_art_latin.pack(anchor=tk.W)
        self.lbl_art_consigne = tk.Label(info_art, text="Consigne", font=police_corps(10), bg="#1a1b26", fg="#dcd6cd")
        self.lbl_art_consigne.pack(anchor=tk.W, pady=(4, 0))

        # Zone de réponse
        self.reponse_frame = tk.Frame(self.etal_frame, bg="#24283b")
        self.reponse_frame.pack(fill=tk.X, pady=10)

        # Affichage saisie chiffres romains
        self.zone_saisie = tk.Label(
            self.reponse_frame, text="", font=("Palatino Linotype", 22, "bold"),
            bg="#181a24", fg="#ffd700", width=16, bd=2, relief="sunken"
        )
        self.zone_saisie.pack(pady=6)

        # Boutons tuiles romaines (I, V, X, L, C, D, M)
        self.tuiles_frame = tk.Frame(self.reponse_frame, bg="#24283b")
        self.tuiles_frame.pack(pady=6)

        self.btn_tuiles = []
        for lettre in ["I", "V", "X", "L", "C", "D", "M"]:
            b = tk.Button(
                self.tuiles_frame, text=lettre, font=("Palatino Linotype", 14, "bold"),
                bg="#d4af37", fg="#1a1b26", width=3, cursor="hand2",
                command=lambda let=lettre: self._ajouter_lettre(let)
            )
            b.pack(side=tk.LEFT, padx=4)
            self.btn_tuiles.append(b)

        btn_effacer = tk.Button(
            self.tuiles_frame, text="⌫ Effacer", font=police_corps(10),
            bg="#e74c3c", fg="#ffffff", padx=8, command=self._effacer_lettre
        )
        btn_effacer.pack(side=tk.LEFT, padx=8)

        # Entrée numérique pour le mode rendu
        self.entree_num = tk.Entry(self.reponse_frame, font=("Georgia", 14), width=10, justify="center")

        # Bouton Valider
        self.btn_valider = tk.Button(
            self.etal_frame, text="✓ Valider la Transaction", font=police_titre(12),
            bg="#27ae60", fg="#ffffff", padx=20, pady=6, cursor="hand2",
            command=self._verifier_reponse
        )
        self.btn_valider.pack(pady=10)

        self.lbl_feedback = tk.Label(self.etal_frame, text="", font=police_corps(11, gras=True), bg="#24283b")
        self.lbl_feedback.pack()

    def _changer_mode(self, mode):
        self.mode = mode
        self.btn_mode_composer.configure(bg=self.C["accent"] if mode == "composer" else self.C["editor"],
                                        fg=self.C["sel_fg"] if mode == "composer" else self.C["fg"])
        self.btn_mode_rendu.configure(bg=self.C["accent"] if mode == "rendu" else self.C["editor"],
                                     fg=self.C["sel_fg"] if mode == "rendu" else self.C["fg"])
        self.btn_mode_eclair.configure(bg=self.C["accent"] if mode == "eclair" else self.C["editor"],
                                      fg=self.C["sel_fg"] if mode == "eclair" else self.C["fg"])
        self._nouveau_defi()

    def _ajouter_lettre(self, lettre):
        self.proposition_romaine += lettre
        self.zone_saisie.configure(text=self.proposition_romaine)

    def _effacer_lettre(self):
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
            audio.play_coin()
            self.lbl_score.configure(
                text=f"Score : {self.score_session} pts | 🪙 {self.app.data.get('sesterces', 0)} Sesterces"
            )
            self.after(1600, self._nouveau_defi)
        else:
            self.lbl_feedback.configure(text=msg, fg="#e74c3c")
            audio.play_wrong()
