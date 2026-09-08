"""
Mini-jeu arcade : La Course de Chars au Circus Maximus.
Affrontement de rapidité cartoon entre le Char Bleu (le joueur / Veneti)
et le Char Rouge (le champion rival Maximus / Russati).
"""

import math
import random
import tkinter as tk
from pathlib import Path
from tkinter import messagebox

try:
    from PIL import Image, ImageTk
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

from app import audio
from app import progress as prog
from app.animations import declencher_pluie_sesterces
from app.polices import police_bouton, police_corps, police_titre
from app.responsive import adapter_geometrie_fenetre, obtenir_facteur_echelle

ASSETS_CIRCUS = Path(__file__).resolve().parent.parent / "assets" / "images" / "circus"

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
    {"q": "Quelle faction porte la couleur bleue au cirque ?", "rep": "Veneti", "fausses": ["Russati", "Prasini", "Albati"]},
    {"q": "Quelle faction porte la couleur rouge au cirque ?", "rep": "Russati", "fausses": ["Veneti", "Prasini", "Albati"]},
    {"q": "Comment appelle-t-on le mur central du cirque ?", "rep": "La Spina", "fausses": ["Le Forum", "L'Atrium", "La Cavea"]},
    {"q": "Quel animal en bronze servait à compter les tours ?", "rep": "Le dauphin", "fausses": ["Le lion", "L'aigle", "Le cygne"]},
]


class CircusMaximusWindow(tk.Toplevel):
    """Mini-jeu arcade de course de chars cartoon au Circus Maximus."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🏎️ Circus Maximus — La Grande Course de Chars")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        adapter_geometrie_fenetre(self, 800, 620, min_w=680, min_h=520)
        self.transient(master)

        self.scale = obtenir_facteur_echelle(self)
        self.cw = int(round(760 * self.scale))
        self.ch = int(round(240 * self.scale))

        # Progression des chars (0.0 à 100.0%)
        self.pos_joueur = 0.0
        self.pos_rival = 0.0
        self.tour_joueur = 1
        self.course_terminee = False
        self.combo_reponses = 0
        self.turbo_frames = 0
        self.anim_tick = 0
        self.particules_poussiere = []
        self._loop_timer = None
        self._rival_timer = None

        # Chargement des sprites cartoon
        self._charger_sprites()

        # 1. Liseré supérieur
        tk.Frame(self, bg=self.C["accent"], height=4).pack(fill=tk.X, side=tk.TOP)

        # 2. En-tête arcade
        hdr = tk.Frame(self, bg=self.C["panel"], padx=14, pady=8)
        hdr.pack(fill=tk.X)

        nom_h = prog.get_nom_heros(app.data)
        tk.Label(
            hdr,
            text="🏎️ CIRCUS MAXIMUS",
            font=police_titre(15, gras=True),
            bg=self.C["panel"],
            fg=self.C["accent"]
        ).pack(side=tk.LEFT)

        self.lbl_dauphins = tk.Label(
            hdr,
            text="🐬 🐬 🐬 Tours",
            font=police_corps(10, gras=True),
            bg=self.C["panel"],
            fg="#38bdf8"
        )
        self.lbl_dauphins.pack(side=tk.LEFT, padx=12)

        self.lap_lbl = tk.Label(
            hdr,
            text=f"🏁 {nom_h} • Tour 1/3  •  0 m",
            font=police_corps(10, gras=True),
            bg=self.C["panel"],
            fg=self.C["fg"]
        )
        self.lap_lbl.pack(side=tk.RIGHT)

        # Mini barre de circuit / progression
        self.mini_track = tk.Canvas(self, height=16, bg="#24283b", highlightthickness=1, highlightbackground=self.C["panel"])
        self.mini_track.pack(fill=tk.X, padx=18, pady=(0, 4))
        self._dessiner_mini_track()

        # 3. Piste de course principale (Canvas)
        self.canvas = tk.Canvas(
            self,
            width=self.cw,
            height=self.ch,
            bg="#d2a66e",
            highlightthickness=2,
            highlightbackground=self.C["accent"]
        )
        self.canvas.pack(padx=18, pady=(2, 8))
        self._dessiner_piste()

        # 4. Zone Question & Réponses rapides
        self.q_frame = tk.Frame(
            self,
            bg=self.C["editor"],
            padx=16,
            pady=10,
            highlightthickness=1,
            highlightbackground=self.C["panel"]
        )
        self.q_frame.pack(fill=tk.BOTH, expand=True, padx=18, pady=(0, 10))

        # Bandeau turbo / combo
        self.f_turbo = tk.Frame(self.q_frame, bg=self.C["editor"])
        self.f_turbo.pack(fill=tk.X, pady=(0, 4))

        self.consigne_lbl = tk.Label(
            self.f_turbo,
            text="⚡ Réponds juste pour accélérer ! Utilise la souris ou les touches [1], [2], [3], [4] !",
            font=police_corps(9, italique=True),
            bg=self.C["editor"],
            fg=self.C["muted"]
        )
        self.consigne_lbl.pack(side=tk.LEFT)

        self.combo_lbl = tk.Label(
            self.f_turbo,
            text="⚡ TURBO : [░░░░] x1",
            font=police_corps(9, gras=True),
            bg=self.C["editor"],
            fg="#e0af68"
        )
        self.combo_lbl.pack(side=tk.RIGHT)

        # Intitulé de la question
        self.question_lbl = tk.Label(
            self.q_frame,
            text="",
            font=police_titre(13, gras=True),
            bg=self.C["editor"],
            fg=self.C["accent"],
            wraplength=int(round(720 * self.scale))
        )
        self.question_lbl.pack(pady=4)

        # 4 Grands Pavés de réponse arcade
        self.btns_frame = tk.Frame(self.q_frame, bg=self.C["editor"])
        self.btns_frame.pack(fill=tk.BOTH, expand=True, pady=4)
        self.btns_frame.columnconfigure(0, weight=1)
        self.btns_frame.columnconfigure(1, weight=1)
        self.btns_frame.rowconfigure(0, weight=1)
        self.btns_frame.rowconfigure(1, weight=1)

        couleurs_boutons = [
            ("#1e3a8a", "#93c5fd", "1"),  # Bleu
            ("#065f46", "#a7f3d0", "2"),  # Vert
            ("#92400e", "#fde68a", "3"),  # Ambre
            ("#831843", "#fbcfe8", "4"),  # Pourpre
        ]

        self.reponse_btns = []
        for i in range(4):
            r = i // 2
            c = i % 2
            bg_b, fg_b, num = couleurs_boutons[i]
            btn = tk.Button(
                self.btns_frame,
                text="",
                font=police_bouton(10, gras=True),
                relief="flat",
                bg=bg_b,
                fg="#ffffff",
                activebackground="#ffd700",
                activeforeground="#1a1b26",
                cursor="hand2",
                padx=10,
                pady=6,
                wraplength=int(round(320 * self.scale))
            )
            btn.grid(row=r, column=c, padx=6, pady=4, sticky="nsew")
            self.reponse_btns.append(btn)

        # Raccourcis clavier (touches 1, 2, 3, 4 et clavier numérique)
        for idx, key in enumerate(("1", "2", "3", "4")):
            self.bind(f"<Key-{key}>", lambda e, i=idx: self._clic_touche(i))
            self.bind(f"<KP_{key}>", lambda e, i=idx: self._clic_touche(i))
        # Support touches AZERTY françaises (&, é, ", ')
        for idx, key in enumerate(("ampersand", "eacute", "quotedbl", "apostrophe")):
            self.bind(f"<{key}>", lambda e, i=idx: self._clic_touche(i))

        self.questions_dispos = list(QUESTIONS_CIRCUS)
        random.shuffle(self.questions_dispos)
        self.q_index = 0

        self._poser_question()
        self._boucle_rival()
        self._boucle_animation()

    def _charger_sprites(self):
        """Charge et prépare les sprites cartoon des chars et du décor."""
        self.sprite_bleu = None
        self.sprite_rouge = None
        self.sprite_spina = None

        if not HAS_PIL:
            return

        try:
            f_bleu = ASSETS_CIRCUS / "chariot_bleu.png"
            if f_bleu.exists():
                im_b = Image.open(f_bleu).convert("RGBA")
                target_w = int(round(150 * self.scale))
                target_h = int(target_w * (im_b.height / im_b.width))
                im_b = im_b.resize((target_w, target_h), Image.Resampling.LANCZOS)
                self.sprite_bleu = ImageTk.PhotoImage(im_b)

            f_rouge = ASSETS_CIRCUS / "chariot_rouge.png"
            if f_rouge.exists():
                im_r = Image.open(f_rouge).convert("RGBA")
                target_w = int(round(150 * self.scale))
                target_h = int(target_w * (im_r.height / im_r.width))
                im_r = im_r.resize((target_w, target_h), Image.Resampling.LANCZOS)
                self.sprite_rouge = ImageTk.PhotoImage(im_r)

            f_spina = ASSETS_CIRCUS / "circus_spina.png"
            if f_spina.exists():
                im_s = Image.open(f_spina).convert("RGBA")
                target_w = int(round(260 * self.scale))
                target_h = int(target_w * (im_s.height / im_s.width))
                im_s = im_s.resize((target_w, target_h), Image.Resampling.LANCZOS)
                self.sprite_spina = ImageTk.PhotoImage(im_s)
        except Exception:
            pass

    def _dessiner_mini_track(self):
        """Affiche la mini-barre de position des deux chars en tête."""
        self.mini_track.delete("all")
        w = self.mini_track.winfo_width()
        if w <= 10:
            w = 760

        # Ligne de fond
        self.mini_track.create_line(30, 8, w - 40, 8, fill="#414868", width=3)
        self.mini_track.create_text(w - 20, 8, text="🏁", font=("", 9))

        # Position relative
        x_start = 35
        x_end = w - 45
        pos_rel_j = (self.tour_joueur - 1) / 3.0 + (self.pos_joueur / 300.0)
        pos_rel_r = (self.tour_joueur - 1) / 3.0 + (self.pos_rival / 300.0)

        xj = x_start + (x_end - x_start) * min(1.0, max(0.0, pos_rel_j))
        xr = x_start + (x_end - x_start) * min(1.0, max(0.0, pos_rel_r))

        self.mini_track.create_oval(xr - 5, 3, xr + 5, 13, fill="#ef4444", outline="#ffffff")
        self.mini_track.create_oval(xj - 6, 2, xj + 6, 14, fill="#38bdf8", outline="#ffffff", width=2)

    def _dessiner_piste(self):
        """Dessine le décor du Circus Maximus (sable, gradins, dalles et Spina)."""
        self.canvas.delete("decor")
        cw, ch = self.cw, self.ch

        # 1. Gradins du haut (foule stylisée)
        self.canvas.create_rectangle(0, 0, cw, 28, fill="#6d28d9", outline="", tags="decor")
        # Fanions colorés des 4 factions
        for x in range(20, cw, 40):
            col_f = ("#2563eb", "#dc2626", "#16a34a", "#ffffff")[(x // 40) % 4]
            self.canvas.create_polygon(x, 4, x + 16, 4, x + 8, 22, fill=col_f, outline="#ffd700", tags="decor")

        # 2. Piste de sable avec texture et dalles
        self.canvas.create_line(0, 28, cw, 28, fill="#ffffff", width=2, tags="decor")
        self.canvas.create_line(0, ch - 2, cw, ch - 2, fill="#8b5a2b", width=3, tags="decor")

        # 3. La Spina centrale (barrière de séparation avec obélisque et dauphins)
        y_spina = ch // 2
        self.canvas.create_line(20, y_spina, cw - 20, y_spina, fill="#fafaf9", width=4, tags="decor")

        # Obélisque / Image Spina
        if self.sprite_spina:
            self.canvas.create_image(cw // 2, y_spina - 10, image=self.sprite_spina, tags="decor")
        else:
            self.canvas.create_rectangle(cw // 2 - 35, y_spina - 12, cw // 2 + 35, y_spina + 12,
                                         fill="#78350f", outline="#ffd700", width=2, tags="decor")
            self.canvas.create_text(cw // 2, y_spina, text="🏛️ SPINA", font=("Georgia", 9, "bold"),
                                    fill="#ffffff", tags="decor")

        # 4. Ligne d'arrivée
        x_arr = cw - 60
        for y in range(30, ch - 5, 12):
            fill_c = "#ffffff" if (y // 12) % 2 == 0 else "#1c1917"
            self.canvas.create_rectangle(x_arr - 6, y, x_arr + 6, y + 12, fill=fill_c, outline="", tags="decor")
        self.canvas.create_text(x_arr, 15, text="🏁 META", font=("Georgia", 8, "bold"), fill="#ffffff", tags="decor")

    def _dessiner_chars(self):
        """Dessine les deux chars cartoon avec galop sinusoïdal et particules de sable."""
        self.canvas.delete("char")
        self.canvas.delete("effet")

        x_min = 60
        x_max = self.cw - 110

        xj = x_min + (x_max - x_min) * (self.pos_joueur / 100.0)
        xr = x_min + (x_max - x_min) * (self.pos_rival / 100.0)

        # Roulis et galop (oscillation verticale sinusoïdale rythmée)
        bob_j = math.sin(self.anim_tick * 0.5) * 3.0
        bob_r = math.sin((self.anim_tick + 2) * 0.45) * 3.0

        y_joueur = int(self.ch * 0.28 + bob_j)
        y_rival = int(self.ch * 0.72 + bob_r)

        # 1. Particules de poussière de sable
        for p in self.particules_poussiere:
            r = p["r"]
            self.canvas.create_oval(
                p["x"] - r, p["y"] - r, p["x"] + r, p["y"] + r,
                fill=p["col"], outline="", tags="effet"
            )

        # 2. Effet Turbo (traînées de vitesse dorées)
        if self.turbo_frames > 0:
            for dy in (-12, -4, 4, 12):
                lg = random.randint(25, 60)
                self.canvas.create_line(
                    xj - 20, y_joueur + dy, xj - 20 - lg, y_joueur + dy,
                    fill="#ffd700", width=2, dash=(6, 4), tags="effet"
                )
            self.canvas.create_text(
                xj - 40, y_joueur - 20,
                text="CELERITER !",
                font=("Georgia", 9, "bold italic"),
                fill="#ffd700",
                tags="effet"
            )

        # 3. Char Joueur (Bleu / Veneti)
        nom_h = prog.get_nom_heros(self.app.data)
        if self.sprite_bleu:
            self.canvas.create_image(xj, y_joueur, image=self.sprite_bleu, tags="char")
            # Nom et bannière
            self.canvas.create_rectangle(xj - 32, y_joueur - 38, xj + 32, y_joueur - 24,
                                         fill="#1e3a8a", outline="#ffd700", tags="char")
            self.canvas.create_text(xj, y_joueur - 31, text=f"🔵 {nom_h}",
                                    font=("Georgia", 8, "bold"), fill="#ffffff", tags="char")
        else:
            self._dessiner_char_fallback(xj, y_joueur, nom_h, "#2563eb", "#ffffff")

        # 4. Char Rival (Rouge / Russati)
        if self.sprite_rouge:
            self.canvas.create_image(xr, y_rival, image=self.sprite_rouge, tags="char")
            # Nom et bannière
            self.canvas.create_rectangle(xr - 34, y_rival - 38, xr + 34, y_rival - 24,
                                         fill="#991b1b", outline="#fca5a5", tags="char")
            self.canvas.create_text(xr, y_rival - 31, text="🔴 Maximus",
                                    font=("Georgia", 8, "bold"), fill="#ffffff", tags="char")
        else:
            self._dessiner_char_fallback(xr, y_rival, "Maximus", "#dc2626", "#451a03")

    def _dessiner_char_fallback(self, x, y, nom, couleur, couleur_cheval):
        """Dessin vectoriel de secours si les sprites cartoon ne peuvent être chargés."""
        self.canvas.create_oval(x - 20, y - 10, x + 20, y + 10, fill=couleur, outline="#ffd700", tags="char")
        self.canvas.create_oval(x + 20, y - 8, x + 50, y + 8, fill=couleur_cheval, tags="char")
        self.canvas.create_text(x, y, text=nom, font=("Georgia", 8, "bold"), fill="#ffffff", tags="char")

    def _boucle_animation(self):
        """Boucle d'animation fluide pour le galop et les particules de sable."""
        if self.course_terminee:
            return

        self.anim_tick += 1

        # Générer de la poussière sous les roues
        if self.anim_tick % 2 == 0:
            xj = 60 + (self.cw - 170) * (self.pos_joueur / 100.0)
            xr = 60 + (self.cw - 170) * (self.pos_rival / 100.0)
            yj = int(self.ch * 0.28 + 18)
            yr = int(self.ch * 0.72 + 18)

            p_cols = ["#edd6ad", "#dfbc88", "#c99b5b", "#f5e6ca"]
            self.particules_poussiere.append({
                "x": xj - 35, "y": yj + random.randint(-4, 4),
                "r": random.randint(2, 5), "col": random.choice(p_cols), "vie": 6
            })
            self.particules_poussiere.append({
                "x": xr - 35, "y": yr + random.randint(-4, 4),
                "r": random.randint(2, 5), "col": random.choice(p_cols), "vie": 6
            })

        # Mettre à jour les particules
        vivantes = []
        for p in self.particules_poussiere:
            p["x"] -= random.randint(3, 7)
            p["r"] += 0.5
            p["vie"] -= 1
            if p["vie"] > 0:
                vivantes.append(p)
        self.particules_poussiere = vivantes

        if self.turbo_frames > 0:
            self.turbo_frames -= 1

        self._dessiner_chars()
        self._dessiner_mini_track()
        self._loop_timer = self.after(45, self._boucle_animation)

    def _boucle_rival(self):
        """Avancée autonome et réaliste du char rival."""
        if self.course_terminee:
            return
        vitesse = random.uniform(0.7, 1.4)
        self.pos_rival += vitesse
        if self.pos_rival >= 100.0:
            self.pos_rival = 0.0

        self._dessiner_chars()
        self._rival_timer = self.after(300, self._boucle_rival)

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
            badge = f"[{i + 1}] "
            self.reponse_btns[i].configure(
                text=badge + opt,
                state="normal",
                command=lambda reponse=opt: self._verifier_reponse(reponse)
            )

    def _clic_touche(self, index):
        """Action déclenchée par un raccourci clavier 1, 2, 3 ou 4."""
        if 0 <= index < len(self.reponse_btns):
            btn = self.reponse_btns[index]
            if btn.cget("state") != "disabled":
                btn.invoke()

    def _verifier_reponse(self, choix):
        if self.course_terminee:
            return
        est_correct = (choix == self.current_q["rep"])

        if est_correct:
            self.combo_reponses += 1
            audio.play_chariot_whip()

            # Calcul du boost avec combo
            boost = 22.0 + min(12.0, self.combo_reponses * 3.0)
            self.pos_joueur += boost
            self.turbo_frames = 18

            combo_txt = "🔥 x" + str(self.combo_reponses) if self.combo_reponses > 1 else ""
            self.consigne_lbl.configure(
                text=f"⚡ CELERITER ! Magnifique coup de fouet (+{int(boost)}%) {combo_txt}",
                fg=self.C["ok"]
            )
            self.combo_lbl.configure(
                text=f"⚡ TURBO : [{'█' * min(4, self.combo_reponses)}{'░' * max(0, 4 - self.combo_reponses)}] x{self.combo_reponses}",
                fg="#ffd700"
            )
        else:
            self.combo_reponses = 0
            audio.play_wrong()
            self.pos_joueur = max(0.0, self.pos_joueur - 8.0)
            self.consigne_lbl.configure(
                text=f"❌ Oups ! La bonne réponse était : {self.current_q['rep']}",
                fg=self.C["err"]
            )
            self.combo_lbl.configure(text="⚡ TURBO : [░░░░] x1", fg="#e0af68")

        # Gestion des tours
        if self.pos_joueur >= 100.0:
            if self.tour_joueur < 3:
                self.tour_joueur += 1
                self.pos_joueur = 0.0
                audio.play_coin()
                # Mise à jour des dauphins d'or
                dauphins = ["🐬", "🐬", "🐬"]
                for t in range(self.tour_joueur - 1):
                    dauphins[t] = "💧"
                self.lbl_dauphins.configure(text=" ".join(dauphins) + f" Tour {self.tour_joueur}/3")
            else:
                self._victoire_course()
                return

        dist_totale = int((self.tour_joueur - 1) * 300 + (self.pos_joueur * 3))
        nom_h = prog.get_nom_heros(self.app.data)
        self.lap_lbl.configure(text=f"🏁 {nom_h} • Tour {self.tour_joueur}/3  •  Distance : {dist_totale} m")
        self._dessiner_chars()
        self._poser_question()

    def _victoire_course(self):
        """Célébration grandiose de victoire au Circus Maximus."""
        self.course_terminee = True
        self.pos_joueur = 100.0
        self._dessiner_chars()
        self.lap_lbl.configure(text="🏆 VICTOIRE DU CIRCUS MAXIMUS !")
        self.lbl_dauphins.configure(text="🏆 🏆 🏆 Triomphe !")
        self.consigne_lbl.configure(
            text="🏆 Tu franchis la ligne d'arrivée en tête ! Le Circus Maximus t'acclame !",
            fg=self.C["accent"]
        )

        # Désactiver les boutons de réponse
        for btn in self.reponse_btns:
            btn.configure(state="disabled")

        # Récompense et sons
        self.app.ajouter_sesterces(100)
        audio.play_tuba_fanfare()
        declencher_pluie_sesterces(self, count=32)

        def _confirmer():
            messagebox.showinfo(
                "Victoire Triomphale !",
                "Félicitations Aurige !\n\n"
                "Tu remportes la palme de lauriers du Circus Maximus et une prime impériale de 100 Sesterces 🪙 !"
            )
            self.destroy()

        self.after(2200, _confirmer)

    def destroy(self):
        self.course_terminee = True
        if self._loop_timer:
            try:
                self.after_cancel(self._loop_timer)
            except Exception:
                pass
            self._loop_timer = None
        if self._rival_timer:
            try:
                self.after_cancel(self._rival_timer)
            except Exception:
                pass
            self._rival_timer = None
        try:
            self.canvas.delete("all")
        except Exception:
            pass
        self.sprite_bleu = None
        self.sprite_rouge = None
        self.sprite_spina = None
        super().destroy()

