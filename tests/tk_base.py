"""
Socle commun aux tests qui ouvrent une fenêtre Tkinter.

Sous Linux, la suite se terminait par « Tcl_AsyncDelete: async handler deleted
by the wrong thread » suivi d'un abandon du processus. Chaque classe de test
crée son propre interpréteur Tcl ; les widgets encore référencés en mémoire
étaient finalisés par le ramasse-miettes bien après la destruction de leur
interpréteur, parfois depuis un autre thread, ce que Tcl refuse.

On vide donc la file d'événements et on force le ramassage AVANT de détruire
la racine, tant que l'interpréteur est encore vivant pour absorber les
finalisations.
"""

import gc


def annuler_rappels(racine):
    """Annule les after() encore planifiés sur cet interpréteur.

    Un rappel qui se déclenche après la destruction de sa fenêtre provoque
    « invalid command name ... ("after" script) », et sous Linux il participe
    à l'abandon du processus en fin de suite.
    """
    try:
        for identifiant in racine.tk.call("after", "info"):
            try:
                racine.after_cancel(identifiant)
            except Exception:
                pass
    except Exception:
        pass


def vider_caches_images():
    """Vide les caches de PhotoImage de l'application.

    Une PhotoImage appartient à l'interpréteur qui l'a créée. Gardée dans un
    cache de module, elle survit à la fenêtre et devient inutilisable pour la
    suivante (« image "pyimageNN" doesn't exist »), en plus de traîner un objet
    Tcl mort jusqu'à la fin du processus.
    """
    try:
        from app import icones

        icones.vider_cache()
    except Exception:
        pass
    try:
        from app import cadres

        cadres._PHOTO_CACHE.clear()
    except Exception:
        pass


def detruire_racine(racine):
    """Ferme une racine Tk sans laisser de widget ni de rappel à traiter après coup."""
    if racine is None:
        return
    annuler_rappels(racine)
    vider_caches_images()
    try:
        racine.update_idletasks()
    except Exception:
        pass
    # Les widgets orphelins doivent mourir pendant que Tcl peut encore répondre.
    gc.collect()
    try:
        racine.destroy()
    except Exception:
        pass
    gc.collect()
