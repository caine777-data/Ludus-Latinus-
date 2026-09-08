"""
Module du Mode Duel à 2 Joueurs sur le même clavier (« Colosseum Duellum »).
Deux joueurs s'affrontent en direct au buzzer :
- Joueur 1 (Marcus / Gauche) : Touches A, Z, E
- Joueur 2 (Julia / Droite) : Touches 1, 2, 3 (ou J, K, L)
Le plus rapide à donner la bonne réponse repousse son adversaire dans l'arène !
"""

import random
import tkinter as tk
from tkinter import messagebox

from app import audio
from app.polices import police_corps, police_titre

QUESTIONS_DUEL = [
    # --- 5ème : Vocabulaire fondamental & 1re/2e déclinaisons ---
    {"q": "Que signifie « Lupus » ?", "choix": ["Loup", "Lièvre", "Lune"], "rep": 0},
    {"q": "Que signifie « Canis » ?", "choix": ["Chien", "Chat", "Cheval"], "rep": 0},
    {"q": "Quel est le cas du sujet en latin ?", "choix": ["Le Nominatif", "L'Accusatif", "L'Ablatif"], "rep": 0},
    {"q": "Que signifie « Domus » ?", "choix": ["Maison", "Temple", "Jardin"], "rep": 0},
    {"q": "Que signifie « Bellum » ?", "choix": ["Guerre", "Beauté", "Bœuf"], "rep": 0},
    {"q": "Qui est le dieu de la guerre ?", "choix": ["Mars", "Jupiter", "Neptune"], "rep": 0},
    {"q": "Que signifie « Equus » ?", "choix": ["Cheval", "Aigle", "Poisson"], "rep": 0},
    {"q": "Que signifie « Mater » ?", "choix": ["Mère", "Père", "Frère"], "rep": 0},
    {"q": "Que signifie « Aqua » ?", "choix": ["Eau", "Feu", "Terre"], "rep": 0},
    {"q": "Que signifie « Ignis » ?", "choix": ["Feu", "Glace", "Vent"], "rep": 0},
    {"q": "Quel cas exprime le COD ?", "choix": ["L'Accusatif", "Le Génitif", "Le Datif"], "rep": 0},
    {"q": "Que signifie « Servus » ?", "choix": ["Esclave", "Maître", "Général"], "rep": 0},
    {"q": "Que signifie « Puella » ?", "choix": ["Jeune fille", "Garçon", "Reine"], "rep": 0},
    {"q": "Que signifie « Gladius » ?", "choix": ["Glaive", "Bouclier", "Casque"], "rep": 0},
    {"q": "Que signifie « Auriga » ?", "choix": ["Conducteur de char", "Gladiateur", "Sénateur"], "rep": 0},

    # --- 4ème : 3e déclinaison, temps du passé & République ---
    {"q": "Que signifie « Rex » (3e déclinaison) ?", "choix": ["Roi", "Loi", "Reine"], "rep": 0},
    {"q": "Que signifie « Civis » (3e déclinaison) ?", "choix": ["Citoyen", "Cité", "Soldat"], "rep": 0},
    {"q": "Que signifie « Mare » ?", "choix": ["Mer", "Soleil", "Ciel"], "rep": 0},
    {"q": "Que signifie « Fortis » (adjectif 2e classe) ?", "choix": ["Courageux / Fort", "Lâche", "Rapide"], "rep": 0},
    {"q": "Quel suffixe caractérise l'imparfait latin ?", "choix": ["-ba-", "-vi-", "-re-"], "rep": 0},
    {"q": "Quelle est la désinence du parfait à la 1re personne du singulier ?", "choix": ["-i", "-o", "-m"], "rep": 0},
    {"q": "Que signifie « Veni, vidi, vici » de César ?", "choix": ["Je suis venu, j'ai vu, j'ai vaincu", "Vivre, aimer, mourir", "Parler, écouter, comprendre"], "rep": 0},
    {"q": "Que signifie l'abréviation « SPQR » ?", "choix": ["Le Sénat et le Peuple Romain", "Rome Pour Toujours", "Paix et Victoire Romaine"], "rep": 0},

    # --- 3ème : 4e/5e déclinaisons, grammaire avancée & Empire ---
    {"q": "Que signifie « Manus » (4e déclinaison) ?", "choix": ["La main / La troupe", "Le matin", "La mer"], "rep": 0},
    {"q": "Que signifie « Dies » (5e déclinaison) ?", "choix": ["Le jour", "Le dieu", "La nuit"], "rep": 0},
    {"q": "Quelle construction réunit un nom et un participe à l'ablatif sans lien grammatical ?", "choix": ["L'ablatif absolu", "La proposition infinitive", "Le complément du nom"], "rep": 0},
    {"q": "Dans une proposition infinitive, à quel cas se met le sujet du verbe infinitif ?", "choix": ["À l'Accusatif", "Au Nominatif", "Au Datif"], "rep": 0},
    {"q": "Qui est l'auteur illustre de l'Énéide ?", "choix": ["Virgile", "César", "Cicéron"], "rep": 0},
    {"q": "Qui a prononcé le célèbre « O tempora, o mores ! » ?", "choix": ["Cicéron", "Romulus", "Néron"], "rep": 0},
    {"q": "Quel célèbre historien et naturaliste a péri lors de l'éruption du Vésuve ?", "choix": ["Pline l'Ancien", "Tite-Live", "Sénèque"], "rep": 0},
]


class DuelWindow(tk.Toplevel):
    """Fenêtre de combat à 2 Joueurs en face-à-face sur le même clavier."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        from app.theme import THEMES, est_sombre
        self.C = getattr(app, "C", None) or THEMES["Nuit au Colisée"]

        self.title("⚔️ Colosseum Duellum — Duel à 2 Joueurs — Ludus Latinus")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 960, 680, min_w=780, min_h=520)

        bg_def = self.C.get("bg", "#15161e")
        self.configure(bg=bg_def)

        self.sombre = est_sombre(bg_def)
        self.c_bg_arene = bg_def
        self.c_panel = self.C.get("panel", self.C.get("card_bg", "#1a1b26"))
        self.c_heading = self.C.get("heading", "#ffd700")
        self.c_muted = self.C.get("muted", "#a9b1d6")
        self.c_editor = self.C.get("editor", "#24283b")
        self.c_q_bg = "#24283b" if self.sombre else "#ffffff"
        self.c_q_fg = "#ffffff" if self.sombre else self.c_heading

        # Camps J1 (Bleu) et J2 (Rouge)
        self.c_camp_j1_bg = "#1a233a" if self.sombre else "#edf5fd"
        self.c_btn_j1_bg = "#243050" if self.sombre else "#d0e4f7"
        self.c_btn_j1_fg = "#ffffff" if self.sombre else "#1a365d"

        self.c_camp_j2_bg = "#3a1a23" if self.sombre else "#fdedec"
        self.c_btn_j2_bg = "#502430" if self.sombre else "#fadbd8"
        self.c_btn_j2_fg = "#ffffff" if self.sombre else "#78281f"

        self.score_j1 = 0
        self.score_j2 = 0
        self.position_corde = 0  # de -5 (victoire J2) à +5 (victoire J1)
        self.max_points = 5

        self.bloque_j1 = False
        self.bloque_j2 = False
        self.question_en_cours = None
        self._timer_manche = None

        self.pool_questions = list(QUESTIONS_DUEL)
        random.shuffle(self.pool_questions)

        self._build_ui()
        self._nouvelle_manche()

        # Écoute des touches du clavier pour les deux joueurs
        self.bind("<KeyPress>", self._sur_touche)
        self.focus_set()

    def _build_ui(self):
        # En-tête
        hdr = tk.Frame(self, bg=self.c_panel, padx=16, pady=10)
        hdr.pack(fill=tk.X)

        tk.Label(hdr, text="⚔️ COLOSSEUM DUELLUM — DUEL SUR LE MÊME CLAVIER ⚔️",
                 font=police_titre(14), bg=self.c_panel, fg="#ffd700" if self.sombre else self.c_heading).pack()
        tk.Label(hdr, text="Le premier qui répond repousse son adversaire hors de l'arène !",
                 font=police_corps(10, italique=True), bg=self.c_panel, fg=self.c_muted).pack()

        # Jauge de tir à la corde gladiateur au centre
        jauge_box = tk.Frame(self, bg=self.c_bg_arene, pady=12)
        jauge_box.pack(fill=tk.X, padx=40)

        # Labels noms des combattants
        noms_frame = tk.Frame(jauge_box, bg=self.c_bg_arene)
        noms_frame.pack(fill=tk.X, pady=(0, 4))

        self.lbl_score_j1 = tk.Label(
            noms_frame, text="🟦 JOUEUR 1 : MARCUS (0)", font=police_titre(12),
            bg=self.c_bg_arene, fg="#2980b9" if not self.sombre else "#3498db"
        )
        self.lbl_score_j1.pack(side=tk.LEFT)

        self.lbl_score_j2 = tk.Label(
            noms_frame, text="(0) JULIA : JOUEUR 2 🟥", font=police_titre(12),
            bg=self.c_bg_arene, fg="#c0392b" if not self.sombre else "#e74c3c"
        )
        self.lbl_score_j2.pack(side=tk.RIGHT)

        # Canvas de la barre de combat
        self.canvas_jauge = tk.Canvas(jauge_box, height=36, bg=self.c_panel, highlightthickness=2, highlightbackground="#d4af37")
        self.canvas_jauge.pack(fill=tk.X)

        # Zone de la question centrale
        q_frame = tk.Frame(self, bg=self.c_q_bg, bd=2, relief="ridge", padx=20, pady=14)
        q_frame.pack(fill=tk.X, padx=40, pady=10)

        self.lbl_question = tk.Label(
            q_frame, text="Question...", font=police_titre(16),
            bg=self.c_q_bg, fg=self.c_q_fg, wraplength=700
        )
        self.lbl_question.pack()

        # Les deux camps (Joueur 1 à gauche, Joueur 2 à droite)
        camps_frame = tk.Frame(self, bg=self.c_bg_arene, padx=20)
        camps_frame.pack(fill=tk.BOTH, expand=True, pady=10)

        # Camp Joueur 1 (Touches A, Z, E)
        camp_j1 = tk.Frame(camps_frame, bg=self.c_camp_j1_bg, bd=2, relief="ridge", padx=16, pady=12)
        camp_j1.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 10))

        tk.Label(camp_j1, text="🟦 MARCUS (Gauche)", font=police_titre(13), bg=self.c_camp_j1_bg, fg="#2980b9" if not self.sombre else "#3498db").pack(pady=(0, 8))
        tk.Label(camp_j1, text="Touches : [A] [Z] [E]", font=police_corps(10, gras=True), bg=self.c_camp_j1_bg, fg="#d4af37" if self.sombre else "#8c1d1d").pack(pady=(0, 8))

        self.btn_j1 = []
        for let in ["A", "Z", "E"]:
            b = tk.Label(camp_j1, text=f"[{let}] Option", font=police_corps(11, gras=True),
                         bg=self.c_btn_j1_bg, fg=self.c_btn_j1_fg, bd=1, relief="raised", padx=10, pady=8)
            b.pack(fill=tk.X, pady=4)
            self.btn_j1.append(b)

        self.lbl_statut_j1 = tk.Label(camp_j1, text="Prêt !", font=police_corps(10, gras=True), bg=self.c_camp_j1_bg, fg="#2ecc71")
        self.lbl_statut_j1.pack(pady=8)

        # Camp Joueur 2 (Touches 1, 2, 3 ou J, K, L)
        camp_j2 = tk.Frame(camps_frame, bg=self.c_camp_j2_bg, bd=2, relief="ridge", padx=16, pady=12)
        camp_j2.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(10, 0))

        tk.Label(camp_j2, text="🟥 JULIA (Droite)", font=police_titre(13), bg=self.c_camp_j2_bg, fg="#c0392b" if not self.sombre else "#e74c3c").pack(pady=(0, 8))
        tk.Label(camp_j2, text="Touches : [1] [2] [3] ou [J] [K] [L]", font=police_corps(10, gras=True), bg=self.c_camp_j2_bg, fg="#d4af37" if self.sombre else "#8c1d1d").pack(pady=(0, 8))

        self.btn_j2 = []
        for let in ["1 / J", "2 / K", "3 / L"]:
            b = tk.Label(camp_j2, text=f"[{let}] Option", font=police_corps(11, gras=True),
                         bg=self.c_btn_j2_bg, fg=self.c_btn_j2_fg, bd=1, relief="raised", padx=10, pady=8)
            b.pack(fill=tk.X, pady=4)
            self.btn_j2.append(b)

        self.lbl_statut_j2 = tk.Label(camp_j2, text="Prêt !", font=police_corps(10, gras=True), bg=self.c_camp_j2_bg, fg="#2ecc71")
        self.lbl_statut_j2.pack(pady=8)

        self._actualiser_jauge()

    def _actualiser_jauge(self):
        cv = self.canvas_jauge
        cv.delete("all")
        w = cv.winfo_width()
        if w <= 1:
            w = 880
        h = 36

        # Ratio de 0 (tout à gauche J2 gagne) à 1 (tout à droite J1 gagne)
        # position_corde va de -5 à +5
        pos_norm = (self.position_corde + 5) / 10.0
        x_milieu = int(w * pos_norm)

        # Côté gauche (Bleu J1)
        cv.create_rectangle(0, 0, x_milieu, h, fill="#2980b9", outline="")
        # Côté droit (Rouge J2)
        cv.create_rectangle(x_milieu, 0, w, h, fill="#c0392b", outline="")

        # Curseur glaives au milieu
        cv.create_rectangle(x_milieu - 4, 0, x_milieu + 4, h, fill="#ffd700", outline="#ffffff")
        cv.create_text(x_milieu, h // 2, text="⚔️", font=("Segoe UI Emoji", 14))

    def _nouvelle_manche(self):
        if not self.pool_questions:
            self.pool_questions = list(QUESTIONS_DUEL)
            random.shuffle(self.pool_questions)

        self.question_en_cours = self.pool_questions.pop()
        self.bloque_j1 = False
        self.bloque_j2 = False

        self.lbl_statut_j1.configure(text="À toi !", fg="#2ecc71")
        self.lbl_statut_j2.configure(text="À toi !", fg="#2ecc71")

        self.lbl_question.configure(text=self.question_en_cours["q"])

        # Mélanger les propositions tout en retenant la bonne
        propositions = list(enumerate(self.question_en_cours["choix"]))
        bonne_reponse_str = self.question_en_cours["choix"][self.question_en_cours["rep"]]

        random.shuffle(propositions)
        self.ordre_options = [p[1] for p in propositions]
        self.bonne_option_idx = self.ordre_options.index(bonne_reponse_str)

        touches_j1 = ["A", "Z", "E"]
        touches_j2 = ["1/J", "2/K", "3/L"]
        for i in range(3):
            self.btn_j1[i].configure(
                text=f"[{touches_j1[i]}]  {self.ordre_options[i]}",
                bg=self.c_btn_j1_bg, fg=self.c_btn_j1_fg
            )
            self.btn_j2[i].configure(
                text=f"[{touches_j2[i]}]  {self.ordre_options[i]}",
                bg=self.c_btn_j2_bg, fg=self.c_btn_j2_fg
            )

        self._actualiser_jauge()

    def _sur_touche(self, event):
        key = event.keysym.upper()

        # Commandes Joueur 1 (A, Z, E)
        mapping_j1 = {"A": 0, "Z": 1, "E": 2}
        # Commandes Joueur 2 (1, 2, 3, J, K, L, KP_1, KP_2, KP_3)
        mapping_j2 = {
            "1": 0, "2": 1, "3": 2,
            "AMPERSAND": 0, "EACUTE": 1, "QUOTEDBL": 2,  # Clavier AZERTY français
            "J": 0, "K": 1, "L": 2,
            "KP_1": 0, "KP_2": 1, "KP_3": 2,
        }

        if key in mapping_j1 and not self.bloque_j1:
            self._traiter_reponse_joueur(1, mapping_j1[key])
        elif key in mapping_j2 and not self.bloque_j2:
            self._traiter_reponse_joueur(2, mapping_j2[key])

    def _traiter_reponse_joueur(self, joueur, choix_idx):
        est_correct = (choix_idx == self.bonne_option_idx)

        if est_correct:
            audio.play_sword_slash()
            if joueur == 1:
                self.score_j1 += 1
                self.position_corde = min(self.max_points, self.position_corde + 1)
                self.lbl_statut_j1.configure(text="🎯 TOUCHÉ ! Point pour Marcus !", fg="#2ecc71")
                self.lbl_score_j1.configure(text=f"🟦 JOUEUR 1 : MARCUS ({self.score_j1})")
                self.btn_j1[choix_idx].configure(bg="#27ae60", fg="#ffffff")
            else:
                self.score_j2 += 1
                self.position_corde = max(-self.max_points, self.position_corde - 1)
                self.lbl_statut_j2.configure(text="🎯 TOUCHÉ ! Point pour Julia !", fg="#2ecc71")
                self.lbl_score_j2.configure(text=f"({self.score_j2}) JULIA : JOUEUR 2 🟥")
                self.btn_j2[choix_idx].configure(bg="#27ae60", fg="#ffffff")

            self._actualiser_jauge()

            # Vérifier victoire finale
            if self.position_corde >= self.max_points:
                self._fin_duel("Marcus (Joueur 1)")
            elif self.position_corde <= -self.max_points:
                self._fin_duel("Julia (Joueur 2)")
            else:
                self._timer_manche = self.after(1100, self._nouvelle_manche)
        else:
            audio.play_bouclier()
            audio.play_wrong()
            if joueur == 1:
                self.bloque_j1 = True
                self.lbl_statut_j1.configure(text="🛡️ BLOQUÉ PAR LE SCUTUM !", fg="#e74c3c")
                self.btn_j1[choix_idx].configure(bg="#c0392b", fg="#ffffff")
            else:
                self.bloque_j2 = True
                self.lbl_statut_j2.configure(text="🛡️ BLOQUÉ PAR LE SCUTUM !", fg="#e74c3c")
                self.btn_j2[choix_idx].configure(bg="#c0392b", fg="#ffffff")

            # Si les deux ont échoué, manche suivante
            if self.bloque_j1 and self.bloque_j2:
                self._timer_manche = self.after(1200, self._nouvelle_manche)

    def _fin_duel(self, vainqueur):
        if hasattr(audio, "play_triumph_grand"):
            audio.play_triumph_grand()
        else:
            audio.play_fanfare()
        audio.play_foule()
        self.app.ajouter_sesterces(15)
        if hasattr(self.app, "_animer_confettis"):
            self.app._animer_confettis()

        try:
            from app.succes import incrementer_stat_succes
            if (self.score_j1 >= self.max_points and self.score_j2 == 0) or (self.score_j2 >= self.max_points and self.score_j1 == 0):
                incrementer_stat_succes(self.app, "duels_parfaits")
            incrementer_stat_succes(self.app, "duels_gagnes")
        except Exception:
            pass

        messagebox.showinfo(
            "🏆 Triomphe du Colisée !",
            f"Victoire éclatante de {vainqueur} !\n\n"
            f"La foule de Rome acclame les deux vaillants gladiateurs.\n"
            f"Chaque joueur reçoit 15 Sesterces pour sa vaillance !"
        )
        self.destroy()

    def destroy(self):
        if self._timer_manche:
            try:
                self.after_cancel(self._timer_manche)
            except Exception:
                pass
            self._timer_manche = None
        super().destroy()
