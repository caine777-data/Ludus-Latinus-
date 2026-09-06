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
    "standard": {"nom": "Toge Classique", "prix": 0, "desc": "La noble toge blanche ornée d'une écharpe rouge."},
    "mercure": {"nom": "Ailes de Mercure", "prix": 150, "desc": "Les sandales et le casque ailés du messager divin."},
    "imperator": {"nom": "Couronne Impériale", "prix": 250, "desc": "La couronne de laurier d'or massif des Césars."},
    "savant": {"nom": "Lunettes de Philosophe", "prix": 100, "desc": "Pour lire les parchemins anciens sans fatiguer."},
}


class MascotteWidget(tk.Frame):
    """Widget affichant Lupulus avec sa bulle de dialogue dynamique."""

    def __init__(self, master, app=None, taille=100, **kw):
        super().__init__(master, **kw)
        self.app = app
        self.taille = taille
        self.emotion_actuelle = "normal"
        self._images_cache = {}
        self._reset_timer = None

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

        self.set_emotion("normal")

    def _charger_image(self, emotion):
        if emotion in self._images_cache:
            return self._images_cache[emotion]

        fichier = ASSETS_LUPULUS / f"lupulus_{emotion}.png"
        if not fichier.exists():
            fichier = ASSETS_LUPULUS / "lupulus_normal.png"

        if fichier.exists():
            try:
                if HAS_PIL:
                    im = Image.open(fichier).convert("RGBA")
                    if im.size != (self.taille, self.taille):
                        im = im.resize((self.taille, self.taille), Image.Resampling.LANCZOS)
                    photo = ImageTk.PhotoImage(im)
                else:
                    photo = tk.PhotoImage(file=str(fichier))
                self._images_cache[emotion] = photo
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
