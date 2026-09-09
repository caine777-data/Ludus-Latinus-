"""
Module Forum Imperiale — La Reconstruction de Rome.

Méta-jeu valorisant les sesterces amassés par l'élève.
Permet de restaurer les 6 grands monuments du Forum Romain antique,
débloquant des bonus passifs permanents (sesterces accrus, XP, indices)
et des fiches historiques illustrées.
"""

import tkinter as tk
from tkinter import messagebox, ttk

from app import audio
from app import progress as prog

# Définition des 6 grands monuments du Forum Romain
MONUMENTS_FORUM = [
    {
        "id": "lacus_iuturnae",
        "nom": "Lacus Iuturnae",
        "titre_fr": "La Fontaine Sacrée de Juturne",
        "cout": 50,
        "x": 120, "y": 270, "w": 90, "h": 70,
        "bonus": "💧 Source Divine : Rétablit l'énergie et la concentration.",
        "description": "Bassin sacré au pied du Palatin où les jumeaux divins Castor et Pollux abreuvèrent leurs coursiers d'écume après la victoire du lac Régille.",
        "couleur_toit": "#3a75c4"
    },
    {
        "id": "templum_saturni",
        "nom": "Templum Saturni",
        "titre_fr": "Le Temple de Saturne (L'Aérarium)",
        "cout": 100,
        "x": 240, "y": 180, "w": 105, "h": 110,
        "bonus": "🪙 Trésor Impérial : +20% de sesterces gagnés sur chaque exercice !",
        "description": "L'un des plus anciens temples de Rome, abritant l'Aerarium populi Romani, le trésor public de la République où dormaient l'or et l'argent de l'Empire.",
        "couleur_toit": "#d4af37"
    },
    {
        "id": "curia_iulia",
        "nom": "Curia Iulia",
        "titre_fr": "La Curie Julia (Le Sénat)",
        "cout": 150,
        "x": 380, "y": 150, "w": 115, "h": 125,
        "bonus": "📜 Sagesse des Pères : +10% de bonus d'expérience sur les leçons d'histoire.",
        "description": "Le cœur politique de Rome fondé par Jules César et achevé par Auguste. C'est ici que les sénateurs en toge blanche débattaient du destin du monde.",
        "couleur_toit": "#8b2500"
    },
    {
        "id": "arcus_titi",
        "nom": "Arcus Titi",
        "titre_fr": "L'Arc de Triomphe de Titus",
        "cout": 250,
        "x": 525, "y": 190, "w": 100, "h": 105,
        "bonus": "🎖️ Gloire des Légions : Débloque le titre impérial « Patricien Bâtisseur ».",
        "description": "Arc triomphal monumental en marbre pentélique érigé à l'entrée est du Forum, célébrant les exploits romains et le triomphe de l'Empire.",
        "couleur_toit": "#a3702a"
    },
    {
        "id": "aedes_minervae",
        "nom": "Aedes Minervae",
        "titre_fr": "Le Sanctuaire de Minerve",
        "cout": 350,
        "x": 655, "y": 160, "w": 100, "h": 115,
        "bonus": "🦉 Pensée Éclairée : T'offre 1 indice gratuit quotidien sur les exercices difficiles.",
        "description": "Sanctuaire dédié à Minerve, déesse de la sagesse, de la stratégie et de l'intelligence pratique. Ses colonnes corinthiennes veillent sur les étudiants.",
        "couleur_toit": "#2e6f40"
    },
    {
        "id": "rostra_augusta",
        "nom": "Rostra Augusta",
        "titre_fr": "La Tribune des Rostres & Colonnes d'Or",
        "cout": 500,
        "x": 420, "y": 320, "w": 130, "h": 80,
        "bonus": "👑 Grand Bâtisseur : Débloque le Trophée d'or suprême « Forum Restitutum » !",
        "description": "La célèbre tribune des orateurs ornée des éperons de navires ennemis en bronze conquis à Actium. De là résonnaient les discours enflammés de Cicéron.",
        "couleur_toit": "#f3e5ab"
    }
]


class ForumImperialeDialog(tk.Toplevel):
    """Fenêtre interactive du Forum Imperiale (Reconstruction de Rome)."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🏛️ Forum Imperiale — La Reconstruction de Rome")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        w, h = 880, 680
        sw = self.winfo_screenwidth()
        sh = self.winfo_screenheight()
        self.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")

        self.transient(master)
        self.grab_set()

        self.monument_selectionne = MONUMENTS_FORUM[1]  # Temple de Saturne par défaut

        # Liseré d'or supérieur
        tk.Frame(self, bg=self.C["accent"], height=6).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=20, pady=10)
        hdr.pack(fill=tk.X)

        top_row = tk.Frame(hdr, bg=self.C["panel"])
        top_row.pack(fill=tk.X)

        tk.Label(
            top_row,
            text="🏛️ Forum Imperiale — Reconstruis la Ville Éternelle",
            font=(app.title_font.cget("family"), 16, "bold"),
            bg=self.C["panel"],
            fg=self.C["accent"]
        ).pack(side=tk.LEFT)

        self.lbl_sesterces = tk.Label(
            top_row,
            text=f"🪙 {self.app.data.get('sesterces', 0)} HS Disponibles",
            font=(app.body.cget("family"), 12, "bold"),
            bg=self.C["panel"],
            fg="#d4af37"
        )
        self.lbl_sesterces.pack(side=tk.RIGHT)

        tk.Label(
            hdr,
            text="Utilise tes sesterces pour restaurer les ruines du Forum et débloquer de puissants bonus permanents !",
            font=(app.body.cget("family"), 9),
            bg=self.C["panel"],
            fg=self.C["muted"]
        ).pack(anchor="w", pady=(2, 0))

        # Canvas panoramique du Forum
        self.cv_w = 840
        self.cv_h = 380
        self.cv = tk.Canvas(
            self,
            width=self.cv_w,
            height=self.cv_h,
            bg="#fdfaf3" if not self.C.get("is_dark", False) else "#1a1612",
            highlightthickness=2,
            highlightbackground=self.C["accent"],
            cursor="hand2"
        )
        self.cv.pack(padx=20, pady=(6, 10))
        self.cv.bind("<Button-1>", self._on_canvas_click)

        # Zone d'inspection du monument sélectionné (Fiche architecturale)
        self.inspector = tk.Frame(self, bg=self.C["editor"], padx=20, pady=12, highlightthickness=1,
                                  highlightbackground=self.C["accent"])
        self.inspector.pack(fill=tk.BOTH, expand=True, padx=20, pady=(0, 10))

        self._build_inspector()

        # Barre inférieure
        bottom_bar = tk.Frame(self, bg=self.C["panel"], padx=20, pady=8)
        bottom_bar.pack(fill=tk.X, side=tk.BOTTOM)

        self.lbl_status = tk.Label(
            bottom_bar,
            text="Clique sur n'importe quel monument pour inspecter ses bienfaits et le restaurer.",
            font=(app.body.cget("family"), 9, "italic"),
            bg=self.C["panel"],
            fg=self.C["muted"]
        )
        self.lbl_status.pack(side=tk.LEFT)

        ttk.Button(bottom_bar, text="Fermer", command=self.destroy).pack(side=tk.RIGHT)

        self._dessiner_forum()
        self.lift()
        self.focus_force()

    # -----------------------------------------------------------------------
    # DESSIN DU FORUM ROMAIN ISOMÉTRIQUE
    # -----------------------------------------------------------------------
    def _dessiner_forum(self):
        self.cv.delete("all")
        is_dark = self.C.get("is_dark", False)

        # 1. Ciel romain (Dégradé d'aurore dorée vers l'azur)
        ciel_top = "#1b355a" if is_dark else "#e8f4fc"
        ciel_mid = "#322030" if is_dark else "#fdf5e6"
        self.cv.create_rectangle(0, 0, self.cv_w, 140, fill=ciel_top, outline="")
        self.cv.create_rectangle(0, 70, self.cv_w, 140, fill=ciel_mid, outline="")

        # Soleil radieux d'or
        self.cv.create_oval(self.cv_w - 120, 20, self.cv_w - 60, 80, fill="#fde8a0", outline="#d4af37", width=2)

        # 2. Mont Palatin et colline de l'Aventin au second plan
        colline_bg = "#2a2218" if is_dark else "#8ba870"
        self.cv.create_polygon(
            0, 160, 150, 110, 380, 130, 600, 95, 840, 140, 840, 200, 0, 200,
            fill=colline_bg, outline=""
        )

        # Pins parasols et cyprès sur la colline
        for tx in (80, 190, 320, 480, 680, 780):
            # Tronc
            self.cv.create_line(tx, 130, tx, 100, fill="#5a3d28", width=3)
            # Dôme pin
            self.cv.create_oval(tx - 18, 90, tx + 18, 110, fill="#2b5e32", outline="")

        # 3. Sol du Forum (Dalles de travertin et terre battue)
        sol_bg = "#201a14" if is_dark else "#eeddc5"
        self.cv.create_rectangle(0, 140, self.cv_w, self.cv_h, fill=sol_bg, outline="")

        # Chaussée de la Via Sacra en pavés polygonaux
        via_color = "#332a22" if is_dark else "#cfbaa0"
        self.cv.create_polygon(
            0, 310, 300, 260, 580, 250, 840, 280, 840, 340, 550, 320, 280, 330, 0, 380,
            fill=via_color, outline="#bfa386"
        )

        # Jointures de dalles romaines transversales
        for jx in range(30, 840, 45):
            self.cv.create_line(jx, 275 + (jx % 15), jx + 10, 335, fill="#a68e73", width=1)

        # 4. Dessin des 6 Monuments du Forum
        monuments_restaures = prog.get_monuments_forum(self.app.data)

        for m in MONUMENTS_FORUM:
            mid = m["id"]
            est_restaure = mid in monuments_restaures
            est_selectionne = (m["id"] == self.monument_selectionne["id"])

            x, y, w, h = m["x"], m["y"], m["w"], m["h"]

            # Socle du monument
            if est_selectionne:
                # Halo de sélection doré
                self.cv.create_rectangle(x - 6, y - 6, x + w + 6, y + h + 6, outline="#d4af37", width=3, dash=(4, 2))

            if est_restaure:
                # MONUMENT RESTAURÉ (Marbre éclatant, colonnes dorées, bannière pourpre)
                # Corps principal marbre blanc
                self.cv.create_rectangle(x, y + 25, x + w, y + h, fill="#fdfbf7", outline="#c5a059", width=2)

                # Colonnes corinthiennes jumelées
                col_step = max(18, w // 4)
                for cx in range(x + 10, x + w - 8, col_step):
                    self.cv.create_rectangle(cx, y + 25, cx + 8, y + h - 6, fill="#faf5e8", outline="#d4af37")

                # Fronton triangulaire sculpté
                self.cv.create_polygon(
                    x - 4, y + 25, x + w // 2, y, x + w + 4, y + 25,
                    fill=m["couleur_toit"], outline="#d4af37", width=2
                )
                # Rosette d'or au centre du fronton
                self.cv.create_oval(x + w // 2 - 5, y + 12, x + w // 2 + 5, y + 22, fill="#f9d342", outline="#8b2500")

                # Pastille de victoire émeraude
                self.cv.create_oval(x + w - 16, y - 6, x + w + 8, y + 18, fill="#2e6f40", outline="#ffffff", width=2)
                self.cv.create_text(x + w - 4, y + 6, text="✓", font=("Arial", 11, "bold"), fill="#ffffff")

            else:
                # EN RUINE (Blocs grisâtres, fissures, toiture effondrée, à restaurer)
                self.cv.create_rectangle(x, y + 25, x + w, y + h, fill="#6b645b", outline="#403c37", width=2)

                # Colonnes brisées
                col_step = max(18, w // 4)
                for i, cx in enumerate(range(x + 10, x + w - 8, col_step)):
                    broken_h = h - 20 if i % 2 == 0 else h // 2
                    self.cv.create_rectangle(cx, y + h - broken_h, cx + 8, y + h - 6, fill="#7e776e", outline="#302d29")

                # Débris et herbes folles au pied
                self.cv.create_polygon(x, y + 35, x + w // 3, y + 15, x + w, y + 40, fill="#504a43", outline="")
                self.cv.create_text(x + w // 2, y + h // 2, text="🏚️ Ruine", font=(self.app.body.cget("family"), 9, "bold"), fill="#f0e6d2")

                # Badge Coût Sesterces
                self.cv.create_rectangle(x + 6, y + h - 24, x + w - 6, y + h - 4, fill="#1c1813", outline="#d4af37")
                self.cv.create_text(
                    x + w // 2, y + h - 14,
                    text=f"🪙 {m['cout']} HS",
                    font=(self.app.body.cget("family"), 9, "bold"),
                    fill="#f3e5ab"
                )

            # Nom abrégé au-dessus
            self.cv.create_text(
                x + w // 2, y - 10,
                text=m["nom"],
                font=(self.app.title_font.cget("family"), 9, "bold"),
                fill="#8b2500" if not is_dark else "#e5a759"
            )

    # -----------------------------------------------------------------------
    # GESTION DU CLIC SUR LE CANVAS
    # -----------------------------------------------------------------------
    def _on_canvas_click(self, event):
        for m in MONUMENTS_FORUM:
            x, y, w, h = m["x"], m["y"], m["w"], m["h"]
            if x <= event.x <= x + w and y <= event.y <= y + h:
                self.monument_selectionne = m
                audio.play_coin()
                self._dessiner_forum()
                self._build_inspector()
                return

    # -----------------------------------------------------------------------
    # FICHE D'INSPECTION DU MONUMENT
    # -----------------------------------------------------------------------
    def _build_inspector(self):
        for w in self.inspector.winfo_children():
            w.destroy()

        m = self.monument_selectionne
        monuments_restaures = prog.get_monuments_forum(self.app.data)
        est_restaure = m["id"] in monuments_restaures

        top = tk.Frame(self.inspector, bg=self.C["editor"])
        top.pack(fill=tk.X)

        titre = f"🏛️ {m['nom']} — {m['titre_fr']}"
        tk.Label(
            top,
            text=titre,
            font=(self.app.title_font.cget("family"), 13, "bold"),
            bg=self.C["editor"],
            fg=self.C["accent"]
        ).pack(side=tk.LEFT)

        # Statut
        if est_restaure:
            badge_text = "✓ Splendeur Restaurée"
            badge_bg = "#2e6f40"
            badge_fg = "#ffffff"
        else:
            badge_text = f"⏳ En Ruines (Coût : {m['cout']} HS)"
            badge_bg = "#6a4e10"
            badge_fg = "#fff0aa"

        tk.Label(
            top,
            text=f"  {badge_text}  ",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg=badge_bg,
            fg=badge_fg,
            padx=6, pady=2
        ).pack(side=tk.RIGHT)

        # Description historique
        tk.Label(
            self.inspector,
            text=m["description"],
            font=(self.app.body.cget("family"), 9),
            justify=tk.LEFT,
            wraplength=800,
            bg=self.C["editor"],
            fg=self.C["fg"]
        ).pack(anchor="w", pady=(6, 8))

        # Bienfait Permanent
        bonus_frame = tk.Frame(self.inspector, bg="#fcf8ed" if not self.C.get("is_dark", False) else "#2d2319",
                               padx=12, pady=6, relief="solid", bd=1)
        bonus_frame.pack(fill=tk.X, pady=(0, 8))

        tk.Label(
            bonus_frame,
            text=f"✨ Bienfait permanent : {m['bonus']}",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg=bonus_frame.cget("bg"),
            fg="#2e6f40" if not self.C.get("is_dark", False) else "#66dd88"
        ).pack(anchor="w")

        # Bouton d'action
        action_row = tk.Frame(self.inspector, bg=self.C["editor"])
        action_row.pack(fill=tk.X)

        if not est_restaure:
            btn_restaurer = tk.Button(
                action_row,
                text=f"🔨 Reconstruire ce Monument ({m['cout']} Sesterces)",
                font=(self.app.body.cget("family"), 11, "bold"),
                bg="#d4af37", fg="#1a1409",
                activebackground="#f3e5ab",
                padx=16, pady=6, relief="flat", cursor="hand2",
                command=self._restaurer_monument
            )
            btn_restaurer.pack(side=tk.LEFT)
        else:
            tk.Label(
                action_row,
                text="🏛️ Ce chef-d'œuvre rayonne sur le Forum. Son bienfait est actif en permanence !",
                font=(self.app.body.cget("family"), 10, "italic"),
                bg=self.C["editor"],
                fg=self.C["muted"]
            ).pack(side=tk.LEFT)

    # -----------------------------------------------------------------------
    # RESTAURATION D'UN MONUMENT
    # -----------------------------------------------------------------------
    def _restaurer_monument(self):
        m = self.monument_selectionne
        succes, msg = prog.debloquer_monument_forum(self.app.data, m["id"], m["cout"])

        if succes:
            audio.play_build()
            audio.play_victory()
            self.lbl_sesterces.configure(text=f"🪙 {self.app.data.get('sesterces', 0)} HS Disponibles")
            self._dessiner_forum()
            self._build_inspector()
            messagebox.showinfo(
                "Forum Imperiale",
                f"🏛️ Triomphe ! Le {m['nom']} a été restauré avec faste !\n\n{m['bonus']}"
            )
        else:
            audio.play_wrong()
            messagebox.showwarning("Fonds Insuffisants", msg)
