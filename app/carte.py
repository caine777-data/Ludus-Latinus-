"""
Carte d'Aventure interactive : La Via Appia de Rome.
Affiche la route des 10 Mondes avec étapes milliaires, étoiles dorées et accès direct.
"""

import tkinter as tk
from tkinter import ttk

from app import audio
from content import CURRICULUM


class CarteAventureWindow(tk.Toplevel):
    """Carte d'aventure façon Mario / Duolingo pour Ludus Latinus."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🗺️ La Via Appia — Carte d'Aventure de Rome")
        self.configure(bg=self.C["panel"])
        self.resizable(True, True)

        from app.responsive import adapter_geometrie_fenetre
        w, h = adapter_geometrie_fenetre(self, 820, 640, min_w=680, min_h=480)

        # Liseré supérieur
        tk.Frame(self, bg=self.C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=18, pady=10)
        hdr.pack(fill=tk.X)
        tk.Label(hdr, text="🗺️ La Via Appia — Route Impériale des 10 Mondes",
                 font=(app.title_font.cget("family"), 16, "bold"),
                 bg=self.C["panel"], fg=self.C["accent"]).pack(side=tk.LEFT)

        faits = len(app.data.get("completed", []))
        total_items = sum(len(lvl["lessons"]) for lvl in CURRICULUM)
        pct = int(100 * faits / max(1, total_items))
        tk.Label(hdr, text=f"Progression : {faits}/{total_items} leçons ({pct}%)",
                 font=(app.body.cget("family"), 10, "bold"),
                 bg=self.C["panel"], fg=self.C["fg"]).pack(side=tk.RIGHT)

        # Zone centrale défilante avec Canvas
        wrap = tk.Frame(self, bg=self.C["bg"])
        wrap.pack(fill=tk.BOTH, expand=True, padx=12, pady=(0, 10))

        self.canvas = tk.Canvas(wrap, bg="#eedcc1", highlightthickness=0)
        scrollbar = ttk.Scrollbar(wrap, orient="vertical", command=self.canvas.yview)
        self.canvas.configure(yscrollcommand=scrollbar.set)

        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.canvas.bind("<Configure>", lambda e: self._dessiner_carte())
        self.bind("<MouseWheel>", lambda e: self.canvas.yview_scroll(int(-1 * (e.delta / 120)), "units"))

    def _dessiner_carte(self):
        self.canvas.delete("all")
        cw = max(700, self.canvas.winfo_width())

        # Calculer la hauteur totale nécessaire pour les 10 mondes
        monde_height = 200
        total_h = len(CURRICULUM) * monde_height + 120
        self.canvas.configure(scrollregion=(0, 0, cw, total_h))

        completed_set = set(self.app.data.get("completed", []))
        echecs = self.app.data.get("echecs", {})

        # Tracé de la route romaine pavée sinueuse
        centre_x = cw // 2
        points_route = []
        for i in range(len(CURRICULUM)):
            y = 60 + i * monde_height + 80
            # Sinuosité alternée gauche/droite
            offset_x = -80 if (i % 2 == 1) else 80
            points_route.append((centre_x + offset_x, y))

        # Dessiner le ruban pavé
        for i in range(len(points_route) - 1):
            x1, y1 = points_route[i]
            x2, y2 = points_route[i + 1]
            self.canvas.create_line(x1, y1, x2, y2, fill="#d2b48c", width=42, capstyle="round")
            self.canvas.create_line(x1, y1, x2, y2, fill="#c49a6c", width=34, capstyle="round")
            self.canvas.create_line(x1, y1, x2, y2, fill="#f5deb3", width=4, dash=(12, 10))

        # Placer chaque Monde
        for i, lvl in enumerate(CURRICULUM):
            y_base = 60 + i * monde_height
            x_centre = points_route[i][0]

            # Bannière du Monde
            self.canvas.create_rectangle(
                x_centre - 200, y_base, x_centre + 200, y_base + 38,
                fill="#3a1e12", outline="#ffd700", width=2
            )
            self.canvas.create_text(
                x_centre, y_base + 19,
                text=lvl["title"],
                font=(self.app.body.cget("family"), 11, "bold"),
                fill="#ffd700"
            )

            # Placer les leçons de ce monde
            lecons = lvl["lessons"]
            n_lecons = len(lecons)
            largeur_bloc = min(540, cw - 60)
            pas_x = largeur_bloc // max(1, n_lecons)
            start_x = centre_x - (largeur_bloc // 2) + (pas_x // 2)

            for j, les in enumerate(lecons):
                lx = start_x + j * pas_x
                ly = y_base + 75 + ((j % 2) * 20)

                lid = les["id"]
                est_fait = (lid in completed_set)
                is_boss = (les.get("type") == "arene")

                # Statut étoiles
                nb_err = echecs.get(lid, 0)
                if est_fait:
                    if nb_err == 0:
                        etoiles = "⭐⭐⭐"
                    elif nb_err <= 2:
                        etoiles = "⭐⭐"
                    else:
                        etoiles = "⭐"
                    fill_c = "#4caf50" if not is_boss else "#d4af37"
                    symb = "🏆" if not is_boss else "👑"
                else:
                    etoiles = ""
                    fill_c = "#8d6e63" if not is_boss else "#b71c1c"
                    symb = "⚡" if not is_boss else "⚔️"

                # Pointeur / Borne
                rayon = 22 if not is_boss else 28
                self.canvas.create_oval(
                    lx - rayon, ly - rayon, lx + rayon, ly + rayon,
                    fill=fill_c, outline="#ffffff", width=2, tags=("milestone", lid)
                )
                self.canvas.create_text(
                    lx, ly, text=symb, font=("Segoe UI Emoji", 14 if not is_boss else 18),
                    tags=("milestone", lid)
                )

                # Étoiles au-dessus
                if etoiles:
                    self.canvas.create_text(lx, ly - rayon - 9, text=etoiles, font=("Segoe UI Emoji", 8))

                # Titre court sous la borne
                titre_court = les["title"].replace("⚔️ Défi de l'Arène : ", "").replace("⚔️ Combat d'Arène Ultime : ", "")
                if len(titre_court) > 16:
                    titre_court = titre_court[:14] + "…"
                self.canvas.create_text(
                    lx, ly + rayon + 12, text=titre_court,
                    font=(self.app.body.cget("family"), 8, "bold"), fill="#2e1a0b"
                )

                # Rendre la borne cliquable
                def _clic_borne(e, target_id=lid):
                    self.app._charger_item(target_id)
                    audio.play_coin()
                    self.destroy()

                self.canvas.tag_bind(lid, "<Button-1>", _clic_borne)
                self.canvas.tag_bind(lid, "<Enter>", lambda e: self.canvas.configure(cursor="hand2"))
                self.canvas.tag_bind(lid, "<Leave>", lambda e: self.canvas.configure(cursor=""))
