"""
Module de la Taverne des Dés Romains (« Alea Iacta Est »).

Simule une taverne romaine antique (popina / taberna) où l'apprenant lance
4 dés romains authentiques (tesserae / astragali) avec le cornet en cuir (fritillus) :
- Rituel quotidien gratuit (Bonus Diurnum)
- Combinaisons historiques : Iactus Venereus (Coup de Vénus), Canis (Coup du Chien), Senatus, Plebeius
- Gains de Sesterces, protection de Streak et défi de Mercure
- Ambiance sonore et visuelle antique
"""

import random
import tkinter as tk
from datetime import date
from tkinter import messagebox

from app import audio
from app.polices import police_corps, police_titre
from app.theme import est_sombre

# Valeurs romaines des faces de dés
CHIFFRES_ROMAINS = {
    1: "I",
    2: "II",
    3: "III",
    4: "IV",
    5: "V",
    6: "VI",
}

# Questions de rédemption pour le Coup du Chien (Défi de Mercure)
QUESTIONS_CHIEN = [
    {
        "q": "Que signifie la célèbre citation de César : « Alea iacta est » ?",
        "options": ["Le sort en est jeté", "Rome vaincra", "La guerre commence", "Les dés sont pipés"],
        "bonne": 0,
    },
    {
        "q": "Quel dieu romain ailé protège les voyageurs et les joueurs habiles ?",
        "options": ["Mars", "Mercure", "Jupiter", "Vulcain"],
        "bonne": 1,
    },
    {
        "q": "Comment les Romains appelaient-ils le cornet en cuir pour lancer les dés ?",
        "options": ["Fritillus", "Scutum", "Gladius", "Toga"],
        "bonne": 0,
    },
    {
        "q": "Que signifie la formule latine de salutation « Salve ! » ?",
        "options": ["Bonjour / Salut", "Au revoir", "À l'attaque", "Merci"],
        "bonne": 0,
    },
    {
        "q": "Combien font les chiffres romains : X + V ?",
        "options": ["15", "10", "5", "50"],
        "bonne": 0,
    },
]


class TaverneAleaWindow(tk.Toplevel):
    """Fenêtre de la Taverne Romaine des Dés et du Rituel Quotidien."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.title("🎲 Taverne « Alea Iacta Est » — Les Dés de la Fortune")
        self.geometry("860x650")
        self.minsize(780, 560)

        self.C = getattr(app, "C", {
            "bg": "#1e1b18",
            "panel": "#2d2722",
            "editor": "#3a322b",
            "fg": "#f5efe6",
            "muted": "#a89f91",
            "accent": "#d4af37",
            "heading": "#e6c65c",
            "ok": "#10b981",
        })
        self.sombre = est_sombre(getattr(app, "theme_name", "dark"))
        self.configure(bg=self.C["bg"])

        self.en_animation = False
        self.valeurs_des = [1, 3, 4, 6]  # Valeur de départ (Le Coup de Vénus)

        self._creer_interface()
        self._dessiner_table()
        self._actualiser_statut_lancer()

    def _creer_interface(self):
        C = self.C

        # Liseré impérial doré
        tk.Frame(self, bg="#d4af37", height=5).pack(fill=tk.X, side=tk.TOP)

        # 1. En-tête de la Taverne Romaine
        hdr = tk.Frame(self, bg=C["panel"], padx=18, pady=10)
        hdr.pack(fill=tk.X, side=tk.TOP)

        titre_box = tk.Frame(hdr, bg=C["panel"])
        titre_box.pack(side=tk.LEFT)
        tk.Label(
            titre_box,
            text="🎲 TABERNA FORTUNAE · ALEA IACTA EST",
            font=police_titre(14, gras=True),
            bg=C["panel"],
            fg=C["heading"],
        ).pack(anchor="w")
        tk.Label(
            titre_box,
            text="Taverne de la Subura · Lance les 4 osselets sacrés pour invoquer la grâce des Dieux",
            font=police_corps(9, italique=True),
            bg=C["panel"],
            fg=C["muted"],
        ).pack(anchor="w")

        # Affichage Sesterces et Bouclier de Streak du joueur
        stats_box = tk.Frame(hdr, bg=C["panel"])
        stats_box.pack(side=tk.RIGHT)

        self.lbl_sesterces = tk.Label(
            stats_box,
            text=f"🪙 {self.app.data.get('sesterces', 0)} Sesterces",
            font=police_corps(10, gras=True),
            bg=C["editor"],
            fg="#d4af37",
            padx=10,
            pady=4,
            relief="flat",
        )
        self.lbl_sesterces.pack(side=tk.LEFT, padx=4)

        bouclier_actif = self.app.data.get("streak_protege", False)
        self.lbl_bouclier = tk.Label(
            stats_box,
            text="🛡️ Bouclier : ACTIF" if bouclier_actif else "🛡️ Bouclier : Inactif",
            font=police_corps(9, gras=True),
            bg=C["editor"],
            fg=C["ok"] if bouclier_actif else C["muted"],
            padx=8,
            pady=4,
            relief="flat",
        )
        self.lbl_bouclier.pack(side=tk.LEFT, padx=4)

        # 2. Canvas de la Table de Taverne en Bois Massif et Feutrine
        self.canvas = tk.Canvas(
            self,
            bg="#18130e",
            highlightthickness=2,
            highlightbackground="#5c4326",
            height=320,
        )
        self.canvas.pack(fill=tk.BOTH, expand=True, padx=18, pady=10)
        self.canvas.bind("<Configure>", lambda _e: self._dessiner_table())

        # 3. Zone d'Actions & Résultat
        zone_bas = tk.Frame(self, bg=C["bg"], padx=18, pady=8)
        zone_bas.pack(fill=tk.X, side=tk.BOTTOM)

        # Bandeau de résultat
        self.lbl_resultat_titre = tk.Label(
            zone_bas,
            text="Prépare le cornet en cuir (fritillus) et lance les 4 dés !",
            font=police_titre(12, gras=True),
            bg=C["bg"],
            fg=C["heading"],
        )
        self.lbl_resultat_titre.pack(pady=(0, 2))

        self.lbl_resultat_gain = tk.Label(
            zone_bas,
            text="",
            font=police_corps(10, gras=True),
            bg=C["bg"],
            fg=C["ok"],
        )
        self.lbl_resultat_gain.pack(pady=(0, 8))

        # Boutons d'action
        btn_bar = tk.Frame(zone_bas, bg=C["bg"])
        btn_bar.pack(pady=4)

        self.btn_lancer = tk.Button(
            btn_bar,
            text="🎲 LANCER LES DÉS (Gratuit aujourd'hui)",
            font=police_corps(11, gras=True),
            bg="#d4af37",
            fg="#1a1409",
            relief="flat",
            cursor="hand2",
            padx=18,
            pady=8,
            command=self._declencher_lancer,
        )
        self.btn_lancer.pack(side=tk.LEFT, padx=6)

        btn_regles = tk.Button(
            btn_bar,
            text="📜 Règles Antiques",
            font=police_corps(10),
            bg=C["panel"],
            fg=C["fg"],
            relief="flat",
            cursor="hand2",
            padx=12,
            pady=8,
            command=self._afficher_regles,
        )
        btn_regles.pack(side=tk.LEFT, padx=6)

    def _actualiser_statut_lancer(self):
        """Vérifie si le lancer gratuit quotidien est disponible."""
        auj = date.today().isoformat()
        dernier = self.app.data.get("dernier_alea_date")
        if dernier == auj:
            self.btn_lancer.configure(
                text="🎲 RELANCER LES DÉS (15 Sesterces 🪙)",
                bg="#991b1b",
                fg="#ffffff",
            )
        else:
            self.btn_lancer.configure(
                text="🎲 LANCER GRATUIT DU JOUR (Bonus Diurnum)",
                bg="#d4af37",
                fg="#1a1409",
            )

    def _dessiner_table(self):
        """Dessine la table en bois de taverne et les 4 dés sur le canvas."""
        cv = self.canvas
        cv.delete("all")
        w = cv.winfo_width()
        h = cv.winfo_height()
        if w <= 10 or h <= 10:
            w = 820
            h = 340

        # Texture de la table en bois avec lattes
        cv.create_rectangle(0, 0, w, h, fill="#231911", outline="")
        for y in range(0, h, 28):
            cv.create_line(0, y, w, y, fill="#1c130c", width=2)
            cv.create_line(0, y + 1, w, y + 1, fill="#2d2117", width=1)

        # Tapis de feutrine romaine ovale au centre
        pad_x = 60
        pad_y = 30
        cv.create_oval(pad_x, pad_y, w - pad_x, h - pad_y, fill="#4a151b", outline="#8e2b34", width=4)
        cv.create_oval(pad_x + 6, pad_y + 6, w - pad_x - 6, h - pad_y - 6, fill="", outline="#d4af37", width=1)

        # Dessiner le cornet en cuir antique (fritillus) à gauche
        cx_cornet = pad_x + 80
        cy_cornet = h // 2
        cv.create_polygon(
            cx_cornet - 35, cy_cornet - 50,
            cx_cornet + 35, cy_cornet - 50,
            cx_cornet + 22, cy_cornet + 55,
            cx_cornet - 22, cy_cornet + 55,
            fill="#5a3d28", outline="#2b1a10", width=3, smooth=True
        )
        cv.create_line(cx_cornet - 30, cy_cornet - 15, cx_cornet + 30, cy_cornet - 15, fill="#d4af37", width=3)
        cv.create_text(cx_cornet, cy_cornet + 15, text="FRITILLUS", fill="#d4af37", font=police_corps(7, gras=True))

        # Dessiner les 4 dés romains 3D
        centre_x = (w + pad_x + 60) // 2
        largeur_de = 68
        espacement = 88
        depart_x = centre_x - int(1.5 * espacement)
        centre_y = h // 2

        for i, val in enumerate(self.valeurs_des):
            dx = depart_x + i * espacement
            dy = centre_y
            self._dessiner_de_romain(cv, dx, dy, largeur_de, val)

    def _dessiner_de_romain(self, cv, x, y, taille, valeur):
        """Dessine un dé antique 3D avec ombre et chiffre romain en relief."""
        demi = taille // 2

        # Ombre portée du dé
        cv.create_oval(x - demi, y + demi - 6, x + demi + 12, y + demi + 16, fill="#130b08", outline="")

        # Face principale en ivoire patiné ou marbre
        cv.create_rectangle(
            x - demi, y - demi, x + demi, y + demi,
            fill="#fcfbf7", outline="#c5bca8", width=3
        )
        # Biseau supérieur et gauche pour effet 3D
        cv.create_line(x - demi + 2, y - demi + 2, x + demi - 2, y - demi + 2, fill="#ffffff", width=2)
        cv.create_line(x - demi + 2, y - demi + 2, x - demi + 2, y + demi - 2, fill="#ffffff", width=2)
        # Biseau inférieur et droit plus sombre
        cv.create_line(x - demi + 2, y + demi - 2, x + demi - 2, y + demi - 2, fill="#a89f8c", width=2)
        cv.create_line(x + demi - 2, y - demi + 2, x + demi - 2, y + demi - 2, fill="#a89f8c", width=2)

        # Chiffre romain gravé en or / pourpre
        chiffre = CHIFFRES_ROMAINS.get(valeur, str(valeur))
        cv.create_text(
            x, y,
            text=chiffre,
            font=police_titre(18, gras=True),
            fill="#8b1e28",
        )

    def _declencher_lancer(self):
        """Vérifie l'éligibilité et démarre le roulement des dés."""
        if self.en_animation:
            return

        auj = date.today().isoformat()
        dernier = self.app.data.get("dernier_alea_date")
        gratuit = (dernier != auj)

        if not gratuit:
            sesterces = self.app.data.get("sesterces", 0)
            if sesterces < 15:
                messagebox.showinfo(
                    "Taverne Romaine",
                    f"Il te faut 15 Sesterces pour relancer les dés aujourd'hui.\n"
                    f"Tu as actuellement {sesterces} Sesterces 🪙.\n"
                    f"Reviens demain pour ton lancer gratuit ou gagne des leçons !",
                )
                return
            self.app.ajouter_sesterces(-15)
            self.lbl_sesterces.configure(text=f"🪙 {self.app.data.get('sesterces', 0)} Sesterces")

        # Marquer la date du jour
        self.app.data["dernier_alea_date"] = auj
        self.app.data["historique_alea"] = self.app.data.get("historique_alea", 0) + 1
        from app import progress as prog
        prog.save_progress(self.app.data)

        self._actualiser_statut_lancer()
        self._animer_lancer(0)

    def _animer_lancer(self, etape):
        """Anime le secouement du gobelet et le roulement des dés."""
        self.en_animation = True
        total_etapes = 10

        if etape < total_etapes:
            # Sons de roulement de dés
            if etape % 3 == 0:
                audio.play_dice()

            # Changement aléatoire temporaire des faces
            self.valeurs_des = [random.randint(1, 6) for _ in range(4)]
            self._dessiner_table()
            self.after(60, lambda: self._animer_lancer(etape + 1))
        else:
            self.en_animation = False
            # Tirage final
            self.valeurs_des = [random.randint(1, 6) for _ in range(4)]
            self._dessiner_table()
            self._evaluer_resultat()

    def _evaluer_resultat(self):
        """Évalue la combinaison romaine obtenue et attribue les récompenses."""
        des = sorted(self.valeurs_des)
        faces_distinctes = set(des)

        # 1. Iactus Venereus (Coup de Vénus) : 4 faces toutes différentes
        if len(faces_distinctes) == 4:
            audio.play_triumph_grand()
            self.lbl_resultat_titre.configure(
                text="👑 IACTUS VENEREUS ! LE COUP DE VÉNUS !",
                fg="#f59e0b",
            )
            # Gains : 50 Sesterces + Bouclier de Streak
            self.app.ajouter_sesterces(50)
            self.app.data["streak_protege"] = True
            from app import progress as prog
            prog.save_progress(self.app.data)

            self.lbl_resultat_gain.configure(
                text="Grand Triomphe des Dieux ! +50 Sesterces 🪙 et 🛡️ Protection de Streak activée !",
                fg="#10b981",
            )
            self.lbl_bouclier.configure(text="🛡️ Bouclier : ACTIF", fg=self.C["ok"])
            if hasattr(self.app, "reagir_succes"):
                self.app.reagir_succes("Par Vénus ! Un lancer d'une grâce divine !")

        # 2. Canis (Coup du Chien) : 4 As (1, 1, 1, 1)
        elif des == [1, 1, 1, 1]:
            audio.play_wrong()
            self.lbl_resultat_titre.configure(
                text="🐶 CANIS ! LE COUP DU CHIEN !",
                fg="#ef4444",
            )
            self.lbl_resultat_gain.configure(
                text="Malchance... 4 As ! Mais Mercure t'accorde une seconde chance : Défi de Rédemption !",
                fg="#f59e0b",
            )
            self.after(800, self._lancer_defi_mercure)

        # 3. Senatus (Coup du Sénateur) : Brelan ou Doubles paires
        elif any(des.count(x) >= 3 for x in des) or len(faces_distinctes) <= 2:
            audio.play_coin()
            self.lbl_resultat_titre.configure(
                text="🏛️ SENATUS ! LE COUP DU SÉNATEUR !",
                fg="#38bdf8",
            )
            self.app.ajouter_sesterces(25)
            self.lbl_resultat_gain.configure(
                text="L'autorité du Sénat récompense ta constance : +25 Sesterces 🪙 !",
                fg="#10b981",
            )
            if hasattr(self.app, "reagir_succes"):
                self.app.reagir_succes("Une combinaison digne des nobles patres du Sénat !")

        # 4. Plebeius (Coup du Plébéien) : Lancer standard
        else:
            somme = sum(des)
            audio.play_coin()
            self.lbl_resultat_titre.configure(
                text="🏺 PLEBEIUS · LE COUP DU CITOYEN",
                fg=self.C["fg"],
            )
            self.app.ajouter_sesterces(somme)
            self.lbl_resultat_gain.configure(
                text=f"La fortune populaire te sourit : +{somme} Sesterces 🪙 (somme des dés) !",
                fg="#10b981",
            )

        self.lbl_sesterces.configure(text=f"🪙 {self.app.data.get('sesterces', 0)} Sesterces")

    def _lancer_defi_mercure(self):
        """Ouvre un dialogue de défi de Mercure pour transformer le Coup du Chien en succès."""
        defi = random.choice(QUESTIONS_CHIEN)
        win = tk.Toplevel(self)
        win.title("⚡ Défi de Mercure — La Rédemption Romaine")
        win.geometry("520x360")
        win.configure(bg=self.C["panel"])
        win.transient(self)
        win.grab_set()

        tk.Label(
            win,
            text="⚡ DÉFI DE MERCURE",
            font=police_titre(12, gras=True),
            bg=self.C["panel"],
            fg="#d4af37",
        ).pack(pady=(14, 4))

        tk.Label(
            win,
            text="Mercure te tend son caducée ! Réponds juste pour inverser le sort\net remporter +30 Sesterces 🪙 au lieu de la défaite :",
            font=police_corps(9),
            bg=self.C["panel"],
            fg=self.C["fg"],
            wraplength=460,
            justify="center",
        ).pack(pady=(0, 10))

        tk.Label(
            win,
            text=f"« {defi['q']} »",
            font=police_corps(11, gras=True),
            bg=self.C["panel"],
            fg=self.C["heading"],
            wraplength=460,
            justify="center",
        ).pack(pady=6)

        opts_frame = tk.Frame(win, bg=self.C["panel"])
        opts_frame.pack(fill=tk.X, padx=24, pady=10)

        def _repondre(choix_idx):
            if choix_idx == defi["bonne"]:
                audio.play_correct()
                self.app.ajouter_sesterces(30)
                self.lbl_sesterces.configure(text=f"🪙 {self.app.data.get('sesterces', 0)} Sesterces")
                self.lbl_resultat_gain.configure(
                    text="⚡ Défi de Mercure RÉUSSI ! Tu remportes +30 Sesterces 🪙 !",
                    fg="#10b981",
                )
                messagebox.showinfo("Mercure te sourit !", "Optime ! Tu as vaincu la malédiction du Chien !")
            else:
                audio.play_wrong()
                self.lbl_resultat_gain.configure(
                    text="Défi de Mercure manqué. Les dieux te testeront à nouveau demain !",
                    fg="#ef4444",
                )
            win.destroy()

        for i, opt in enumerate(defi["options"]):
            btn = tk.Button(
                opts_frame,
                text=opt,
                font=police_corps(10),
                bg=self.C["editor"],
                fg=self.C["fg"],
                relief="flat",
                cursor="hand2",
                pady=6,
                command=lambda idx=i: _repondre(idx),
            )
            btn.pack(fill=tk.X, pady=3)

    def _afficher_regles(self):
        """Affiche les règles historiques des dés romains."""
        msg = (
            "🏛️ RÈGLES DES DÉS ROMAINS (Alea / Tesserae) :\n\n"
            "Dans l'Antiquité, les Romains lançaient 4 osselets ou dés dans un cornet (fritillus) :\n\n"
            "👑 Le Coup de Vénus (Iactus Venereus) :\n"
            "Quatre faces différentes (ex: I, III, IV, VI). C'était le lancer le plus noble et chanceux !\n"
            "-> Gain : +50 Sesterces 🪙 et 1 Bouclier de Streak anti-oubli !\n\n"
            "🏛️ Le Coup du Sénateur (Senatus) :\n"
            "Au moins 3 dés identiques ou deux paires.\n"
            "-> Gain : +25 Sesterces 🪙.\n\n"
            "🐶 Le Coup du Chien (Canis) :\n"
            "Quatre As (1, 1, 1, 1). Considéré comme le pire lancer... mais Mercure te propose un quiz pour transformer l'échec en +30 Sesterces !\n\n"
            "🏺 Le Coup du Plébéien (Plebeius) :\n"
            "Tout autre tirage. Tu reçois la somme de tes dés en Sesterces !"
        )
        messagebox.showinfo("Règles des Dés Romains", msg, parent=self)
