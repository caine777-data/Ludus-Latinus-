"""
Le Musée des Curiosités et Secrets de Rome.
Fiches illustrées et anecdotes insolites débloquées au fil de la progression.
"""

import tkinter as tk
from tkinter import ttk

CARTES_MUSEE = [
    {
        "id": "rome_fondation",
        "titre": "La Louve et les Jumeaux",
        "icone": "🐺",
        "epoque": "Origines de Rome (-753)",
        "image": "musee_louve.png",
        "texte": (
            "D'après la légende, Romulus et son frère Rémus ont été abandonnés dans un berceau "
            "sur le fleuve Tibre. Une louve généreuse (*Lupa*) les a recueillis dans une grotte "
            "et les a nourris de son lait avant qu'un berger ne les adopte.\n\n"
            "💡 Le savais-tu ? « Lupa » en latin désignait aussi familièrement les femmes courageuses !"
        )
    },
    {
        "id": "cave_canem",
        "titre": "Cave Canem : Attention au chien !",
        "icone": "🐕",
        "epoque": "Pompéi",
        "image": "musee_cave_canem.png",
        "texte": (
            "À l'entrée de nombreuses maisons romaines (la *domus*), on trouvait une mosaïque au sol "
            "représentant un molosse féroce attaché avec l'inscription « CAVE CANEM ».\n\n"
            "💡 C'est le tout premier panneau « Attention au chien » de l'Histoire humaine ! "
            "On l'a retrouvé intact sous les cendres de Pompéi."
        )
    },
    {
        "id": "pouce_gladiateur",
        "titre": "Le Pouce du Gladiateur : Vrai ou Faux ?",
        "icone": "⚔️",
        "epoque": "Le Colisée",
        "image": "musee_gladiateur.png",
        "texte": (
            "Dans les films, l'empereur baisse le pouce vers le bas pour ordonner la mort du gladiateur.\n\n"
            "💡 En réalité, les historiens ont découvert que c'était l'inverse ! "
            "Le pouce pointé vers le haut ou vers la gorge (*pollice verso*) signifiait : 'égorge-le avec ton fer'. "
            "Pour gracier le combattant, le public cachait son pouce à l'intérieur du poing fermé pour dire 'range ton épée' !"
        )
    },
    {
        "id": "lion_nemee",
        "titre": "Le Lion de Némée et sa peau magique",
        "icone": "🦁",
        "epoque": "Mythologie",
        "image": "musee_lion.png",
        "texte": (
            "Pour son tout premier travail, Hercule dut affronter le monstrueux Lion de Némée. "
            "Les flèches et l'épée ricochaient sur sa peau impénétrable ! "
            "Hercule dut l'étouffer à mains nues, puis utilisa les propres griffes du lion pour découper sa peau "
            "et s'en faire une armure invulnérable."
        )
    },
    {
        "id": "monstres_pegase",
        "titre": "Pégase et les Créatures Mythologiques",
        "icone": "🪽",
        "epoque": "Mythes Gréco-Romains",
        "image": "musee_pegase.png",
        "texte": (
            "Pégase (*Pegasus*) est le cheval ailé divin né du sang de Méduse. D'un coup de sabot "
            "sur le mont Hélicon, il fit jaillir la source Hippocrène qui inspire tous les poètes et savants !\n\n"
            "💡 Les Romains ornaient souvent leurs vases, mosaïques et pièces de monnaie "
            "de ce symbole céleste de liberté et d'inspiration."
        )
    },
    {
        "id": "legion_tortue",
        "titre": "La Légion Romaine et la Formation Tortue",
        "icone": "🛡️",
        "epoque": "Armée Impériale",
        "image": "musee_legion.png",
        "texte": (
            "La légion romaine était redoutée dans tout le monde antique grâce à son organisation d'acier. "
            "Sa formation la plus célèbre, la *testudo* (tortue), consistait à verrouiller les grands boucliers *scuta* "
            "devant, sur les flancs et au-dessus des têtes.\n\n"
            "💡 Les flèches et javelines ennemies rebondissaient sur ce toit impénétrable "
            "comme des gouttes de pluie sur une carapace !"
        )
    },
    {
        "id": "circus_maximus",
        "titre": "La folie des 4 équipes du Cirque !",
        "icone": "🐎",
        "epoque": "Courses de chars",
        "image": "musee_circus.png",
        "texte": (
            "À Rome, tout le monde avait son équipe de chars favorite identifiée par une couleur : "
            "les Rouges (*Russati*), les Blancs (*Albati*), les Bleus (*Veneti*) et les Verts (*Prasini*) !\n\n"
            "💡 Les supporters romains criaient tellement fort dans le Circus Maximus (plus de 150 000 spectateurs) "
            "que le bruit s'entendait jusqu'à l'autre bout de la ville !"
        )
    },
    {
        "id": "secrets_termes",
        "titre": "Le chauffage magique des Thermes (*Hypocauste*)",
        "icone": "♨️",
        "epoque": "Ingénierie romaine",
        "image": "musee_thermes.png",
        "texte": (
            "Comment les Romains chauffaient-ils leurs piscines et leurs sols en plein hiver ? "
            "Grâce à l'hypocauste : un immense foyer souterrain entretenu par des serviteurs, "
            "faisant circuler de l'air brûlant sous les dalles surélevées par des piliers de briques.\n\n"
            "💡 Les Romains marchaient avec des sandales en bois pour ne pas se brûler la plante des pieds !"
        )
    },
    {
        "id": "laurier_or_5eme",
        "titre": "Le Laurier d'Or du Triomphe (Programme 5ème)",
        "icone": "👑",
        "epoque": "Fin du Cycle 5ème",
        "image": "musee_trophee_5eme.png",
        "texte": (
            "Le Sénat et le Peuple de Rome décernent la « Corona Triumphalis » à l'élève "
            "ayant franchi les 10 Mondes et réussi les 49 leçons du programme officiel de 5ème !\n\n"
            "🏆 Récompenses obtenues :\n"
            "• Le titre honorifique de TRIUMPHATOR SUPREMUS\n"
            "• Le Grand Badge d'Or officiel de Rome\n"
            "• Une prime impériale de +200 Sesterces d'Or\n"
            "• Le Diplôme Impérial d'Honneur imprimable !"
        )
    }
]


class MuseeWindow(tk.Toplevel):
    def __init__(self, parent, app):
        super().__init__(parent)
        self.app = app
        self.title("Le Musée des Curiosités et Secrets de Rome 📜")
        self.geometry("880x640")
        self.minsize(820, 600)
        self.configure(bg=app.C["bg"])
        self.transient(parent)

        self._img_ref = None
        self._build_ui()

    def _build_ui(self):
        C = self.app.C
        hdr = tk.Frame(self, bg=C["panel"], padx=16, pady=12)
        hdr.pack(fill=tk.X)

        tk.Label(hdr, text="📜 Musée des Curiosités Romaines", font=(self.app.title_font.cget("family"), 14, "bold"),
                 bg=C["panel"], fg=C["heading"]).pack(side=tk.LEFT)

        tk.Label(hdr, text="Fiches richement illustrées et secrets de l'Antiquité !", font=(self.app.body.cget("family"), 10),
                 bg=C["panel"], fg=C["muted"]).pack(side=tk.RIGHT)

        paned = ttk.PanedWindow(self, orient=tk.HORIZONTAL)
        paned.pack(fill=tk.BOTH, expand=True, padx=16, pady=12)

        # Liste de gauche
        cadre_liste = ttk.Frame(paned, width=320)
        paned.add(cadre_liste, weight=1)

        self.listbox = tk.Listbox(cadre_liste, font=(self.app.body.cget("family"), 10),
                                  width=36,
                                  bg=C["editor"], fg=C["fg"], selectbackground=C["accent"],
                                  selectforeground=C["sel_fg"], relief="flat", bd=1)
        self.listbox.pack(fill=tk.BOTH, expand=True)
        self.listbox.bind("<<ListboxSelect>>", self._on_select)

        for carte in CARTES_MUSEE:
            self.listbox.insert(tk.END, f"{carte['icone']}  {carte['titre']}")

        # Panneau de droite : fiche détaillée
        self.cadre_detail = ttk.Frame(paned)
        paned.add(self.cadre_detail, weight=3)

        self.detail_titre = tk.Label(self.cadre_detail, text="", font=(self.app.title_font.cget("family"), 13, "bold"),
                                     bg=C["bg"], fg=C["heading"], wraplength=480, justify="left")
        self.detail_titre.pack(anchor="w", padx=14, pady=(8, 2))

        self.detail_epoque = tk.Label(self.cadre_detail, text="", font=(self.app.body.cget("family"), 9, "italic"),
                                      bg=C["bg"], fg=C["muted"])
        self.detail_epoque.pack(anchor="w", padx=14, pady=(0, 6))

        # Illustration avec cadre romain
        self.detail_image_lbl = tk.Label(self.cadre_detail, bg=C["bg"])
        self.detail_image_lbl.pack(padx=14, pady=(0, 6))

        self.detail_texte = tk.Text(self.cadre_detail, wrap="word", relief="flat", height=7,
                                    font=(self.app.body.cget("family"), 10),
                                    bg=C["editor"], fg=C["fg"], padx=12, pady=10)
        self.detail_texte.pack(fill=tk.BOTH, expand=True, padx=14, pady=(0, 8))

        self.btn_ceremonie = tk.Button(
            self.cadre_detail, text="🎆 Revivre la Cérémonie du Triomphe de 5ème",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg="#c59b27", fg="#ffffff", activebackground="#a6801a",
            relief="flat", padx=12, pady=6, cursor="hand2",
            command=self._lancer_triomphe
        )

        if CARTES_MUSEE:
            self.listbox.selection_set(0)
            self._afficher_carte(0)

    def _on_select(self, event):
        sel = self.listbox.curselection()
        if sel:
            self._afficher_carte(sel[0])

    def _afficher_carte(self, idx):
        from app.cadres import charger_photo_romaine

        carte = CARTES_MUSEE[idx]
        self.detail_titre.configure(text=f"{carte['icone']} {carte['titre']}")
        self.detail_epoque.configure(text=f"Époque / Contexte : {carte['epoque']}")

        # Charger l'illustration encadrée
        img_nom = carte.get("image")
        if img_nom:
            photo = charger_photo_romaine(img_nom)
            if photo:
                self._img_ref = photo
                self.detail_image_lbl.configure(image=self._img_ref)
                self.detail_image_lbl.pack(before=self.detail_texte, padx=14, pady=(0, 6))
            else:
                self.detail_image_lbl.pack_forget()
        else:
            self.detail_image_lbl.pack_forget()

        self.detail_texte.configure(state="normal")
        self.detail_texte.delete("1.0", tk.END)
        self.detail_texte.insert("1.0", carte["texte"])
        self.detail_texte.configure(state="disabled")

        if carte.get("id") == "laurier_or_5eme":
            self.btn_ceremonie.pack(pady=(0, 8))
        else:
            self.btn_ceremonie.pack_forget()

    def _lancer_triomphe(self):
        from app.triomphe import Triomphe5emeDialog
        Triomphe5emeDialog(self, self.app)
