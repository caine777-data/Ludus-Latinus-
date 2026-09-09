"""
Module Memoria Velox — Le Dojo de Révision Éclair (Flashcards 3D & Répétition Espacée).

Permet aux élèves de mémoriser durablement le vocabulaire latin du Collège
grâce à des cartes 3D en marbre interactives à retournement animé (Flip Card),
la prononciation vocale en latin restitué et l'algorithme de répétition espacée (SRS).
"""

import math
import random
import tkinter as tk
from tkinter import ttk

from app import audio
from app import progress as prog

# Corpus de vocabulaire latin du Collège (5e, 4e, 3e)
VOCABULAIRE_SRS = [
    # 🏛️ Dieux & Mythes
    {
        "id": "v_iuppiter", "latin": "Iuppiter", "genre": "nom masc. (3e décl.)",
        "francais": "Jupiter", "etymologie": "Le roi des dieux, maître de la foudre et de l'Olympe.",
        "exemple": "Iuppiter fulmen tenet.", "exemple_fr": "Jupiter tient la foudre.",
        "categorie": "Dieux & Mythes"
    },
    {
        "id": "v_minerva", "latin": "Minerva", "genre": "nom fém. (1re décl.)",
        "francais": "Minerve", "etymologie": "Déesse de la sagesse, de la stratégie et des artisans.",
        "exemple": "Minerva sapientiam dat.", "exemple_fr": "Minerve donne la sagesse.",
        "categorie": "Dieux & Mythes"
    },
    {
        "id": "v_mars", "latin": "Mars", "genre": "nom masc. (3e décl.)",
        "francais": "Mars", "etymologie": "Donne martial, mardi. Dieu de la guerre et père de Romulus.",
        "exemple": "Mars legiones ducit.", "exemple_fr": "Mars conduit les légions.",
        "categorie": "Dieux & Mythes"
    },
    {
        "id": "v_mercurius", "latin": "Mercurius", "genre": "nom masc. (2e décl.)",
        "francais": "Mercure", "etymologie": "Donne mercredi, mercuriale. Messager des dieux aux ailes d'or.",
        "exemple": "Mercurius celer est.", "exemple_fr": "Mercure est rapide.",
        "categorie": "Dieux & Mythes"
    },
    {
        "id": "v_monstrum", "latin": "Monstrum", "genre": "nom neutre (2e décl.)",
        "francais": "Le prodige / Le monstre", "etymologie": "Donne monstre, monstrueux. Signe envoyé par les dieux.",
        "exemple": "Hercules monstrum vicit.", "exemple_fr": "Hercule a vaincu le monstre.",
        "categorie": "Dieux & Mythes"
    },

    # 🏡 Maison & Famille
    {
        "id": "v_domus", "latin": "Domus", "genre": "nom fém. (4e décl.)",
        "francais": "La maison", "etymologie": "Donne domicile, domestique, domaine.",
        "exemple": "Domus ampla est.", "exemple_fr": "La maison est vaste.",
        "categorie": "Maison & Famille"
    },
    {
        "id": "v_pater", "latin": "Pater", "genre": "nom masc. (3e décl.)",
        "francais": "Le père", "etymologie": "Donne paternel, patrimoine, patrie.",
        "exemple": "Pater familias domum regit.", "exemple_fr": "Le père de famille dirige la maison.",
        "categorie": "Maison & Famille"
    },
    {
        "id": "v_mater", "latin": "Mater", "genre": "nom fém. (3e décl.)",
        "francais": "La mère", "etymologie": "Donne maternel, maternité, matrice.",
        "exemple": "Mater liberos amat.", "exemple_fr": "La mère aime ses enfants.",
        "categorie": "Maison & Famille"
    },
    {
        "id": "v_filius", "latin": "Filius", "genre": "nom masc. (2e décl.)",
        "francais": "Le fils", "etymologie": "Donne filial, affiliation.",
        "exemple": "Filius in atrio legit.", "exemple_fr": "Le fils lit dans l'atrium.",
        "categorie": "Maison & Famille"
    },
    {
        "id": "v_servus", "latin": "Servus", "genre": "nom masc. (2e décl.)",
        "francais": "L'esclave / Le serviteur", "etymologie": "Donne serviteur, servitude, service.",
        "exemple": "Servus cenam parat.", "exemple_fr": "L'esclave prépare le repas.",
        "categorie": "Maison & Famille"
    },
    {
        "id": "v_atrium", "latin": "Atrium", "genre": "nom neutre (2e décl.)",
        "francais": "L'atrium (salle centrale)", "etymologie": "Grande pièce avec ouverture zénithale (compluvium).",
        "exemple": "Hospites in atrio sunt.", "exemple_fr": "Les invités sont dans l'atrium.",
        "categorie": "Maison & Famille"
    },

    # ⚔️ Armée & Légions
    {
        "id": "v_miles", "latin": "Miles", "genre": "nom masc. (3e décl.)",
        "francais": "Le soldat / Le légionnaire", "etymologie": "Donne militaire, milice, militant.",
        "exemple": "Miles scutum tenet.", "exemple_fr": "Le soldat tient son bouclier.",
        "categorie": "Armée & Légions"
    },
    {
        "id": "v_gladius", "latin": "Gladius", "genre": "nom masc. (2e décl.)",
        "francais": "Le glaive / L'épée", "etymologie": "Donne gladiateur, glaive, glaïeul.",
        "exemple": "Gladius acutus est.", "exemple_fr": "Le glaive est acéré.",
        "categorie": "Armée & Légions"
    },
    {
        "id": "v_scutum", "latin": "Scutum", "genre": "nom neutre (2e décl.)",
        "francais": "Le grand bouclier", "etymologie": "Donne écu, écuyer, écusson.",
        "exemple": "Scutum legionis rubrum est.", "exemple_fr": "Le bouclier de la légion est rouge.",
        "categorie": "Armée & Légions"
    },
    {
        "id": "v_castra", "latin": "Castra", "genre": "nom neutre pluriel (2e décl.)",
        "francais": "Le camp militaire", "etymologie": "Donne castel, château, Chester.",
        "exemple": "Legio in castris manet.", "exemple_fr": "La légion reste dans le camp.",
        "categorie": "Armée & Légions"
    },
    {
        "id": "v_victoria", "latin": "Victoria", "genre": "nom fém. (1re décl.)",
        "francais": "La victoire", "etymologie": "Donne victoire, victorieux.",
        "exemple": "Victoria exercitui gloria est.", "exemple_fr": "La victoire est une gloire pour l'armée.",
        "categorie": "Armée & Légions"
    },

    # 🐾 Animaux & Nature
    {
        "id": "v_lupus", "latin": "Lupus", "genre": "nom masc. (2e décl.)",
        "francais": "Le loup", "etymologie": "Donne louve, louveteau, Lupulus !",
        "exemple": "Lupus in silva ululat.", "exemple_fr": "Le loup hurle dans la forêt.",
        "categorie": "Animaux & Nature"
    },
    {
        "id": "v_canis", "latin": "Canis", "genre": "nom masc./fém. (3e décl.)",
        "francais": "Le chien", "etymologie": "Donne canin, canicule, canidé.",
        "exemple": "Cave canem !", "exemple_fr": "Attention au chien !",
        "categorie": "Animaux & Nature"
    },
    {
        "id": "v_equus", "latin": "Equus", "genre": "nom masc. (2e décl.)",
        "francais": "Le cheval", "etymologie": "Donne équestre, équitation, équidé.",
        "exemple": "Equus per campum currit.", "exemple_fr": "Le cheval court à travers la plaine.",
        "categorie": "Animaux & Nature"
    },
    {
        "id": "v_aquila", "latin": "Aquila", "genre": "nom fém. (1re décl.)",
        "francais": "L'aigle (emblème de Rome)", "etymologie": "Donne aquilin. L'aigle d'or des légions.",
        "exemple": "Aquila super montes volat.", "exemple_fr": "L'aigle vole au-dessus des montagnes.",
        "categorie": "Animaux & Nature"
    },
    {
        "id": "v_mare", "latin": "Mare", "genre": "nom neutre (3e décl.)",
        "francais": "La mer", "etymologie": "Donne marin, maritime, marée.",
        "exemple": "Mare Nostrum navigamus.", "exemple_fr": "Nous naviguons sur Notre Mer (Méditerranée).",
        "categorie": "Animaux & Nature"
    },

    # 📜 Verbes Majeurs
    {
        "id": "v_amare", "latin": "Amare", "genre": "verbe (1re conjugaison)",
        "francais": "Aimer", "etymologie": "Donne amitié, amateur, amant.",
        "exemple": "Marcus litteras amat.", "exemple_fr": "Marcus aime les lettres.",
        "categorie": "Verbes Majeurs"
    },
    {
        "id": "v_videre", "latin": "Videre", "genre": "verbe (2e conjugaison)",
        "francais": "Voir", "etymologie": "Donne vision, visible, évident.",
        "exemple": "Veni, vidi, vici.", "exemple_fr": "Je suis venu, j'ai vu, j'ai vaincu.",
        "categorie": "Verbes Majeurs"
    },
    {
        "id": "v_legere", "latin": "Legere", "genre": "verbe (3e conjugaison)",
        "francais": "Lire / Choisir", "etymologie": "Donne lecture, lisible, leçon.",
        "exemple": "Discipulus librum legit.", "exemple_fr": "L'élève lit un livre.",
        "categorie": "Verbes Majeurs"
    },
    {
        "id": "v_vincere", "latin": "Vincere", "genre": "verbe (3e conjugaison)",
        "francais": "Vaincre", "etymologie": "Donne invincible, vainqueur, victoire.",
        "exemple": "Fortuna fortes adiuvat.", "exemple_fr": "La fortune aide les courageux.",
        "categorie": "Verbes Majeurs"
    },
    {
        "id": "v_esse", "latin": "Esse", "genre": "verbe irrégulier",
        "francais": "Être", "etymologie": "Donne essence, essentiel. Sum, es, est, sumus, estis, sunt.",
        "exemple": "Roma caput mundi est.", "exemple_fr": "Rome est la capitale du monde.",
        "categorie": "Verbes Majeurs"
    },

    # 🌟 Valeurs & Citoyenneté
    {
        "id": "v_virtus", "latin": "Virtus", "genre": "nom fém. (3e décl.)",
        "francais": "Le courage / La vertu", "etymologie": "Donne vertu, vertueux. La bravoure civique romaine.",
        "exemple": "Virtus praemium habet.", "exemple_fr": "Le courage a sa récompense.",
        "categorie": "Valeurs & Citoyenneté"
    },
    {
        "id": "v_civis", "latin": "Civis", "genre": "nom masc./fém. (3e décl.)",
        "francais": "Le citoyen", "etymologie": "Donne civisme, civique, civil.",
        "exemple": "Civis Romanus sum.", "exemple_fr": "Je suis citoyen romain.",
        "categorie": "Valeurs & Citoyenneté"
    },
    {
        "id": "v_pax", "latin": "Pax", "genre": "nom fém. (3e décl.)",
        "francais": "La paix", "etymologie": "Donne pacifique, apaiser. La Pax Romana.",
        "exemple": "Pax in terra regnat.", "exemple_fr": "La paix règne sur terre.",
        "categorie": "Valeurs & Citoyenneté"
    }
]


class MemoriaVeloxDialog(tk.Toplevel):
    """Dojo de Révision Éclair — Flashcards 3D en marbre avec SRS Leitner."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🃏 Memoria Velox — Le Dojo de Révision Éclair")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        w, h = 760, 620
        sw = self.winfo_screenwidth()
        sh = self.winfo_screenheight()
        self.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")

        self.transient(master)
        self.grab_set()

        # Session variables
        self.deck = list(VOCABULAIRE_SRS)
        random.shuffle(self.deck)
        self.current_index = 0
        self.face_actuelle = "recto"  # "recto" ou "verso"
        self.anim_step = 0
        self.en_animation = False
        self.scale_x = 1.0
        self.cartes_reussies = 0
        self.sesterces_gagnes = 0

        # Liseré d'or
        tk.Frame(self, bg=self.C["accent"], height=6).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=20, pady=10)
        hdr.pack(fill=tk.X)

        top_row = tk.Frame(hdr, bg=self.C["panel"])
        top_row.pack(fill=tk.X)

        tk.Label(
            top_row,
            text="🃏 Memoria Velox — Dojo de Révision Éclair",
            font=(app.title_font.cget("family"), 16, "bold"),
            bg=self.C["panel"],
            fg=self.C["accent"]
        ).pack(side=tk.LEFT)

        self.lbl_score = tk.Label(
            top_row,
            text=f"🪙 +0 HS  ·  Série: {self.app.data.get('sesterces', 0)} HS",
            font=(app.body.cget("family"), 11, "bold"),
            bg=self.C["panel"],
            fg="#d4af37"
        )
        self.lbl_score.pack(side=tk.RIGHT)

        # Barre de progression
        prog_row = tk.Frame(self, bg=self.C["panel"], padx=24)
        prog_row.pack(fill=tk.X, pady=(2, 6))

        self.lbl_prog = tk.Label(
            prog_row,
            text="Carte 1 / 10",
            font=(app.body.cget("family"), 10, "bold"),
            bg=self.C["panel"],
            fg=self.C["muted"]
        )
        self.lbl_prog.pack(side=tk.LEFT)

        self.pbar = ttk.Progressbar(prog_row, length=450, mode="determinate", maximum=10)
        self.pbar.pack(side=tk.RIGHT, fill=tk.X, expand=True, padx=(14, 0))

        # Canvas central pour la Flashcard en Marbre 3D
        self.canvas_w = 700
        self.canvas_h = 360
        self.cv = tk.Canvas(
            self,
            width=self.canvas_w,
            height=self.canvas_h,
            bg=self.C["panel"],
            highlightthickness=0,
            cursor="hand2"
        )
        self.cv.pack(pady=8)
        self.cv.bind("<Button-1>", lambda e: self._retourner_carte())

        # Barre d'évaluation SRS Leitner
        self.eval_frame = tk.Frame(self, bg=self.C["panel"], padx=20, pady=8)
        self.eval_frame.pack(fill=tk.X)

        self.btn_hard = tk.Button(
            self.eval_frame,
            text="🔴 À Revoir\n(Demain)",
            font=(app.body.cget("family"), 10, "bold"),
            bg="#5a1818", fg="#ffcccc",
            activebackground="#7a2424",
            padx=18, pady=6, relief="flat", cursor="hand2",
            command=lambda: self._noter_carte(1)
        )
        self.btn_hard.pack(side=tk.LEFT, expand=True, fill=tk.X, padx=8)

        self.btn_med = tk.Button(
            self.eval_frame,
            text="🟡 Hésitant (+5 HS)\n(Dans 3 jours)",
            font=(app.body.cget("family"), 10, "bold"),
            bg="#6a4e10", fg="#fff0aa",
            activebackground="#886414",
            padx=18, pady=6, relief="flat", cursor="hand2",
            command=lambda: self._noter_carte(2)
        )
        self.btn_med.pack(side=tk.LEFT, expand=True, fill=tk.X, padx=8)

        self.btn_easy = tk.Button(
            self.eval_frame,
            text="🟢 Maîtrisé ! (+10 HS)\n(Dans 7 jours)",
            font=(app.body.cget("family"), 10, "bold"),
            bg="#1b5229", fg="#ccffdd",
            activebackground="#266e38",
            padx=18, pady=6, relief="flat", cursor="hand2",
            command=lambda: self._noter_carte(3)
        )
        self.btn_easy.pack(side=tk.LEFT, expand=True, fill=tk.X, padx=8)

        # Pied de page
        bottom_bar = tk.Frame(self, bg=self.C["panel"], padx=20, pady=8)
        bottom_bar.pack(fill=tk.X, side=tk.BOTTOM)

        tk.Label(
            bottom_bar,
            text="💡 Astuce : Clique sur la carte pour la retourner et révéler la traduction et son étymologie !",
            font=(app.body.cget("family"), 9, "italic"),
            bg=self.C["panel"],
            fg=self.C["muted"]
        ).pack(side=tk.LEFT)

        ttk.Button(bottom_bar, text="Quitter", command=self.destroy).pack(side=tk.RIGHT)

        self._dessiner_carte()
        self.lift()
        self.focus_force()

    # -----------------------------------------------------------------------
    # DESSIN DE LA FLASHCARD 3D
    # -----------------------------------------------------------------------
    def _dessiner_carte(self):
        self.cv.delete("all")
        if self.current_index >= min(10, len(self.deck)):
            self._afficher_victoire_session()
            return

        carte = self.deck[self.current_index]
        self.lbl_prog.configure(text=f"Carte {self.current_index + 1} / 10")
        self.pbar["value"] = self.current_index + 1

        cx = self.canvas_w // 2
        cy = self.canvas_h // 2
        card_w = int(520 * abs(self.scale_x))
        card_h = 320

        x1 = cx - card_w // 2
        y1 = cy - card_h // 2
        x2 = cx + card_w // 2
        y2 = cy + card_h // 2

        if card_w < 10:
            return  # Milieu de retournement

        # Ombre portée douce 3D
        self.cv.create_rectangle(x1 + 6, y1 + 8, x2 + 6, y2 + 8, fill="#0a0805", outline="")

        if self.face_actuelle == "recto":
            # RECTO : Marbre blanc travertin impérial
            bg_card = "#f8f5ee" if not self.C.get("is_dark", False) else "#2d261e"
            border_gold = "#d4af37"

            self.cv.create_rectangle(x1, y1, x2, y2, fill=bg_card, outline=border_gold, width=4)
            # Liseré intérieur ciselé
            self.cv.create_rectangle(x1 + 8, y1 + 8, x2 - 8, y2 - 8, fill="", outline="#c5a059", width=1)

            # Badge Thème antique
            cat_text = f"🏛️ {carte['categorie']}"
            self.cv.create_rectangle(cx - 100, y1 + 18, cx + 100, y1 + 44, fill="#ecdcb9", outline=border_gold)
            self.cv.create_text(cx, y1 + 31, text=cat_text, font=(self.app.body.cget("family"), 9, "bold"), fill="#5a3810")

            # Mot Latin Majuscule Triomphale
            latin_txt = carte["latin"]
            self.cv.create_text(
                cx, cy - 25,
                text=latin_txt,
                font=(self.app.title_font.cget("family"), 30, "bold"),
                fill="#8b2500" if not self.C.get("is_dark", False) else "#e69b50"
            )

            # Nature grammaticale
            self.cv.create_text(
                cx, cy + 25,
                text=carte["genre"],
                font=(self.app.body.cget("family"), 11, "italic"),
                fill="#777777" if not self.C.get("is_dark", False) else "#b0a090"
            )

            # Bouton Prononciation Audio
            self.cv.create_rectangle(cx - 85, y2 - 62, cx + 85, y2 - 28, fill="#2e6f40", outline="#ffffff", width=1)
            self.cv.create_text(
                cx, y2 - 45,
                text="🔊 Prononcer en Latin",
                font=(self.app.body.cget("family"), 10, "bold"),
                fill="#ffffff"
            )

            # Indication de clic
            self.cv.create_text(
                cx, y2 - 14,
                text="👆 Clique pour retourner",
                font=(self.app.body.cget("family"), 8),
                fill="#999999"
            )
        else:
            # VERSO : Marbre pourpre impérial / Parchemin doré
            bg_card = "#fff8e7" if not self.C.get("is_dark", False) else "#351e1e"
            border_gold = "#e5c158"

            self.cv.create_rectangle(x1, y1, x2, y2, fill=bg_card, outline=border_gold, width=4)
            self.cv.create_rectangle(x1 + 8, y1 + 8, x2 - 8, y2 - 8, fill="", outline="#8b2500", width=1)

            # Traduction Française
            self.cv.create_text(
                cx, y1 + 45,
                text=carte["francais"],
                font=(self.app.title_font.cget("family"), 22, "bold"),
                fill="#2e6f40" if not self.C.get("is_dark", False) else "#55cc77"
            )

            # Ligne de séparation dorée
            self.cv.create_line(cx - 150, y1 + 75, cx + 150, y1 + 75, fill=border_gold, width=2)

            # Étymologie & Dérivés en Français
            self.cv.create_text(
                cx, y1 + 115,
                text=carte["etymologie"],
                font=(self.app.body.cget("family"), 10),
                fill="#333333" if not self.C.get("is_dark", False) else "#e0d0c0",
                width=420,
                justify=tk.CENTER
            )

            # Boîte Exemple latin en contexte
            self.cv.create_rectangle(cx - 210, y1 + 160, cx + 210, y2 - 45, fill="#f2e4c8" if not self.C.get("is_dark", False) else "#4a2c20", outline="#c5a059")
            self.cv.create_text(
                cx, y1 + 195,
                text=f"« {carte['exemple']} »",
                font=(self.app.body.cget("family"), 12, "bold italic"),
                fill="#8b2500" if not self.C.get("is_dark", False) else "#ffaa66"
            )
            self.cv.create_text(
                cx, y1 + 228,
                text=f"= {carte['exemple_fr']}",
                font=(self.app.body.cget("family"), 10),
                fill="#444444" if not self.C.get("is_dark", False) else "#ddccbb"
            )

            # Indication
            self.cv.create_text(
                cx, y2 - 20,
                text="Évalue ta mémorisation ci-dessous :",
                font=(self.app.body.cget("family"), 9, "italic"),
                fill="#888888"
            )

    # -----------------------------------------------------------------------
    # ANIMATION DU RETOURNEMENT DE CARTE (FLIP)
    # -----------------------------------------------------------------------
    def _retourner_carte(self):
        if self.en_animation or self.current_index >= min(10, len(self.deck)):
            return

        # Vérifier si clic sur le bouton audio
        carte = self.deck[self.current_index]
        audio.play_card_flip()
        audio.speak_latin(carte["latin"])

        self.en_animation = True
        self._animer_flip_step(10)

    def _animer_flip_step(self, step):
        # Réduction de 1.0 à 0.0 puis expansion de 0.0 à 1.0
        if step > 0:
            self.scale_x = math.cos(math.radians((10 - step) * 9))
            self._dessiner_carte()
            self.after(16, lambda: self._animer_flip_step(step - 1))
        else:
            # Point médian : on change la face
            self.face_actuelle = "verso" if self.face_actuelle == "recto" else "recto"
            self._animer_expand_step(10)

    def _animer_expand_step(self, step):
        if step >= 0:
            self.scale_x = math.sin(math.radians((10 - step) * 9))
            self._dessiner_carte()
            self.after(16, lambda: self._animer_expand_step(step - 1))
        else:
            self.scale_x = 1.0
            self.en_animation = False
            self._dessiner_carte()

    # -----------------------------------------------------------------------
    # NOTATION SRS LEITNER
    # -----------------------------------------------------------------------
    def _noter_carte(self, note: int):
        if self.current_index >= min(10, len(self.deck)):
            return

        carte = self.deck[self.current_index]
        prog.enregistrer_revision_srs(self.app.data, carte["id"], note)

        if note == 3:
            # Facile / Maîtrisé
            gain = 10
            self.cartes_reussies += 1
            audio.play_coin()
        elif note == 2:
            # Moyen
            gain = 5
            self.cartes_reussies += 1
            audio.play_coin()
        else:
            # À revoir
            gain = 0
            audio.play_wrong()
            # On réinjecte la carte à la fin pour révision immédiate
            self.deck.append(carte)

        if gain > 0:
            # Bonus forum saturne
            bonus = int(gain * prog.bonus_forum_sesterces(self.app.data))
            tot_gain = gain + bonus
            self.sesterces_gagnes += tot_gain
            self.app.data["sesterces"] = self.app.data.get("sesterces", 0) + tot_gain
            prog.save_progress(self.app.data)

        self.lbl_score.configure(text=f"🪙 +{self.sesterces_gagnes} HS  ·  Solde: {self.app.data.get('sesterces', 0)} HS")

        self.current_index += 1
        self.face_actuelle = "recto"
        self._dessiner_carte()

    # -----------------------------------------------------------------------
    # ÉCRAN DE FIN DE SESSION CHRONO
    # -----------------------------------------------------------------------
    def _afficher_victoire_session(self):
        self.cv.delete("all")
        self.eval_frame.pack_forget()

        cx = self.canvas_w // 2
        cy = self.canvas_h // 2

        audio.play_victory()

        # Cadre or de triomphe
        self.cv.create_rectangle(60, 40, self.canvas_w - 60, self.canvas_h - 40, fill="#fcf9f2", outline="#d4af37", width=4)
        self.cv.create_rectangle(70, 50, self.canvas_w - 70, self.canvas_h - 50, fill="", outline="#8b2500", width=1)

        self.cv.create_text(
            cx, cy - 80,
            text="👑 Triomphe de la Mémoire ! 👑",
            font=(self.app.title_font.cget("family"), 22, "bold"),
            fill="#8b2500"
        )

        self.cv.create_text(
            cx, cy - 25,
            text=f"Tu as révisé avec succès 10 cartes de vocabulaire latin !\n"
                 f"Mots mémorisés : {self.cartes_reussies} / 10\n"
                 f"Butin amassé : +{self.sesterces_gagnes} Sesterces 🪙",
            font=(self.app.body.cget("family"), 12),
            justify=tk.CENTER,
            fill="#333333"
        )

        self.cv.create_text(
            cx, cy + 50,
            text="« Repetitio est mater studiorum »\n(La répétition est la mère des études)",
            font=(self.app.body.cget("family"), 11, "italic bold"),
            fill="#2e6f40",
            justify=tk.CENTER
        )

        self.lbl_prog.configure(text="Session terminée !")
        self.pbar["value"] = 10
