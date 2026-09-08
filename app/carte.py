"""
Carte d'Aventure interactive : La Via Appia de Rome.
Affiche la route panoramique des Mondes romains avec chaussée pavée sinueuse,
aqueduc romain Aqua Claudia, collines du Latium, pins parasols méditerranéens,
arcs de triomphe monumentaux, bornes 3D en marbre et or impérial,
et le marqueur animé du héros Marcus sur la Via Appia.
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

# Correspondance des portraits de boss pour les arènes finales
BOSS_PAR_MONDE = {
    "monde1": "boss_mercure_cadre_140.png",
    "monde2": "boss_sphinx_cadre_140.png",
    "monde3": "boss_lion_cadre_140.png",
    "monde4": "boss_minotaure_cadre_140.png",
    "monde5": "boss_gladiateur_cadre_140.png",
    "monde6": "boss_gladiateur_cadre_140.png",
    "monde11": "boss_mercure_cadre_140.png",
    "monde16": "boss_minotaure_cadre_140.png",
    "monde21": "boss_gladiateur_cadre_140.png",
    "monde26": "boss_gladiateur_cadre_140.png",
}


def to_roman(n: int) -> str:
    """Convertit un entier 1..50 en chiffre romain majuscule classique."""
    if n <= 0:
        return "I"
    val = [50, 40, 10, 9, 5, 4, 1]
    syb = ["L", "XL", "X", "IX", "V", "IV", "I"]
    res = ""
    i = 0
    while n > 0:
        for _ in range(n // val[i]):
            res += syb[i]
            n -= val[i]
        i += 1
    return res or "I"


def calculer_offset_route(j: int, n_lecons: int, w_idx: int) -> float:
    """Calcule l'ondulation sinueuse de la route pour placer chaque borne sur les pavés."""
    direction = 1 if (w_idx % 2 == 1) else -1
    if n_lecons <= 1 or j == n_lecons - 1:
        return 0.0  # L'arène finale de boss est toujours centrée devant l'Arc de Triomphe
    t = j / max(1, n_lecons - 1)
    val = math.sin(t * math.pi * 1.25) - 0.45 * (1.0 - t)
    return val * 72.0 * direction


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

        adapter_geometrie_fenetre(self, 960, 720, min_w=860, min_h=560)

        self._pulse_job = None
        self._pulse_frame = 0
        self._active_milestone = None  # (lx, ly, rayon)
        self._tooltip_window = None
        self._photo_avatar = None
        self._cache_images = {}
        self._has_scrolled_to_active = False

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
                padx=14,
                pady=5,
                command=lambda c=cid: self._changer_classe(c),
            )
            b.pack(side=tk.LEFT, padx=(0, 8))
            self.btn_tabs[cid] = b

        # Zone centrale défilante avec Canvas
        wrap = tk.Frame(self, bg=self.C["bg"])
        wrap.pack(fill=tk.BOTH, expand=True, padx=12, pady=(0, 10))

        self.canvas = tk.Canvas(wrap, bg="#fcf8f0", highlightthickness=0)
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
            self._has_scrolled_to_active = False
            self._rafraichir_onglets()
            self._dessiner_carte()

    def _load_avatar_image(self):
        """Charge la vignette médaillon du héros pour marquer sa position sur la Via Appia."""
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

    def _load_boss_image(self, boss_fname: str, target_size: int):
        """Charge et redimensionne un portrait de boss de fin de monde."""
        if not HAS_PIL or not boss_fname:
            return None
        cache_key = (boss_fname, target_size)
        if cache_key in self._cache_images:
            return self._cache_images[cache_key]
        p = ASSETS_IMAGES / boss_fname
        if p.exists():
            try:
                im = Image.open(p).convert("RGBA")
                im_resized = im.resize((target_size, target_size), Image.Resampling.LANCZOS)
                photo = ImageTk.PhotoImage(im_resized)
                self._cache_images[cache_key] = photo
                return photo
            except Exception:
                return None
        return None

    # =========================================================================
    # DÉCOR PANORAMIQUE DE LA CAMPAGNE ROMAINE (Latium, Aqueduc, Pins, Cyprès)
    # =========================================================================

    def _dessiner_decor_arriere_plan(self, cw: int, total_h: int, scale: float):
        """Dessine la fresque panoramique : ciel d'aurore, aqueduc Aqua Claudia, collines, arbres."""
        # 1. Ciel classique d'Italie centrale (dégradé d'aurore dorée vers l'azur)
        h_ciel = int(145 * scale)
        couleurs_ciel = ["#a0cbe8", "#b8d9f0", "#d1e6f5", "#fae8cc", "#f8d9be"]
        nb_tranches = len(couleurs_ciel)
        pas_ciel = h_ciel / nb_tranches
        for i, col in enumerate(couleurs_ciel):
            y1 = int(i * pas_ciel)
            y2 = int((i + 1) * pas_ciel) + (1 if i == nb_tranches - 1 else 0)
            self.canvas.create_rectangle(0, y1, cw, y2, fill=col, outline="")

        # Nuages classiques doux flottant dans le ciel
        self._dessiner_nuage(int(110 * scale), int(45 * scale), scale)
        self._dessiner_nuage(int(cw * 0.58), int(35 * scale), scale * 1.1)
        self._dessiner_nuage(cw - int(120 * scale), int(60 * scale), scale * 0.85)

        # 2. Chaîne lointaine des Monts Albains et Apennins (perspective bleutée)
        pts_apennins = [
            0, int(115 * scale),
            int(80 * scale), int(85 * scale),
            int(180 * scale), int(105 * scale),
            int(290 * scale), int(72 * scale),
            int(420 * scale), int(98 * scale),
            int(560 * scale), int(68 * scale),
            int(690 * scale), int(102 * scale),
            int(820 * scale), int(75 * scale),
            cw, int(92 * scale),
            cw, int(145 * scale),
            0, int(145 * scale),
        ]
        self.canvas.create_polygon(pts_apennins, fill="#98adc2", outline="")

        # 3. Collines étagées du Latium (vignobles et oliveraies)
        pts_colline_lointaine = [
            0, int(135 * scale),
            int(120 * scale), int(112 * scale),
            int(280 * scale), int(130 * scale),
            int(460 * scale), int(108 * scale),
            int(640 * scale), int(132 * scale),
            int(790 * scale), int(116 * scale),
            cw, int(128 * scale),
            cw, int(170 * scale),
            0, int(170 * scale),
        ]
        self.canvas.create_polygon(pts_colline_lointaine, fill="#b5c89d", outline="")

        pts_colline_proche = [
            0, int(162 * scale),
            int(150 * scale), int(140 * scale),
            int(360 * scale), int(164 * scale),
            int(540 * scale), int(138 * scale),
            int(740 * scale), int(160 * scale),
            cw, int(145 * scale),
            cw, int(220 * scale),
            0, int(220 * scale),
        ]
        self.canvas.create_polygon(pts_colline_proche, fill="#c7d9a9", outline="")

        # 4. Le Grand Aqueduc Romain (Aqua Claudia) à double niveau d'arches
        aq_y_base = int(122 * scale)
        aq_h = int(48 * scale)
        aq_specus_h = int(7 * scale)

        # Canal d'eau supérieur (Specus)
        self.canvas.create_rectangle(
            0, aq_y_base, cw, aq_y_base + aq_specus_h,
            fill="#7b5d40", outline="#543e2a", width=1
        )
        self.canvas.create_line(
            0, aq_y_base + int(2 * scale), cw, aq_y_base + int(2 * scale),
            fill="#a6845f", width=max(1, int(1.5 * scale))
        )

        # Arches de l'aqueduc enjambant toute la largeur du panorama
        pas_arcade = int(42 * scale)
        largeur_arche = int(24 * scale)

        for px in range(int(10 * scale), cw + pas_arcade, pas_arcade):
            # Pilier de travertin
            self.canvas.create_rectangle(
                px, aq_y_base + aq_specus_h,
                px + largeur_arche, aq_y_base + aq_h,
                fill="#b89a77", outline="#6e5237", width=1
            )
            # Voûte cintrée laissant entrevoir les collines et le ciel
            self.canvas.create_arc(
                px + int(3 * scale), aq_y_base + aq_specus_h + int(10 * scale),
                px + largeur_arche - int(3 * scale), aq_y_base + aq_h + int(8 * scale),
                start=0, extent=180, fill="#c7d9a9", outline="#6e5237", width=1
            )
            # Liseré de clé de voûte et corniche d'imposte
            self.canvas.create_line(
                px - int(2 * scale), aq_y_base + aq_specus_h + int(10 * scale),
                px + largeur_arche + int(2 * scale), aq_y_base + aq_specus_h + int(10 * scale),
                fill="#543e2a", width=1
            )

        # 5. Plaine de la Campagne Romaine et fond de parchemin chaud
        self.canvas.create_rectangle(
            0, int(205 * scale), cw, total_h,
            fill="#f7f2e6", outline=""
        )

        # Filets cartographiques latéraux avec encadrement classique
        w_cadre = int(14 * scale)
        self.canvas.create_line(
            w_cadre, int(210 * scale), w_cadre, total_h - int(20 * scale),
            fill="#dac4a4", width=1, dash=(int(6 * scale), int(6 * scale))
        )
        self.canvas.create_line(
            cw - w_cadre, int(210 * scale), cw - w_cadre, total_h - int(20 * scale),
            fill="#dac4a4", width=1, dash=(int(6 * scale), int(6 * scale))
        )

        # 6. Rose des Vents antique (Rosa Ventorum) au sommet droit
        self._dessiner_rose_des_vents(cw - int(80 * scale), int(65 * scale), scale)

        # 7. Végétation méditerranéenne emblématique et monuments de la Campagne Romaine
        step_vegetation = int(240 * scale)
        for idx_v, y_veg in enumerate(range(int(240 * scale), total_h - int(90 * scale), step_vegetation)):
            # Côté gauche : Pin parasol majestueux
            px_g = int(55 * scale) + ((y_veg // 50) % int(30 * scale))
            self._dessiner_pin_parasol(px_g, y_veg, scale)

            # Côté droit : Paire de cyprès toscans sentinelles
            px_d = cw - int(65 * scale) - ((y_veg // 45) % int(25 * scale))
            self._dessiner_cypres(px_d, y_veg + int(50 * scale), scale)
            self._dessiner_cypres(px_d + int(18 * scale), y_veg + int(64 * scale), scale * 0.85)

            # Monuments et architectures classiques au fil du voyage
            if idx_v % 4 == 0:
                self._dessiner_monument_milliarium(int(35 * scale), y_veg + int(115 * scale), scale)
            elif idx_v % 4 == 1:
                self._dessiner_villa_romaine(cw - int(80 * scale), y_veg + int(110 * scale), scale)
            elif idx_v % 4 == 2:
                self._dessiner_fontaine_romaine(int(36 * scale), y_veg + int(120 * scale), scale)
            else:
                self._dessiner_aedicula(cw - int(52 * scale), y_veg + int(115 * scale), scale)

    def _dessiner_nuage(self, cx: int, cy: int, scale: float):
        """Dessine un nuage doux et vaporeux dans le ciel méditerranéen."""
        r = int(14 * scale)
        self.canvas.create_oval(
            cx - r * 2, cy - r, cx + r * 2, cy + r,
            fill="#ffffff", outline=""
        )
        self.canvas.create_oval(
            cx - r, cy - int(r * 1.5), cx + r, cy + r,
            fill="#ffffff", outline=""
        )
        self.canvas.create_oval(
            cx + int(r * 0.8), cy - int(r * 1.1), cx + int(r * 2.6), cy + int(r * 0.8),
            fill="#ffffff", outline=""
        )

    def _dessiner_rose_des_vents(self, cx: int, cy: int, scale: float):
        """Dessine une Rose des Vents antique classique avec les 4 points cardinaux latins."""
        r = int(22 * scale)
        # Cercle extérieur doré
        self.canvas.create_oval(
            cx - r, cy - r, cx + r, cy + r,
            outline="#c49b38", width=max(1, int(1.5 * scale))
        )
        # Étoile à 8 pointes
        r_pt = int(20 * scale)
        r_in = int(6 * scale)
        # Aiguille Nord (Septentrio) dorée et pourpre
        self.canvas.create_polygon(
            [cx, cy - r_pt, cx - r_in, cy, cx, cy - r_in],
            fill="#c53030", outline="#8b1e28"
        )
        self.canvas.create_polygon(
            [cx, cy - r_pt, cx + r_in, cy, cx, cy - r_in],
            fill="#e2b744", outline="#b8860b"
        )
        # Aiguille Sud (Meridies)
        self.canvas.create_polygon(
            [cx, cy + r_pt, cx - r_in, cy, cx, cy + r_in],
            fill="#d4af37", outline="#8b6508"
        )
        # Aiguilles Est / Ouest
        self.canvas.create_polygon(
            [cx + r_pt, cy, cx, cy - r_in, cx + r_in, cy],
            fill="#dfbe6b", outline="#8b6508"
        )
        self.canvas.create_polygon(
            [cx - r_pt, cy, cx, cy - r_in, cx - r_in, cy],
            fill="#dfbe6b", outline="#8b6508"
        )
        # Point central et initiale N (Septentrio)
        self.canvas.create_oval(
            cx - int(3 * scale), cy - int(3 * scale),
            cx + int(3 * scale), cy + int(3 * scale),
            fill="#ffd700", outline="#543e2a"
        )
        self.canvas.create_text(
            cx, cy - r_pt - int(8 * scale), text="N",
            font=police_corps(7, gras=True), fill="#8b1e28"
        )

    def _dessiner_pin_parasol(self, x: int, y: int, scale: float):
        """Dessine un authentique Pin parasol romain (Pinus pinea) avec grand dôme aplati étagé."""
        h_tronc = int(58 * scale)
        # Ombre portée de l'arbre au sol
        self.canvas.create_oval(
            x - int(24 * scale), y - int(4 * scale),
            x + int(24 * scale), y + int(5 * scale),
            fill="#d8cbb7", outline=""
        )
        # Tronc sculpté, sinueux et légèrement courbé
        pts_tronc = [
            x - int(4 * scale), y,
            x - int(2 * scale), y - int(h_tronc * 0.45),
            x - int(5 * scale), y - h_tronc,
            x - int(1 * scale), y - h_tronc,
            x + int(1 * scale), y - int(h_tronc * 0.45),
            x + int(3 * scale), y,
        ]
        self.canvas.create_polygon(pts_tronc, fill="#5a3d24", outline="#3c2613")

        # Ramifications principales en éventail
        y_cime = y - h_tronc
        self.canvas.create_line(
            x - int(3 * scale), y_cime,
            x - int(26 * scale), y_cime - int(12 * scale),
            fill="#5a3d24", width=max(1, int(3 * scale))
        )
        self.canvas.create_line(
            x, y_cime,
            x + int(24 * scale), y_cime - int(10 * scale),
            fill="#5a3d24", width=max(1, int(3 * scale))
        )

        # Dôme de feuillage parasol étagé (3 couches d'ovales aplatis avec rehauts de lumière)
        # Couche inférieure d'ombre
        self.canvas.create_oval(
            x - int(38 * scale), y_cime - int(24 * scale),
            x + int(36 * scale), y_cime - int(4 * scale),
            fill="#1b3917", outline=""
        )
        # Couche médiane de pin méditerranéen
        self.canvas.create_oval(
            x - int(34 * scale), y_cime - int(29 * scale),
            x + int(32 * scale), y_cime - int(9 * scale),
            fill="#2c5a24", outline=""
        )
        # Dôme supérieur recevant la lumière dorée du soleil
        self.canvas.create_oval(
            x - int(28 * scale), y_cime - int(33 * scale),
            x + int(26 * scale), y_cime - int(16 * scale),
            fill="#417c37", outline=""
        )
        self.canvas.create_arc(
            x - int(24 * scale), y_cime - int(33 * scale),
            x + int(22 * scale), y_cime - int(20 * scale),
            start=20, extent=140, style="arc",
            outline="#67a858", width=max(1, int(2 * scale))
        )

    def _dessiner_cypres(self, x: int, y: int, scale: float):
        """Dessine un cyprès toscan élancé et pointu (Cupressus sempervirens)."""
        h = int(48 * scale)
        w = int(8 * scale)
        # Ombre au sol
        self.canvas.create_oval(
            x - int(9 * scale), y - int(3 * scale),
            x + int(9 * scale), y + int(4 * scale),
            fill="#d8cbb7", outline=""
        )
        # Petit pied de tronc
        self.canvas.create_line(
            x, y, x, y - int(6 * scale),
            fill="#45311e", width=max(1, int(2 * scale))
        )
        # Silhouette fuselée
        pts_cypres = [
            x, y - h,
            x - w, y - int(h * 0.45),
            x - int(w * 0.8), y - int(6 * scale),
            x + int(w * 0.8), y - int(6 * scale),
            x + w, y - int(h * 0.45),
        ]
        self.canvas.create_polygon(pts_cypres, fill="#193316", outline="#10210e")
        # Touche de lumière latérale
        self.canvas.create_line(
            x, y - h + int(4 * scale),
            x - int(w * 0.4), y - int(10 * scale),
            fill="#2c5427", width=max(1, int(1.5 * scale))
        )

    def _dessiner_monument_milliarium(self, x: int, y: int, scale: float):
        """Dessine une borne milliaire romaine sculptée (cippus) bordant la Via Appia."""
        w = int(14 * scale)
        h = int(28 * scale)
        # Socle carré
        self.canvas.create_rectangle(
            x - w // 2 - int(2 * scale), y,
            x + w // 2 + int(2 * scale), y + int(6 * scale),
            fill="#8d765d", outline="#544332", width=1
        )
        # Colonne milliaire en travertin
        self.canvas.create_rectangle(
            x - w // 2, y - h,
            x + w // 2, y,
            fill="#baa48b", outline="#6e5640", width=1
        )
        # Sommet arrondi
        self.canvas.create_arc(
            x - w // 2, y - h - int(6 * scale),
            x + w // 2, y - h + int(6 * scale),
            start=0, extent=180, fill="#baa48b", outline="#6e5640", width=1
        )
        # Inscription antique miniature
        self.canvas.create_line(
            x - int(4 * scale), y - int(h * 0.65),
            x + int(4 * scale), y - int(h * 0.65),
            fill="#544332", width=1
        )
        self.canvas.create_line(
            x - int(3 * scale), y - int(h * 0.45),
            x + int(3 * scale), y - int(h * 0.45),
            fill="#544332", width=1
        )

    def _dessiner_aedicula(self, x: int, y: int, scale: float):
        """Dessine une aedicula (sanctuaire miniature romain à fronton classique)."""
        w = int(22 * scale)
        h = int(26 * scale)
        # Socle
        self.canvas.create_rectangle(
            x - w // 2, y, x + w // 2, y + int(4 * scale),
            fill="#8a735c", outline="#4d3c2d", width=1
        )
        # Colonnes
        col_w = max(1, int(2 * scale))
        self.canvas.create_line(x - int(7 * scale), y, x - int(7 * scale), y - h, fill="#c9b7a1", width=col_w)
        self.canvas.create_line(x + int(7 * scale), y, x + int(7 * scale), y - h, fill="#c9b7a1", width=col_w)
        # Fronton triangulaire
        self.canvas.create_polygon(
            [x - w // 2, y - h, x, y - h - int(8 * scale), x + w // 2, y - h],
            fill="#a68e74", outline="#4d3c2d", width=1
        )

    def _dessiner_villa_romaine(self, x: int, y: int, scale: float):
        """Dessine une villa rustica romaine classique avec toit de tuiles et colonnade."""
        w = int(46 * scale)
        h_corps = int(22 * scale)
        h_toit = int(14 * scale)

        # Ombre au sol
        self.canvas.create_rectangle(
            x - w // 2 + 2, y - 2, x + w // 2 + 4, y + int(4 * scale),
            fill="#d5c8b5", outline=""
        )
        # Corps principal de la villa en stuc ocre antique
        self.canvas.create_rectangle(
            x - w // 2, y - h_corps, x + w // 2, y,
            fill="#e8dac3", outline="#7a634e", width=1
        )
        # Colonnade / portique à colonnes de marbre
        nb_col = 5
        pas_col = w // (nb_col - 1)
        for c in range(nb_col):
            col_x = x - w // 2 + c * pas_col
            self.canvas.create_line(
                col_x, y, col_x, y - h_corps + int(3 * scale),
                fill="#b8a791", width=max(1, int(1.5 * scale))
            )
        # Toit gâblé en tuiles romaines (tegulae et imbrices) en terre cuite
        pts_toit = [
            x - w // 2 - int(4 * scale), y - h_corps,
            x, y - h_corps - h_toit,
            x + w // 2 + int(4 * scale), y - h_corps,
        ]
        self.canvas.create_polygon(pts_toit, fill="#b5523b", outline="#6e2b1c", width=1)
        # Lignes de faîtage et de tuiles
        self.canvas.create_line(
            x - int(8 * scale), y - h_corps - int(h_toit * 0.5),
            x + int(8 * scale), y - h_corps - int(h_toit * 0.5),
            fill="#d9755d", width=1
        )

    def _dessiner_fontaine_romaine(self, x: int, y: int, scale: float):
        """Dessine une fontaine publique ou abreuvoir en pierre (lacus) le long de la route."""
        w = int(24 * scale)
        h = int(16 * scale)
        # Bassin en pierre
        self.canvas.create_rectangle(
            x - w // 2, y - h, x + w // 2, y,
            fill="#9b856e", outline="#544332", width=1
        )
        # Eau bleue cristalline à l'intérieur
        self.canvas.create_rectangle(
            x - w // 2 + int(2 * scale), y - h + int(2 * scale),
            x + w // 2 - int(2 * scale), y - int(2 * scale),
            fill="#7aa4bd", outline=""
        )
        # Stèle dorsale avec mascaron / déversoir
        self.canvas.create_rectangle(
            x - int(4 * scale), y - h - int(10 * scale),
            x + int(4 * scale), y - h,
            fill="#baa48b", outline="#544332", width=1
        )
        # Jet d'eau fin
        self.canvas.create_line(
            x, y - h - int(4 * scale), x, y - int(6 * scale),
            fill="#d8ecf8", width=max(1, int(1.2 * scale))
        )

    # =========================================================================
    # ARCHITECTURE DE LA CARTE : VIA APPIA, ÉTAPES 3D & ARCS DE TRIOMPHE
    # =========================================================================

    def _dessiner_carte(self):
        """Génère et dessine l'ensemble de la carte d'aventure interactive."""
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
        cw = max(760, self.canvas.winfo_width())
        scale = obtenir_facteur_echelle(self.canvas)

        # Calcul des positions absolues de toutes les étapes le long de la Via Appia
        cx = cw // 2
        y_courant = int(240 * scale)
        dy_lecon = int(92 * scale)
        dy_arc = int(115 * scale)

        structures_mondes = []
        points_route_complets = [(cx, int(195 * scale))]

        for w_idx, lvl in enumerate(mondes):
            lecons = lvl["lessons"]
            n_lecons = len(lecons)
            coords_monde = []

            for j, les in enumerate(lecons):
                offset_x = int(calculer_offset_route(j, n_lecons, w_idx) * scale)
                lx = cx + offset_x
                ly = y_courant + int(j * dy_lecon)
                coords_monde.append((lx, ly, les, j))
                points_route_complets.append((lx, ly))

            y_fin_monde = y_courant + n_lecons * dy_lecon
            y_arc = y_fin_monde + int(48 * scale)

            structures_mondes.append({
                "lvl": lvl,
                "w_idx": w_idx,
                "coords": coords_monde,
                "y_arc": y_arc if (w_idx < len(mondes) - 1) else None,
            })

            # Point de passage dans l'Arc de Triomphe vers le monde suivant
            if w_idx < len(mondes) - 1:
                points_route_complets.append((cx, y_arc))
                y_courant = y_arc + dy_arc
            else:
                y_courant = y_fin_monde + int(80 * scale)

        total_h = y_courant + int(60 * scale)
        self.canvas.configure(scrollregion=(0, 0, cw, total_h))

        # 1. Décor panoramique en arrière-plan
        self._dessiner_decor_arriere_plan(cw, total_h, scale)

        # 2. Tracé de la chaussée romaine de la Via Appia (multi-couches pavées)
        self._dessiner_route_via_appia(points_route_complets, scale)

        # 3. Rendu des Arcs de Triomphe et des Bornes Milliaires 3D
        self._active_milestone = None
        premiere_inachevee_trouvee = False
        echecs = self.app.data.get("echecs", {})

        # Premier passage : Arcs de Triomphe entre les mondes (en arrière-plan des bornes)
        for s in structures_mondes:
            w_idx = s["w_idx"]
            lvl = s["lvl"]
            y_arc = s["y_arc"]
            if y_arc is not None and w_idx + 1 < len(mondes):
                prochain_monde = mondes[w_idx + 1]
                self._dessiner_arc_triomphe(cx, y_arc, w_idx + 1, prochain_monde["title"], scale)

        # Deuxième passage : Bornes milliaires 3D et cartouches d'étapes
        for s in structures_mondes:
            coords = s["coords"]
            for lx, ly, les, j in coords:
                lid = les["id"]
                est_fait = (lid in completed_set)
                is_boss = (les.get("type") == "arene")

                # Détermination de l'état de l'étape
                if est_fait:
                    etat = "conquis"
                elif not premiere_inachevee_trouvee:
                    premiere_inachevee_trouvee = True
                    etat = "actif"
                else:
                    etat = "verrouille"

                # Dessiner la borne 3D
                r_borne = self._dessiner_borne_3d(
                    lx, ly, etat, is_boss, j, les, s["lvl"]["id"], echecs.get(lid, 0), scale
                )

                if etat == "actif":
                    self._active_milestone = (lx, ly, r_borne)

                # Cartouche d'intitulé élégant à côté de la borne (sans aucune troncature)
                self._dessiner_cartouche_lecon(lx, ly, cx, j, les, etat, is_boss, scale)

                # Interactions (clic, survol, infobulle)
                self._lier_evenements_borne(lid, les, lx, ly)

        # 4. Animer le halo doré et l'avatar du héros Marcus sur l'étape active
        if self._active_milestone:
            self._animer_halo()
            if not self._has_scrolled_to_active:
                self._has_scrolled_to_active = True
                # Centrer automatiquement la vue sur la prochaine leçon à jouer
                lx_act, ly_act, _ = self._active_milestone
                hauteur_vue = self.canvas.winfo_height() or 700
                cible_y = max(0, ly_act - hauteur_vue // 2)
                self.canvas.yview_moveto(cible_y / max(1, total_h))

    # =========================================================================
    # TRACÉ RÉALISTE DE LA CHAUSSÉE ROMAINE (BORDURES, PAVÉS, JOINTS, ORNIÈRES)
    # =========================================================================

    def _dessiner_route_via_appia(self, points_route: list, scale: float):
        """Dessine la voie romaine continue pavée de dalles de basalte avec joints de mortier."""
        if len(points_route) < 2:
            return

        # Aplatir la liste des points pour Tkinter
        flat_pts = []
        for x, y in points_route:
            flat_pts.extend([x, y])

        # Largeurs de chaussée proportionnelles à l'échelle
        w_talus = int(82 * scale)
        w_bordure = int(72 * scale)
        w_paves = int(62 * scale)
        w_interieur = int(52 * scale)

        # 1. Talus d'accotement stabilisé (terra battuta)
        self.canvas.create_line(
            flat_pts, smooth=True, width=w_talus,
            fill="#ab916e", capstyle="round", joinstyle="round"
        )
        # 2. Bordures de gros blocs de pierre taillée (crepidines / umbones)
        self.canvas.create_line(
            flat_pts, smooth=True, width=w_bordure,
            fill="#6d5438", capstyle="round", joinstyle="round"
        )
        # 3. Corps de chaussée en dalles de basalte (saxa quadrata)
        self.canvas.create_line(
            flat_pts, smooth=True, width=w_paves,
            fill="#bda282", capstyle="round", joinstyle="round"
        )
        # 4. Surface centrale patinée par le passage des légions et des chars
        self.canvas.create_line(
            flat_pts, smooth=True, width=w_interieur,
            fill="#d5c0a0", capstyle="round", joinstyle="round"
        )

        # 5. Joints de dalles transversaux réguliers créant l'aspect pavé antique
        for i in range(len(points_route) - 1):
            x1, y1 = points_route[i]
            x2, y2 = points_route[i + 1]
            dx = x2 - x1
            dy = y2 - y1
            dist = math.hypot(dx, dy)
            if dist > 0:
                pas = int(22 * scale)
                nb_joints = max(1, int(dist // pas))
                for s in range(1, nb_joints):
                    t = s / nb_joints
                    px = x1 + dx * t
                    py = y1 + dy * t
                    # Normale perpendiculaire à la route
                    nx = -dy / dist * (w_paves / 2.3)
                    ny = dx / dist * (w_paves / 2.3)
                    self.canvas.create_line(
                        px - nx, py - ny, px + nx, py + ny,
                        fill="#957a5b", width=max(1, int(1.5 * scale))
                    )
                    # Joint oblique alterné pour le motif polygonal de basalte
                    if s % 2 == 0:
                        self.canvas.create_line(
                            px - nx * 0.5, py - ny * 0.5,
                            px - nx * 0.5 + (dx / dist) * int(10 * scale),
                            py - ny * 0.5 + (dy / dist) * int(10 * scale),
                            fill="#957a5b", width=max(1, int(1.2 * scale))
                        )

        # 6. Ornière médiane dorée marquant le centre de la voie
        self.canvas.create_line(
            flat_pts, smooth=True, width=max(2, int(2.5 * scale)),
            fill="#eee2cc", dash=(int(8 * scale), int(7 * scale)),
            capstyle="round"
        )

    # =========================================================================
    # ARCS DE TRIOMPHE MONUMENTAUX (ARCUS TRIUMPHALIS) ENTRE LES MONDES
    # =========================================================================

    def _dessiner_arc_triomphe(self, cx: int, y: int, prochain_idx: int, titre_monde: str, scale: float):
        """Dessine un Arc de Triomphe romain monumental enjambant la Via Appia entre deux Mondes."""
        w_arc = int(300 * scale)
        h_arc = int(96 * scale)
        w_baie = int(88 * scale)
        h_baie = int(58 * scale)

        y_haut = y - h_arc // 2
        y_bas = y + h_arc // 2

        # 1. Ombre portée massive au sol
        self.canvas.create_rectangle(
            cx - w_arc // 2 - int(4 * scale), y_bas - int(2 * scale),
            cx + w_arc // 2 + int(4 * scale), y_bas + int(6 * scale),
            fill="#2d1e13", outline=""
        )

        # 2. Piliers massifs en travertin sculpté (gauche et droite)
        # Pilier gauche
        self.canvas.create_rectangle(
            cx - w_arc // 2, y_haut + int(30 * scale),
            cx - w_baie // 2, y_bas,
            fill="#b89e7e", outline="#5a412c", width=1
        )
        # Pilier droit
        self.canvas.create_rectangle(
            cx + w_baie // 2, y_haut + int(30 * scale),
            cx + w_arc // 2, y_bas,
            fill="#b89e7e", outline="#5a412c", width=1
        )

        # Colonnes corinthiennes jumelées en relief
        col_w = int(11 * scale)
        for offset_col in (-w_arc // 2 + int(14 * scale), -w_baie // 2 - int(16 * scale),
                           w_baie // 2 + int(6 * scale), w_arc // 2 - int(25 * scale)):
            # Fût de colonne avec liseré de marbre
            self.canvas.create_rectangle(
                cx + offset_col, y_haut + int(32 * scale),
                cx + offset_col + col_w, y_bas - int(4 * scale),
                fill="#dfcfba", outline="#7a634e", width=1
            )
            # Chapiteau corinthien doré
            self.canvas.create_rectangle(
                cx + offset_col - int(2 * scale), y_haut + int(29 * scale),
                cx + offset_col + col_w + int(2 * scale), y_haut + int(35 * scale),
                fill="#ffd700", outline="#8b6508", width=1
            )

        # 3. Voûte d'arche centrale en plein cintre enjambant la route
        self.canvas.create_arc(
            cx - w_baie // 2, y_bas - h_baie * 2 + int(12 * scale),
            cx + w_baie // 2, y_bas + int(12 * scale),
            start=0, extent=180, fill="#f7f2e6", outline="#5a412c", width=max(2, int(2 * scale))
        )
        # Clé de voûte saillante (console d'arc)
        self.canvas.create_polygon(
            [cx - int(8 * scale), y_bas - h_baie + int(10 * scale),
             cx + int(8 * scale), y_bas - h_baie + int(10 * scale),
             cx + int(5 * scale), y_bas - h_baie + int(24 * scale),
             cx - int(5 * scale), y_bas - h_baie + int(24 * scale)],
            fill="#ffd700", outline="#5a412c", width=1
        )

        # 4. Attique supérieur avec cartouche pourpre impérial et lettrage doré
        self.canvas.create_rectangle(
            cx - w_arc // 2 - int(6 * scale), y_haut,
            cx + w_arc // 2 + int(6 * scale), y_haut + int(30 * scale),
            fill="#521018", outline="#ffd700", width=max(2, int(2 * scale))
        )
        self.canvas.create_rectangle(
            cx - w_arc // 2 - int(3 * scale), y_haut + int(3 * scale),
            cx + w_arc // 2 + int(3 * scale), y_haut + int(27 * scale),
            fill="#3d0910", outline="#c9a13b", width=1
        )

        # Titre nettoyé du Monde à franchir
        titre_net = titre_monde
        for pfx in ("1 · ", "2 · ", "3 · ", "4 · ", "5 · ", "6 · ", "7 · ", "8 · ", "9 · ", "10 · "):
            if titre_net.startswith(pfx):
                titre_net = titre_net[len(pfx):]
                break
        titre_net = titre_net.replace("🏛️", "").replace("⚔️", "").replace("⚡", "").strip()

        # Inscription latine dorée en 2 lignes équilibrées
        self.canvas.create_text(
            cx, y_haut + int(10 * scale),
            text=f"MUNDUS {to_roman(prochain_idx + 1)}",
            font=police_corps(int(7 * scale), gras=True), fill="#ffd700"
        )
        self.canvas.create_text(
            cx, y_haut + int(20 * scale),
            text=titre_net.upper(),
            font=police_corps(int(8 * scale), gras=True), fill="#ffffff"
        )

        # 5. Aigle impérial doré / couronne de laurier au sommet
        self.canvas.create_oval(
            cx - int(12 * scale), y_haut - int(9 * scale),
            cx + int(12 * scale), y_haut + int(9 * scale),
            fill="#ffd700", outline="#8b6508", width=1
        )
        self.canvas.create_text(
            cx, y_haut, text="🦅",
            font=("Segoe UI Emoji", int(9 * scale))
        )

        # Deux bannières de légionnaires (Vexilla) pourpres bordant l'Arc
        for bx in (cx - w_arc // 2 - int(18 * scale), cx + w_arc // 2 + int(18 * scale)):
            # Hampe dorée avec pommeau
            self.canvas.create_line(
                bx, y_haut - int(12 * scale), bx, y_bas,
                fill="#ffd700", width=max(1, int(2 * scale))
            )
            # Voile pourpre vertical
            self.canvas.create_rectangle(
                bx - int(7 * scale), y_haut - int(4 * scale),
                bx + int(7 * scale), y_haut + int(38 * scale),
                fill="#58111a", outline="#ffd700", width=1
            )
            # Inscription verticale SPQR
            self.canvas.create_text(
                bx, y_haut + int(17 * scale),
                text="S\nP\nQ\nR",
                font=police_corps(int(6 * scale), gras=True),
                fill="#ffd700", justify=tk.CENTER
            )

    # =========================================================================
    # BORNES MILLIAIRES EN 3D IMPÉRIAL (OR, AMBRE, TRAVERTIN, ARÈNE DE BOSS)
    # =========================================================================

    def _dessiner_borne_3d(self, lx: int, ly: int, etat: str, is_boss: bool,
                           j: int, lecon: dict, monde_id: str, nb_err: int, scale: float) -> int:
        """Dessine le médaillon milliaire 3D en marbre sculpté ou bronze impérial."""
        lid = lecon["id"]
        rayon = int((27 if not is_boss else 36) * scale)

        # 1. Socle en pierre taillée (piédestal antique sous la borne)
        w_socle = rayon + int(7 * scale)
        h_socle = int(9 * scale)
        self.canvas.create_rectangle(
            lx - w_socle, ly + rayon - int(4 * scale),
            lx + w_socle, ly + rayon + h_socle,
            fill="#6d553e", outline="#3f2e20", width=1,
            tags=("milestone", lid)
        )
        # Biseau supérieur du socle
        self.canvas.create_line(
            lx - w_socle, ly + rayon - int(4 * scale),
            lx + w_socle, ly + rayon - int(4 * scale),
            fill="#9b7e61", width=max(1, int(1.5 * scale)),
            tags=("milestone", lid)
        )

        # 2. Ombre portée douce sur les pavés
        self.canvas.create_oval(
            lx - rayon + int(3 * scale), ly - rayon + int(5 * scale),
            lx + rayon + int(3 * scale), ly + rayon + int(5 * scale),
            fill="#291a0e", outline="",
            tags=("milestone", lid)
        )

        # 3. Rendu selon l'état de l'étape
        chiffre_romain = to_roman(j + 1)

        if etat == "conquis":
            # --- ÉTAPE ACCOMPLIE : OR IMPÉRIAL & COURONNE DE LAURIERS ---
            # Cercle extérieur biseauté en or
            self.canvas.create_oval(
                lx - rayon, ly - rayon, lx + rayon, ly + rayon,
                fill="#c69512", outline="#ffd700", width=max(2, int(2.5 * scale)),
                tags=("milestone", lid)
            )
            # Cœur doré chatoyant
            self.canvas.create_oval(
                lx - rayon + int(3 * scale), ly - rayon + int(3 * scale),
                lx + rayon - int(3 * scale), ly + rayon - int(3 * scale),
                fill="#f7be24", outline="#b3820a", width=1,
                tags=("milestone", lid)
            )
            # Reflet spéculaire brillant sur la partie supérieure
            self.canvas.create_arc(
                lx - rayon + int(4 * scale), ly - rayon + int(3 * scale),
                lx + rayon - int(4 * scale), ly + rayon - int(5 * scale),
                start=30, extent=120, style="arc",
                outline="#ffffff", width=max(1, int(2 * scale)),
                tags=("milestone", lid)
            )
            # Chiffre romain gravé en bronze sombre
            self.canvas.create_text(
                lx, ly - (int(2 * scale) if not is_boss else int(4 * scale)),
                text=chiffre_romain,
                font=police_titre(int((12 if not is_boss else 14) * scale)),
                fill="#422502",
                tags=("milestone", lid)
            )
            # Pastille verte de victoire au bas de la borne
            r_check = int(8 * scale)
            cx_chk = lx + rayon - int(6 * scale)
            cy_chk = ly + rayon - int(6 * scale)
            self.canvas.create_oval(
                cx_chk - r_check, cy_chk - r_check,
                cx_chk + r_check, cy_chk + r_check,
                fill="#2e7d32", outline="#ffffff", width=1,
                tags=("milestone", lid)
            )
            self.canvas.create_text(
                cx_chk, cy_chk, text="✓",
                font=police_corps(int(7 * scale), gras=True), fill="#ffffff",
                tags=("milestone", lid)
            )
            # Étoiles dorées flottant au sommet
            etoiles = "⭐⭐⭐" if nb_err == 0 else ("⭐⭐" if nb_err <= 2 else "⭐")
            self.canvas.create_text(
                lx, ly - rayon - int(11 * scale),
                text=etoiles, font=("Segoe UI Emoji", int(9 * scale)),
                tags=("milestone", lid)
            )

        elif etat == "actif":
            # --- ÉTAPE SUIVANTE / ACTIVE : AMBRE RAYONNANT & HALO PULSANT ---
            self.canvas.create_oval(
                lx - rayon, ly - rayon, lx + rayon, ly + rayon,
                fill="#e67e22", outline="#ffd700", width=max(2, int(3 * scale)),
                tags=("milestone", lid)
            )
            self.canvas.create_oval(
                lx - rayon + int(3 * scale), ly - rayon + int(3 * scale),
                lx + rayon - int(3 * scale), ly + rayon - int(3 * scale),
                fill="#f39c12", outline="#c0392b", width=1,
                tags=("milestone", lid)
            )
            # Symbole de défi énergique
            symb = "⚡" if not is_boss else "⚔️"
            self.canvas.create_text(
                lx, ly, text=symb,
                font=("Segoe UI Emoji", int((13 if not is_boss else 16) * scale)),
                tags=("milestone", lid)
            )

        else:
            # --- ÉTAPE VERROUILLÉE : PIERRE DE TRAVERTIN & CADENAS DE BRONZE ---
            self.canvas.create_oval(
                lx - rayon, ly - rayon, lx + rayon, ly + rayon,
                fill="#766352", outline="#4a3b2f", width=max(2, int(2 * scale)),
                tags=("milestone", lid)
            )
            self.canvas.create_oval(
                lx - rayon + int(3 * scale), ly - rayon + int(3 * scale),
                lx + rayon - int(3 * scale), ly + rayon - int(3 * scale),
                fill="#5e4d3f", outline="#3b2d22", width=1,
                tags=("milestone", lid)
            )
            # Chiffre romain gravé en creux
            self.canvas.create_text(
                lx, ly - int(4 * scale), text=chiffre_romain,
                font=police_titre(int((10 if not is_boss else 12) * scale)),
                fill="#3a2b1f",
                tags=("milestone", lid)
            )
            # Cadenas de bronze antique
            self.canvas.create_text(
                lx, ly + int(6 * scale), text="🔒",
                font=("Segoe UI Emoji", int(9 * scale)),
                tags=("milestone", lid)
            )

        # Spécificité Boss / Arène Ultime de Monde
        if is_boss:
            # Grand bouclier circulaire d'apparat avec liseré pourpre
            self.canvas.create_oval(
                lx - rayon - int(3 * scale), ly - rayon - int(3 * scale),
                lx + rayon + int(3 * scale), ly + rayon + int(3 * scale),
                outline="#ffd700", width=max(2, int(2 * scale)),
                tags=("milestone", lid)
            )
            # Tente de charger la vignette officielle du Boss
            boss_fname = BOSS_PAR_MONDE.get(monde_id)
            if boss_fname and etat != "verrouille":
                target_sz = int(38 * scale)
                photo_boss = self._load_boss_image(boss_fname, target_sz)
                if photo_boss:
                    self.canvas.create_image(
                        lx, ly, image=photo_boss, tags=("milestone", lid)
                    )

            # Ruban pourpre impérial "ÉPREUVE FINALE" au bas du bouclier
            b_w, b_h = int(50 * scale), int(11 * scale)
            by = ly + rayon + int(19 * scale)
            self.canvas.create_rectangle(
                lx - b_w, by - b_h, lx + b_w, by + b_h,
                fill="#58111a", outline="#ffd700", width=1,
                tags=("milestone", lid)
            )
            self.canvas.create_text(
                lx, by, text="👑 ÉPREUVE FINALE",
                font=police_corps(int(7 * scale), gras=True), fill="#ffd700",
                tags=("milestone", lid)
            )

        return rayon

    # =========================================================================
    # CARTOUCHES D'INTITULÉS AÉRÉS & LISIBLES SANS TRONCATURE
    # =========================================================================

    def _dessiner_cartouche_lecon(self, lx: int, ly: int, cx: int, j: int,
                                  lecon: dict, etat: str, is_boss: bool, scale: float):
        """Dessine un cartouche parchemin flottant élégant à côté de la borne."""
        lid = lecon["id"]

        # Positionnement en quinconce selon la courbure de la route (gauche ou droite)
        sur_la_gauche = (lx <= cx)
        decalage_x = -int(148 * scale) if sur_la_gauche else int(148 * scale)
        c_x = lx + decalage_x
        c_y = ly

        # Titre nettoyé et élégamment formaté
        titre_net = lecon["title"]
        for pfx in ("⚔️ Défi de l'Arène : ", "⚔️ Combat d'Arène Ultime : "):
            titre_net = titre_net.replace(pfx, "")

        lignes = textwrap.wrap(titre_net, width=22)
        if len(lignes) > 2:
            lignes = [lignes[0], lignes[1][:18] + "…"]
        titre_formate = "\n".join(lignes)

        w_cart = int(144 * scale)
        h_cart = int((42 + (len(lignes) - 1) * 13) * scale)

        # Guide de liaison pointillé doré entre la borne et son cartouche
        self.canvas.create_line(
            lx + (int(30 * scale) if not sur_la_gauche else -int(30 * scale)), ly,
            c_x + (-w_cart // 2 if not sur_la_gauche else w_cart // 2), ly,
            fill="#c9b085", width=1, dash=(int(3 * scale), int(3 * scale)),
            tags=("milestone", lid)
        )

        # 1. Ombre douce du cartouche
        self.canvas.create_rectangle(
            c_x - w_cart // 2 + 2, c_y - h_cart // 2 + 2,
            c_x + w_cart // 2 + 2, c_y + h_cart // 2 + 2,
            fill="#23170e", outline="", tags=("milestone", lid)
        )
        # 2. Fond parchemin chaud avec double filet doré
        bg_col = "#fffdf7" if etat != "verrouille" else "#f8f2e6"
        border_col = "#ffd700" if etat == "actif" else ("#c5a56d" if etat == "conquis" else "#8c7661")
        border_w = max(2, int(2 * scale)) if etat == "actif" else max(1, int(1.5 * scale))

        self.canvas.create_rectangle(
            c_x - w_cart // 2, c_y - h_cart // 2,
            c_x + w_cart // 2, c_y + h_cart // 2,
            fill=bg_col, outline=border_col, width=border_w,
            tags=("milestone", lid)
        )

        # Type de défi
        type_str = "Arène" if is_boss else ("Exercice" if lecon.get("type") == "exercice" else "Leçon")
        chiffre = to_roman(j + 1)
        self.canvas.create_text(
            c_x, c_y - h_cart // 2 + int(10 * scale),
            text=f"Étape {chiffre} · {type_str}",
            font=police_corps(int(7 * scale), gras=True),
            fill="#8b1e28" if etat != "verrouille" else "#6e5d4d",
            tags=("milestone", lid)
        )

        # Intitulé complet
        self.canvas.create_text(
            c_x, c_y + int(4 * scale),
            text=titre_formate,
            font=police_corps(int(8 * scale), gras=True),
            fill="#231408" if etat != "verrouille" else "#4d3d30",
            justify=tk.CENTER,
            tags=("milestone", lid)
        )

    # =========================================================================
    # INTERACTIONS, ÉVÉNEMENTS, BULLES D'AIDE ET HALO PULSANT
    # =========================================================================

    def _lier_evenements_borne(self, lid: str, les: dict, lx: int, ly: int):
        """Associe les clics et survols pour ouvrir la leçon et afficher l'infobulle."""
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

    def _animer_halo(self):
        """Anime le halo doré ondulant et le Pin de héros Marcus au-dessus de l'étape active."""
        if not self._active_milestone or not self.canvas.winfo_exists():
            return

        lx, ly, r_base = self._active_milestone
        self.canvas.delete("halo_actif")

        self._pulse_frame = (self._pulse_frame + 1) % 16
        delta = math.sin(self._pulse_frame * (math.pi / 8)) * 5.0
        r = r_base + 3 + delta
        couleur = "#ffd700" if delta > 0 else "#ffe082"

        # Halo pulsant concentrique
        self.canvas.create_oval(
            lx - r, ly - r, lx + r, ly + r,
            outline=couleur, width=3, tags=("halo_actif",)
        )
        self.canvas.create_oval(
            lx - r - 3, ly - r - 3, lx + r + 3, ly + r + 3,
            outline="#d4af37", width=1, tags=("halo_actif",)
        )

        # Pin du Héros Marcus/Julia en lévitation douce
        bob = int(math.sin(self._pulse_frame * (math.pi / 8)) * 3)
        avatar_y = ly - r_base - 34 + bob

        if self._photo_avatar:
            # Vignette médaillon
            self.canvas.create_image(
                lx, avatar_y, image=self._photo_avatar, tags=("halo_actif",)
            )

        # Bulle dorée "Tu es ici !" avec queue pointant vers l'avatar
        b_w, b_h = 44, 12
        by = avatar_y - 30
        self.canvas.create_rectangle(
            lx - b_w, by - b_h, lx + b_w, by + b_h,
            fill="#d4af37", outline="#2b1a0e", width=1, tags=("halo_actif",)
        )
        # Pointeur triangulaire
        self.canvas.create_polygon(
            [lx - 5, by + b_h, lx + 5, by + b_h, lx, by + b_h + 5],
            fill="#d4af37", outline="#2b1a0e", tags=("halo_actif",)
        )
        self.canvas.create_text(
            lx, by, text="📍 Tu es ici !",
            font=police_corps(8, gras=True), fill="#2b1a0e", tags=("halo_actif",)
        )

        self._pulse_job = self.after(90, self._animer_halo)

    def _montrer_tooltip(self, lecon: dict, lx: int, ly: int):
        """Affiche une infobulle flottante riche au survol d'une borne milliaire."""
        self._cacher_tooltip()
        lid = lecon["id"]
        est_fait = lid in self.app.data.get("completed", [])
        is_boss = (lecon.get("type") == "arene")

        f_tip = tk.Frame(
            self.canvas, bg="#1f2335", bd=1, relief="solid",
            highlightbackground="#ffd700", highlightthickness=1, padx=12, pady=8
        )
        t_titre = lecon.get("title", "")
        tk.Label(
            f_tip, text=t_titre, font=police_corps(9, gras=True),
            bg="#1f2335", fg="#ffd700"
        ).pack(anchor="w")

        type_nom = "⚔️ Défi du Colisée (Boss)" if is_boss else (
            "📝 Exercice Pratique" if lecon.get("type") == "exercice" else "🏛️ Découverte Historique"
        )
        tk.Label(
            f_tip, text=f"Catégorie : {type_nom}", font=police_corps(8),
            bg="#1f2335", fg="#a9b1d6"
        ).pack(anchor="w")

        statut_txt = "✅ Conquis avec honneur !" if est_fait else "⚡ Étape prête pour l'épreuve"
        tk.Label(
            f_tip, text=statut_txt, font=police_corps(8, italique=True),
            bg="#1f2335", fg="#9ece6a" if est_fait else "#e0af68"
        ).pack(anchor="w")

        reward = "+25 Sesterces 🪙 · +50 XP" if is_boss else "+10 Sesterces 🪙 · +20 XP"
        tk.Label(
            f_tip, text=f"Butin : {reward}", font=police_corps(8, gras=True),
            bg="#1f2335", fg="#ffd700"
        ).pack(anchor="w", pady=(2, 0))

        tk.Label(
            f_tip, text="▶ Cliquer pour entrer dans l'épreuve",
            font=police_corps(7, gras=True), bg="#1f2335", fg="#7aa2f7"
        ).pack(anchor="w", pady=(4, 0))

        tip_id = self.canvas.create_window(lx, ly - 56, window=f_tip, anchor="s")
        self._tooltip_window = (tip_id, f_tip)

    def _cacher_tooltip(self):
        """Ferme l'infobulle flottante."""
        if self._tooltip_window:
            try:
                tip_id, f_tip = self._tooltip_window
                self.canvas.delete(tip_id)
                f_tip.destroy()
            except Exception:
                pass
            self._tooltip_window = None
