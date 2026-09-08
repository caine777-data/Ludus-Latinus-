"""
Carte d'Aventure interactive : La Via Appia de Rome.
Affiche la route des Mondes romains avec étapes milliaires pavées, étoiles dorées,
halo pulsant sur la prochaine leçon et infobulles riches.
"""

import math
import textwrap
import tkinter as tk
from pathlib import Path
from tkinter import ttk

try:
    from PIL import Image, ImageTk
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

from app import audio
from app.polices import police_corps, police_titre
from app.responsive import adapter_geometrie_fenetre, obtenir_facteur_echelle
from content import CLASSES, get_curriculum_classe

ASSETS_IMAGES = Path(__file__).resolve().parent.parent / "assets" / "images"


class CarteAventureWindow(tk.Toplevel):
    """Carte d'aventure interactive sur la Via Appia pour Ludus Latinus."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🗺️ La Via Appia — Carte d'Aventure de Rome")
        self.configure(bg=self.C["panel"])
        self.resizable(True, True)

        self.classe_active = self.app.data.get("classe_active", "5eme")
        if self.classe_active not in CLASSES:
            self.classe_active = "5eme"

        adapter_geometrie_fenetre(self, 930, 700, min_w=840, min_h=520)

        self._pulse_job = None
        self._pulse_frame = 0
        self._active_milestone = None  # (lx, ly, rayon)
        self._tooltip_window = None
        self._photo_avatar = None
        self._load_avatar_image()

        # Liseré supérieur impérial
        tk.Frame(self, bg=self.C["accent"], height=5).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        self.hdr = tk.Frame(self, bg=self.C["panel"], padx=18, pady=10)
        self.hdr.pack(fill=tk.X)
        self.lbl_titre_carte = tk.Label(
            self.hdr, text="",
            font=police_titre(15),
            bg=self.C["panel"], fg=self.C["accent"]
        )
        self.lbl_titre_carte.pack(side=tk.LEFT)

        self.lbl_progression = tk.Label(
            self.hdr, text="",
            font=police_corps(10, gras=True),
            bg=self.C["panel"], fg=self.C["fg"]
        )
        self.lbl_progression.pack(side=tk.RIGHT)

        # Sélecteur de classe à onglets
        self.tabs_frame = tk.Frame(self, bg=self.C["panel"], padx=18)
        self.tabs_frame.pack(fill=tk.X, pady=(0, 8))
        self.btn_tabs = {}
        for cid, info in CLASSES.items():
            b = tk.Button(
                self.tabs_frame,
                text=f"{info['icone']} {info['titre']} · {info['sous_titre']}",
                font=police_corps(9, gras=True),
                relief="flat",
                cursor="hand2",
                padx=12,
                pady=4,
                command=lambda c=cid: self._changer_classe(c),
            )
            b.pack(side=tk.LEFT, padx=(0, 8))
            self.btn_tabs[cid] = b

        # Zone centrale défilante avec Canvas
        wrap = tk.Frame(self, bg=self.C["bg"])
        wrap.pack(fill=tk.BOTH, expand=True, padx=12, pady=(0, 10))

        self.canvas = tk.Canvas(wrap, bg="#ebd9be", highlightthickness=0)
        scrollbar = ttk.Scrollbar(wrap, orient="vertical", command=self.canvas.yview)
        self.canvas.configure(yscrollcommand=scrollbar.set)

        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.canvas.bind("<Configure>", lambda e: self._dessiner_carte())
        self.bind("<MouseWheel>", lambda e: self.canvas.yview_scroll(int(-1 * (e.delta / 120)), "units"))
        self.bind("<Destroy>", self._sur_detruire)

        self._rafraichir_onglets()
        audio.play_parchemin()

    def _sur_detruire(self, event=None):
        if self._pulse_job:
            try:
                self.after_cancel(self._pulse_job)
            except Exception:
                pass
            self._pulse_job = None
        self._cacher_tooltip()

    def _rafraichir_onglets(self):
        for cid, btn in self.btn_tabs.items():
            if cid == self.classe_active:
                btn.configure(bg=self.C["accent"], fg=self.C["sel_fg"])
            else:
                btn.configure(bg=self.C["editor"], fg=self.C["fg"])

    def _changer_classe(self, classe):
        if classe in CLASSES:
            audio.play_click()
            self.classe_active = classe
            self.app.data["classe_active"] = classe
            self.app._sauvegarder()
            self.app._rafraichir_selecteur_classe()
            self.app._populate_tree()
            self.app._refresh_badges()
            self._rafraichir_onglets()
            self._dessiner_carte()

    def _load_avatar_image(self):
        """Charge la vignette du héros pour matérialiser sa position sur la Via Appia."""
        if not HAS_PIL:
            return
        sexe = self.app.data.get("avatar", "garcon")
        fname = f"avatar_{sexe}_medaillon_48.png"
        p = ASSETS_IMAGES / fname
        if not p.exists():
            p = ASSETS_IMAGES / "avatar_garcon_medaillon_48.png"
        if p.exists():
            try:
                im = Image.open(p).convert("RGBA")
                self._photo_avatar = ImageTk.PhotoImage(im)
            except Exception:
                self._photo_avatar = None

    def _dessiner_decor_arriere_plan(self, cw, total_h, scale):
        """Dessine le paysage panoramique de la campagne romaine (ciel, collines, aqueduc, cyprès)."""
        ciel_h = int(120 * scale)
        self.canvas.create_rectangle(0, 0, cw, ciel_h, fill="#cce5f4", outline="")
        self.canvas.create_rectangle(0, ciel_h, cw, int(180 * scale), fill="#faebd7", outline="")
        self.canvas.create_rectangle(0, int(180 * scale), cw, total_h, fill="#eedec7", outline="")

        # Chaîne de montagnes lointaines (Monts Albains / Apennins)
        pts_montagnes = [
            0, int(115 * scale),
            int(90 * scale), int(75 * scale),
            int(190 * scale), int(95 * scale),
            int(310 * scale), int(65 * scale),
            int(460 * scale), int(90 * scale),
            int(620 * scale), int(70 * scale),
            int(780 * scale), int(105 * scale),
            cw, int(80 * scale),
            cw, int(160 * scale),
            0, int(160 * scale)
        ]
        self.canvas.create_polygon(pts_montagnes, fill="#b5c8d6", outline="")

        # Collines verdoyantes du Latium
        pts_collines_1 = [
            0, int(145 * scale),
            int(140 * scale), int(120 * scale),
            int(290 * scale), int(140 * scale),
            int(450 * scale), int(115 * scale),
            int(610 * scale), int(142 * scale),
            int(750 * scale), int(125 * scale),
            cw, int(135 * scale),
            cw, int(210 * scale),
            0, int(210 * scale)
        ]
        self.canvas.create_polygon(pts_collines_1, fill="#c0d8ac", outline="")

        pts_collines_2 = [
            0, int(180 * scale),
            int(180 * scale), int(155 * scale),
            int(370 * scale), int(185 * scale),
            int(540 * scale), int(160 * scale),
            cw, int(185 * scale),
            cw, int(250 * scale),
            0, int(250 * scale)
        ]
        self.canvas.create_polygon(pts_collines_2, fill="#acc798", outline="")

        # Aqueduc romain antique enjambant la vallée à l'horizon
        aq_y = int(142 * scale)
        aq_h = int(28 * scale)
        aq_w = int(18 * scale)
        self.canvas.create_line(
            int(20 * scale), aq_y, cw - int(20 * scale), aq_y,
            fill="#8d7256", width=max(2, int(4 * scale))
        )
        pas_aq = int(36 * scale)
        for px in range(int(30 * scale), cw - int(30 * scale), pas_aq):
            self.canvas.create_rectangle(
                px, aq_y, px + aq_w, aq_y + aq_h,
                fill="#bfa383", outline="#8d7256"
            )
            self.canvas.create_arc(
                px + int(2 * scale), aq_y + int(8 * scale),
                px + aq_w - int(2 * scale), aq_y + aq_h,
                start=0, extent=180, fill="#acc798", outline="#8d7256"
            )

        # Arbres méditerranéens (Cyprès toscans et Pins parasols) le long de la route
        step_arbres = int(140 * scale)
        for y_a in range(int(220 * scale), total_h - int(60 * scale), step_arbres):
            cx_g = int(35 * scale) + ((y_a // 40) % 20)
            self._dessiner_cypres(cx_g, y_a, scale)
            px_d = cw - int(40 * scale) - ((y_a // 30) % 25)
            self._dessiner_pin(px_d, y_a + int(50 * scale), scale)

    def _dessiner_cypres(self, x, y, scale):
        h = int(36 * scale)
        w = int(7 * scale)
        self.canvas.create_line(x, y, x, y + int(6 * scale), fill="#4a3018", width=max(1, int(2 * scale)))
        self.canvas.create_polygon([x, y - h, x - w, y, x + w, y], fill="#1e3818", outline="#13260f")

    def _dessiner_pin(self, x, y, scale):
        h = int(30 * scale)
        r = int(14 * scale)
        self.canvas.create_line(x, y, x - int(3 * scale), y - h, fill="#52391e", width=max(1, int(3 * scale)))
        self.canvas.create_oval(
            x - r - int(3 * scale), y - h - int(10 * scale),
            x + r - int(3 * scale), y - h + int(4 * scale),
            fill="#2c4d22", outline="#1a3314"
        )

    def _dessiner_carte(self):
        if self._pulse_job:
            try:
                self.after_cancel(self._pulse_job)
            except Exception:
                pass
            self._pulse_job = None

        mondes = get_curriculum_classe(self.classe_active)
        info_classe = CLASSES.get(self.classe_active, CLASSES["5eme"])
        self.lbl_titre_carte.configure(
            text=f"🗺️ La Via Appia — {info_classe['titre']} : {info_classe['sous_titre']}"
        )

        completed_set = set(self.app.data.get("completed", []))
        total_items = sum(len(lvl["lessons"]) for lvl in mondes)
        faits = sum(1 for lvl in mondes for les in lvl["lessons"] if les["id"] in completed_set)
        pct = int(100 * faits / max(1, total_items))
        self.lbl_progression.configure(
            text=f"Progression {info_classe['titre']} : {faits}/{total_items} leçons ({pct}%)"
        )

        self._rafraichir_onglets()
        self.canvas.delete("all")
        cw = max(720, self.canvas.winfo_width())

        scale = obtenir_facteur_echelle(self.canvas)
        monde_height = int(210 * scale)
        total_h = len(mondes) * monde_height + int(140 * scale)
        self.canvas.configure(scrollregion=(0, 0, cw, total_h))

        # 0. Décor panoramique en arrière-plan
        self._dessiner_decor_arriere_plan(cw, total_h, scale)

        echecs = self.app.data.get("echecs", {})

        # Tracé de la route romaine pavée sinueuse
        centre_x = cw // 2
        points_route = []
        offset_ampl = int(90 * scale)
        for i in range(len(mondes)):
            y = int(70 * scale) + i * monde_height + int(85 * scale)
            offset_x = -offset_ampl if (i % 2 == 1) else offset_ampl
            points_route.append((centre_x + offset_x, y))

        # 1. Bordure d'accotement pavé antique
        w_large = int(48 * scale)
        w_moyen = int(38 * scale)
        w_centre = int(28 * scale)
        for i in range(len(points_route) - 1):
            x1, y1 = points_route[i]
            x2, y2 = points_route[i + 1]
            # Bordure extérieure en dalles de lave
            self.canvas.create_line(x1, y1, x2, y2, fill="#a68058", width=w_large, capstyle="round")
            # Corps de la chaussée (silices et mortier antique)
            self.canvas.create_line(x1, y1, x2, y2, fill="#cfab7e", width=w_moyen, capstyle="round")
            self.canvas.create_line(x1, y1, x2, y2, fill="#dfbe92", width=w_centre, capstyle="round")
            # Joints de pavés romains transversaux
            dx = x2 - x1
            dy = y2 - y1
            dist = math.hypot(dx, dy)
            if dist > 0:
                pas = int(30 * scale)
                nb_joints = max(1, int(dist // pas))
                for s in range(1, nb_joints):
                    t = s / nb_joints
                    px = x1 + dx * t
                    py = y1 + dy * t
                    # Normale perpendiculaire
                    nx = -dy / dist * (w_moyen / 2.2)
                    ny = dx / dist * (w_moyen / 2.2)
                    self.canvas.create_line(
                        px - nx, py - ny, px + nx, py + ny,
                        fill="#b08b5e", width=max(1, int(1.5 * scale))
                    )
            # Ligne médiane dorée
            self.canvas.create_line(
                x1, y1, x2, y2, fill="#fdf3d4",
                width=max(2, int(3 * scale)), dash=(int(10 * scale), int(8 * scale))
            )

        self._active_milestone = None
        premiere_inachevee_trouvee = False

        # 2. Placer chaque Monde
        for i, lvl in enumerate(mondes):
            y_base = int(65 * scale) + i * monde_height
            x_centre = points_route[i][0]

            # Bannière du Monde en marbre & bronze impérial
            b_w = int(230 * scale)
            b_h = int(38 * scale)
            # Ombre portée de la bannière
            self.canvas.create_rectangle(
                x_centre - b_w + 3, y_base + 3, x_centre + b_w + 3, y_base + b_h + 3,
                fill="#2b1a10", outline=""
            )
            # Fond pourpre impérial avec double liseré doré
            self.canvas.create_rectangle(
                x_centre - b_w, y_base, x_centre + b_w, y_base + b_h,
                fill="#4a151b", outline="#ffd700", width=max(2, int(2 * scale))
            )
            self.canvas.create_rectangle(
                x_centre - b_w + 3, y_base + 3, x_centre + b_w - 3, y_base + b_h - 3,
                fill="#380d12", outline="#c9a13b", width=1
            )
            self.canvas.create_text(
                x_centre, y_base + b_h // 2,
                text=lvl["title"],
                font=police_corps(11, gras=True),
                fill="#ffd700"
            )

            # Placer les leçons de ce monde
            lecons = lvl["lessons"]
            n_lecons = len(lecons)
            largeur_bloc = min(int(680 * scale), cw - int(80 * scale))
            pas_x = largeur_bloc // max(1, n_lecons)
            start_x = centre_x - (largeur_bloc // 2) + (pas_x // 2)

            for j, les in enumerate(lecons):
                lx = start_x + j * pas_x
                ly = y_base + int(80 * scale) + ((j % 2) * int(36 * scale))

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
                    fill_c = "#2e7d32" if not is_boss else "#d4af37"
                    symb = "🏆" if not is_boss else "👑"
                else:
                    etoiles = ""
                    if not premiere_inachevee_trouvee:
                        premiere_inachevee_trouvee = True
                        self._active_milestone = (lx, ly, int((22 if not is_boss else 28) * scale))
                        fill_c = "#e67e22" if not is_boss else "#c0392b"
                        symb = "⚡" if not is_boss else "⚔️"
                    else:
                        fill_c = "#5d4037"
                        symb = "🔒"

                # Pointeur / Borne milliaire romaine
                rayon = int((22 if not is_boss else 28) * scale)

                # Piédestal en pierre taillée sous la borne
                self.canvas.create_rectangle(
                    lx - rayon - int(4 * scale), ly + rayon - int(4 * scale),
                    lx + rayon + int(4 * scale), ly + rayon + int(6 * scale),
                    fill="#6e5641", outline="#3e2d1d", width=1, tags=("milestone", lid)
                )

                # Ombre portée de la borne
                self.canvas.create_oval(
                    lx - rayon + 2, ly - rayon + 4, lx + rayon + 2, ly + rayon + 4,
                    fill="#3b2310", outline="", tags=("milestone", lid)
                )

                # Couronne de laurier dorée pour les étapes accomplies
                if est_fait:
                    self.canvas.create_oval(
                        lx - rayon - int(4 * scale), ly - rayon - int(4 * scale),
                        lx + rayon + int(4 * scale), ly + rayon + int(4 * scale),
                        outline="#ffd700", width=max(2, int(2 * scale)), tags=("milestone", lid)
                    )

                self.canvas.create_oval(
                    lx - rayon, ly - rayon, lx + rayon, ly + rayon,
                    fill=fill_c, outline="#ffffff" if est_fait or lid == (self._active_milestone and lid) else "#a6855b",
                    width=max(2, int(2 * scale)),
                    tags=("milestone", lid)
                )
                self.canvas.create_text(
                    lx, ly, text=symb,
                    font=("Segoe UI Emoji", int((13 if not is_boss else 17) * scale)),
                    tags=("milestone", lid)
                )

                # Étoiles au-dessus de la borne
                if etoiles:
                    self.canvas.create_text(
                        lx, ly - rayon - int(10 * scale),
                        text=etoiles, font=("Segoe UI Emoji", int(8 * scale))
                    )

                # Titre propre sous la borne (sans coupure brute)
                titre_net = les["title"].replace("⚔️ Défi de l'Arène : ", "").replace("⚔️ Combat d'Arène Ultime : ", "")
                mots = textwrap.wrap(titre_net, width=17)
                if len(mots) > 2:
                    mots = [mots[0], mots[1][:14] + "…"]
                titre_affiche = "\n".join(mots)

                th = len(mots) * int(12 * scale) + int(8 * scale)
                tw = int(54 * scale)
                ty_pos = ly + rayon + int(10 * scale)

                # Cartouche en pierre/parchemin avec ombre douce
                self.canvas.create_rectangle(
                    lx - tw + 2, ty_pos, lx + tw + 2, ty_pos + th + 2,
                    fill="#3b2310", outline="", tags=("milestone", lid)
                )
                self.canvas.create_rectangle(
                    lx - tw, ty_pos - int(2 * scale), lx + tw, ty_pos + th,
                    fill="#fcf8f0", outline="#cbb592", width=1, tags=("milestone", lid)
                )
                self.canvas.create_text(
                    lx, ty_pos + th // 2 - int(1 * scale), text=titre_affiche,
                    font=police_corps(7, gras=True), fill="#2e1a0b", justify=tk.CENTER,
                    tags=("milestone", lid)
                )

                # Interaction au clic & survol
                def _clic_borne(e, target_id=lid):
                    self._cacher_tooltip()
                    self.app._charger_item(target_id)
                    audio.play_coin()
                    self.destroy()

                def _survol_borne(e, lecon_data=les, x_coord=lx, y_coord=ly):
                    self.canvas.configure(cursor="hand2")
                    self._montrer_tooltip(lecon_data, x_coord, y_coord)

                def _quitter_borne(e):
                    self.canvas.configure(cursor="")
                    self._cacher_tooltip()

                self.canvas.tag_bind(lid, "<Button-1>", _clic_borne)
                self.canvas.tag_bind(lid, "<Enter>", _survol_borne)
                self.canvas.tag_bind(lid, "<Leave>", _quitter_borne)

        # Lancer le halo pulsant et l'avatar du héros sur la borne active
        if self._active_milestone:
            self._animer_halo()

    def _animer_halo(self):
        """Anime un halo lumineux ondulant et le marqueur avatar du héros sur la prochaine étape."""
        if not self._active_milestone or not self.canvas.winfo_exists():
            return

        lx, ly, r_base = self._active_milestone
        self.canvas.delete("halo_actif")

        self._pulse_frame = (self._pulse_frame + 1) % 16
        # Oscillation sinusoïdale douce
        delta = math.sin(self._pulse_frame * (math.pi / 8)) * 6
        r = r_base + 3 + delta
        couleur = "#ffd700" if delta > 0 else "#ffe082"

        self.canvas.create_oval(
            lx - r, ly - r, lx + r, ly + r,
            outline=couleur, width=3, tags=("halo_actif",)
        )
        self.canvas.create_oval(
            lx - r - 4, ly - r - 4, lx + r + 4, ly + r + 4,
            outline="#d4af37", width=1, tags=("halo_actif",)
        )

        # Flottement doux de l'avatar du joueur au-dessus de la borne
        bob = int(math.sin(self._pulse_frame * (math.pi / 8)) * 3)
        avatar_y = ly - r_base - 32 + bob

        if self._photo_avatar:
            self.canvas.create_image(lx, avatar_y, image=self._photo_avatar, tags=("halo_actif",))

        # Bulle dorée "Tu es ici !"
        b_w, b_h = 42, 11
        by = avatar_y - 28
        self.canvas.create_rectangle(
            lx - b_w, by - b_h, lx + b_w, by + b_h,
            fill="#d4af37", outline="#1a1409", width=1, tags=("halo_actif",)
        )
        self.canvas.create_text(
            lx, by, text="📍 Tu es ici !",
            font=police_corps(8, gras=True), fill="#1a1409", tags=("halo_actif",)
        )

        self._pulse_job = self.after(90, self._animer_halo)

    def _montrer_tooltip(self, lecon, lx, ly):
        """Affiche une infobulle flottante élégante au survol d'une borne."""
        self._cacher_tooltip()
        lid = lecon["id"]
        est_fait = lid in self.app.data.get("completed", [])
        is_boss = (lecon.get("type") == "arene")

        f_tip = tk.Frame(
            self.canvas, bg="#24283b", bd=1, relief="solid",
            highlightbackground="#ffd700", highlightthickness=1, padx=10, pady=6
        )
        t_titre = lecon.get("title", "")
        tk.Label(
            f_tip, text=t_titre, font=police_corps(9, gras=True),
            bg="#24283b", fg="#ffd700"
        ).pack(anchor="w")

        type_nom = "⚔️ Défi du Colisée" if is_boss else ("📝 Exercice Pratique" if lecon.get("type") == "exercice" else "🏛️ Découverte")
        tk.Label(
            f_tip, text=f"Type : {type_nom}", font=police_corps(8),
            bg="#24283b", fg="#a9b1d6"
        ).pack(anchor="w")

        statut_txt = "✅ Conquis !" if est_fait else "⚡ Étape suivante à débloquer"
        tk.Label(
            f_tip, text=statut_txt, font=police_corps(8, italique=True),
            bg="#24283b", fg="#9ece6a" if est_fait else "#e0af68"
        ).pack(anchor="w")

        reward = "+20 Sesterces 🪙" if is_boss else "+10 Sesterces 🪙"
        tk.Label(
            f_tip, text=f"Récompense : {reward}", font=police_corps(8, gras=True),
            bg="#24283b", fg="#ffd700"
        ).pack(anchor="w")

        tip_id = self.canvas.create_window(lx, ly - 50, window=f_tip, anchor="s")
        self._tooltip_window = (tip_id, f_tip)

    def _cacher_tooltip(self):
        if self._tooltip_window:
            try:
                tip_id, f_tip = self._tooltip_window
                self.canvas.delete(tip_id)
                f_tip.destroy()
            except Exception:
                pass
            self._tooltip_window = None
