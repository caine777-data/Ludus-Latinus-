"""
Module d'animations visuelles pour Ludus Latinus.

Fournit des effets visuels ludiques sans aucune dépendance tierce :
- Pluie de Sesterces tombantes (CoinRain) lors des victoires et triomphes
- Effet de frappe d'épée (SlashEffect) lors des coups réussis en arène
- Secousse d'impact (ScreenShake) lors des coups critiques
"""

import random
import tkinter as tk

from app import audio


class CoinRainAnimation:
    """Anime une cascade de sesterces dorés tombant du haut de la fenêtre."""

    def __init__(self, root, count=24, duration_ms=1800, on_complete=None):
        self.root = root
        self.count = count
        self.duration_ms = duration_ms
        self.on_complete = on_complete
        self.alive = True

        root.update_idletasks()
        w = max(400, root.winfo_width())
        h = max(300, root.winfo_height())

        self.canvas = tk.Canvas(root, width=w, height=h, highlightthickness=0)
        # Placer le canvas en superposition absolue
        self.canvas.place(x=0, y=0, relwidth=1.0, relheight=1.0)
        # Rendre le fond assorti ou neutre avec transparence simulée
        bg_col = root.cget("bg") if hasattr(root, "cget") else "#241b12"
        self.canvas.configure(bg=bg_col)

        # Créer les pièces
        self.coins = []
        for _ in range(count):
            x = random.randint(20, max(20, w - 40))
            y = random.randint(-180, -20)
            vx = random.uniform(-1.8, 1.8)
            vy = random.uniform(4.0, 9.0)
            size = random.choice([16, 20, 24, 28])
            # Utilise l'émoji sesterce ou un médaillon d'or
            cid = self.canvas.create_text(
                x, y, text="🪙", font=("Segoe UI Emoji", size)
            )
            self.coins.append({"id": cid, "x": x, "y": y, "vx": vx, "vy": vy, "w": w, "h": h, "bounces": 0})

        audio.play_coin_cascade()
        self._animate(0)

    def _animate(self, elapsed_ms):
        if not self.alive:
            return
        if elapsed_ms >= self.duration_ms:
            self.destroy()
            return

        for c in self.coins:
            c["x"] += c["vx"]
            c["y"] += c["vy"]
            c["vy"] += 0.35  # Gravité

            # Rebond sur le bas
            ground = c["h"] - 35
            if c["y"] >= ground and c["bounces"] < 2:
                c["y"] = ground
                c["vy"] = -abs(c["vy"]) * 0.45
                c["bounces"] += 1

            self.canvas.coords(c["id"], c["x"], c["y"])

        self.root.after(30, lambda: self._animate(elapsed_ms + 30))

    def destroy(self):
        self.alive = False
        try:
            self.canvas.destroy()
        except Exception:
            pass
        if self.on_complete:
            try:
                self.on_complete()
            except Exception:
                pass


def declencher_pluie_sesterces(parent_win, count=22, on_complete=None):
    """Déclenche la pluie de sesterces dorés sur la fenêtre donnée."""
    try:
        CoinRainAnimation(parent_win, count=count, on_complete=on_complete)
    except Exception:
        if on_complete:
            on_complete()


def effet_slash_epee(canvas, x1, y1, x2, y2, color="#ffd700", on_complete=None):
    """Trace un arc de coup d'épée lumineux rapide dans le canvas."""
    try:
        audio.play_sword_slash()
        line1 = canvas.create_line(x1, y1, x2, y2, fill=color, width=5, capstyle="round")
        line2 = canvas.create_line(x1, y1, x2, y2, fill="#ffffff", width=2, capstyle="round")

        def _effacer(step=0):
            if step == 0:
                canvas.itemconfig(line1, fill="#ffaa00", width=3)
                canvas.after(50, lambda: _effacer(1))
            else:
                canvas.delete(line1)
                canvas.delete(line2)
                if on_complete:
                    on_complete()

        canvas.after(60, _effacer)
    except Exception:
        if on_complete:
            on_complete()


def secousse_widget(widget, distance=8, repetitions=4):
    """Fait trembler visuellement un widget lors d'un impact en arène."""
    try:
        offsets = [distance, -distance, distance // 2, 0]

        def _step(idx=0):
            if idx < len(offsets):
                off = offsets[idx]
                try:
                    widget.pack_configure(padx=(off, -off) if off > 0 else (0, 0))
                except Exception:
                    pass
                widget.after(35, lambda: _step(idx + 1))
            else:
                try:
                    widget.pack_configure(padx=0)
                except Exception:
                    pass

        _step(0)
    except Exception:
        pass
