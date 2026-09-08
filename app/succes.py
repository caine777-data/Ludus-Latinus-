"""
Module de gestion des Succès & Trophées Romains secrets.
Fournit le catalogue des exploits antiques, le système de vérification
en temps réel avec attribution de sesterces, et l'interface du Panthéon.
"""

import tkinter as tk
from tkinter import ttk

from app import audio
from app.polices import police_corps, police_titre
from app.responsive import adapter_geometrie_fenetre

CATALOGUE_SUCCES = {
    "polyglotte": {
        "id": "polyglotte",
        "titre": "Polyglotte du Forum",
        "icone": "🗣️",
        "desc": "Écouter au moins 20 phrases latines avec la prononciation vocale antique.",
        "desc_secrete": "Écouter 20 phrases latines.",
        "secret": False,
        "recompense_sesterces": 30,
        "seuil": 20,
        "cle_stat": "audio_ecoutes",
        "unite": "phrases écoutées",
    },
    "banquier": {
        "id": "banquier",
        "titre": "Banquier du Forum",
        "icone": "🪙",
        "desc": "Accumuler au moins 500 Sesterces dans ton trésor personnel.",
        "desc_secrete": "Accumuler 500 Sesterces.",
        "secret": False,
        "recompense_sesterces": 50,
        "seuil": 500,
        "cle_stat": "sesterces_max",
        "unite": "Sesterces",
    },
    "invincible": {
        "id": "invincible",
        "titre": "Champion Invincible",
        "icone": "⚔️",
        "desc": "Remporter un duel au Colisée avec 3 victoires d'affilée sans aucune faute (score 3 à 0).",
        "desc_secrete": "??? Trophée secret : Brille par ton invincibilité dans les arènes du Colisée !",
        "secret": True,
        "recompense_sesterces": 40,
        "seuil": 1,
        "cle_stat": "duels_parfaits",
        "unite": "duel sans faute",
    },
    "cryptographe": {
        "id": "cryptographe",
        "titre": "Maître Cryptographe",
        "icone": "📜",
        "desc": "Déchiffrer au moins 3 dépêches militaires secrètes dans le Chiffre de César.",
        "desc_secrete": "Déchiffrer 3 dépêches militaires secrètes.",
        "secret": False,
        "recompense_sesterces": 30,
        "seuil": 3,
        "cle_stat": "cesar_resolus",
        "unite": "dépêches décodées",
    },
    "collectionneur": {
        "id": "collectionneur",
        "titre": "Grand Collectionneur",
        "icone": "🃏",
        "desc": "Découvrir et posséder au moins 5 cartes mythologiques dans son Album.",
        "desc_secrete": "Découvrir 5 cartes mythologiques.",
        "secret": False,
        "recompense_sesterces": 30,
        "seuil": 5,
        "cle_stat": "cartes_possedees",
        "unite": "cartes trouvées",
    },
    "mercator": {
        "id": "mercator",
        "titre": "Mercator de Trajan",
        "icone": "🏺",
        "desc": "Conclure 5 opérations et calculs avec succès aux Marchés de Trajan.",
        "desc_secrete": "Conclure 5 opérations marchandes de Trajan.",
        "secret": False,
        "recompense_sesterces": 30,
        "seuil": 5,
        "cle_stat": "marche_transactions",
        "unite": "transactions",
    },
    "triomphe_4eme": {
        "id": "triomphe_4eme",
        "titre": "Triomphateur de la République",
        "icone": "🦅",
        "desc": "Conquérir l'ensemble du programme de 4ème (Mondes 11 à 18) et débloquer les lauriers républicains.",
        "desc_secrete": "??? Trophée républicain : Conquiers l'intégralité du programme de 4ème !",
        "secret": True,
        "recompense_sesterces": 60,
        "seuil": 1,
        "cle_stat": "triomphe_4eme",
        "unite": "programme 4e conquis",
    },
    "triomphe_cycle4": {
        "id": "triomphe_cycle4",
        "titre": "Maître du Collège",
        "icone": "🏆",
        "desc": "Accomplir l'ensemble du Cycle 4 (26 mondes) de l'entrée en 5ème jusqu'au Brevet en 3ème.",
        "desc_secrete": "??? Trophée suprême : Triomphe sur l'intégralité du Cycle 4 du Collège !",
        "secret": True,
        "recompense_sesterces": 100,
        "seuil": 1,
        "cle_stat": "triomphe_cycle4",
        "unite": "cycle 4 achevé",
    },
}


def valeur_progression_succes(data, id_succes):
    """Calcule la valeur courante de progression pour un succès donné."""
    info = CATALOGUE_SUCCES.get(id_succes)
    if not info or not data:
        return 0

    if id_succes == "banquier":
        s_actuel = int(data.get("sesterces", 0))
        s_max = int(data.get("stats_succes", {}).get("sesterces_max", 0))
        return max(s_actuel, s_max)
    elif id_succes == "collectionneur":
        cartes = data.get("cartes_collection", [])
        return len(cartes) if isinstance(cartes, (list, set, tuple)) else 0
    elif id_succes == "triomphe_4eme":
        return 1 if "triomphe_4eme" in data.get("badges", []) else 0
    elif id_succes == "triomphe_cycle4":
        return 1 if "triomphe_cycle4" in data.get("badges", []) else 0
    else:
        stats = data.get("stats_succes", {})
        return int(stats.get(info["cle_stat"], 0))


def verifier_et_debloquer_succes(app, id_succes):
    """Vérifie si le succès spécifié doit être débloqué. Renvoie les infos si débloqué."""
    if not hasattr(app, "data") or not isinstance(app.data, dict):
        return None

    info = CATALOGUE_SUCCES.get(id_succes)
    if not info:
        return None

    debloques = app.data.setdefault("succes_debloques", [])
    if id_succes in debloques:
        return None

    val = valeur_progression_succes(app.data, id_succes)
    if val >= info["seuil"]:
        debloques.append(id_succes)
        recompense = info["recompense_sesterces"]
        app.data["sesterces"] = app.data.get("sesterces", 0) + recompense

        try:
            from app import progress as prog
            prog.save_progress(app.data)
        except Exception:
            pass

        if hasattr(app, "_refresh_header_stats"):
            try:
                app._refresh_header_stats()
            except Exception:
                pass

        if hasattr(app, "notifier_succes"):
            try:
                app.notifier_succes(info)
            except Exception:
                pass

        return info
    return None


def incrementer_stat_succes(app, cle_stat, increment=1):
    """Incrémente une statistique de succès et vérifie immédiatement les trophées."""
    if not hasattr(app, "data") or not isinstance(app.data, dict):
        return []

    stats = app.data.setdefault("stats_succes", {})
    actuel = stats.get(cle_stat, 0)
    stats[cle_stat] = actuel + increment

    if cle_stat == "sesterces_max":
        s_actuel = app.data.get("sesterces", 0)
        stats["sesterces_max"] = max(stats.get("sesterces_max", 0), s_actuel)

    try:
        from app import progress as prog
        prog.save_progress(app.data)
    except Exception:
        pass

    return verifier_tous_succes(app)


def verifier_tous_succes(app):
    """Vérifie l'ensemble du catalogue et débloque tout succès éligible."""
    if not hasattr(app, "data") or not isinstance(app.data, dict):
        return []

    # Mettre à jour sesterces_max si le solde actuel est plus élevé
    stats = app.data.setdefault("stats_succes", {})
    s_actuel = app.data.get("sesterces", 0)
    if s_actuel > stats.get("sesterces_max", 0):
        stats["sesterces_max"] = s_actuel

    nouveaux = []
    for sid in CATALOGUE_SUCCES:
        res = verifier_et_debloquer_succes(app, sid)
        if res:
            nouveaux.append(res)
    return nouveaux


class SuccesWindow(tk.Toplevel):
    """Fenêtre du Panthéon des Trophées et Succès Secrets Romains."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        from app.theme import THEMES, est_sombre
        self.C = getattr(app, "C", None) or THEMES["colisee"]
        self.title("🏛️ Panthéon des Trophées Romains — Ludus Latinus")

        bg_def = self.C.get("bg", "#181922")
        self.sombre = est_sombre(bg_def)

        self.configure(bg=bg_def)
        adapter_geometrie_fenetre(self, 680, 560)
        self.minsize(480, 400)
        self.transient(master)

        c_panel = self.C.get("panel", "#222430")
        c_heading = self.C.get("heading", "#ffd700")
        c_muted = self.C.get("muted", "#9193a8")

        # En-tête antique
        hdr = tk.Frame(self, bg=c_panel, padx=16, pady=12)
        hdr.pack(fill=tk.X)

        tk.Label(
            hdr,
            text="🏛️ LE PANTHÉON DES TROPHÉES",
            font=police_titre(16),
            bg=c_panel,
            fg="#ffd700" if self.sombre else c_heading,
        ).pack(anchor="w")

        tk.Label(
            hdr,
            text="Accomplis des exploits antiques pour gagner gloire, lauriers et sesterces !",
            font=police_corps(10, italique=True),
            bg=c_panel,
            fg=c_muted,
        ).pack(anchor="w", pady=(2, 0))

        # Barre de résumé
        debloques = set(self.app.data.get("succes_debloques", []))
        total = len(CATALOGUE_SUCCES)
        nb_debloques = len(debloques)
        pct = int((nb_debloques / max(1, total)) * 100)

        sesterces_gagnes = sum(
            CATALOGUE_SUCCES[sid]["recompense_sesterces"]
            for sid in debloques
            if sid in CATALOGUE_SUCCES
        )

        c_resume_bg = "#1f2335" if self.sombre else "#faf4e8"
        barre_resume = tk.Frame(self, bg=c_resume_bg, padx=16, pady=8)
        barre_resume.pack(fill=tk.X)

        tk.Label(
            barre_resume,
            text=f"🏆 Progression : {nb_debloques} / {total} ({pct}%)",
            font=police_corps(10, gras=True),
            bg=c_resume_bg,
            fg="#e0af68" if self.sombre else "#8c1d1d",
        ).pack(side=tk.LEFT)

        tk.Label(
            barre_resume,
            text=f"🪙 Butin récolté : +{sesterces_gagnes} Sesterces",
            font=police_corps(10, gras=True),
            bg=c_resume_bg,
            fg="#ffd700" if self.sombre else "#b8860b",
        ).pack(side=tk.RIGHT)

        # Zone déroulante des trophées
        c_bg = self.C.get("bg", "#181922")
        conteneur = tk.Frame(self, bg=c_bg)
        conteneur.pack(fill=tk.BOTH, expand=True, padx=12, pady=10)

        canvas = tk.Canvas(conteneur, bg=c_bg, highlightthickness=0)
        scrollbar = ttk.Scrollbar(conteneur, orient="vertical", command=canvas.yview)
        self.scroll_frame = tk.Frame(canvas, bg=c_bg)

        self.scroll_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )

        win_id = canvas.create_window((0, 0), window=self.scroll_frame, anchor="nw")

        def _sur_canvas_config(event):
            canvas.itemconfig(win_id, width=max(100, event.width - 24))
        canvas.bind("<Configure>", _sur_canvas_config)

        canvas.configure(yscrollcommand=scrollbar.set)
        canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        def _on_mousewheel(e):
            if canvas.winfo_exists():
                canvas.yview_scroll(int(-1 * (e.delta / 120)), "units")
        self.bind("<MouseWheel>", _on_mousewheel)

        self._afficher_cartes_succes()
        audio.play_cloche()

        # Bouton bas
        btn_barre = tk.Frame(self, bg=c_panel, padx=12, pady=8)
        btn_barre.pack(fill=tk.X)

        tk.Button(
            btn_barre,
            text="Fermer (Échap)",
            font=police_corps(10, gras=True),
            bg=self.C.get("editor", "#14151c"),
            fg=self.C.get("fg", "#eae8f2"),
            activebackground=self.C.get("accent", "#e5a93c"),
            activeforeground=self.C.get("sel_fg", "#14151c"),
            relief="flat",
            cursor="hand2",
            padx=16,
            pady=4,
            command=self.destroy,
        ).pack(side=tk.RIGHT)

        self.bind("<Escape>", lambda e: self.destroy())

    def _afficher_cartes_succes(self):
        debloques = set(self.app.data.get("succes_debloques", []))

        # Trier : d'abord débloqués, puis autres
        liste_succes = sorted(
            CATALOGUE_SUCCES.values(),
            key=lambda x: (0 if x["id"] in debloques else 1, x["secret"])
        )

        for item in liste_succes:
            sid = item["id"]
            est_debloque = sid in debloques
            est_secret_verrouille = item["secret"] and not est_debloque
            val = valeur_progression_succes(self.app.data, sid)
            seuil = item["seuil"]

            # Carte avec theme adaptatif
            if self.sombre:
                bg_carte = "#24283b" if est_debloque else ("#19182b" if est_secret_verrouille else "#1f2335")
                bd_col = "#d4af37" if est_debloque else ("#565f89" if est_secret_verrouille else "#3b4261")
            else:
                bg_carte = "#ffffff" if est_debloque else ("#f8f4fc" if est_secret_verrouille else "#faf6ee")
                bd_col = "#c59b27" if est_debloque else ("#b8a4cc" if est_secret_verrouille else "#ded3bf")

            f_carte = tk.Frame(
                self.scroll_frame,
                bg=bg_carte,
                highlightthickness=2 if est_debloque else 1,
                highlightbackground=bd_col,
                padx=12,
                pady=10
            )
            f_carte.pack(fill=tk.X, pady=6, padx=4)

            # Colonne 1 : Icône
            icone_txt = item["icone"] if not est_secret_verrouille else "🔒"
            f_ico = tk.Frame(f_carte, bg=bg_carte, width=54)
            f_ico.pack(side=tk.LEFT, padx=(0, 12))
            tk.Label(
                f_ico,
                text=icone_txt,
                font=("Segoe UI Emoji", 24),
                bg=bg_carte,
            ).pack(anchor="center")

            # Colonne 2 : Statut / Récompense (à droite en priorité)
            f_statut = tk.Frame(f_carte, bg=bg_carte)
            f_statut.pack(side=tk.RIGHT, padx=(10, 4))

            if est_debloque:
                tk.Label(
                    f_statut,
                    text="✓ DÉBLOQUÉ",
                    font=police_corps(9, gras=True),
                    bg=bg_carte,
                    fg="#27ae60"
                ).pack(anchor="e")
                tk.Label(
                    f_statut,
                    text=f"+{item['recompense_sesterces']} 🪙",
                    font=police_corps(9, gras=True),
                    bg=bg_carte,
                    fg="#ffd700" if self.sombre else "#b8860b"
                ).pack(anchor="e")
            else:
                tk.Label(
                    f_statut,
                    text=f"🪙 +{item['recompense_sesterces']}",
                    font=police_corps(9, gras=True),
                    bg="#181a24" if self.sombre else "#efe6d5",
                    fg="#ffd700" if self.sombre else "#8c1d1d",
                    padx=6,
                    pady=2,
                    relief="groove"
                ).pack(anchor="e")

            # Colonne 3 : Textes & Jauge (centre expansif)
            f_txt = tk.Frame(f_carte, bg=bg_carte)
            f_txt.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

            if est_secret_verrouille:
                titre_txt = "??? Trophée Secret"
                desc_txt = item["desc_secrete"]
                fg_titre = "#bb9af7" if self.sombre else "#6c5ce7"
                fg_desc = "#9aa5ce" if self.sombre else "#666666"
            else:
                titre_txt = item["titre"]
                desc_txt = item["desc"]
                fg_titre = "#ffd700" if (est_debloque and self.sombre) else (self.C.get("heading", "#8c1d1d") if not self.sombre else "#c0caf5")
                fg_desc = ("#c0caf5" if est_debloque else "#9aa5ce") if self.sombre else self.C.get("fg", "#2c2621")

            tk.Label(
                f_txt,
                text=titre_txt,
                font=police_titre(11),
                bg=bg_carte,
                fg=fg_titre,
                anchor="w"
            ).pack(fill=tk.X)

            tk.Label(
                f_txt,
                text=desc_txt,
                font=police_corps(9),
                bg=bg_carte,
                fg=fg_desc,
                wraplength=340,
                justify=tk.LEFT,
                anchor="w"
            ).pack(fill=tk.X, pady=(2, 4))

            # Jauge de progression
            f_jauge = tk.Frame(f_txt, bg=bg_carte)
            f_jauge.pack(fill=tk.X, pady=(2, 0))

            val_affichee = min(val, seuil)
            ratio = min(1.0, max(0.0, val_affichee / max(1, seuil)))

            # Label ratio d'abord à droite pour garantir sa visibilité intégrale
            lbl_ratio = tk.Label(
                f_jauge,
                text=f"{val_affichee} / {seuil} {item['unite']}" if not est_secret_verrouille else "Mystère",
                font=("Georgia", 8, "italic"),
                bg=bg_carte,
                fg="#a9b1d6" if self.sombre else "#777777"
            )
            lbl_ratio.pack(side=tk.RIGHT, padx=(8, 0))

            # Canvas barre de progression
            c_barre_bg = "#16161e" if self.sombre else "#e8dfce"
            canvas_barre = tk.Canvas(f_jauge, height=10, bg=c_barre_bg, highlightthickness=0)
            canvas_barre.pack(side=tk.LEFT, fill=tk.X, expand=True)

            def _dessiner_barre(event, c=canvas_barre, r=ratio, deb=est_debloque):
                w = event.width
                c.delete("all")
                couleur = "#2ecc71" if deb else ("#ffd700" if self.sombre else "#b8860b")
                c.create_rectangle(0, 0, int(w * r), 10, fill=couleur, width=0)

            canvas_barre.bind("<Configure>", _dessiner_barre)
