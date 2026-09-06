"""
Fenêtre festive et animée du Grand Triomphe de Rome — Fin du Programme de 5ème.
Débloque le Badge Suprême « Corona Triumphalis » avec rayons de gloire,
pluie de sesterces, fanfare de tubas et diplôme impérial imprimable.
"""

import math
import random
import tkinter as tk
import webbrowser
from pathlib import Path

from app import audio
from app import progress as prog


def diplome_triomphe_html(nom_heros, genre, sesterces_total, date_str):
    """Génère un diplôme impérial d'honneur en HTML autonome et imprimable."""
    titre_heros = "IMPERATOR" if genre == "garcon" else "IMPERATRIX"
    accord = "au vaillant élève" if genre == "garcon" else "à la vaillante élève"
    return f"""<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8">
<title>Diplôme Impérial de Latin — Classe de 5ème</title>
<style>
  body {{
    font-family: 'Times New Roman', Georgia, serif;
    background: #2b141e;
    color: #2c1810;
    margin: 0;
    padding: 30px;
    display: flex;
    justify-content: center;
  }}
  .cadre-exterieur {{
    background: #fffdf7;
    width: 820px;
    padding: 24px;
    border: 8px double #c59b27;
    box-shadow: 0 10px 40px rgba(0,0,0,0.6);
    border-radius: 6px;
    box-sizing: border-box;
  }}
  .cadre-interieur {{
    border: 2px solid #8b5a2b;
    padding: 36px 40px;
    text-align: center;
    background: radial-gradient(circle at center, #ffffff 40%, #fbf6ec 100%);
  }}
  .spqr {{
    font-size: 18px;
    letter-spacing: 8px;
    color: #7b1113;
    font-weight: bold;
    margin-bottom: 8px;
  }}
  .aigle {{
    font-size: 54px;
    line-height: 1;
    margin-bottom: 10px;
  }}
  h1 {{
    font-size: 32px;
    color: #7b1113;
    text-transform: uppercase;
    letter-spacing: 3px;
    margin: 4px 0 12px;
    border-bottom: 2px solid #c59b27;
    display: inline-block;
    padding-bottom: 6px;
  }}
  .sous-titre {{
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 4px;
    color: #8b5a2b;
    margin-bottom: 24px;
  }}
  .texte-intro {{
    font-size: 16px;
    font-style: italic;
    color: #555;
    margin-bottom: 12px;
  }}
  .nom-heros {{
    font-size: 38px;
    color: #1a1a1a;
    font-weight: bold;
    letter-spacing: 2px;
    margin: 16px 0;
    text-shadow: 1px 1px 2px rgba(197, 155, 39, 0.4);
  }}
  .citation {{
    font-size: 18px;
    color: #7b1113;
    font-weight: bold;
    margin: 16px 0 24px;
  }}
  .paragraphe {{
    font-size: 15px;
    line-height: 1.6;
    color: #333;
    max-width: 620px;
    margin: 0 auto 28px;
  }}
  .stats-box {{
    display: flex;
    justify-content: space-around;
    background: #f5eedc;
    border: 1px solid #d4af37;
    border-radius: 6px;
    padding: 12px;
    margin: 20px auto;
    max-width: 580px;
    font-weight: bold;
    color: #7b1113;
  }}
  .signatures {{
    display: flex;
    justify-content: space-between;
    margin-top: 40px;
    padding: 0 20px;
    font-size: 14px;
    color: #666;
  }}
  .signature-col {{
    border-top: 1px solid #aaa;
    padding-top: 8px;
    width: 220px;
  }}
  .sceau {{
    font-size: 40px;
    margin-top: 10px;
  }}
</style>
</head>
<body>
<div class="cadre-exterieur">
  <div class="cadre-interieur">
    <div class="spqr">SENATVS POPVLVSQVE ROMANVS</div>
    <div class="aigle">🦅</div>
    <h1>Diplôme Impérial d'Honneur</h1>
    <div class="sous-titre">Cycle Collège — Classe de 5ème</div>

    <div class="texte-intro">Le Sénat de Rome et l'Académie de Ludus Latinus décernent ce titre suprême {accord} :</div>
    <div class="nom-heros">🏛️ {nom_heros} 🏛️</div>
    <div class="citation">« VENI, VIDI, VICI — GLOIRE AU NOUVEL {titre_heros} DU LATIN ! »</div>

    <div class="paragraphe">
      Pour avoir franchi les 10 Mondes de la Via Appia, déchiffré les déclinaisons antiques,
      vaincu les créatures du Colisée et maîtrisé avec éclat l'ensemble des 49 leçons du programme officiel de 5ème.
    </div>

    <div class="stats-box">
      <div>🗺️ 10 / 10 Mondes</div>
      <div>📜 49 / 49 Leçons</div>
      <div>🪙 {sesterces_total} Sesterces d'Or</div>
      <div>👑 Corona Triumphalis</div>
    </div>

    <div class="signatures">
      <div class="signature-col">
        <strong>Fait à Rome, le {date_str}</strong><br>
        Le Sénateur Consulaire
      </div>
      <div class="sceau">🏛️</div>
      <div class="signature-col">
        <strong>Ludus Latinus</strong><br>
        Le Maître des Études Antiques
      </div>
    </div>
  </div>
</div>
<script>window.onload = () => {{ /* Prêt pour impression avec Ctrl+P */ }};</script>
</body>
</html>
"""


class Triomphe5emeDialog(tk.Toplevel):
    """Fenêtre cinématique et animée de remise du Grand Badge de Triomphe de 5ème."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("🏛️ GRAND TRIOMPHE DE ROME — Fin du Programme de 5ème ! 👑")
        self.configure(bg="#1a0914")
        self.resizable(False, False)

        from app.responsive import adapter_geometrie_fenetre
        w, h = adapter_geometrie_fenetre(self, 720, 650, min_w=600, min_h=500)

        # Liseré d'or supérieur étincelant
        tk.Frame(self, bg="#ffd700", height=6).pack(fill=tk.X, side=tk.TOP)

        # Zone Canvas interactive pour l'animation (Rayons tournants + Médaillon + Pluie)
        self.cw = w
        self.ch = min(330, max(220, int(h * 0.48)))
        self._anim_timer = None
        self.canvas = tk.Canvas(self, width=self.cw, height=self.ch, bg="#1a0914", highlightthickness=0)
        self.canvas.pack(fill=tk.X, side=tk.TOP)

        # Image du médaillon trophée doré 3D
        img_trophy = Path(__file__).resolve().parent.parent / "assets" / "images" / "trophee_triomphe_medaillon_130.png"
        self.trophy_photo = tk.PhotoImage(file=str(img_trophy)) if img_trophy.exists() else None

        # Cadre d'informations sous le canvas
        info_frame = tk.Frame(self, bg="#27101f", padx=20, pady=12)
        info_frame.pack(fill=tk.BOTH, expand=True)

        nom_heros = prog.get_nom_heros(app.data)
        genre = prog.get_genre(app.data)
        titre = "IMPERATOR" if genre == "garcon" else "IMPERATRIX"

        # Titre héroïque
        tk.Label(
            info_frame,
            text=f"👑 GLOIRE À TOI, {nom_heros.upper()} {titre} DU LATIN ! 👑",
            font=(app.title_font.cget("family"), 16, "bold"),
            bg="#27101f", fg="#ffd700"
        ).pack(pady=(0, 4))

        tk.Label(
            info_frame,
            text="Tu as conquis les 10 Mondes et terminé l'intégralité du programme officiel de 5ème !",
            font=(app.body.cget("family"), 10, "italic"),
            bg="#27101f", fg="#f3e8ff"
        ).pack(pady=(0, 8))

        # Carte de statistiques de triomphe
        stats_card = tk.Frame(info_frame, bg="#3b162f", relief="ridge", bd=2, padx=14, pady=8)
        stats_card.pack(fill=tk.X, pady=4)

        sc_cols = [
            ("🗺️ Mondes", "10 / 10 Conquis"),
            ("📜 Leçons", "49 / 49 Maîtrisées"),
            ("⚔️ Boss", "10 Vaincus"),
            ("🪙 Récompense", "+200 Sesterces")
        ]
        for label, val in sc_cols:
            col = tk.Frame(stats_card, bg="#3b162f")
            col.pack(side=tk.LEFT, expand=True)
            tk.Label(col, text=label, font=(app.body.cget("family"), 9), bg="#3b162f", fg="#d4af37").pack()
            tk.Label(col, text=val, font=(app.body.cget("family"), 10, "bold"), bg="#3b162f", fg="#ffffff").pack()

        # Barre de boutons
        btn_bar = tk.Frame(self, bg="#1a0914", padx=16, pady=14)
        btn_bar.pack(fill=tk.X, side=tk.BOTTOM)

        tk.Button(
            btn_bar, text="📜 Mon Diplôme",
            font=(app.body.cget("family"), 9, "bold"),
            bg="#c59b27", fg="#ffffff", activebackground="#b0881e",
            relief="flat", padx=10, pady=6, cursor="hand2",
            command=self._ouvrir_diplome
        ).pack(side=tk.LEFT, padx=4)

        tk.Button(
            btn_bar, text="🏛️ Voir au Musée",
            font=(app.body.cget("family"), 9),
            bg="#3b162f", fg="#ffffff",
            relief="flat", padx=8, pady=6, cursor="hand2",
            command=self._ouvrir_musee
        ).pack(side=tk.LEFT, padx=4)

        tk.Button(
            btn_bar, text="🎆 Fanfare",
            font=(app.body.cget("family"), 9),
            bg="#1a0914", fg="#d4af37",
            relief="flat", padx=6, pady=6, cursor="hand2",
            command=self._rejouer_fanfare
        ).pack(side=tk.LEFT, padx=4)

        tk.Button(
            btn_bar, text="Continuer avec Gloire ⚔️",
            font=(app.body.cget("family"), 9, "bold"),
            bg="#27ae60", fg="#ffffff",
            relief="flat", padx=12, pady=6, cursor="hand2",
            command=self.destroy
        ).pack(side=tk.RIGHT, padx=4)

        # Variables d'animation
        self.angle_rayons = 0.0
        self.rayon_pulse = 0.0
        self.step_pulse = 0.08
        self.nb_ticks = 0

        # Particules de confettis / sesterces / lauriers
        self.particules = []
        symboles = ["⭐", "🪙", "🌿", "✨", "🏛️", "👑"]
        couleurs = ["#ffd700", "#f1c40f", "#e67e22", "#e74c3c", "#9b59b6", "#ffffff"]
        for _ in range(45):
            self.particules.append({
                "x": random.randint(20, self.cw - 20),
                "y": random.randint(-self.ch, 0),
                "vx": random.uniform(-1.2, 1.2),
                "vy": random.uniform(2.5, 6.0),
                "sym": random.choice(symboles),
                "taille": random.randint(11, 20),
                "color": random.choice(couleurs)
            })

        # Déclenchement sonore
        audio.play_tuba_fanfare()
        audio.play_coin_cascade()

        # Démarrer la boucle d'animation
        self._animer()

    def _animer(self):
        if not self.winfo_exists():
            return

        self.canvas.delete("all")
        cx, cy = self.cw // 2, 160

        # 1. Dessin des rayons de gloire dorés tournants (Sunburst)
        self.angle_rayons += 0.025
        nb_rayons = 16
        longueur_rayons = 220
        for i in range(nb_rayons):
            a1 = self.angle_rayons + (i * 2 * math.pi / nb_rayons)
            a2 = a1 + (math.pi / nb_rayons) * 0.7
            x1 = cx + math.cos(a1) * longueur_rayons
            y1 = cy + math.sin(a1) * longueur_rayons
            x2 = cx + math.cos(a2) * longueur_rayons
            y2 = cy + math.sin(a2) * longueur_rayons
            # Couleur dorée tamisée alternée
            c_rayon = "#3d2218" if i % 2 == 0 else "#2d1620"
            self.canvas.create_polygon(cx, cy, x1, y1, x2, y2, fill=c_rayon, outline="")

        # 2. Grand Badge / Médaillon du Triomphe
        self.rayon_pulse += self.step_pulse
        if self.rayon_pulse > 6.0 or self.rayon_pulse < -2.0:
            self.step_pulse = -self.step_pulse

        r_base = 86 + self.rayon_pulse

        # Halo d'or diffus
        self.canvas.create_oval(cx - r_base - 14, cy - r_base - 14,
                                cx + r_base + 14, cy + r_base + 14,
                                fill="#4a2c11", outline="")

        # Couronne de lauriers extérieure (Corona Triumphalis)
        self.canvas.create_oval(cx - r_base - 6, cy - r_base - 6,
                                cx + r_base + 6, cy + r_base + 6,
                                fill="#d4af37", outline="#ffd700", width=4)

        # Ornements de feuilles de laurier sur le pourtour
        for i in range(12):
            ang = i * (2 * math.pi / 12)
            lx = cx + math.cos(ang) * (r_base + 2)
            ly = cy + math.sin(ang) * (r_base + 2)
            self.canvas.create_text(lx, ly, text="🌿", font=("", 14), fill="#27ae60")

        # Médaillon Trophée 3D au centre s'il est disponible
        if self.trophy_photo:
            self.canvas.create_image(cx, cy - 8, image=self.trophy_photo)
        else:
            # Cercle impérial pourpre intérieur
            r_int = r_base - 14
            self.canvas.create_oval(cx - r_int, cy - r_int, cx + r_int, cy + r_int,
                                    fill="#7a142c", outline="#f5deb3", width=3)
            # Aigle impérial et inscriptions
            self.canvas.create_text(cx, cy - 32, text="🦅", font=("Segoe UI Emoji", 30))
            self.canvas.create_text(cx, cy + 6, text="SPQR", font=("Georgia", 16, "bold"), fill="#ffd700")
            self.canvas.create_text(cx, cy + 26, text="CLASSE DE 5ÈME", font=("Georgia", 9, "bold"), fill="#ffffff")

        # Bannière dorée sous le médaillon
        b_w, b_h = 135, 26
        by = cy + 74
        self.canvas.create_rectangle(cx - b_w, by - b_h // 2, cx + b_w, by + b_h // 2,
                                     fill="#d4af37", outline="#ffffff", width=2)
        self.canvas.create_text(cx, by, text="★ TRIUMPHATOR SUPREMUS ★",
                                font=("Georgia", 10, "bold"), fill="#50121a")

        # 3. Pluie animée de particules (confettis, sesterces, étoiles)
        for p in self.particules:
            p["x"] += p["vx"]
            p["y"] += p["vy"]
            if p["y"] > self.ch + 20:
                p["y"] = random.randint(-40, -10)
                p["x"] = random.randint(20, self.cw - 20)
                p["vy"] = random.uniform(2.5, 6.0)

            self.canvas.create_text(
                p["x"], p["y"], text=p["sym"],
                font=("Segoe UI Emoji", p["taille"]), fill=p["color"]
            )

        self.nb_ticks += 1
        self._anim_timer = self.after(35, self._animer)

    def destroy(self):
        if self._anim_timer:
            try:
                self.after_cancel(self._anim_timer)
            except Exception:
                pass
            self._anim_timer = None
        super().destroy()

    def _ouvrir_diplome(self):
        nom = prog.get_nom_heros(self.app.data)
        genre = prog.get_genre(self.app.data)
        sesterces = self.app.data.get("sesterces", 100)
        from datetime import date
        date_str = date.today().strftime("%d/%m/%Y")

        html = diplome_triomphe_html(nom, genre, sesterces, date_str)
        dossier = prog.DATA_DIR / "certificats"
        try:
            dossier.mkdir(parents=True, exist_ok=True)
            fichier = dossier / "Diplome_Triomphe_5eme.html"
            fichier.write_text(html, encoding="utf-8")
            webbrowser.open(fichier.as_uri())
        except Exception:
            pass

    def _ouvrir_musee(self):
        from app.musee import MuseeWindow
        MuseeWindow(self.master, self.app)

    def _rejouer_fanfare(self):
        audio.play_tuba_fanfare()
        audio.play_coin_cascade()
