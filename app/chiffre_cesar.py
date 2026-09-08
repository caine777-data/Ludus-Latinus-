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
        from app.theme import THEMES, est_sombre
        self.C = getattr(app, "C", None) or THEMES["Rome Impériale"]

        self.title("📜 L'Atelier Secret : Le Chiffre de César — Ludus Latinus")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 900, 720, min_w=720, min_h=520)

        bg_def = self.C.get("bg", "#faf4e8")
        self.configure(bg=bg_def)

        self.sombre = est_sombre(bg_def)
        self.c_panel = self.C.get("panel", "#ffffff")
        self.c_editor = self.C.get("editor", "#f8f5ee")
        self.c_card = "#1a1b26" if self.sombre else "#ffffff"
        self.c_saisie = "#181a24" if self.sombre else "#fcf8f0"
        self.c_fg_primary = "#ffffff" if self.sombre else self.C.get("fg", "#222222")
        self.c_fg_accent = "#ffd700" if self.sombre else self.C.get("heading", "#7c1d1d")

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
                 bg=self.C["panel"], fg=self.c_fg_accent).pack(anchor=tk.W)
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
                 bg=self.C["panel"], fg=self.c_fg_accent).pack(pady=(0, 6))

        self.canvas_roue = tk.Canvas(roue_box, width=280, height=280, bg=self.C["panel"], highlightthickness=0)
        self.canvas_roue.pack(pady=4)

        # Contrôles de la clé de décalage
        ctrl_cle = tk.Frame(roue_box, bg=self.C["panel"])
        ctrl_cle.pack(fill=tk.X, pady=8)

        tk.Button(ctrl_cle, text="◀ -1", font=police_corps(10, gras=True),
                  bg=self.C["editor"], fg=self.C["fg"], padx=8, command=lambda: self._changer_cle(-1)).pack(side=tk.LEFT, padx=4)

        self.lbl_cle = tk.Label(ctrl_cle, text=f"Décalage : Clé +{self.cle_actuelle}",
                                font=police_titre(12), bg=self.C["panel"], fg=self.c_fg_accent)
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

        self.lbl_mis_titre = tk.Label(self.mission_box, text="", font=police_titre(13), bg=self.C["panel"], fg=self.c_fg_accent)
        self.lbl_mis_titre.pack(anchor=tk.W)

        self.lbl_mis_contexte = tk.Label(self.mission_box, text="", font=police_corps(9, italique=True),
                                         bg=self.C["panel"], fg=self.C["fg"], wraplength=440, justify=tk.LEFT)
        self.lbl_mis_contexte.pack(anchor=tk.W, pady=4)

        tk.Label(self.mission_box, text="📜 Message intercepté (Chiffré) :", font=police_corps(10, gras=True),
                 bg=self.C["panel"], fg="#e74c3c" if self.sombre else "#c0392b").pack(anchor=tk.W, pady=(8, 2))

        self.txt_chiffre = tk.Label(self.mission_box, text="", font=("Palatino Linotype", 12, "bold"),
                                    bg=self.c_saisie, fg="#ffd700" if self.sombre else "#8c1d1d",
                                    bd=2, relief="sunken", padx=10, pady=8,
                                    wraplength=440, justify=tk.LEFT)
        self.txt_chiffre.pack(fill=tk.X, pady=4)

        tk.Label(self.mission_box, text="✏️ Ta traduction / Déchiffrement :", font=police_corps(10, gras=True),
                 bg=self.C["panel"], fg=self.C["fg"]).pack(anchor=tk.W, pady=(8, 2))

        self.entree_dechiffre = tk.Entry(self.mission_box, font=("Palatino Linotype", 11),
                                         bg=self.c_card, fg=self.c_fg_primary,
                                         insertbackground=self.c_fg_primary, relief="groove", bd=2)
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
                 bg=self.C["panel"], fg=self.c_fg_accent).pack(anchor=tk.W, pady=(0, 6))

        tk.Label(self.bac_box, text="Tape ton texte clair en latin ou en français :", font=police_corps(10),
                 bg=self.C["panel"], fg=self.C["fg"]).pack(anchor=tk.W)

        self.txt_bac_clair = tk.Text(self.bac_box, height=4, font=("Georgia", 11),
                                     bg=self.c_card, fg=self.c_fg_primary,
                                     insertbackground=self.c_fg_primary, relief="groove", bd=2)
        self.txt_bac_clair.insert(tk.END, "AVE CAESAR MORITURI TE SALUTANT")
        self.txt_bac_clair.pack(fill=tk.X, pady=4)

        btn_chiffrer = tk.Button(self.bac_box, text="🔒 Chiffrer avec la Clé", font=police_corps(10, gras=True),
                                 bg=self.C["accent"], fg=self.C["sel_fg"], padx=10, pady=4, command=self._chiffrer_libre)
        btn_chiffrer.pack(anchor=tk.W, pady=4)

        tk.Label(self.bac_box, text="Message Chiffré généré :", font=police_corps(10, gras=True),
                 bg=self.C["panel"], fg=self.c_fg_accent).pack(anchor=tk.W, pady=(6, 2))

        self.txt_bac_chiffre = tk.Text(self.bac_box, height=4, font=("Palatino Linotype", 11, "bold"),
                                       bg=self.c_saisie, fg="#ffd700" if self.sombre else "#8c1d1d",
                                       relief="sunken", bd=2)
        self.txt_bac_chiffre.pack(fill=tk.X, pady=4)

        self._dessiner_roue()

    def _dessiner_roue(self):
        """Dessine les deux anneaux concentriques de la roue de César avec rendu antique patiné."""
        cv = self.canvas_roue
        cv.delete("all")

        cx, cy = 140, 140
        r_ext = 125
        r_int = 86
        r_centre = 46

        # Ombre portée de la roue
        cv.create_oval(cx - r_ext + 4, cy - r_ext + 4, cx + r_ext + 4, cy + r_ext + 4,
                       fill="#0c0d12" if self.sombre else "#d0c5b4", outline="")

        # Anneau externe bronze patiné
        c_bronze = "#3b2210" if self.sombre else "#5c3a1e"
        cv.create_oval(cx - r_ext, cy - r_ext, cx + r_ext, cy + r_ext, fill=c_bronze, outline="#c59b27", width=3)

        # Filet gravé sur anneau externe
        cv.create_oval(cx - r_ext + 6, cy - r_ext + 6, cx + r_ext - 6, cy + r_ext - 6, fill="", outline="#e6c35c", width=1)

        # Anneau interne laiton/or patiné
        c_laiton = "#c59b27" if self.sombre else "#dfb94a"
        cv.create_oval(cx - r_int, cy - r_int, cx + r_int, cy + r_int, fill=c_laiton, outline="#2b180a", width=2)
        cv.create_oval(cx - r_int + 4, cy - r_int + 4, cx + r_int - 4, cy + r_int - 4, fill="", outline="#8a6b16", width=1)

        # Repères / rayons subtils entre les anneaux
        for i in range(26):
            ang = (i * (2 * math.pi / 26)) - (math.pi / 2) - (math.pi / 26)
            x1 = cx + math.cos(ang) * (r_int)
            y1 = cy + math.sin(ang) * (r_int)
            x2 = cx + math.cos(ang) * (r_ext)
            y2 = cy + math.sin(ang) * (r_ext)
            cv.create_line(x1, y1, x2, y2, fill="#7d4b24" if self.sombre else "#8a5830", width=1)

        # Moyeu central impérial
        cv.create_oval(cx - r_centre, cy - r_centre, cx + r_centre, cy + r_centre, fill="#1c0f06", outline="#ffd700", width=2)
        cv.create_text(cx, cy - 6, text="SPQR", fill="#ffd700", font=("Palatino Linotype", 10, "bold"))
        cv.create_text(cx, cy + 8, text="🦅", font=("Segoe UI Emoji", 10))

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
            lx = cx + math.cos(angle) * (r_int - 17)
            ly = cy + math.sin(angle) * (r_int - 17)
            cv.create_text(lx, ly, text=lettre_chiffree, fill="#1c0f06", font=("Palatino Linotype", 8, "bold"))

    def _changer_cle(self, delta):
        self.cle_actuelle = (self.cle_actuelle + delta - 1) % 25 + 1
        self.lbl_cle.configure(text=f"Décalage : Clé +{self.cle_actuelle}")
        self._dessiner_roue()
        audio.play_stylet()

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
            audio.speak_latin(m["clair_attendu"])
            self.lbl_feedback_mission.configure(
                text=f"✓ Décodage Parfait ! Traduction : « {m['traduction']} »\n+ {m['gain']} Sesterces !",
                fg="#2ecc71"
            )
            self.app.ajouter_sesterces(m["gain"])
            if hasattr(self.app, "_animer_confettis"):
                self.app._animer_confettis()
            try:
                from app.succes import incrementer_stat_succes
                incrementer_stat_succes(self.app, "cesar_resolus")
            except Exception:
                pass
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
        audio.play_stylet()
