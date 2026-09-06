"""
Vues interactives des exercices de latin pour Ludus Latinus.

Comprend :
- VuePuzzle : Reconstitution de phrase façon Duolingo (mots cliquables)
- VueTrou : Texte à trous ou terminaisons avec tolérance orthographique
- VueDecodeur : Le Décodeur de Cas (Sujet 🔵, COD 🔴, Verbe 🟢)
- VueArene : Combat de Boss contre un monstre ou un gladiateur
- VueOrdre : Remise en ordre des étapes ou phrases
"""

import random
import tkinter as tk
from tkinter import ttk

from app import audio, exercices_latin
from app.animations import declencher_pluie_sesterces, secousse_widget


class _VueBase:
    """Ce que toutes les vues d'exercices ont en commun."""

    def __init__(self, parent, app):
        self.app = app
        self.lecon = None
        self.frame = ttk.Frame(parent)
        self._zones_texte = []

    def tr(self, cle, **kw):
        return self.app.tr(cle, **kw)

    def appliquer_theme(self, C):
        for widget, role in self._zones_texte:
            fond = C["editor"] if role == "saisie" else C["console"]
            widget.configure(bg=fond, fg=C["fg"])
            if isinstance(widget, tk.Text):
                widget.configure(insertbackground=C["fg"])

    def afficher(self):
        self.frame.pack(fill=tk.BOTH, expand=True)

    def masquer(self):
        self.frame.pack_forget()


# ------------------------------------------------------------- 1. Vue Puzzle
class VuePuzzle(_VueBase):
    """Reconstitution de phrase façon Duolingo avec jetons de mots cliquables."""

    def __init__(self, parent, app):
        super().__init__(parent, app)
        f = self.frame
        self.mots_choisis = []
        self.mots_disponibles = []

        self.titre = ttk.Label(f, text="🧩 Reconstitue la traduction", style="Title.TLabel", wraplength=720)
        self.titre.pack(anchor="w", padx=16, pady=(12, 4))

        cadre_source = ttk.Frame(f)
        cadre_source.pack(anchor="w", padx=16, pady=(4, 10))
        self.source_lbl = ttk.Label(cadre_source, text="", font=(app.body.cget("family"), 13, "bold"))
        self.source_lbl.pack(side=tk.LEFT, padx=(0, 12))
        self.btn_audio = ttk.Button(cadre_source, text="🔊 Écouter", command=self._ecouter)
        self.btn_audio.pack(side=tk.LEFT)

        lbl_rep = ttk.Label(f, text="Ta proposition de traduction :", style="Muted.TLabel")
        lbl_rep.pack(anchor="w", padx=16, pady=(4, 2))
        self.cadre_reponse = tk.Frame(f, bg="#ffffff", bd=1, relief="solid", height=45)
        self.cadre_reponse.pack(fill=tk.X, padx=16, pady=(0, 10))

        lbl_banque = ttk.Label(f, text="Mots disponibles (clique pour ajouter) :", style="Muted.TLabel")
        lbl_banque.pack(anchor="w", padx=16, pady=(4, 2))
        self.cadre_banque = ttk.Frame(f)
        self.cadre_banque.pack(anchor="w", padx=16, pady=(0, 12))

        barre = ttk.Frame(f)
        barre.pack(anchor="w", padx=16, pady=6)
        self.btn_check = ttk.Button(barre, text="Vérifier", command=self.verifier, style="Primary.TButton")
        self.btn_check.pack(side=tk.LEFT, padx=(0, 8))
        self.btn_reset = ttk.Button(barre, text="Effacer", command=self.reinitialiser)
        self.btn_reset.pack(side=tk.LEFT)

        self.retour = ttk.Label(f, text="", style="TLabel", wraplength=720)
        self.retour.pack(anchor="w", padx=16, pady=8)

    def _ecouter(self):
        phrase = self.lecon.get("latin") or self.source_lbl.cget("text")
        audio.speak_latin(phrase)

    def charger(self, lecon):
        self.lecon = lecon
        self.source_lbl.configure(text=lecon.get("latin", lecon.get("enonce", "")))
        self.mots_choisis = []
        banque = list(lecon.get("mots", []))
        random.shuffle(banque)
        self.mots_disponibles = banque
        self.retour.configure(text="")
        self._redessiner()

    def _redessiner(self):
        for widget in self.cadre_reponse.winfo_children():
            widget.destroy()
        if not self.mots_choisis:
            ph = tk.Label(self.cadre_reponse, text="(Clique sur les mots ci-dessous pour former la phrase)",
                          fg="#888888", bg=self.cadre_reponse.cget("bg"))
            ph.pack(side=tk.LEFT, padx=10, pady=8)
        else:
            for idx, mot in enumerate(self.mots_choisis):
                b = tk.Button(self.cadre_reponse, text=mot, bg="#e3f2fd", fg="#0d47a1",
                              font=(self.app.body.cget("family"), 10, "bold"), relief="raised", bd=1,
                              padx=8, pady=4, cursor="hand2",
                              command=lambda i=idx: self._retirer_mot(i))
                b.pack(side=tk.LEFT, padx=4, pady=6)

        for widget in self.cadre_banque.winfo_children():
            widget.destroy()
        for idx, mot in enumerate(self.mots_disponibles):
            b = tk.Button(self.cadre_banque, text=mot, bg="#f5f5f5", fg="#333333",
                          font=(self.app.body.cget("family"), 10), relief="groove", bd=1,
                          padx=8, pady=4, cursor="hand2",
                          command=lambda i=idx: self._choisir_mot(i))
            b.pack(side=tk.LEFT, padx=4, pady=4)

    def _choisir_mot(self, idx):
        if 0 <= idx < len(self.mots_disponibles):
            mot = self.mots_disponibles.pop(idx)
            self.mots_choisis.append(mot)
            self._redessiner()

    def _retirer_mot(self, idx):
        if 0 <= idx < len(self.mots_choisis):
            mot = self.mots_choisis.pop(idx)
            self.mots_disponibles.append(mot)
            self._redessiner()

    def reinitialiser(self):
        if self.lecon:
            self.charger(self.lecon)

    def verifier(self):
        if not self.lecon:
            return
        solution = self.lecon.get("solution") or self.lecon.get("francais")
        reussi, msg = exercices_latin.verifier_puzzle(self.mots_choisis, solution)
        C = self.app.C
        if reussi:
            audio.play_correct()
            declencher_pluie_sesterces(self.app.root, count=12)
            self.retour.configure(text="✨ " + msg, foreground=C["ok"])
            self.app.valider_item(self.lecon["id"], "Traduction réussie ! +10 Sesterces 🪙")
            self.app.ajouter_sesterces(10)
        else:
            audio.play_wrong()
            self.retour.configure(text="❌ " + msg, foreground=C["err"])


# --------------------------------------------------------------- 2. Vue Trou
class VueTrou(_VueBase):
    """Texte à trous ou saisie de terminaison avec tolérance orthographique."""

    def __init__(self, parent, app):
        super().__init__(parent, app)
        f = self.frame
        self.titre = ttk.Label(f, text="✍️ Complète la phrase", style="Title.TLabel", wraplength=720)
        self.titre.pack(anchor="w", padx=16, pady=(12, 4))

        self.consigne = ttk.Label(f, text="", style="TLabel", wraplength=720)
        self.consigne.pack(anchor="w", padx=16, pady=(0, 8))

        cadre_phrase = ttk.Frame(f)
        cadre_phrase.pack(anchor="w", padx=16, pady=6)
        self.avant_lbl = ttk.Label(cadre_phrase, text="", font=(app.body.cget("family"), 12, "bold"))
        self.avant_lbl.pack(side=tk.LEFT)

        self.saisie = ttk.Entry(cadre_phrase, font=(app.body.cget("family"), 12, "bold"), width=14)
        self.saisie.pack(side=tk.LEFT, padx=6)
        self.saisie.bind("<Return>", lambda e: self.verifier())

        self.apres_lbl = ttk.Label(cadre_phrase, text="", font=(app.body.cget("family"), 12, "bold"))
        self.apres_lbl.pack(side=tk.LEFT)

        self.btn_audio = ttk.Button(cadre_phrase, text="🔊 Écouter", command=self._ecouter)
        self.btn_audio.pack(side=tk.LEFT, padx=12)

        # Lettres spéciales / accents
        cadre_accents = ttk.Frame(f)
        cadre_accents.pack(anchor="w", padx=16, pady=4)
        ttk.Label(cadre_accents, text="Lettres :", style="Muted.TLabel").pack(side=tk.LEFT, padx=(0, 6))
        for char in ("ā", "ē", "ī", "ō", "ū"):
            btn = ttk.Button(cadre_accents, text=char, width=3, command=lambda c=char: self._inserer_char(c))
            btn.pack(side=tk.LEFT, padx=2)

        barre = ttk.Frame(f)
        barre.pack(anchor="w", padx=16, pady=10)
        self.btn_check = ttk.Button(barre, text="Vérifier", command=self.verifier, style="Primary.TButton")
        self.btn_check.pack(side=tk.LEFT)

        self.retour = ttk.Label(f, text="", style="TLabel", wraplength=720)
        self.retour.pack(anchor="w", padx=16, pady=6)

    def _inserer_char(self, c):
        self.saisie.insert(tk.INSERT, c)
        self.saisie.focus_set()

    def _ecouter(self):
        phrase = self.lecon.get("latin_complet") or self.avant_lbl.cget("text")
        audio.speak_latin(phrase)

    def charger(self, lecon):
        self.lecon = lecon
        self.consigne.configure(text=lecon.get("consigne", "Complète avec la bonne réponse :"))
        self.avant_lbl.configure(text=lecon.get("avant", ""))
        self.apres_lbl.configure(text=lecon.get("apres", ""))
        self.saisie.delete(0, tk.END)
        self.retour.configure(text="")
        self.saisie.focus_set()

    def verifier(self):
        if not self.lecon:
            return
        proposition = self.saisie.get()
        solution = self.lecon.get("solution") or self.lecon.get("attendu")
        reussi, msg = exercices_latin.verifier_trou(proposition, solution)
        C = self.app.C
        if reussi:
            audio.play_correct()
            declencher_pluie_sesterces(self.app.root, count=12)
            self.retour.configure(text="✨ " + msg, foreground=C["ok"])
            self.app.valider_item(self.lecon["id"], "Exercice réussi ! +10 Sesterces 🪙")
            self.app.ajouter_sesterces(10)
        else:
            audio.play_wrong()
            self.retour.configure(text="❌ " + msg, foreground=C["err"])


# ----------------------------------------------------------- 3. Vue Décodeur
class VueDecodeur(_VueBase):
    """Le Décodeur de Cas : attribution interactive de rôles grammaticaux."""

    ROLES = [
        ("sujet", "🔵 Sujet (Nominatif)", "#1e88e5", "#ffffff"),
        ("cod", "🔴 COD (Accusatif)", "#e53935", "#ffffff"),
        ("verbe", "🟢 Verbe (Action)", "#43a047", "#ffffff"),
        ("autre", "⚪ Neutre / Complément", "#757575", "#ffffff"),
    ]

    def __init__(self, parent, app):
        super().__init__(parent, app)
        f = self.frame
        self.titre = ttk.Label(f, text="🔍 Le Décodeur de Cas", style="Title.TLabel", wraplength=720)
        self.titre.pack(anchor="w", padx=16, pady=(12, 4))

        self.aide = ttk.Label(f, text="Clique sur chaque mot pour changer son rôle grammatical (Sujet, COD ou Verbe) !",
                              style="Muted.TLabel", wraplength=720)
        self.aide.pack(anchor="w", padx=16, pady=(0, 8))

        self.cadre_mots = ttk.Frame(f)
        self.cadre_mots.pack(anchor="w", padx=16, pady=10)
        self.boutons_mots = []
        self.roles_actuels = {}

        legende = ttk.Frame(f)
        legende.pack(anchor="w", padx=16, pady=6)
        ttk.Label(legende, text="Légende :", font=(app.body.cget("family"), 9, "bold")).pack(side=tk.LEFT, padx=(0, 6))
        for r_id, r_label, r_bg, r_fg in self.ROLES:
            lbl = tk.Label(legende, text=r_label, bg=r_bg, fg=r_fg, padx=6, pady=2,
                           font=(app.body.cget("family"), 9, "bold"))
            lbl.pack(side=tk.LEFT, padx=4)

        barre = ttk.Frame(f)
        barre.pack(anchor="w", padx=16, pady=12)
        self.btn_check = ttk.Button(barre, text="Vérifier l'analyse", command=self.verifier, style="Primary.TButton")
        self.btn_check.pack(side=tk.LEFT, padx=(0, 8))
        self.btn_audio = ttk.Button(barre, text="🔊 Écouter la phrase", command=self._ecouter)
        self.btn_audio.pack(side=tk.LEFT)

        self.retour = ttk.Label(f, text="", style="TLabel", wraplength=720)
        self.retour.pack(anchor="w", padx=16, pady=6)

    def _ecouter(self):
        phrase = " ".join(self.lecon.get("mots", []))
        audio.speak_latin(phrase)

    def charger(self, lecon):
        self.lecon = lecon
        self.roles_actuels = {}
        for widget in self.cadre_mots.winfo_children():
            widget.destroy()
        self.boutons_mots = []

        mots = lecon.get("mots", [])
        for idx, mot in enumerate(mots):
            self.roles_actuels[idx] = "autre"
            btn = tk.Button(self.cadre_mots, text=f"{mot}\n(⚪ Neutre)",
                            font=(self.app.body.cget("family"), 11, "bold"),
                            bg="#f0f0f0", fg="#333333", relief="raised", bd=2,
                            padx=12, pady=8, cursor="hand2",
                            command=lambda i=idx: self._cycler_role(i))
            btn.pack(side=tk.LEFT, padx=6)
            self.boutons_mots.append(btn)
        self.retour.configure(text="")

    def _cycler_role(self, idx):
        ordre = ["autre", "sujet", "cod", "verbe"]
        courant = self.roles_actuels.get(idx, "autre")
        suiv_idx = (ordre.index(courant) + 1) % len(ordre)
        nouveau = ordre[suiv_idx]
        self.roles_actuels[idx] = nouveau

        mot = self.lecon.get("mots", [])[idx]
        for r_id, r_label, r_bg, r_fg in self.ROLES:
            if r_id == nouveau:
                self.boutons_mots[idx].configure(text=f"{mot}\n({r_label.split()[0]})", bg=r_bg, fg=r_fg)
                break

    def verifier(self):
        if not self.lecon:
            return
        roles_attendus = self.lecon.get("roles", {})
        attendus = {int(k): v for k, v in roles_attendus.items()}
        reussi, msg = exercices_latin.verifier_decodeur(self.roles_actuels, attendus)
        C = self.app.C
        if reussi:
            audio.play_correct()
            declencher_pluie_sesterces(self.app.root, count=14)
            self.retour.configure(text="✨ " + msg, foreground=C["ok"])
            self.app.valider_item(self.lecon["id"], "Analyse de cas réussie ! +15 Sesterces 🪙")
            self.app.ajouter_sesterces(15)
        else:
            audio.play_wrong()
            self.retour.configure(text="❌ " + msg, foreground=C["err"])


# -------------------------------------------------------------- 4. Vue Arène
class VueArene(_VueBase):
    """Combat de Boss dans l'Arène du Colisée."""

    def __init__(self, parent, app):
        super().__init__(parent, app)
        f = self.frame
        self.combat = None
        self._img_refs = {}

        self.titre = ttk.Label(f, text="⚔️ Défi de l'Arène du Colisée", style="Title.TLabel", wraplength=720)
        self.titre.pack(anchor="w", padx=16, pady=(10, 4))

        # Cadre du duel (Héros vs Boss)
        self.duel_frame = tk.Frame(f, bg="#1a181e", bd=2, relief="ridge", padx=12, pady=10)
        self.duel_frame.pack(fill=tk.X, padx=16, pady=4)

        # Côté Héros (Joueur)
        self.cadre_heros = tk.Frame(self.duel_frame, bg="#1a181e", bd=2, relief="groove",
                                    highlightthickness=2, highlightbackground="#d4af37", padx=4, pady=4)
        self.cadre_heros.pack(side=tk.LEFT, padx=8)

        self.img_heros_lbl = tk.Label(self.cadre_heros, bg="#1a181e")
        self.img_heros_lbl.pack()

        self.nom_heros_lbl = tk.Label(self.cadre_heros, text="Héros", font=(app.body.cget("family"), 10, "bold"),
                                      bg="#1a181e", fg="#e8c26f")
        self.nom_heros_lbl.pack(pady=(2, 0))

        # Centre VS
        vs_cadre = tk.Frame(self.duel_frame, bg="#1a181e")
        vs_cadre.pack(side=tk.LEFT, expand=True)

        tk.Label(vs_cadre, text="⚔️", font=("Segoe UI Emoji", 26), bg="#1a181e", fg="#ffcc00").pack()
        tk.Label(vs_cadre, text="VS", font=(app.title_font.cget("family"), 16, "bold"),
                 bg="#1a181e", fg="#ff4444").pack()

        # Côté Boss
        self.cadre_boss = tk.Frame(self.duel_frame, bg="#1a181e", bd=2, relief="groove",
                                   highlightthickness=2, highlightbackground="#e74c3c", padx=4, pady=4)
        self.cadre_boss.pack(side=tk.RIGHT, padx=8)

        self.img_boss_lbl = tk.Label(self.cadre_boss, bg="#1a181e")
        self.img_boss_lbl.pack()

        info_boss = tk.Frame(self.cadre_boss, bg="#1a181e")
        info_boss.pack(fill=tk.X, pady=(2, 0))

        self.nom_boss = tk.Label(info_boss, text="Adversaire", font=(app.body.cget("family"), 10, "bold"),
                                 bg="#1a181e", fg="#ffcc00")
        self.nom_boss.pack()

        self.pv_lbl = tk.Label(info_boss, text="❤️❤️❤️", font=("Segoe UI Emoji", 13),
                               bg="#1a181e", fg="#ff4444")
        self.pv_lbl.pack(pady=(1, 0))

        self.question_lbl = ttk.Label(f, text="", style="Title.TLabel", wraplength=720)
        self.question_lbl.pack(anchor="w", padx=16, pady=(10, 4))

        self.cadre_options = ttk.Frame(f)
        self.cadre_options.pack(anchor="w", padx=24, pady=4)
        self.boutons_options = []

        self.retour = ttk.Label(f, text="", style="TLabel", wraplength=720)
        self.retour.pack(anchor="w", padx=16, pady=6)

    def charger(self, lecon):
        from pathlib import Path
        from app import progress as prog

        self.lecon = lecon
        boss_data = lecon.get("boss", {})
        questions = lecon.get("questions", [])
        self.combat = exercices_latin.EtatCombatArene(
            nom_boss=boss_data.get("nom", "Monstre"),
            icone=boss_data.get("icone", "👾"),
            pv_max=boss_data.get("pv", len(questions)),
            questions=questions
        )
        self.nom_boss.configure(text=self.combat.nom_boss)
        self.retour.configure(text="")

        img_dir = Path(__file__).resolve().parent.parent / "assets" / "images"

        # Image Héros (Médaillon romain orné)
        genre = prog.get_genre(self.app.data)
        nom_h = prog.get_nom_heros(self.app.data)
        self.nom_heros_lbl.configure(text=f"{nom_h} 🛡️")
        heros_med = img_dir / ("avatar_fille_medaillon_140.png" if genre == "fille" else "avatar_garcon_medaillon_140.png")
        heros_file = heros_med if heros_med.exists() else (img_dir / ("avatar_fille_140.png" if genre == "fille" else "avatar_garcon_140.png"))
        if heros_file.exists():
            try:
                self._img_refs["heros"] = tk.PhotoImage(file=str(heros_file))
                self.img_heros_lbl.configure(image=self._img_refs["heros"])
            except Exception:
                self.img_heros_lbl.configure(text="👦" if genre == "garcon" else "👧", font=("Segoe UI Emoji", 40))

        # Image Boss (Cadre de combat antique avec rivets)
        b_name = self.combat.nom_boss.lower()
        if "mercure" in b_name or "mercurius" in b_name:
            boss_file = img_dir / "boss_mercure_cadre_140.png"
            if not boss_file.exists():
                boss_file = img_dir / "boss_mercure_140.png"
        elif "minotaure" in b_name:
            boss_file = img_dir / "boss_minotaure_cadre_140.png"
            if not boss_file.exists():
                boss_file = img_dir / "boss_minotaure_140.png"
        elif "lion" in b_name:
            boss_file = img_dir / "boss_lion_cadre_140.png"
            if not boss_file.exists():
                boss_file = img_dir / "boss_lion_140.png"
        elif "sphinx" in b_name:
            boss_file = img_dir / "boss_sphinx_cadre_140.png"
            if not boss_file.exists():
                boss_file = img_dir / "boss_sphinx_140.png"
        elif "mirmillon" in b_name or "gladiateur" in b_name or "maximus" in b_name:
            boss_file = img_dir / "boss_gladiateur_cadre_140.png"
            if not boss_file.exists():
                boss_file = img_dir / "boss_gladiateur_140.png"
        else:
            boss_file = None

        if boss_file and boss_file.exists():
            try:
                self._img_refs["boss"] = tk.PhotoImage(file=str(boss_file))
                self.img_boss_lbl.configure(image=self._img_refs["boss"])
            except Exception:
                self.img_boss_lbl.configure(text=self.combat.icone, font=("Segoe UI Emoji", 40))
        else:
            self.img_boss_lbl.configure(text=self.combat.icone, font=("Segoe UI Emoji", 40))

        self._afficher_tour()

    def _afficher_tour(self):
        coeurs = "❤️ " * self.combat.pv_actuels + "🖤 " * (self.combat.pv_max - self.combat.pv_actuels)
        self.pv_lbl.configure(text=coeurs.strip())

        for b in self.boutons_options:
            b.destroy()
        self.boutons_options = []

        if self.combat.victoire:
            self.question_lbl.configure(text="🏆 VICTOIRE ÉCLATANTE AU COLISÉE !")
            self.retour.configure(text=f"Tu as triomphé de {self.combat.nom_boss} ! Tout Rome t'acclame !",
                                  foreground=self.app.C["ok"])
            audio.play_tuba_fanfare()
            declencher_pluie_sesterces(self.app.root, count=26)
            self.app.valider_item(self.lecon["id"], "Boss de l'Arène terrassé ! +50 Sesterces 🪙")
            self.app.ajouter_sesterces(50)
            return

        q = self.combat.question_actuelle()
        if not q:
            return

        self.question_lbl.configure(text=q.get("question", ""))
        for idx, opt in enumerate(q.get("options", [])):
            btn = ttk.Button(self.cadre_options, text=opt, command=lambda i=idx: self._repondre(i))
            btn.pack(anchor="w", pady=3, fill=tk.X)
            self.boutons_options.append(btn)

    def _repondre(self, idx):
        reussi, msg = self.combat.repondre(idx)
        C = self.app.C
        if reussi:
            audio.play_sword_slash()
            secousse_widget(self.img_boss_lbl, distance=10)
            self.retour.configure(text="⚔️ " + msg, foreground=C["ok"])
        else:
            audio.play_wrong()
            self.retour.configure(text="🛡️ " + msg, foreground=C["err"])
        self._afficher_tour()


# -------------------------------------------------- Classes de compatibilité
class VueOrdre(_VueBase):
    def __init__(self, parent, app):
        super().__init__(parent, app)
    def charger(self, lecon): pass
    def traduire(self): pass

class VuePrediction(_VueBase):
    def __init__(self, parent, app):
        super().__init__(parent, app)
    def charger(self, lecon): pass
    def traduire(self): pass

class VueTurtle(_VueBase):
    def __init__(self, parent, app):
        super().__init__(parent, app)
    def charger(self, lecon): pass
    def traduire(self): pass

