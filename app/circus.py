"""
Mini-jeu arcade : La Course de Chars au Circus Maximus.
Affrontement de rapidité entre le Char Bleu (le joueur) et le Char Rouge (le champion rival).
"""

import random
import tkinter as tk
from tkinter import messagebox

from app import audio
from app import progress as prog
from app.animations import declencher_pluie_sesterces

QUESTIONS_CIRCUS = [
    {"q": "Que signifie 'equus' (qui tire ton char) ?", "rep": "Le cheval", "fausses": ["Le loup", "L'aigle", "Le taureau"]},
    {"q": "Que signifie 'celeriter' pour aller plus vite ?", "rep": "Rapidement", "fausses": ["Lentement", "Toujours", "Jamais"]},
    {"q": "Que signifie 'victoria' ?", "rep": "La victoire", "fausses": ["La défaite", "Le départ", "La route"]},
    {"q": "Que signifie 'circus' en latin ?", "rep": "Le cercle / la piste", "fausses": ["Le lion", "Le casque", "Le pont"]},
    {"q": "Comment dit-on 'quatre' en latin (quadrige) ?", "rep": "Quattuor", "fausses": ["Tres", "Quinque", "Duo"]},
    {"q": "Que signifie 'auriga' (le pilote de char) ?", "rep": "Le cocher", "fausses": ["Le forgeron", "Le sénateur", "Le médecin"]},
    {"q": "Que veut dire 'arena' à l'origine ?", "rep": "Le sable", "fausses": ["L'eau", "L'or", "La pierre"]},
    {"q": "Que crie la foule romaine pour encourager : 'Curre' ?", "rep": "Cours !", "fausses": ["Arrête !", "Regarde !", "Écoute !"]},
    {"q": "Que signifie 'fortis' ?", "rep": "Fort / courageux", "fausses": ["Léger", "Paresseux", "Triste"]},
    {"q": "Que signifie 'gloria' ?", "rep": "La gloire", "fausses": ["La peur", "La nuit", "Le sommeil"]},
]


class CircusMaximusWindow(tk.Toplevel):
    """Mini-jeu de course au Circus Maximus."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🏎️ Circus Maximus — La Grande Course de Chars")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        from app.responsive import adapter_geometrie_fenetre
        w, h = adapter_geometrie_fenetre(self, 760, 580, min_w=640, min_h=460)

        # Liseré supérieur
        tk.Frame(self, bg=self.C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=16, pady=8)
        hdr.pack(fill=tk.X)
        nom_h = prog.get_nom_heros(app.data)
        tk.Label(hdr, text="🏎️ La Grande Course du Circus Maximus",
                 font=(app.title_font.cget("family"), 16, "bold"),
                 bg=self.C["panel"], fg=self.C["accent"]).pack(side=tk.LEFT)
        self.lap_lbl = tk.Label(hdr, text=f"🏁 {nom_h} • Tour 1/3  •  Distance : 0 m",
                                font=(app.body.cget("family"), 10, "bold"),
                                bg=self.C["panel"], fg=self.C["fg"])
        self.lap_lbl.pack(side=tk.RIGHT)

        # Piste de course (Canvas)
        self.cw = 720
        self.ch = 220
        self.canvas = tk.Canvas(self, width=self.cw, height=self.ch, bg="#d9ad73", highlightthickness=2,
                                highlightbackground=self.C["accent"])
        self.canvas.pack(padx=20, pady=(4, 10))

        # Tracé de la piste de sable
        self._dessiner_piste()

        # Progression des chars (0.0 à 100.0%)
        self.pos_joueur = 0.0
        self.pos_rival = 0.0
        self.tour_joueur = 1
        self.course_terminee = False

        self._dessiner_chars()

        # Zone Question & Réponses rapides
        self.q_frame = tk.Frame(self, bg=self.C["editor"], padx=20, pady=12, highlightthickness=1,
                                highlightbackground=self.C["panel"])
        self.q_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=(0, 14))

        self.consigne_lbl = tk.Label(
            self.q_frame,
            text="Réponds vite et juste pour accélérer et doubler le champion rouge !",
            font=(app.body.cget("family"), 10, "italic"),
            bg=self.C["editor"], fg=self.C["muted"]
        )
        self.consigne_lbl.pack(pady=(0, 6))

        self.question_lbl = tk.Label(
            self.q_frame,
            text="",
            font=(app.body.cget("family"), 13, "bold"),
            bg=self.C["editor"], fg=self.C["accent"]
        )
        self.question_lbl.pack(pady=4)

        # 4 Boutons de réponse
        self.btns_frame = tk.Frame(self.q_frame, bg=self.C["editor"])
        self.btns_frame.pack(fill=tk.BOTH, expand=True, pady=6)
        self.btns_frame.columnconfigure(0, weight=1)
        self.btns_frame.columnconfigure(1, weight=1)

        self.reponse_btns = []
        for i in range(4):
            r = i // 2
            c = i % 2
            btn = tk.Button(
                self.btns_frame, text="", font=(app.body.cget("family"), 10, "bold"),
                relief="flat", bg=self.C["panel"], fg=self.C["fg"], padx=10, pady=8, cursor="hand2"
            )
            btn.grid(row=r, column=c, padx=6, pady=4, sticky="nsew")
            self.reponse_btns.append(btn)

        self.questions_dispos = list(QUESTIONS_CIRCUS)
        random.shuffle(self.questions_dispos)
        self.q_index = 0

        self._poser_question()
        self._boucle_rival()

    def _dessiner_piste(self):
        # Lignes blanches de piste
        self.canvas.create_line(40, 40, self.cw - 40, 40, fill="#e8cfa1", width=3, dash=(10, 8))
        self.canvas.create_line(40, 110, self.cw - 40, 110, fill="#ffffff", width=4)  # La Spina centrale
        self.canvas.create_line(40, 180, self.cw - 40, 180, fill="#e8cfa1", width=3, dash=(10, 8))

        # Obélisques décoratives sur la spina
        self.canvas.create_rectangle(self.cw // 2 - 25, 95, self.cw // 2 + 25, 125, fill="#8b5a2b", outline="#ffd700")
        self.canvas.create_text(self.cw // 2, 110, text="🏛️ SPINA", font=("", 9, "bold"), fill="#ffffff")

        # Ligne d'arrivée
        self.canvas.create_line(self.cw - 70, 20, self.cw - 70, 200, fill="#ffffff", width=6)
        self.canvas.create_text(self.cw - 70, 15, text="🏁 ARRIVÉE", font=("", 8, "bold"), fill="#ffffff")

    def _dessiner_un_char(self, x, y, nom, couleur_fond, couleur_bord, couleur_cheval, tag="char"):
        # 1. Poussière / Trainée de vitesse
        self.canvas.create_line(x - 26, y + 16, x - 46, y + 16, fill="#f5deb3", width=2, dash=(4, 3), tags=tag)
        self.canvas.create_line(x - 22, y + 11, x - 38, y + 9, fill="#f5deb3", width=1, dash=(3, 2), tags=tag)

        # 2. Timon en bois (reliant le char aux chevaux)
        self.canvas.create_line(x + 4, y + 6, x + 50, y + 4, fill="#8b5a2b", width=3, tags=tag)

        # 3. Cheval au galop (silhouette antique)
        # Corps
        self.canvas.create_oval(x + 30, y - 10, x + 62, y + 10, fill=couleur_cheval, outline="#2c1810", width=1, tags=tag)
        # Cou et tête
        self.canvas.create_polygon(x + 50, y - 4, x + 64, y - 22, x + 74, y - 18, x + 66, y - 4,
                                   fill=couleur_cheval, outline="#2c1810", width=1, tags=tag)
        # Oreille
        self.canvas.create_polygon(x + 62, y - 26, x + 66, y - 20, x + 60, y - 20, fill=couleur_bord, tags=tag)
        # Crinière
        self.canvas.create_line(x + 52, y - 8, x + 62, y - 20, fill=couleur_bord, width=2, tags=tag)
        # Pattes avant tendues au galop
        self.canvas.create_line(x + 58, y + 4, x + 76, y - 2, fill=couleur_cheval, width=3, tags=tag)
        self.canvas.create_line(x + 76, y - 2, x + 84, y + 2, fill="#2c1810", width=2, tags=tag)
        # Pattes arrière projetées
        self.canvas.create_line(x + 36, y + 4, x + 20, y + 16, fill=couleur_cheval, width=3, tags=tag)
        # Queue flottante
        self.canvas.create_line(x + 30, y - 2, x + 14, y - 10, fill=couleur_cheval, width=3, tags=tag)

        # 4. Caisson du char romain (bleu ou rouge avec garnitures or)
        self.canvas.create_polygon(x - 24, y - 14, x + 8, y - 14, x + 14, y + 2, x + 6, y + 10, x - 24, y + 10,
                                   fill=couleur_fond, outline="#f1c40f", width=2, tags=tag)
        # Ornement central du bouclier de char
        self.canvas.create_oval(x - 12, y - 6, x - 4, y + 2, fill="#f39c12", outline="#ffffff", width=1, tags=tag)

        # 5. Aurige (le pilote romain)
        # Buste
        self.canvas.create_rectangle(x - 16, y - 16, x - 4, y - 4, fill=couleur_bord, outline="", tags=tag)
        # Tête & casque
        self.canvas.create_oval(x - 15, y - 28, x - 5, y - 16, fill="#fed7aa", outline="#b45309", tags=tag)
        self.canvas.create_arc(x - 17, y - 30, x - 3, y - 16, start=0, extent=180, fill=couleur_bord, outline="#f1c40f", tags=tag)
        # Rênes de conduite
        self.canvas.create_line(x - 4, y - 8, x + 68, y - 14, fill="#5c3818", width=1, tags=tag)

        # 6. Roue à rayons dorés
        self.canvas.create_oval(x - 18, y + 2, x + 4, y + 24, fill="#3e2723", outline="#f1c40f", width=3, tags=tag)
        self.canvas.create_line(x - 7, y + 2, x - 7, y + 24, fill="#f1c40f", width=1, tags=tag)
        self.canvas.create_line(x - 18, y + 13, x + 4, y + 13, fill="#f1c40f", width=1, tags=tag)
        self.canvas.create_oval(x - 9, y + 11, x - 5, y + 15, fill="#ffffff", outline="#f1c40f", tags=tag)

        # 7. Bannière nominative
        self.canvas.create_rectangle(x - 26, y - 42, x + 38, y - 26, fill="#1c1917", outline=couleur_fond, width=1, tags=tag)
        self.canvas.create_text(x + 6, y - 34, text=nom, font=("", 8, "bold"), fill="#ffffff", tags=tag)

    def _dessiner_chars(self):
        # Position X (de 60 à cw - 120)
        x_min, x_max = 70, self.cw - 120
        xj = x_min + (x_max - x_min) * (self.pos_joueur / 100.0)
        xr = x_min + (x_max - x_min) * (self.pos_rival / 100.0)

        # Supprimer anciens sprites
        self.canvas.delete("char")

        nom_h = prog.get_nom_heros(self.app.data)
        # Char Joueur (Voie supérieure, bleu avec monture blanche)
        self._dessiner_un_char(xj, 65, nom_h, couleur_fond="#2563eb",
                              couleur_bord="#1e40af", couleur_cheval="#f8fafc", tag="char")
        # Char Rival (Voie inférieure, rouge avec monture baie foncée)
        self._dessiner_un_char(xr, 145, "Maximus", couleur_fond="#dc2626",
                              couleur_bord="#991b1b", couleur_cheval="#451a03", tag="char")

    def _boucle_rival(self):
        """Fait avancer régulièrement le char rival de manière réaliste."""
        if self.course_terminee:
            return
        # Vitesse du rival (légèrement variable)
        self.pos_rival += random.uniform(0.6, 1.4)
        if self.pos_rival >= 100.0:
            self.pos_rival = 0.0  # Tour suivant du rival

        self._dessiner_chars()
        self.after(300, self._boucle_rival)

    def _poser_question(self):
        if self.course_terminee:
            return
        if self.q_index >= len(self.questions_dispos):
            random.shuffle(self.questions_dispos)
            self.q_index = 0

        q_data = self.questions_dispos[self.q_index]
        self.q_index += 1
        self.current_q = q_data

        self.question_lbl.configure(text=q_data["q"])
        options = [q_data["rep"]] + q_data["fausses"]
        random.shuffle(options)

        for i, opt in enumerate(options):
            self.reponse_btns[i].configure(
                text=opt,
                bg=self.C["panel"],
                state="normal",
                command=lambda reponse=opt: self._verifier_reponse(reponse)
            )

    def _verifier_reponse(self, choix):
        if self.course_terminee:
            return
        est_correct = (choix == self.current_q["rep"])

        if est_correct:
            audio.play_chariot_whip()
            # Turbo boost !
            self.pos_joueur += 22.0
            self.consigne_lbl.configure(text="⚡ Excellent coup de fouet ! Le char accélère !", fg=self.C["ok"])
        else:
            audio.play_wrong()
            self.pos_joueur = max(0.0, self.pos_joueur - 8.0)
            self.consigne_lbl.configure(text=f"❌ Oups ! La bonne réponse était : {self.current_q['rep']}", fg=self.C["err"])

        # Gestion des tours
        if self.pos_joueur >= 100.0:
            if self.tour_joueur < 3:
                self.tour_joueur += 1
                self.pos_joueur = 0.0
                audio.play_coin()
            else:
                self._victoire_course()
                return

        dist_totale = int((self.tour_joueur - 1) * 300 + (self.pos_joueur * 3))
        self.lap_lbl.configure(text=f"🏁 Tour {self.tour_joueur}/3  •  Distance : {dist_totale} m")
        self._dessiner_chars()
        self._poser_question()

    def _victoire_course(self):
        self.course_terminee = True
        self.pos_joueur = 100.0
        self._dessiner_chars()
        self.lap_lbl.configure(text="🏆 VICTOIRE DU CIRCUS MAXIMUS !")
        self.consigne_lbl.configure(text="🏆 Tu as franchi la ligne d'arrivée en tête ! La foule acclame ton nom !", fg=self.C["accent"])

        # Désactiver boutons
        for btn in self.reponse_btns:
            btn.configure(state="disabled")

        # Récompense
        self.app.ajouter_sesterces(100)
        audio.play_tuba_fanfare()
        declencher_pluie_sesterces(self, count=28)

        def _confirmer():
            messagebox.showinfo(
                "Victoire Triomphale !",
                "Félicitations Aurige !\n\n"
                "Tu remportes la palme de lauriers du Circus Maximus et une prime impériale de 100 Sesterces 🪙 !"
            )
            self.destroy()

        self.after(2000, _confirmer)
