"""
Module utilitaire pour la réactivité (responsiveness) de l'interface graphique Tkinter.
Fournit des fonctions pour adapter dynamiquement la géométrie des fenêtres aux écrans
(des résolutions 1024x768 et netbooks aux écrans 4K) et lier le repli automatique
du texte (wraplength) au redimensionnement des conteneurs.
"""

from __future__ import annotations

import tkinter as tk


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
