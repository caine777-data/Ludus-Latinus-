"""
Module utilitaire pour la réactivité (responsiveness) de l'interface graphique Tkinter.
Fournit des fonctions pour adapter dynamiquement la géométrie des fenêtres aux écrans
(des résolutions 1024x768 et netbooks aux écrans 4K) et lier le repli automatique
du texte (wraplength) au redimensionnement des conteneurs.
"""

from __future__ import annotations

import sys
import tkinter as tk


def activer_haute_resolution_dpi():
    """Active la haute résolution DPI sous Windows pour éliminer tout flou ou pixelisation."""
    if sys.platform == "win32":
        try:
            import ctypes
            # Per-Monitor DPI aware V2 (-4)
            ctypes.windll.user32.SetProcessDpiAwarenessContext(ctypes.c_void_p(-4))
            return
        except Exception:
            pass
        try:
            import ctypes
            # PROCESS_PER_MONITOR_DPI_AWARE (2)
            ctypes.windll.shcore.SetProcessDpiAwareness(2)
            return
        except Exception:
            pass
        try:
            import ctypes
            ctypes.windll.user32.SetProcessDPIAware()
        except Exception:
            pass


def obtenir_facteur_echelle(widget=None) -> float:
    """Retourne le facteur d'échelle DPI (1.0 = 100%, 1.5 = 150%, 2.0 = 4K/200%)."""
    try:
        if widget is not None:
            fp = widget.winfo_fpixels("1i")
            if fp > 0:
                return max(1.0, round(fp / 96.0, 2))
    except Exception:
        pass
    return 1.0


def mettre_a_l_echelle_tk(root: tk.Tk):
    """Ajuste le scaling interne de Tkinter selon la résolution physique réelle."""
    try:
        activer_haute_resolution_dpi()
        root.update_idletasks()
        pixels_per_inch = root.winfo_fpixels("1i")
        if pixels_per_inch > 0:
            ratio = pixels_per_inch / 72.0
            root.tk.call("tk", "scaling", ratio)
    except Exception:
        pass


def redimensionner_image_hd(image_pil, w_cible: int, h_cible: int, echelle_dpi: float = 1.0):
    """Redimensionne une image PIL avec rééchantillonnage LANCZOS haute précision adapté au DPI."""
    from PIL import Image
    w_physique = max(1, int(round(w_cible * echelle_dpi)))
    h_physique = max(1, int(round(h_cible * echelle_dpi)))
    resample_filter = getattr(Image, "Resampling", Image).LANCZOS
    return image_pil.resize((w_physique, h_physique), resample=resample_filter)


def adapter_geometrie_fenetre(
    fenetre: tk.Toplevel | tk.Tk,
    largeur_preferee: int = 860,
    hauteur_preferee: int = 640,
    min_w: int = 600,
    min_h: int = 450,
    marge_w: int = 40,
    marge_h: int = 80,
    centrer: bool = True,
) -> tuple[int, int]:
    """
    Calcule et applique une géométrie et des contraintes minsize adaptées à la résolution
    réelle de l'écran, évitant tout débordement hors du moniteur.
    """
    try:
        fenetre.update_idletasks()
        sw = fenetre.winfo_screenwidth()
        sh = fenetre.winfo_screenheight()
    except Exception:
        sw, sh = 1280, 800

    # Largeur et hauteur bornées par la taille de l'écran disponible
    w_max = max(min_w, sw - marge_w)
    h_max = max(min_h, sh - marge_h)

    w = min(largeur_preferee, w_max)
    h = min(hauteur_preferee, h_max)

    if centrer:
        x = max(0, (sw - w) // 2)
        y = max(0, (sh - h) // 2)
        fenetre.geometry(f"{w}x{h}+{x}+{y}")
    else:
        fenetre.geometry(f"{w}x{h}")

    # Min size ajustée si l'écran est très petit
    min_w_effectif = min(min_w, max(300, sw - 20))
    min_h_effectif = min(min_h, max(240, sh - 40))
    fenetre.minsize(min_w_effectif, min_h_effectif)

    return w, h


def lier_wraplength_dynamique(widget_parent, *labels, marge: int = 36, min_wraplength: int = 200):
    """
    Attache un gestionnaire d'événement <Configure> au widget parent pour recalculer
    automatiquement le wraplength des labels lors d'un redimensionnement.
    """
    def _sur_configure(event):
        if event.widget == widget_parent:
            nouveau_wrap = max(min_wraplength, event.width - marge)
            for lbl in labels:
                try:
                    lbl.configure(wraplength=nouveau_wrap)
                except Exception:
                    pass

    widget_parent.bind("<Configure>", _sur_configure, add="+")
