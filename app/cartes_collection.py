"""
Module de l'Album de Cartes Mythologiques 3D et Ouverture de Boosters.
Fournit une collection interactive de 24 cartes romaines (divinités, monstres, héros, monuments)
avec raretés (Marbre, Argent, Or, Légendaire), ouverture de paquets et statistiques.
"""

import tkinter as tk
from pathlib import Path
from tkinter import messagebox, ttk

try:
    from PIL import Image, ImageTk
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

from app import audio
from app import progress as prog
from app.polices import police_corps, police_titre
from app.theme import est_sombre
from content.cartes_data import (
    CARTES_COLLECTION,
    CATEGORIES,
    RARETES,
    tirage_booster,
)

ASSETS_IMAGES = Path(__file__).resolve().parent.parent / "assets" / "images"
PRIX_BOOSTER = 100


class CarteWidget(tk.Frame):
    """Représentation visuelle d'une carte à collectionner 3D."""

    def __init__(self, master, carte_info, debloquee=True, taille_reduite=True, command=None, **kw):
        super().__init__(master, bd=2, relief="ridge", **kw)
        self.carte = carte_info
        self.debloquee = debloquee
        self.command = command

        from app.responsive import obtenir_facteur_echelle
        scale = obtenir_facteur_echelle(master)

        rarete = RARETES.get(self.carte["rarete"], RARETES["commune"])
        couleur_rarete = rarete["couleur"] if self.debloquee else "#555555"

        sombre = True
        try:
            sombre = est_sombre(master.cget("bg"))
        except Exception:
            pass

        if sombre:
            bg_card = "#1f2335" if self.debloquee else "#181a24"
            fg_titre = "#ffd700" if self.debloquee else "#9aa0b4"
        else:
            bg_card = "#ffffff" if self.debloquee else "#f5ece1"
            fg_titre = "#8c1d1d" if self.debloquee else "#6e5d4a"

        w = int((140 if taille_reduite else 260) * scale)
        h = int((210 if taille_reduite else 380) * scale)
        self.configure(bg=bg_card, highlightbackground=couleur_rarete, highlightthickness=2, width=w, height=h)

        # Titre de la carte
        titre_txt = self.carte["nom"] if self.debloquee else "Mystère"
        titre_font = police_titre(9 if taille_reduite else 14)
        self.lbl_titre = tk.Label(self, text=titre_txt, font=titre_font, bg=bg_card, fg=fg_titre)
        self.lbl_titre.pack(fill=tk.X, pady=(4, 2))

        # Illustration
        img_h = int((80 if taille_reduite else 140) * scale)
        self.img_lbl = tk.Label(self, bg=bg_card)
        self.img_lbl.pack(pady=2)

        if self.debloquee:
            self._charger_image(img_h)
        else:
            self._charger_dos(img_h if taille_reduite else int(img_h * 1.25))

        # Rareté & Stats
        stats_frame = tk.Frame(self, bg=bg_card)
        stats_frame.pack(fill=tk.X, padx=4, pady=2)

        badge_txt = rarete["nom"] if self.debloquee else "Scellée"
        badge_lbl = tk.Label(stats_frame, text=badge_txt, font=("Georgia", 8, "bold"),
                             bg=couleur_rarete if self.debloquee else "#3d1f24",
                             fg="#ffffff" if self.debloquee else "#d4af37", padx=4)
        badge_lbl.pack(side=tk.LEFT)

        if self.debloquee:
            atk_lbl = tk.Label(stats_frame, text=f"⚔️ {self.carte['atk']}", font=("Georgia", 8, "bold"),
                               bg=bg_card, fg="#e74c3c")
            atk_lbl.pack(side=tk.RIGHT, padx=2)
            def_lbl = tk.Label(stats_frame, text=f"🛡️ {self.carte['def']}", font=("Georgia", 8, "bold"),
                               bg=bg_card, fg="#3498db")
            def_lbl.pack(side=tk.RIGHT, padx=2)

        # Citation si mode agrandi
        if not taille_reduite:
            if self.debloquee:
                lbl_latin = tk.Label(self, text=f"« {self.carte['citation']} »", font=("Georgia", 10, "italic"),
                                     bg=bg_card, fg="#2ecc71", wraplength=240)
                lbl_latin.pack(pady=6)
                lbl_desc = tk.Label(self, text=self.carte["anecdote"], font=("Georgia", 9),
                                    bg=bg_card, fg="#dcd6cd", wraplength=240, justify=tk.LEFT)
                lbl_desc.pack(padx=8, pady=4)
            else:
                lbl_mystere = tk.Label(
                    self,
                    text="📜 Relique Antique Scellée\n\nCette carte sommeille encore dans les archives du Sénat.\nOuvre des Boosters Mythologiques pour la révéler !",
                    font=("Georgia", 9, "italic"),
                    bg=bg_card, fg="#a9b1d6", wraplength=240, justify=tk.CENTER
                )
                lbl_mystere.pack(padx=8, pady=16)

        if self.command:
            self.bind("<Button-1>", lambda e: self.command(self.carte))
            for child in self.winfo_children():
                child.bind("<Button-1>", lambda e: self.command(self.carte))

    def _charger_dos(self, h_cible):
        dos_path = ASSETS_IMAGES / "dos_carte_collector.png"
        if dos_path.exists() and HAS_PIL:
            try:
                im = Image.open(dos_path).convert("RGBA")
                aspect = im.width / max(1, im.height)
                w_cible = int(h_cible * aspect)
                im_res = im.resize((w_cible, h_cible), Image.Resampling.LANCZOS)
                self._photo = ImageTk.PhotoImage(im_res)
                self.img_lbl.configure(image=self._photo)
                return
            except Exception:
                pass
        self.img_lbl.configure(text="🏛️", font=("Segoe UI Emoji", 28), fg="#d4af37")

    def _charger_image(self, h_cible):
        img_name = self.carte.get("img", "boss_mercure_cadre_140.png")
        img_path = ASSETS_IMAGES / img_name
        if not img_path.exists():
            img_path = ASSETS_IMAGES / "logo_centurion_120.png"

        if img_path.exists() and HAS_PIL:
            try:
                im = Image.open(img_path).convert("RGBA")
                aspect = im.width / max(1, im.height)
                w_cible = int(h_cible * aspect)
                im_res = im.resize((w_cible, h_cible), Image.Resampling.LANCZOS)
                self._photo = ImageTk.PhotoImage(im_res)
                self.img_lbl.configure(image=self._photo)
            except Exception:
                pass


class BoosterOpeningDialog(tk.Toplevel):
    """Fenêtre d'ouverture animée d'un booster de cartes romaines."""

    def __init__(self, master, app, cartes_obtenues, on_close=None):
        super().__init__(master)
        self.app = app
        self.cartes = cartes_obtenues
        self.on_close = on_close
        self.cartes_revelees = 0

        self.title("✨ Ouverture de Booster Mythologique — Ludus Latinus")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 740, 520, min_w=580, min_h=440)
        self.configure(bg="#1a1b26")
        self.transient(master)
        self.grab_set()

        # En-tête
        tk.Label(self, text="🏛️ BOOSTER DU SÉNAT ROMAIN 🏛️", font=police_titre(16),
                 bg="#1a1b26", fg="#ffd700").pack(pady=(16, 4))
        self.lbl_statut = tk.Label(self, text="Clique sur une carte pour la révéler !",
                                   font=police_corps(11, italique=True), bg="#1a1b26", fg="#dcd6cd")
        self.lbl_statut.pack(pady=(0, 16))

        # Zone des 3 cartes
        self.cartes_frame = tk.Frame(self, bg="#1a1b26")
        self.cartes_frame.pack(expand=True, fill=tk.BOTH, padx=20)

        self.widgets_cartes = []
        for c in self.cartes:
            f = tk.Frame(self.cartes_frame, bg="#1a1b26", padx=10)
            f.pack(side=tk.LEFT, expand=True)
            w = CarteWidget(f, c, debloquee=False, taille_reduite=True, command=self._reveler_carte)
            w.pack()
            self.widgets_cartes.append((w, c, f))

        self.btn_valider = tk.Button(self, text="Collecter les Cartes", font=police_corps(11, gras=True),
                                     bg="#27ae60", fg="#ffffff", state=tk.DISABLED,
                                     padx=16, pady=6, command=self._fermer)
        self.btn_valider.pack(pady=16)

        audio.play_parchemin()

    def _reveler_carte(self, carte):
        for idx, (w, c, f) in enumerate(self.widgets_cartes):
            if c["id"] == carte["id"] and not w.debloquee:
                audio.play_carte_flip()
                w.destroy()
                nouv_w = CarteWidget(f, c, debloquee=True, taille_reduite=True)
                nouv_w.pack()
                self.widgets_cartes[idx] = (nouv_w, c, f)
                self.cartes_revelees += 1

                # SFX selon rareté
                if c["rarete"] == "legendaire":
                    audio.play_fanfare()
                    audio.play_booster_reveal()
                    if hasattr(self.app, "_animer_confettis"):
                        self.app._animer_confettis()
                elif c["rarete"] in ("epique", "rare"):
                    audio.play_coin_cascade()
                    audio.play_booster_reveal()
                else:
                    audio.play_coin()

                debloquees = set(self.app.data.get("cartes_collection", []))
                debloquees.add(c["id"])
                self.app.data["cartes_collection"] = list(debloquees)
                prog.save_progress(self.app.data)
                try:
                    from app.succes import verifier_tous_succes
                    verifier_tous_succes(self.app)
                except Exception:
                    pass

                if self.cartes_revelees >= len(self.cartes):
                    self.lbl_statut.configure(text="🎉 Toutes les cartes sont révélées ! Ajoutées à ton Album !", fg="#2ecc71")
                    self.btn_valider.configure(state=tk.NORMAL)
                break

    def _fermer(self):
        if self.on_close:
            self.on_close()
        self.destroy()


class AlbumCartesWindow(tk.Toplevel):
    """Fenêtre principale de l'Album de Cartes Mythologiques."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C

        self.title("🃏 Album des Cartes Mythologiques — Ludus Latinus")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 980, 700, min_w=760, min_h=520)
        self.configure(bg=self.C["bg"])

        self.categorie_filtre = "toutes"
        self._build_ui()
        audio.play_parchemin()

    def _build_ui(self):
        # 1. En-tête avec compteur et bouton d'achat
        hdr = tk.Frame(self, bg=self.C["panel"], padx=14, pady=10)
        hdr.pack(fill=tk.X, side=tk.TOP)

        left_hdr = tk.Frame(hdr, bg=self.C["panel"])
        left_hdr.pack(side=tk.LEFT)

        tk.Label(left_hdr, text="🃏 ALBUM DES LÉGENDES ANTIQUES", font=police_titre(15),
                 bg=self.C["panel"], fg="#ffd700").pack(anchor=tk.W)

        self.lbl_compteur = tk.Label(left_hdr, text="", font=police_corps(10),
                                     bg=self.C["panel"], fg=self.C["muted"])
        self.lbl_compteur.pack(anchor=tk.W)

        right_hdr = tk.Frame(hdr, bg=self.C["panel"])
        right_hdr.pack(side=tk.RIGHT)

        self.btn_acheter_booster = tk.Button(
            right_hdr,
            text=f"🎁 Ouvrir un Booster (🪙 {PRIX_BOOSTER})",
            font=police_corps(10, gras=True),
            bg="#d4af37", fg="#1a1b26", padx=10, pady=4, cursor="hand2",
            command=self._acheter_booster
        )
        self.btn_acheter_booster.pack(side=tk.RIGHT, padx=6)

        # 2. Barre d'onglets de catégories
        tabs_frame = tk.Frame(self, bg=self.C["panel"], padx=10, pady=4)
        tabs_frame.pack(fill=tk.X)

        self.btn_tabs = {}
        for cat_id, cat_nom in [("toutes", "🌟 Toutes")] + list(CATEGORIES.items()):
            btn = tk.Button(tabs_frame, text=cat_nom, font=police_corps(9),
                            bg=self.C["editor"], fg=self.C["fg"], relief="flat", padx=8, pady=2,
                            command=lambda c=cat_id: self._filtrer_categorie(c))
            btn.pack(side=tk.LEFT, padx=3)
            self.btn_tabs[cat_id] = btn

        # 3. Zone principale scindée (Grille d'album à gauche, Inspecteur à droite)
        corps = tk.Frame(self, bg=self.C["bg"])
        corps.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # Panneau Inspecteur agrandi à droite
        self.inspect_frame = tk.Frame(corps, bg=self.C["panel"], width=290, bd=1, relief="ridge")
        self.inspect_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=(10, 0))

        tk.Label(self.inspect_frame, text="🔍 DÉTAILS DE LA CARTE", font=police_titre(12),
                 bg=self.C["panel"], fg=self.C["heading"]).pack(pady=10)
        self.inspect_conteneur = tk.Frame(self.inspect_frame, bg=self.C["panel"])
        self.inspect_conteneur.pack(expand=True, fill=tk.BOTH, padx=10, pady=5)

        # Grille de cartes défilable à gauche
        canvas_frame = tk.Frame(corps, bg=self.C["bg"])
        canvas_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.canvas = tk.Canvas(canvas_frame, bg=self.C["bg"], highlightthickness=0)
        scrollbar = ttk.Scrollbar(canvas_frame, orient="vertical", command=self.canvas.yview)
        self.grid_frame = tk.Frame(self.canvas, bg=self.C["bg"])

        self.canvas.create_window((0, 0), window=self.grid_frame, anchor="nw")
        self.canvas.configure(xscrollcommand=None, yscrollcommand=scrollbar.set)

        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.grid_frame.bind("<Configure>", lambda e: self.canvas.configure(scrollregion=self.canvas.bbox("all")))
        self.canvas.bind("<Configure>", self._on_canvas_configure)

        self._rafraichir_album()

    def _on_canvas_configure(self, event):
        self.canvas.configure(scrollregion=self.canvas.bbox("all"))
        cols = max(3, min(5, (event.width - 24) // 150))
        if getattr(self, "_derniere_cols", None) != cols:
            self._derniere_cols = cols
            self._reorganiser_grille(cols)

    def _reorganiser_grille(self, cols):
        for c in range(cols):
            self.grid_frame.columnconfigure(c, weight=1)
        children = self.grid_frame.winfo_children()
        for idx, w in enumerate(children):
            r = idx // cols
            c = idx % cols
            w.grid(row=r, column=c, padx=8, pady=8)

    def _filtrer_categorie(self, cat):
        audio.play_click()
        self.categorie_filtre = cat
        for c, b in self.btn_tabs.items():
            b.configure(bg=self.C["accent"] if c == cat else self.C["editor"],
                        fg=self.C["sel_fg"] if c == cat else self.C["fg"])
        self._rafraichir_album()

    def _rafraichir_album(self):
        for w in self.grid_frame.winfo_children():
            w.destroy()

        debloquees = set(self.app.data.get("cartes_collection", []))
        total_cartes = len(CARTES_COLLECTION)
        nb_debloquees = len(debloquees)
        pct = int((nb_debloquees / max(1, total_cartes)) * 100)

        self.lbl_compteur.configure(
            text=f"Collection : {nb_debloquees} / {total_cartes} cartes trouvées ({pct}%)"
        )

        # Mettre à jour les compteurs des onglets de catégories
        for cat_id, btn in self.btn_tabs.items():
            if cat_id == "toutes":
                nom_base = "🌟 Toutes"
                cnt = nb_debloquees
                tot = total_cartes
            else:
                nom_base = CATEGORIES.get(cat_id, cat_id)
                tot = sum(1 for c in CARTES_COLLECTION if c["categorie"] == cat_id)
                cnt = sum(1 for c in CARTES_COLLECTION if c["categorie"] == cat_id and c["id"] in debloquees)
            btn.configure(text=f"{nom_base} ({cnt}/{tot})")

        cartes_affichees = [
            c for c in CARTES_COLLECTION
            if self.categorie_filtre == "toutes" or c["categorie"] == self.categorie_filtre
        ]

        cw = max(580, self.canvas.winfo_width())
        cols = max(3, min(5, (cw - 24) // 150))
        self._derniere_cols = cols

        for c_idx in range(cols):
            self.grid_frame.columnconfigure(c_idx, weight=1)

        for idx, c in enumerate(cartes_affichees):
            r = idx // cols
            col = idx % cols
            est_debloquee = c["id"] in debloquees
            carte_w = CarteWidget(
                self.grid_frame, c, debloquee=est_debloquee, taille_reduite=True,
                command=self._inspecter_carte
            )
            carte_w.grid(row=r, column=col, padx=8, pady=8)

        # Afficher la première carte débloquée dans l'inspecteur par défaut
        if cartes_affichees:
            premiere = next((c for c in cartes_affichees if c["id"] in debloquees), cartes_affichees[0])
            self._inspecter_carte(premiere)

    def _inspecter_carte(self, carte):
        audio.play_click()
        for w in self.inspect_conteneur.winfo_children():
            w.destroy()

        debloquees = set(self.app.data.get("cartes_collection", []))
        est_debloquee = carte["id"] in debloquees
        CarteWidget(self.inspect_conteneur, carte, debloquee=est_debloquee, taille_reduite=False).pack(fill=tk.BOTH, expand=True)

    def _acheter_booster(self):
        audio.play_click()
        sesterces = self.app.data.get("sesterces", 0)
        if sesterces < PRIX_BOOSTER:
            messagebox.showwarning(
                "Sesterces Insuffisants",
                f"Il te faut {PRIX_BOOSTER} Sesterces pour ouvrir un booster.\nTu as actuellement {sesterces} Sesterces."
            )
            return

        self.app.data["sesterces"] -= PRIX_BOOSTER
        prog.save_progress(self.app.data)
        self.app._refresh_header_stats()

        cartes_tirage = tirage_booster(3)
        BoosterOpeningDialog(self, self.app, cartes_tirage, on_close=self._rafraichir_album)
