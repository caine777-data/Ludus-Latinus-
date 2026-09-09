"""
Module du Décrypteur Visuel de Phrases (Anatomia Sententiae).

Offre une radiographie syntaxique et morphologique interactive des phrases latines :
- Rubans de cas aux couleurs officielles romaines (Nominatif, Accusatif, Génitif, Datif, Ablatif, Verbe)
- Carte d'anatomie détaillée pour chaque mot (lemme, désinence, fonction, traduction)
- Prononciation vocale instantanée du mot ou de la phrase
- Atelier de traduction guidée pas-à-pas (Trouver le verbe -> Trouver le sujet -> Compléments)
"""

import re
import tkinter as tk
from tkinter import ttk

from app import audio
from app.polices import police_corps, police_titre
from app.theme import eclaircir, est_sombre

# Couleurs et caractéristiques pédagogiques des cas et catégories
CAS_INFO = {
    "nominatif": {
        "nom": "Nominatif",
        "role": "Sujet / Attribut",
        "question": "Qui fait l'action ?",
        "bg": "#1e88e5",  # Bleu Lapis
        "fg": "#ffffff",
        "icone": "👑",
        "desc": "Désigne l'auteur de l'action ou l'état du sujet.",
    },
    "vocatif": {
        "nom": "Vocatif",
        "role": "Interpellation",
        "question": "Ô qui ?",
        "bg": "#00acc1",  # Cyan Romain
        "fg": "#ffffff",
        "icone": "📢",
        "desc": "Sert à apostropher ou interpeller directement une personne.",
    },
    "accusatif": {
        "nom": "Accusatif",
        "role": "C.O.D. / Destination",
        "question": "Qui / Quoi ? (subit l'action) ou Vers où ?",
        "bg": "#e53935",  # Rouge Carmin
        "fg": "#ffffff",
        "icone": "🎯",
        "desc": "Reçoit directement l'action du verbe transitif ou indique le mouvement vers un lieu.",
    },
    "genitif": {
        "nom": "Génitif",
        "role": "Complément du Nom",
        "question": "De qui ? De quoi ? / Possession",
        "bg": "#2e7d32",  # Vert Émeraude
        "fg": "#ffffff",
        "icone": "🗝️",
        "desc": "Indique à qui appartient la chose ou établit une relation de dépendance.",
    },
    "datif": {
        "nom": "Datif",
        "role": "C.O.I. / Attribution",
        "question": "À qui ? Pour qui ?",
        "bg": "#f59e0b",  # Or Impérial
        "fg": "#1a1409",
        "icone": "🎁",
        "desc": "Indique le destinataire ou le bénéficiaire de l'action.",
    },
    "ablatif": {
        "nom": "Ablatif",
        "role": "Complément Circonstanciel",
        "question": "Où ? Quand ? Comment ? Par quel moyen ?",
        "bg": "#8e24aa",  # Pourpre Royal
        "fg": "#ffffff",
        "icone": "🗺️",
        "desc": "Exprime les circonstances : lieu où l'on est, temps, moyen, instrument ou manière.",
    },
    "verbe": {
        "nom": "Verbe Conjugué",
        "role": "L'Action / Pivot",
        "question": "Que se passe-t-il ?",
        "bg": "#e65100",  # Ambre Flamboyant
        "fg": "#ffffff",
        "icone": "⚡",
        "desc": "Le cœur de la phrase latine. Donne le temps, la personne et l'action principale.",
    },
    "invariable": {
        "nom": "Invariable",
        "role": "Lien / Nuance",
        "question": "Adverbe, préposition, conjonction",
        "bg": "#546e7a",  # Ardoise
        "fg": "#ffffff",
        "icone": "🔗",
        "desc": "Relie les mots ou apporte une précision de temps, d'espace ou de cause.",
    },
}

# Corpus de phrases exemplaires entièrement annotées pour le collège (5e, 4e, 3e)
PHRASES_PREDEFINIES = [
    {
        "titre": "Romulus Romam condidit (5e)",
        "latin": "Romulus Romam condidit",
        "francais": "Romulus fonda Rome.",
        "sens_chunks": ["Romulus", "fonda", "Rome."],
        "mots": [
            {
                "texte": "Romulus",
                "lemme": "Romulus, i, m.",
                "radical": "Romul-",
                "desinence": "-us",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Sujet du verbe 'condidit'",
                "traduction": "Romulus",
                "astuce": "Terminaison en -us de la 2e déclinaison : c'est le sujet !",
            },
            {
                "texte": "Romam",
                "lemme": "Roma, ae, f.",
                "radical": "Rom-",
                "desinence": "-am",
                "cas": "accusatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Complément d'Objet Direct (COD)",
                "traduction": "Rome",
                "astuce": "Terminaison en -am : désinence type de l'accusatif singulier de la 1ère déclinaison.",
            },
            {
                "texte": "condidit",
                "lemme": "condo, condere, condidi, conditum",
                "radical": "condid-",
                "desinence": "-it",
                "cas": "verbe",
                "temps": "parfait de l'indicatif (passé simple)",
                "personne": "3e personne du singulier",
                "fonction": "Verbe principal de la proposition",
                "traduction": "fonda / a fondé",
                "astuce": "Verbe d'action au parfait (terminaison en -it).",
            },
        ],
    },
    {
        "titre": "Puella pulchra rosam agricolae dat (5e)",
        "latin": "Puella pulchra rosam agricolae dat",
        "francais": "La belle jeune fille donne une rose au paysan.",
        "sens_chunks": ["La belle jeune fille", "donne", "une rose", "au paysan."],
        "mots": [
            {
                "texte": "Puella",
                "lemme": "puella, ae, f.",
                "radical": "puell-",
                "desinence": "-a",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Sujet du verbe 'dat'",
                "traduction": "La jeune fille",
                "astuce": "1ère déclinaison en -a au nominatif singulier.",
            },
            {
                "texte": "pulchra",
                "lemme": "pulcher, pulchra, pulchrum",
                "radical": "pulchr-",
                "desinence": "-a",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Épithète du sujet 'puella'",
                "traduction": "belle",
                "astuce": "L'adjectif s'accorde en genre, nombre et cas avec le nom qu'il qualifie.",
            },
            {
                "texte": "rosam",
                "lemme": "rosa, ae, f.",
                "radical": "ros-",
                "desinence": "-am",
                "cas": "accusatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Complément d'Objet Direct (COD)",
                "traduction": "une rose",
                "astuce": "La désinence -am indique l'objet de l'action.",
            },
            {
                "texte": "agricolae",
                "lemme": "agricola, ae, m.",
                "radical": "agricol-",
                "desinence": "-ae",
                "cas": "datif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Complément d'Attribution (COI)",
                "traduction": "au paysan",
                "astuce": "Datif en -ae : c'est la personne à qui l'on donne la rose !",
            },
            {
                "texte": "dat",
                "lemme": "do, dare, dedi, datum",
                "radical": "da-",
                "desinence": "-t",
                "cas": "verbe",
                "temps": "présent de l'indicatif",
                "personne": "3e personne du singulier",
                "fonction": "Verbe principal",
                "traduction": "donne",
                "astuce": "Terminaison -t = il / elle.",
            },
        ],
    },
    {
        "titre": "Caesar legiones in Galliam ducit (4e)",
        "latin": "Caesar legiones in Galliam ducit",
        "francais": "César conduit les légions en Gaule.",
        "sens_chunks": ["César", "conduit", "les légions", "en Gaule."],
        "mots": [
            {
                "texte": "Caesar",
                "lemme": "Caesar, Caesaris, m.",
                "radical": "Caesar-",
                "desinence": "Ø",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Sujet du verbe 'ducit'",
                "traduction": "César",
                "astuce": "3e déclinaison consonnantique : le nom propre est sujet.",
            },
            {
                "texte": "legiones",
                "lemme": "legio, legionis, f.",
                "radical": "legion-",
                "desinence": "-es",
                "cas": "accusatif",
                "nombre": "pluriel",
                "genre": "féminin",
                "fonction": "Complément d'Objet Direct (COD)",
                "traduction": "les légions",
                "astuce": "Désinence -es au pluriel de la 3e déclinaison.",
            },
            {
                "texte": "in",
                "lemme": "in (préposition)",
                "radical": "in",
                "desinence": "",
                "cas": "invariable",
                "fonction": "Préposition suivie de l'accusatif (direction)",
                "traduction": "en / vers",
                "astuce": "In + accusatif exprime le mouvement vers l'intérieur.",
            },
            {
                "texte": "Galliam",
                "lemme": "Gallia, ae, f.",
                "radical": "Galli-",
                "desinence": "-am",
                "cas": "accusatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Complément circonstanciel de lieu (direction)",
                "traduction": "Gaule",
                "astuce": "Accusatif de destination introduit par 'in'.",
            },
            {
                "texte": "ducit",
                "lemme": "duco, ducere, duxi, ductum",
                "radical": "duc-",
                "desinence": "-it",
                "cas": "verbe",
                "temps": "présent de l'indicatif",
                "personne": "3e personne du singulier",
                "fonction": "Verbe transitif direct",
                "traduction": "conduit / mène",
                "astuce": "3e conjugaison en -ere (duco).",
            },
        ],
    },
    {
        "titre": "Lupus in silva sub arbore dormit (5e)",
        "latin": "Lupus in silva sub arbore dormit",
        "francais": "Le loup dort dans la forêt sous un arbre.",
        "sens_chunks": ["Le loup", "dort", "dans la forêt", "sous un arbre."],
        "mots": [
            {
                "texte": "Lupus",
                "lemme": "lupus, i, m.",
                "radical": "lup-",
                "desinence": "-us",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Sujet de 'dormit'",
                "traduction": "Le loup",
                "astuce": "Nominatif de la 2e déclinaison.",
            },
            {
                "texte": "in",
                "lemme": "in (préposition)",
                "radical": "in",
                "desinence": "",
                "cas": "invariable",
                "fonction": "Préposition suivie de l'ablatif (lieu où l'on est)",
                "traduction": "dans",
                "astuce": "In + ablatif exprime le lieu fixe sans mouvement.",
            },
            {
                "texte": "silva",
                "lemme": "silva, ae, f.",
                "radical": "silv-",
                "desinence": "-a",
                "cas": "ablatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Complément circonstanciel de lieu",
                "traduction": "la forêt",
                "astuce": "Ablatif singulier en -a long de la 1ère déclinaison.",
            },
            {
                "texte": "sub",
                "lemme": "sub (préposition)",
                "radical": "sub",
                "desinence": "",
                "cas": "invariable",
                "fonction": "Préposition + ablatif",
                "traduction": "sous",
                "astuce": "Indique la position inférieure.",
            },
            {
                "texte": "arbore",
                "lemme": "arbor, arboris, f.",
                "radical": "arbor-",
                "desinence": "-e",
                "cas": "ablatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Complément circonstanciel de lieu",
                "traduction": "un arbre",
                "astuce": "Désinence d'ablatif en -e de la 3e déclinaison.",
            },
            {
                "texte": "dormit",
                "lemme": "dormio, dormire, dormivi, dormitum",
                "radical": "dormi-",
                "desinence": "-t",
                "cas": "verbe",
                "temps": "présent de l'indicatif",
                "personne": "3e personne du singulier",
                "fonction": "Verbe intransitif",
                "traduction": "dort",
                "astuce": "4e conjugaison en -ire.",
            },
        ],
    },
    {
        "titre": "Discipulus bonus librum magistri legit (4e)",
        "latin": "Discipulus bonus librum magistri legit",
        "francais": "Le bon élève lit le livre du maître.",
        "sens_chunks": ["Le bon élève", "lit", "le livre", "du maître."],
        "mots": [
            {
                "texte": "Discipulus",
                "lemme": "discipulus, i, m.",
                "radical": "discipul-",
                "desinence": "-us",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Sujet de 'legit'",
                "traduction": "L'élève",
                "astuce": "Nominatif masculin singulier.",
            },
            {
                "texte": "bonus",
                "lemme": "bonus, bona, bonum",
                "radical": "bon-",
                "desinence": "-us",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Épithète du sujet",
                "traduction": "bon",
                "astuce": "Accordé au nominatif masculin avec 'discipulus'.",
            },
            {
                "texte": "librum",
                "lemme": "liber, libri, m.",
                "radical": "libr-",
                "desinence": "-um",
                "cas": "accusatif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Complément d'Objet Direct (COD)",
                "traduction": "le livre",
                "astuce": "Accusatif en -um de la 2e déclinaison.",
            },
            {
                "texte": "magistri",
                "lemme": "magister, magistri, m.",
                "radical": "magistr-",
                "desinence": "-i",
                "cas": "genitif",
                "nombre": "singulier",
                "genre": "masculin",
                "fonction": "Complément du nom 'librum'",
                "traduction": "du maître",
                "astuce": "Génitif singulier en -i indiquant l'appartenance.",
            },
            {
                "texte": "legit",
                "lemme": "lego, legere, legi, lectum",
                "radical": "leg-",
                "desinence": "-it",
                "cas": "verbe",
                "temps": "présent de l'indicatif",
                "personne": "3e personne du singulier",
                "fonction": "Verbe principal",
                "traduction": "lit",
                "astuce": "3e conjugaison.",
            },
        ],
    },
    {
        "titre": "Alea iacta est (Devise & Histoire)",
        "latin": "Alea iacta est",
        "francais": "Le dé est jeté (le sort en est jeté).",
        "sens_chunks": ["Le sort (le dé)", "en est jeté."],
        "mots": [
            {
                "texte": "Alea",
                "lemme": "alea, ae, f.",
                "radical": "ale-",
                "desinence": "-a",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Sujet du verbe passif",
                "traduction": "Le dé / le jeu de dés / le sort",
                "astuce": "Le mot désigne à la fois le dé romain et le hasard.",
            },
            {
                "texte": "iacta",
                "lemme": "iacio, iacere, ieci, iactum",
                "radical": "iact-",
                "desinence": "-a",
                "cas": "nominatif",
                "nombre": "singulier",
                "genre": "féminin",
                "fonction": "Participe parfait passif accordé avec 'alea'",
                "traduction": "jeté / lancé",
                "astuce": "Participe passé passif accordé au féminin singulier.",
            },
            {
                "texte": "est",
                "lemme": "sum, esse, fui",
                "radical": "es-",
                "desinence": "-t",
                "cas": "verbe",
                "temps": "présent de l'indicatif (auxiliaire)",
                "personne": "3e personne du singulier",
                "fonction": "Auxiliaire du parfait passif 'iacta est'",
                "traduction": "est",
                "astuce": "Participe + sum = forme passive passée.",
            },
        ],
    },
]


def analyser_phrase_auto(texte: str) -> dict:
    """Analyse heuristique automatique d'une phrase latine personnalisée."""
    mots_bruts = re.findall(r"[A-Za-zÀ-ÿ\-]+", texte)
    mots_analyses = []

    for m in mots_bruts:
        ml = m.lower()
        cas = "invariable"
        role = "Complément"
        astuce = "Mot analysé par décomposition morphologique."

        # Mots invariables fréquents, conjonctions et prépositions
        if ml in ("et", "sed", "non", "nam", "quia", "enim", "aut", "ubi", "cum", "nunc", "ita", "sic"):
            cas = "invariable"
            role = "Conjonction ou adverbe"
            astuce = "Mot invariable qui structure la phrase."
        elif ml in ("in", "ad", "per", "ante", "post", "prope", "trans", "inter", "contra"):
            cas = "invariable"
            role = "Préposition (+ Accusatif)"
            astuce = "Introduit un complément de lieu ou de temps."
        elif ml in ("ab", "a", "ex", "e", "cum", "de", "sub", "sine", "pro"):
            cas = "invariable"
            role = "Préposition (+ Ablatif)"
            astuce = "Introduit un complément circonstanciel."
        # Verbes fréquents ou désinences verbales
        elif ml in ("est", "sunt", "erat", "erant", "fuit", "erit", "esse", "habet", "habent", "videt", "vident", "audit", "facit"):
            cas = "verbe"
            role = "Verbe (Action / État)"
            astuce = "Verbe usuel de la langue latine."
        elif ml.endswith(("ant", "ent", "unt", "iunt", "erunt", "istis")):
            cas = "verbe"
            role = "Verbe (3e personne du pluriel)"
            astuce = "Terminaison verbale en -nt indiquant un sujet pluriel."
        elif len(ml) > 2 and ml.endswith(("at", "et", "it", "avit", "evit", "ivit")):
            cas = "verbe"
            role = "Verbe (3e personne du singulier)"
            astuce = "Terminaison verbale en -t indiquant un sujet singulier."
        # Accusatif
        elif ml.endswith(("am", "um", "em", "as", "os", "es")):
            cas = "accusatif"
            role = "Complément d'Objet Direct (COD)"
            astuce = "Terminaison caractéristique de l'accusatif (objet de l'action)."
        # Génitif
        elif ml.endswith(("ae", "i", "is", "orum", "arum", "uum")):
            cas = "genitif"
            role = "Complément du Nom (Génitif)"
            astuce = "Terminaison exprimant souvent la possession ou l'origine."
        # Datif
        elif ml.endswith(("o", "ibus")):
            cas = "datif"
            role = "Datif (Attribution / COI) ou Ablatif"
            astuce = "Terminaison d'attribution ou de circonstance."
        # Nominatif
        elif ml.endswith(("us", "a", "um", "or", "er", "is")):
            cas = "nominatif"
            role = "Sujet potentiel (Nominatif)"
            astuce = "Désinence fréquente pour le sujet de l'action."

        mots_analyses.append({
            "texte": m,
            "lemme": f"{m.lower()} (analyse auto)",
            "radical": m[:-2] if len(m) > 2 else m,
            "desinence": m[-2:] if len(m) > 2 else "",
            "cas": cas,
            "fonction": role,
            "traduction": m,
            "astuce": astuce,
        })

    return {
        "titre": texte[:30] + ("..." if len(texte) > 30 else ""),
        "latin": texte,
        "francais": "Traduction guidée de la phrase.",
        "sens_chunks": mots_bruts,
        "mots": mots_analyses,
    }


class DecrypteurVisuelWindow(tk.Toplevel):
    """Fenêtre moderne du Décrypteur Visuel de Phrases Latines."""

    def __init__(self, master, app, phrase_initiale: str = None):
        super().__init__(master)
        self.app = app
        self.title("🔬 Anatomia Sententiae — Décrypteur Visuel de Phrases")
        self.geometry("980x680")
        self.minsize(820, 560)

        self.C = getattr(app, "C", {
            "bg": "#fcfbf7",
            "panel": "#f4efe2",
            "editor": "#ffffff",
            "fg": "#1e293b",
            "muted": "#64748b",
            "accent": "#991b1b",
            "heading": "#7f1d1d",
            "ok": "#15803d",
            "code": "#854d0e",
        })
        self.sombre = est_sombre(getattr(app, "theme_name", "light"))
        self.configure(bg=self.C["bg"])

        # État interne
        self.phrase_courante = None
        self.mot_selectionne_idx = 0
        self.etape_puzzle = 1  # 1: Verbe, 2: Sujet, 3: Traduction finale
        self.capsules_widgets = []

        self._creer_interface()

        # Charger la phrase initiale ou la première du corpus
        if phrase_initiale:
            p_clean = re.sub(r"[^\w\s]", "", phrase_initiale).strip().lower()
            trouve = False
            for idx, p in enumerate(PHRASES_PREDEFINIES):
                p_latin_clean = re.sub(r"[^\w\s]", "", p["latin"]).strip().lower()
                if p_latin_clean == p_clean:
                    self._charger_phrase_index(idx)
                    trouve = True
                    break
            if not trouve:
                self._charger_phrase_personnalisee(phrase_initiale)
        else:
            self._charger_phrase_index(0)

    def _creer_interface(self):
        C = self.C

        # Liseré impérial supérieur
        tk.Frame(self, bg="#d4af37", height=4).pack(fill=tk.X, side=tk.TOP)

        # 1. En-tête : Titre + Sélecteur de phrase + Saisie personnalisée
        hdr = tk.Frame(self, bg=C["panel"], padx=16, pady=10)
        hdr.pack(fill=tk.X, side=tk.TOP)

        titre_box = tk.Frame(hdr, bg=C["panel"])
        titre_box.pack(side=tk.LEFT)
        tk.Label(
            titre_box,
            text="🔬 ANATOMIA SENTENTIAE",
            font=police_titre(14, gras=True),
            bg=C["panel"],
            fg=C["heading"],
        ).pack(anchor="w")
        tk.Label(
            titre_box,
            text="Radiographie syntaxique & Rubans de cas de la Rome Antique",
            font=police_corps(9, italique=True),
            bg=C["panel"],
            fg=C["muted"],
        ).pack(anchor="w")

        # Sélecteur de phrase préconçue
        ctrl_box = tk.Frame(hdr, bg=C["panel"])
        ctrl_box.pack(side=tk.RIGHT)

        tk.Label(ctrl_box, text="Choisir une phrase :", font=police_corps(9), bg=C["panel"], fg=C["fg"]).pack(side=tk.LEFT, padx=4)

        titres_phrases = [p["titre"] for p in PHRASES_PREDEFINIES]
        self.combo_var = tk.StringVar(value=titres_phrases[0])
        combo = ttk.Combobox(ctrl_box, textvariable=self.combo_var, values=titres_phrases, state="readonly", width=36)
        combo.pack(side=tk.LEFT, padx=4)
        combo.bind("<<ComboboxSelected>>", self._sur_selection_combo)

        # Bouton écouter la phrase
        btn_speak_all = tk.Button(
            ctrl_box,
            text="🔊 Écouter",
            font=police_corps(9, gras=True),
            bg=C["accent"],
            fg="#ffffff",
            relief="flat",
            cursor="hand2",
            padx=8,
            pady=3,
            command=self._prononcer_phrase_entiere,
        )
        btn_speak_all.pack(side=tk.LEFT, padx=6)

        # Barre d'analyse personnalisée
        saisie_bar = tk.Frame(self, bg=C["bg"], padx=16, pady=6)
        saisie_bar.pack(fill=tk.X, side=tk.TOP)

        tk.Label(saisie_bar, text="✍️ Ou analyse ta propre phrase :", font=police_corps(9, gras=True), bg=C["bg"], fg=C["fg"]).pack(side=tk.LEFT, padx=(0, 8))
        self.entry_phrase = ttk.Entry(saisie_bar, font=police_corps(10))
        self.entry_phrase.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=4)
        self.entry_phrase.bind("<Return>", lambda _e: self._analyser_saisie())

        btn_analyser = tk.Button(
            saisie_bar,
            text="Analyser ⚡",
            font=police_corps(9, gras=True),
            bg="#d4af37",
            fg="#1a1409",
            relief="flat",
            cursor="hand2",
            padx=10,
            pady=2,
            command=self._analyser_saisie,
        )
        btn_analyser.pack(side=tk.LEFT, padx=4)

        # 2. Légende des rubans de cas
        legende_bar = tk.Frame(self, bg=C["panel"], padx=12, pady=4)
        legende_bar.pack(fill=tk.X, side=tk.TOP, pady=(2, 6))

        tk.Label(legende_bar, text="Code Couleur :", font=police_corps(8, gras=True), bg=C["panel"], fg=C["muted"]).pack(side=tk.LEFT, padx=(0, 6))
        for info in CAS_INFO.values():
            badge_f = tk.Frame(legende_bar, bg=info["bg"], padx=5, pady=1)
            badge_f.pack(side=tk.LEFT, padx=3)
            tk.Label(
                badge_f,
                text=f"{info['icone']} {info['nom']}",
                font=police_corps(8, gras=True),
                bg=info["bg"],
                fg=info["fg"],
            ).pack()

        # 3. Zone Centrale : Phrase décomposée en Capsules / Rubans Visuels
        self.frame_capsules = tk.Frame(self, bg=C["bg"], padx=20, pady=14)
        self.frame_capsules.pack(fill=tk.X, side=tk.TOP)

        # 4. Zone Inférieure : Double Panneau (Inspecteur d'Anatomie & Puzzle de Traduction)
        panneau_bas = tk.Frame(self, bg=C["bg"], padx=16, pady=4)
        panneau_bas.pack(fill=tk.BOTH, expand=True, side=tk.TOP)

        # Panneau Gauche : Carte d'Anatomie Grammaticale
        self.card_inspecteur = tk.Frame(
            panneau_bas,
            bg=C["editor"],
            highlightbackground="#d4af37",
            highlightthickness=2,
            padx=16,
            pady=12,
        )
        self.card_inspecteur.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 8), pady=4)

        tk.Label(
            self.card_inspecteur,
            text="🔬 CARTE D'ANATOMIE DU MOT",
            font=police_titre(11, gras=True),
            bg=C["editor"],
            fg=C["heading"],
            anchor="w",
        ).pack(fill=tk.X, pady=(0, 8))

        self.lbl_mot_titre = tk.Label(self.card_inspecteur, text="", font=police_titre(16, gras=True), bg=C["editor"], fg=C["accent"], anchor="w")
        self.lbl_mot_titre.pack(fill=tk.X)

        self.lbl_cas_badge = tk.Label(self.card_inspecteur, text="", font=police_corps(9, gras=True), padx=8, pady=3, relief="flat", anchor="w")
        self.lbl_cas_badge.pack(anchor="w", pady=(4, 8))

        self.lbl_lemme = tk.Label(self.card_inspecteur, text="", font=police_corps(10), bg=C["editor"], fg=C["fg"], anchor="w")
        self.lbl_lemme.pack(fill=tk.X, pady=2)

        self.lbl_decomposition = tk.Label(self.card_inspecteur, text="", font=police_corps(10), bg=C["editor"], fg=C["fg"], anchor="w")
        self.lbl_decomposition.pack(fill=tk.X, pady=2)

        self.lbl_fonction = tk.Label(self.card_inspecteur, text="", font=police_corps(10, gras=True), bg=C["editor"], fg=C["fg"], anchor="w")
        self.lbl_fonction.pack(fill=tk.X, pady=2)

        self.lbl_traduction = tk.Label(self.card_inspecteur, text="", font=police_corps(11, italique=True), bg=C["editor"], fg="#d4af37" if self.sombre else "#92400e", anchor="w")
        self.lbl_traduction.pack(fill=tk.X, pady=4)

        self.lbl_astuce = tk.Label(self.card_inspecteur, text="", font=police_corps(9), bg=C["editor"], fg=C["muted"], wraplength=380, justify="left", anchor="w")
        self.lbl_astuce.pack(fill=tk.X, pady=(6, 0))

        # Panneau Droit : Atelier de Traduction Pas-à-Pas
        self.card_atelier = tk.Frame(
            panneau_bas,
            bg=C["editor"],
            highlightbackground=C.get("panel", "#e2e8f0"),
            highlightthickness=1,
            padx=16,
            pady=12,
        )
        self.card_atelier.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(8, 0), pady=4)

        tk.Label(
            self.card_atelier,
            text="🧩 PUZZLE DE TRADUCTION GUIDÉE",
            font=police_titre(11, gras=True),
            bg=C["editor"],
            fg=C["heading"],
            anchor="w",
        ).pack(fill=tk.X, pady=(0, 8))

        self.lbl_consigne_etape = tk.Label(
            self.card_atelier,
            text="",
            font=police_corps(10, gras=True),
            bg=C["editor"],
            fg=C["accent"],
            anchor="w",
            wraplength=380,
            justify="left",
        )
        self.lbl_consigne_etape.pack(fill=tk.X, pady=(0, 6))

        self.frame_puzzle_actions = tk.Frame(self.card_atelier, bg=C["editor"])
        self.frame_puzzle_actions.pack(fill=tk.X, pady=6)

        self.lbl_puzzle_feedback = tk.Label(
            self.card_atelier,
            text="",
            font=police_corps(10, gras=True),
            bg=C["editor"],
            fg=C["ok"],
            wraplength=380,
            justify="left",
        )
        self.lbl_puzzle_feedback.pack(fill=tk.X, pady=6)

        # Ligne de reconstitution française
        reconst_box = tk.Frame(self.card_atelier, bg=C["panel"], padx=10, pady=8)
        reconst_box.pack(fill=tk.X, side=tk.BOTTOM, pady=(8, 0))

        tk.Label(reconst_box, text="Traduction complète fluide :", font=police_corps(9, gras=True), bg=C["panel"], fg=C["muted"]).pack(anchor="w")
        self.lbl_trad_fluide = tk.Label(
            reconst_box,
            text="...",
            font=police_corps(11, gras=True),
            bg=C["panel"],
            fg=C["heading"],
            wraplength=360,
            justify="left",
        )
        self.lbl_trad_fluide.pack(fill=tk.X, pady=(2, 0))

    def _charger_phrase_index(self, index: int):
        if 0 <= index < len(PHRASES_PREDEFINIES):
            self.phrase_courante = PHRASES_PREDEFINIES[index]
            self.combo_var.set(self.phrase_courante["titre"])
            self._construire_capsules()
            self._reinitialiser_puzzle()

    def _sur_selection_combo(self, _event=None):
        titre = self.combo_var.get()
        for i, p in enumerate(PHRASES_PREDEFINIES):
            if p["titre"] == titre:
                self._charger_phrase_index(i)
                break

    def _analyser_saisie(self):
        texte = self.entry_phrase.get().strip()
        if not texte:
            return
        self._charger_phrase_personnalisee(texte)

    def _charger_phrase_personnalisee(self, texte: str):
        self.phrase_courante = analyser_phrase_auto(texte)
        self.combo_var.set("Phrase personnalisée")
        self._construire_capsules()
        self._reinitialiser_puzzle()

    def _construire_capsules(self):
        """Construit les capsules interactives avec rubans de cas."""
        for w in self.frame_capsules.winfo_children():
            w.destroy()
        self.capsules_widgets.clear()

        C = self.C
        mots = self.phrase_courante.get("mots", [])

        # Bandeau de la phrase entière
        phrase_cadre = tk.Frame(self.frame_capsules, bg=C["bg"])
        phrase_cadre.pack(fill=tk.X, pady=(0, 6))

        for idx, mot_info in enumerate(mots):
            cas = mot_info.get("cas", "invariable")
            info_c = CAS_INFO.get(cas, CAS_INFO["invariable"])

            # Boîtier du mot (capsule)
            capsule = tk.Frame(
                phrase_cadre,
                bg=C["editor"],
                highlightthickness=2,
                highlightbackground=info_c["bg"],
                padx=8,
                pady=6,
                cursor="hand2",
            )
            capsule.pack(side=tk.LEFT, padx=5, pady=4)

            # Mot latin principal
            lbl_mot = tk.Label(
                capsule,
                text=mot_info["texte"],
                font=police_corps(13, gras=True),
                bg=C["editor"],
                fg=C["fg"],
                cursor="hand2",
            )
            lbl_mot.pack()

            # Ruban de cas coloré en dessous
            ruban = tk.Frame(capsule, bg=info_c["bg"], padx=6, pady=2)
            ruban.pack(fill=tk.X, pady=(4, 0))

            lbl_ruban = tk.Label(
                ruban,
                text=f"{info_c['icone']} {info_c['nom'].upper()}",
                font=police_corps(7, gras=True),
                bg=info_c["bg"],
                fg=info_c["fg"],
                cursor="hand2",
            )
            lbl_ruban.pack()

            # Mini bouton de prononciation audio du mot individuel
            btn_son = tk.Label(
                capsule,
                text="🔊 Audio",
                font=police_corps(8, gras=True),
                bg=C["editor"],
                fg=C["muted"],
                cursor="hand2",
            )
            btn_son.pack(pady=(4, 0))

            def _clic_mot(_e=None, i=idx):
                self._selectionner_mot(i)

            def _clic_son(_e=None, texte_mot=mot_info["texte"]):
                audio.play_click()
                audio.speak_latin(texte_mot)

            capsule.bind("<Button-1>", _clic_mot)
            lbl_mot.bind("<Button-1>", _clic_mot)
            ruban.bind("<Button-1>", _clic_mot)
            lbl_ruban.bind("<Button-1>", _clic_mot)
            btn_son.bind("<Button-1>", _clic_son)

            self.capsules_widgets.append({
                "frame": capsule,
                "mot": lbl_mot,
                "ruban": ruban,
                "info": mot_info,
                "index": idx,
            })

        if mots:
            self._selectionner_mot(0)

    def _selectionner_mot(self, index: int):
        """Sélectionne un mot et affiche son anatomie complète."""
        self.mot_selectionne_idx = index
        mots = self.phrase_courante.get("mots", [])
        if not (0 <= index < len(mots)):
            return

        m = mots[index]
        cas = m.get("cas", "invariable")
        info_c = CAS_INFO.get(cas, CAS_INFO["invariable"])
        C = self.C

        # Mise en évidence visuelle de la capsule sélectionnée
        for i, cap in enumerate(self.capsules_widgets):
            if i == index:
                cap["frame"].configure(highlightthickness=3, highlightbackground="#d4af37", bg=eclaircir(C["editor"], 0.05) if self.sombre else "#fffdf0")
            else:
                cap_cas = cap["info"].get("cas", "invariable")
                cap_info = CAS_INFO.get(cap_cas, CAS_INFO["invariable"])
                cap["frame"].configure(highlightthickness=2, highlightbackground=cap_info["bg"], bg=C["editor"])

        # Mise à jour de la carte d'anatomie
        self.lbl_mot_titre.configure(text=f"{m['texte']}")
        self.lbl_cas_badge.configure(
            text=f"  {info_c['icone']}  {info_c['nom'].upper()} · {info_c['role']}  ",
            bg=info_c["bg"],
            fg=info_c["fg"],
        )
        self.lbl_lemme.configure(text=f"📖 Dictionnaire : {m.get('lemme', '—')}")

        rad = m.get("radical", "")
        des = m.get("desinence", "")
        decomp = f"🧩 Décomposition : {rad} + [ {des} ]" if (rad or des) else "🧩 Décomposition : mot invariable"
        self.lbl_decomposition.configure(text=decomp)

        self.lbl_fonction.configure(text=f"⚖️ Rôle syntaxique : {m.get('fonction', '—')}")
        self.lbl_traduction.configure(text=f"🇫🇷 Traduction : « {m.get('traduction', m['texte'])} »")
        self.lbl_astuce.configure(text=f"💡 Astuce mnémotechnique : {m.get('astuce', info_c['desc'])}")

        # Interaction avec l'atelier puzzle
        self._interagir_puzzle(index)

    def _reinitialiser_puzzle(self):
        """Initialise le puzzle guidé pas-à-pas."""
        self.etape_puzzle = 1
        self.lbl_puzzle_feedback.configure(text="")
        self.lbl_trad_fluide.configure(text=self.phrase_courante.get("francais", "—"))
        self._actualiser_consigne_puzzle()

    def _actualiser_consigne_puzzle(self):
        mots = self.phrase_courante.get("mots", [])
        verbes = [m["texte"] for m in mots if m.get("cas") == "verbe"]

        if self.etape_puzzle == 1:
            self.lbl_consigne_etape.configure(
                text="Étape 1 : Trouve le VERBE (le cœur de l'action) !\n"
                     "👉 Clique sur le mot qui indique l'action principale.",
                fg="#e65100",
            )
        elif self.etape_puzzle == 2:
            self.lbl_consigne_etape.configure(
                text=f"Étape 2 : Trouve le SUJET (qui fait l'action de '{verbes[0] if verbes else 'l action'}') !\n"
                     "👉 Clique sur le mot au NOMINATIF.",
                fg="#1e88e5",
            )
        elif self.etape_puzzle == 3:
            self.lbl_consigne_etape.configure(
                text="Étape 3 : Assemble les COMPLÉMENTS & lis la phrase complète !\n"
                     "👉 Examine les rôles colorés puis valide la traduction.",
                fg=self.C["ok"],
            )

        # Affichage des boutons d'action d'étape
        for w in self.frame_puzzle_actions.winfo_children():
            w.destroy()

        if self.etape_puzzle == 3:
            btn_valider = tk.Button(
                self.frame_puzzle_actions,
                text="🎉 Valider la traduction & Recevoir +5 Sesterces 🪙",
                font=police_corps(10, gras=True),
                bg="#d4af37",
                fg="#1a1409",
                relief="flat",
                cursor="hand2",
                padx=12,
                pady=6,
                command=self._recompenser_puzzle,
            )
            btn_valider.pack(fill=tk.X)

    def _interagir_puzzle(self, index: int):
        """Vérifie si le mot cliqué correspond à l'attente de l'étape de puzzle."""
        mots = self.phrase_courante.get("mots", [])
        if not (0 <= index < len(mots)):
            return

        m = mots[index]
        cas = m.get("cas")

        if self.etape_puzzle == 1:
            if cas == "verbe":
                audio.play_correct()
                self.lbl_puzzle_feedback.configure(
                    text=f"✔ Bravo ! '{m['texte']}' est bien le verbe ({m.get('fonction', 'action')}).",
                    fg=self.C["ok"],
                )
                self.etape_puzzle = 2
                self._actualiser_consigne_puzzle()
            else:
                self.lbl_puzzle_feedback.configure(
                    text=f"Ce mot ('{m['texte']}') n'est pas le verbe. Cherche l'action !",
                    fg=self.C["accent"],
                )
        elif self.etape_puzzle == 2:
            if cas == "nominatif":
                audio.play_correct()
                self.lbl_puzzle_feedback.configure(
                    text=f"✔ Excellent ! '{m['texte']}' est au Nominatif : c'est le sujet !",
                    fg=self.C["ok"],
                )
                self.etape_puzzle = 3
                self._actualiser_consigne_puzzle()
            else:
                self.lbl_puzzle_feedback.configure(
                    text=f"'{m['texte']}' n'est pas le sujet. Cherche la couleur bleue (Nominatif) !",
                    fg=self.C["accent"],
                )

    def _recompenser_puzzle(self):
        """Récompense l'élève à l'issue de la traduction complète."""
        audio.play_triumph_grand()
        if hasattr(self.app, "ajouter_sesterces"):
            self.app.ajouter_sesterces(5)
        if hasattr(self.app, "reagir_succes"):
            self.app.reagir_succes("Optime ! Phrase décryptée avec brio !")

        self.lbl_puzzle_feedback.configure(
            text="🏆 Triomphe ! Phrase entièrement analysée avec succès (+5 Sesterces 🪙) !",
            fg="#d4af37",
        )

    def _prononcer_phrase_entiere(self):
        """Prononce la phrase latine courante avec la prononciation restituée."""
        if not self.phrase_courante:
            return
        audio.play_click()
        latin = self.phrase_courante.get("latin", "")
        audio.speak_latin(latin)
