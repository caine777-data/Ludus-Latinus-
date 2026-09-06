"""
Module de l'Atelier Secret : « Le Chiffre de César » (Cryptographie Militaire Romaine).
Comprend une double roue cryptographique interactive, des missions de déchiffrement historiques
et un atelier libre pour crypter/décrypter des messages secrets entre élèves.
"""

import math
import tkinter as tk

from app import audio
from app.polices import police_corps, police_titre

ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

MISSIONS_CESAR = [
    {
        "titre": "Mission 1 : Le Message à Quintus Cicéron",
        "contexte": "Gaule, 54 av. J.-C. Les Nerviens encerclent le camp romain. César envoie un message crypté avec la clé classique (+3).",
        "cle": 3,
        "chiffre": "FDHVDU TXLQWR VDOXWHP GLFLW. OHJLRQHV DGIXWXUDH VXQW !",
        "clair_attendu": "CAESAR QUINTO SALUTEM DICIT. LEGIONES ADFUTURAE SUNT !",
        "traduction": "César salue Quintus. Les légions arrivent à la rescousse !",
        "gain": 20,
    },
    {
        "titre": "Mission 2 : Le Franchissement du Rubicon",
        "contexte": "Italie, 49 av. J.-C. César donne l'ordre irrévocable de traverser le fleuve frontière avec la clé (+5).",
        "cle": 5,
        "chiffre": "FQJF NFHYF JXY. WTRF SNYNIJY !",
        "clair_attendu": "ALEA IACTA EST. ROMA NITIDET !",
        "traduction": "Le sort en est jeté. Rome resplendit !",
        "gain": 25,
    },
    {
        "titre": "Mission 3 : La Victoire d'Alésia",
        "contexte": "Les lignes de circonvallation sont attaquées. César transmet la consigne suprême avec la clé (+4).",
        "cle": 4,
        "chiffre": "ZMVI UYMWUYI ERMQEW ! ZMGXSVME RMXMHIX !",
        "clair_attendu": "VIRE QUISQUE ANIMAS ! VICTORIA NITIDET !",
        "traduction": "Que chacun ranime son courage ! La victoire rayonne !",
        "gain": 30,
    },
]


def chiffrer_cesar(texte, cle=3):
    """Chiffre un texte avec l'algorithme du décalage de César."""
    if not texte:
        return ""
    resultat = []
    k = cle % 26
    for c in texte:
        if "A" <= c <= "Z":
            resultat.append(chr((ord(c) - ord("A") + k) % 26 + ord("A")))
        elif "a" <= c <= "z":
            resultat.append(chr((ord(c) - ord("a") + k) % 26 + ord("a")))
        else:
            resultat.append(c)
    return "".join(resultat)


def dechiffrer_cesar(texte, cle=3):
    """Déchiffre un texte avec l'algorithme du décalage de César."""
    return chiffrer_cesar(texte, -cle)


class ChiffreCesarWindow(tk.Toplevel):
    """Fenêtre de l'Atelier Cryptographique de César."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C

        self.title("📜 L'Atelier Secret : Le Chiffre de César — Ludus Latinus")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 900, 720, min_w=720, min_h=520)
        self.configure(bg=self.C["bg"])

        self.cle_actuelle = 3
        self.mission_idx = 0
        self.mode = "missions"  # "missions" ou "bacasable"

        self._build_ui()
        self._charger_mission()

    def _build_ui(self):
        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=14, pady=10)
        hdr.pack(fill=tk.X)

        left_hdr = tk.Frame(hdr, bg=self.C["panel"])
        left_hdr.pack(side=tk.LEFT)

        tk.Label(left_hdr, text="📜 L'ATELIER DU CHIFFRE DE CÉSAR", font=police_titre(15),
                 bg=self.C["panel"], fg="#ffd700").pack(anchor=tk.W)
        tk.Label(left_hdr, text="Décrypte les ordres secrets de Jules César à ses légions !",
                 font=police_corps(10, italique=True), bg=self.C["panel"], fg=self.C["muted"]).pack(anchor=tk.W)

        # Onglets de mode
        barre_modes = tk.Frame(self, bg=self.C["panel"], padx=10, pady=4)
        barre_modes.pack(fill=tk.X)

        self.btn_tab_missions = tk.Button(
            barre_modes, text="⚔️ Missions Militaires Secrètes", font=police_corps(9, gras=True),
            bg=self.C["accent"], fg=self.C["sel_fg"], relief="flat", padx=10, pady=3,
            command=lambda: self._basculer_mode("missions")
        )
        self.btn_tab_missions.pack(side=tk.LEFT, padx=4)

        self.btn_tab_bac = tk.Button(
            barre_modes, text="🛠️ Atelier Libre d'Encodage", font=police_corps(9),
            bg=self.C["editor"], fg=self.C["fg"], relief="flat", padx=10, pady=3,
            command=lambda: self._basculer_mode("bacasable")
        )
        self.btn_tab_bac.pack(side=tk.LEFT, padx=4)

        # Conteneur principal (Roue à gauche, Éditeur/Mission à droite)
        corps = tk.Frame(self, bg=self.C["bg"])
        corps.pack(fill=tk.BOTH, expand=True, padx=12, pady=10)

        # 1. Roue cryptographique interactive à gauche
        roue_box = tk.Frame(corps, bg=self.C["panel"], bd=2, relief="ridge", width=340, padx=10, pady=10)
        roue_box.pack(side=tk.LEFT, fill=tk.BOTH, padx=(0, 10))

        tk.Label(roue_box, text="ROUE CRYPTOGRAPHIQUE", font=police_titre(11),
                 bg=self.C["panel"], fg="#ffd700").pack(pady=(0, 6))

        self.canvas_roue = tk.Canvas(roue_box, width=280, height=280, bg="#1a1b26", highlightthickness=0)
        self.canvas_roue.pack(pady=4)

        # Contrôles de la clé de décalage
        ctrl_cle = tk.Frame(roue_box, bg=self.C["panel"])
        ctrl_cle.pack(fill=tk.X, pady=8)

        tk.Button(ctrl_cle, text="◀ -1", font=police_corps(10, gras=True),
                  bg=self.C["editor"], fg=self.C["fg"], padx=8, command=lambda: self._changer_cle(-1)).pack(side=tk.LEFT, padx=4)

        self.lbl_cle = tk.Label(ctrl_cle, text=f"Décalage : Clé +{self.cle_actuelle}",
                                font=police_titre(12), bg=self.C["panel"], fg="#ffd700")
        self.lbl_cle.pack(side=tk.LEFT, expand=True)

        tk.Button(ctrl_cle, text="+1 ▶", font=police_corps(10, gras=True),
                  bg=self.C["editor"], fg=self.C["fg"], padx=8, command=lambda: self._changer_cle(1)).pack(side=tk.RIGHT, padx=4)

        tk.Label(roue_box, text="Anneau extérieur : Lettre claire (A-Z)\nAnneau intérieur : Lettre chiffrée",
                 font=police_corps(8, italique=True), bg=self.C["panel"], fg=self.C["muted"]).pack()

        # 2. Zone droite (Missions ou Bac à sable)
        self.droite_frame = tk.Frame(corps, bg=self.C["panel"], bd=2, relief="ridge", padx=16, pady=12)
        self.droite_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        # --- Vue Missions ---
        self.mission_box = tk.Frame(self.droite_frame, bg=self.C["panel"])
        self.mission_box.pack(fill=tk.BOTH, expand=True)

        self.lbl_mis_titre = tk.Label(self.mission_box, text="", font=police_titre(13), bg=self.C["panel"], fg="#ffd700")
        self.lbl_mis_titre.pack(anchor=tk.W)

        self.lbl_mis_contexte = tk.Label(self.mission_box, text="", font=police_corps(9, italique=True),
                                         bg=self.C["panel"], fg="#dcd6cd", wraplength=440, justify=tk.LEFT)
        self.lbl_mis_contexte.pack(anchor=tk.W, pady=4)

        tk.Label(self.mission_box, text="📜 Message intercepté (Chiffré) :", font=police_corps(10, gras=True),
                 bg=self.C["panel"], fg="#e74c3c").pack(anchor=tk.W, pady=(8, 2))

        self.txt_chiffre = tk.Label(self.mission_box, text="", font=("Palatino Linotype", 12, "bold"),
                                    bg="#181a24", fg="#f1c40f", bd=2, relief="sunken", padx=10, pady=8,
                                    wraplength=440, justify=tk.LEFT)
        self.txt_chiffre.pack(fill=tk.X, pady=4)

        tk.Label(self.mission_box, text="✏️ Ta traduction / Déchiffrement :", font=police_corps(10, gras=True),
                 bg=self.C["panel"], fg=self.C["fg"]).pack(anchor=tk.W, pady=(8, 2))

        self.entree_dechiffre = tk.Entry(self.mission_box, font=("Palatino Linotype", 11), bg="#1f2335", fg="#ffffff")
        self.entree_dechiffre.pack(fill=tk.X, pady=4)

        # Bouton appliquer automatiquement la clé de la roue
        btn_action_cle = tk.Button(
            self.mission_box, text="⚡ Appliquer le décalage de la roue", font=police_corps(9),
            bg=self.C["editor"], fg=self.C["fg"], padx=8, pady=3, command=self._appliquer_cle_roue
        )
        btn_action_cle.pack(anchor=tk.W, pady=4)

        self.btn_valider_mission = tk.Button(
            self.mission_box, text="✓ Valider le Décodage de l'Ordre", font=police_titre(11),
            bg="#27ae60", fg="#ffffff", padx=14, pady=6, cursor="hand2", command=self._verifier_mission
        )
        self.btn_valider_mission.pack(pady=10)

        self.lbl_feedback_mission = tk.Label(self.mission_box, text="", font=police_corps(10, gras=True), bg=self.C["panel"])
        self.lbl_feedback_mission.pack()

        # --- Vue Bac à sable ---
        self.bac_box = tk.Frame(self.droite_frame, bg=self.C["panel"])

        tk.Label(self.bac_box, text="🛠️ ATELIER LIBRE DE CRYPTOGRAPHIE", font=police_titre(13),
                 bg=self.C["panel"], fg="#ffd700").pack(anchor=tk.W, pady=(0, 6))

        tk.Label(self.bac_box, text="Tape ton texte clair en latin ou en français :", font=police_corps(10),
                 bg=self.C["panel"], fg=self.C["fg"]).pack(anchor=tk.W)

        self.txt_bac_clair = tk.Text(self.bac_box, height=4, font=("Georgia", 11), bg="#1f2335", fg="#ffffff")
        self.txt_bac_clair.insert(tk.END, "AVE CAESAR MORITURI TE SALUTANT")
        self.txt_bac_clair.pack(fill=tk.X, pady=4)

        btn_chiffrer = tk.Button(self.bac_box, text="🔒 Chiffrer avec la Clé", font=police_corps(10, gras=True),
                                 bg=self.C["accent"], fg=self.C["sel_fg"], padx=10, pady=4, command=self._chiffrer_libre)
        btn_chiffrer.pack(anchor=tk.W, pady=4)

        tk.Label(self.bac_box, text="Message Chiffré généré :", font=police_corps(10, gras=True),
                 bg=self.C["panel"], fg="#ffd700").pack(anchor=tk.W, pady=(6, 2))

        self.txt_bac_chiffre = tk.Text(self.bac_box, height=4, font=("Palatino Linotype", 11, "bold"), bg="#181a24", fg="#f1c40f")
        self.txt_bac_chiffre.pack(fill=tk.X, pady=4)

        self._dessiner_roue()

    def _dessiner_roue(self):
        """Dessine les deux anneaux concentriques de la roue de César."""
        cv = self.canvas_roue
        cv.delete("all")

        cx, cy = 140, 140
        r_ext = 125
        r_int = 85
        r_centre = 45

        # Anneau externe bronze
        cv.create_oval(cx - r_ext, cy - r_ext, cx + r_ext, cy + r_ext, fill="#4a2c11", outline="#d4af37", width=3)
        # Anneau interne or
        cv.create_oval(cx - r_int, cy - r_int, cx + r_int, cy + r_int, fill="#d4af37", outline="#241405", width=2)
        # Moyeu central
        cv.create_oval(cx - r_centre, cy - r_centre, cx + r_centre, cy + r_centre, fill="#241405", outline="#ffd700", width=2)
        cv.create_text(cx, cy, text="SPQR", fill="#ffd700", font=("Palatino Linotype", 10, "bold"))

        # Lettres anneau extérieur (Clair : A-Z fixe)
        for i, lettre in enumerate(ALPHABET):
            angle = (i * (2 * math.pi / 26)) - (math.pi / 2)
            lx = cx + math.cos(angle) * (r_ext - 16)
            ly = cy + math.sin(angle) * (r_ext - 16)
            cv.create_text(lx, ly, text=lettre, fill="#ffffff", font=("Palatino Linotype", 9, "bold"))

        # Lettres anneau intérieur (Chiffré : décalé de la clé)
        for i in range(26):
            lettre_chiffree = ALPHABET[(i + self.cle_actuelle) % 26]
            angle = (i * (2 * math.pi / 26)) - (math.pi / 2)
            lx = cx + math.cos(angle) * (r_int - 16)
            ly = cy + math.sin(angle) * (r_int - 16)
            cv.create_text(lx, ly, text=lettre_chiffree, fill="#1a1b26", font=("Palatino Linotype", 8, "bold"))

    def _changer_cle(self, delta):
        self.cle_actuelle = (self.cle_actuelle + delta - 1) % 25 + 1
        self.lbl_cle.configure(text=f"Décalage : Clé +{self.cle_actuelle}")
        self._dessiner_roue()
        audio.play_coin()

    def _basculer_mode(self, mode):
        self.mode = mode
        if mode == "missions":
            self.btn_tab_missions.configure(bg=self.C["accent"], fg=self.C["sel_fg"])
            self.btn_tab_bac.configure(bg=self.C["editor"], fg=self.C["fg"])
            self.bac_box.pack_forget()
            self.mission_box.pack(fill=tk.BOTH, expand=True)
            self._charger_mission()
        else:
            self.btn_tab_missions.configure(bg=self.C["editor"], fg=self.C["fg"])
            self.btn_tab_bac.configure(bg=self.C["accent"], fg=self.C["sel_fg"])
            self.mission_box.pack_forget()
            self.bac_box.pack(fill=tk.BOTH, expand=True)
            self._chiffrer_libre()

    def _charger_mission(self):
        m = MISSIONS_CESAR[self.mission_idx]
        self.lbl_mis_titre.configure(text=m["titre"])
        self.lbl_mis_contexte.configure(text=m["contexte"])
        self.txt_chiffre.configure(text=m["chiffre"])
        self.entree_dechiffre.delete(0, tk.END)
        self.lbl_feedback_mission.configure(text="")

    def _appliquer_cle_roue(self):
        m = MISSIONS_CESAR[self.mission_idx]
        dechiffre = dechiffrer_cesar(m["chiffre"], self.cle_actuelle)
        self.entree_dechiffre.delete(0, tk.END)
        self.entree_dechiffre.insert(0, dechiffre)

    def _verifier_mission(self):
        m = MISSIONS_CESAR[self.mission_idx]
        saisie = self.entree_dechiffre.get().strip().upper()
        if saisie == m["clair_attendu"]:
            audio.play_fanfare()
            self.lbl_feedback_mission.configure(
                text=f"✓ Décodage Parfait ! Traduction : « {m['traduction']} »\n+ {m['gain']} Sesterces !",
                fg="#2ecc71"
            )
            self.app.ajouter_sesterces(m["gain"])
            if self.mission_idx < len(MISSIONS_CESAR) - 1:
                self.after(2200, self._mission_suivante)
            else:
                self.lbl_feedback_mission.configure(
                    text="🏆 Toutes les missions militaires secrètes de César ont été déjouées !",
                    fg="#ffd700"
                )
        else:
            audio.play_wrong()
            self.lbl_feedback_mission.configure(
                text="Ce n'est pas tout à fait le bon message. Règle la roue sur la clé de l'ordre !",
                fg="#e74c3c"
            )

    def _mission_suivante(self):
        self.mission_idx += 1
        self._charger_mission()

    def _chiffrer_libre(self):
        texte = self.txt_bac_clair.get("1.0", tk.END).strip()
        chiffre = chiffrer_cesar(texte, self.cle_actuelle)
        self.txt_bac_chiffre.delete("1.0", tk.END)
        self.txt_bac_chiffre.insert(tk.END, chiffre)
        audio.play_parchemin()
