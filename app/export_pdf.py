"""
Module de génération de Fiches de Révision et Flashcards A4 / PDF pour Ludus Latinus.

Génère des fiches de cours haute fidélité au format A4 (HTML5 + CSS Print vectoriel),
avec encadrements romains dorés, table des 5 déclinaisons, vocabulaire essentiel,
mini-quiz d'auto-évaluation détachable et planches de flashcards à découper.

L'impression ou l'enregistrement en PDF s'effectue directement via le navigateur web
du système ou via la boîte de dialogue d'impression (Ctrl+P).
"""

import tempfile
import tkinter as tk
import webbrowser
from pathlib import Path
from tkinter import messagebox

from app.polices import police_corps, police_titre

# Table de référence des 5 déclinaisons latines
TABLE_DECLINAISONS = [
    {
        "titre": "1ère Déclinaison (Féminin en -a)",
        "modele": "Rosa, rosae (f.) — La rose",
        "singulier": ["rosa", "rosa", "rosam", "rosae", "rosae", "rosa"],
        "pluriel": ["rosae", "rosae", "rosas", "rosarum", "rosis", "rosis"],
    },
    {
        "titre": "2ème Déclinaison (Masculin en -us)",
        "modele": "Dominus, domini (m.) — Le maître",
        "singulier": ["dominus", "domine", "dominum", "domini", "domino", "domino"],
        "pluriel": ["domini", "domini", "dominos", "dominorum", "dominis", "dominis"],
    },
    {
        "titre": "2ème Déclinaison Neutre (en -um)",
        "modele": "Templum, templi (n.) — Le temple",
        "singulier": ["templum", "templum", "templum", "templi", "templo", "templo"],
        "pluriel": ["templa", "templa", "templa", "templorum", "templis", "templis"],
    },
    {
        "titre": "3ème Déclinaison (Parisyllabique / Imparisyllabique)",
        "modele": "Rex, regis (m.) — Le roi",
        "singulier": ["rex", "rex", "regem", "regis", "regi", "rege"],
        "pluriel": ["reges", "reges", "reges", "regum", "regibus", "regibus"],
    },
    {
        "titre": "4ème & 5ème Déclinaisons",
        "modele": "Manus, us (f.) — La main / Res, rei (f.) — La chose",
        "singulier": ["manus / res", "manus / res", "manum / rem", "manus / rei", "manui / rei", "manu / re"],
        "pluriel": ["manus / res", "manus / res", "manus / res", "manuum / rerum", "manibus / rebus", "manibus / rebus"],
    },
]

CAS_NOMS = ["Nominatif (Sujet / Attribut)", "Vocatif (Interpellation)", "Accusatif (COD)", "Génitif (Complément du Nom)", "Datif (COI / Attribution)", "Ablatif (Compléments Circonstanciels)"]

# Flashcards prêtes à l'impression recto-verso ou pliage
FLASHCARDS_DATA = [
    {
        "latin": "LUPUS, I, m.",
        "sens": "Le loup",
        "citation": "Homo homini lupus est.",
        "traduction": "L'homme est un loup pour l'homme.",
        "icon": "🐺",
    },
    {
        "latin": "ROSA, AE, f.",
        "sens": "La rose",
        "citation": "Rosa pulchra in horto est.",
        "traduction": "Une belle rose est dans le jardin.",
        "icon": "🌹",
    },
    {
        "latin": "GLADIUS, II, m.",
        "sens": "Le glaive, l'épée",
        "citation": "Gladius gladiatoris acer est.",
        "traduction": "Le glaive du gladiateur est affûté.",
        "icon": "⚔️",
    },
    {
        "latin": "AQUA, AE, f.",
        "sens": "L'eau",
        "citation": "Aqua vitae fons est.",
        "traduction": "L'eau est la source de la vie.",
        "icon": "💧",
    },
    {
        "latin": "TEMPLUM, I, n.",
        "sens": "Le temple, sanctuaire",
        "citation": "Templum deorum pulchrum est.",
        "traduction": "Le temple des dieux est magnifique.",
        "icon": "🏛️",
    },
    {
        "latin": "CANIS, IS, m./f.",
        "sens": "Le chien",
        "citation": "Cave canem !",
        "traduction": "Attention au chien !",
        "icon": "🐕",
    },
    {
        "latin": "IGNIS, IS, m.",
        "sens": "Le feu",
        "citation": "Ignis vestae semper ardet.",
        "traduction": "Le feu de Vesta brûle toujours.",
        "icon": "🔥",
    },
    {
        "latin": "CORONA, AE, f.",
        "sens": "La couronne de lauriers",
        "citation": "Victoria coronam meret.",
        "traduction": "La victoire mérite la couronne.",
        "icon": "👑",
    },
]


def generer_css_print() -> str:
    """Feuille de style CSS optimisée pour impression A4 vectorielle et affichage écran."""
    return """
    @import url('https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;900&family=Lora:ital,wght@0,400;0,600;1,400&display=swap');

    @page {
        size: A4 portrait;
        margin: 10mm;
    }

    * {
        box-sizing: border-box;
        -webkit-print-color-adjust: exact !important;
        print-color-adjust: exact !important;
    }

    body {
        font-family: 'Lora', 'Georgia', serif;
        background-color: #faf8f5;
        color: #1f1f2e;
        margin: 0;
        padding: 0;
        font-size: 11pt;
        line-height: 1.35;
    }

    .page-a4 {
        width: 190mm;
        min-height: 277mm;
        margin: 0 auto;
        background: #ffffff;
        padding: 12mm;
        border: 4px double #b8860b;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
        position: relative;
    }

    .header-romain {
        text-align: center;
        border-bottom: 2px solid #b8860b;
        padding-bottom: 8px;
        margin-bottom: 12px;
    }

    .header-spqr {
        font-family: 'Cinzel', serif;
        font-size: 14pt;
        letter-spacing: 4px;
        color: #8b0000;
        font-weight: 900;
        margin: 0 0 4px 0;
    }

    .titre-fiche {
        font-family: 'Cinzel', serif;
        font-size: 18pt;
        color: #1a1a2e;
        margin: 0 0 4px 0;
    }

    .meta-eleve {
        display: flex;
        justify-content: space-between;
        font-size: 9.5pt;
        font-style: italic;
        color: #555;
        margin-top: 6px;
    }

    .section-titre {
        font-family: 'Cinzel', serif;
        font-size: 12pt;
        color: #8b0000;
        border-bottom: 1px solid #d4af37;
        margin: 10px 0 6px 0;
        padding-bottom: 2px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    table.declinaison-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 8px;
        font-size: 9pt;
    }

    table.declinaison-table th, table.declinaison-table td {
        border: 1px solid #c9b037;
        padding: 4px 6px;
        text-align: left;
    }

    table.declinaison-table th {
        background-color: #f6ebd2;
        color: #4a2c00;
        font-family: 'Cinzel', serif;
        font-weight: bold;
    }

    table.declinaison-table tr:nth-child(even) {
        background-color: #fbf9f4;
    }

    .terminaison {
        color: #b22222;
        font-weight: bold;
    }

    .quiz-cadre {
        border: 2px dashed #b8860b;
        background: #fffdf7;
        padding: 10px;
        margin-top: 10px;
        border-radius: 4px;
    }

    .quiz-ligne {
        display: flex;
        justify-content: space-between;
        margin-bottom: 5px;
        font-size: 9.5pt;
    }

    .checkbox-carre {
        display: inline-block;
        width: 12px;
        height: 12px;
        border: 1px solid #333;
        margin-right: 6px;
        vertical-align: middle;
    }

    /* Grille de Flashcards découpables */
    .grille-flashcards {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 8mm;
        margin-top: 6mm;
    }

    .carte-decoupe {
        border: 1.5px dashed #b8860b;
        padding: 12px;
        background: #fffbf2;
        border-radius: 6px;
        height: 54mm;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        position: relative;
    }

    .carte-decoupe::before {
        content: "✂ Plier ou Découper";
        position: absolute;
        top: -9px;
        right: 10px;
        background: #ffffff;
        padding: 0 4px;
        font-size: 7.5pt;
        color: #888;
    }

    .carte-latin {
        font-family: 'Cinzel', serif;
        font-size: 13pt;
        font-weight: 700;
        color: #8b0000;
        text-align: center;
    }

    .carte-sens {
        font-size: 11pt;
        font-weight: 600;
        color: #1a1a2e;
        text-align: center;
    }

    .carte-citation {
        font-size: 8.5pt;
        font-style: italic;
        color: #555;
        border-top: 1px solid #e0cfab;
        padding-top: 4px;
        text-align: center;
    }

    .no-print-bar {
        background: #1a1b26;
        color: #fff;
        padding: 12px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
    }

    .btn-imprimer {
        background: #d4af37;
        color: #1a1b26;
        border: none;
        padding: 8px 18px;
        font-family: 'Cinzel', serif;
        font-size: 11pt;
        font-weight: bold;
        border-radius: 4px;
        cursor: pointer;
        transition: background 0.2s;
    }

    .btn-imprimer:hover {
        background: #ffd700;
    }

    @media print {
        .no-print-bar {
            display: none !important;
        }
        body {
            background: #ffffff !important;
        }
        .page-a4 {
            box-shadow: none !important;
            margin: 0 !important;
            width: 100% !important;
            padding: 0 !important;
            border: 3px double #b8860b !important;
        }
    }
    """


def generer_html_fiche_synthese() -> str:
    """Génère le document HTML de la Fiche de Synthèse Grammaticale & Déclinaisons."""
    css = generer_css_print()

    lignes_tables = ""
    for dec in TABLE_DECLINAISONS[:3]:  # Les 3 déclinaisons fondamentales du collège
        lignes_tables += f"""
        <div style="margin-bottom: 10px;">
            <div style="font-weight: bold; font-size: 10pt; color: #4a2c00; margin-bottom: 3px;">
                🏛️ {dec['titre']} — <em>{dec['modele']}</em>
            </div>
            <table class="declinaison-table">
                <tr>
                    <th style="width: 32%;">Cas / Fonction</th>
                    <th style="width: 34%;">Singulier</th>
                    <th style="width: 34%;">Pluriel</th>
                </tr>
        """
        for c_idx, cas in enumerate(CAS_NOMS):
            sing = dec['singulier'][c_idx]
            plur = dec['pluriel'][c_idx]
            lignes_tables += f"""
                <tr>
                    <td><strong>{cas}</strong></td>
                    <td>{sing}</td>
                    <td>{plur}</td>
                </tr>
            """
        lignes_tables += "</table></div>"

    html = f"""<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ludus Latinus — Fiche de Révision Grammaticale A4</title>
    <style>{css}</style>
</head>
<body>
    <div class="no-print-bar">
        <div>
            <strong>📜 Ludus Latinus — Fiche de Révision A4</strong>
            <span style="font-size: 9pt; color: #aaa; margin-left: 10px;">Prête pour impression ou sauvegarde PDF</span>
        </div>
        <div>
            <button class="btn-imprimer" onclick="window.print()">🖨️ Imprimer en A4 / PDF (Ctrl+P)</button>
        </div>
    </div>

    <div class="page-a4">
        <div class="header-romain">
            <div class="header-spqr">SENATVS POPVLVSQVE ROMANVS • LVDVS LATINVS</div>
            <div class="titre-fiche">FICHE DE SYNTHÈSE : DÉCLINAISONS & CAS</div>
            <div class="meta-eleve">
                <span>Discipulus : ___________________________</span>
                <span>Classis : 5ème / 4ème / 3ème</span>
                <span>Dies : ____ / ____ / 202__</span>
            </div>
        </div>

        <div class="section-titre">🏛️ I. Les 6 Cas Latins et leurs Fonctions</div>
        <div style="font-size: 9pt; margin-bottom: 8px; line-height: 1.3;">
            • <strong>Nominatif :</strong> Sujet et Attribut du Sujet (ex: <em>Rosa pulchra est</em>).<br>
            • <strong>Vocatif :</strong> Apostrophe ou interpellation (ex: <em>O domine !</em>).<br>
            • <strong>Accusatif :</strong> Complément d'Objet Direct (COD) et mouvement vers un lieu (ex: <em>Dominum video</em>).<br>
            • <strong>Génitif :</strong> Complément du Nom / Possession (ex: <em>Hortus domini</em>).<br>
            • <strong>Datif :</strong> Complément d'Objet Indirect (COI) / Attribution (ex: <em>Donum do amico</em>).<br>
            • <strong>Ablatif :</strong> Compléments Circonstanciels (moyen, lieu, manière) (ex: <em>Gladiō pugnat</em>).
        </div>

        <div class="section-titre">📜 II. Tableaux des Déclinaisons Fondamentales</div>
        {lignes_tables}

        <div class="section-titre">✂️ III. Mini-Quiz d'Auto-Évaluation (à détacher)</div>
        <div class="quiz-cadre">
            <div style="font-size: 8.5pt; font-weight: bold; margin-bottom: 6px; color: #8b0000;">
                Coche la bonne réponse sans regarder la fiche :
            </div>
            <div class="quiz-ligne">
                <span>1. À quel cas latin correspond le Complément d'Objet Direct (COD) ?</span>
                <span><span class="checkbox-carre"></span>Nominatif &nbsp; <span class="checkbox-carre"></span>Accusatif &nbsp; <span class="checkbox-carre"></span>Datif</span>
            </div>
            <div class="quiz-ligne">
                <span>2. Quelle est la terminaison du Génitif Singulier de la 1ère déclinaison ?</span>
                <span><span class="checkbox-carre"></span>-am &nbsp; <span class="checkbox-carre"></span>-ae &nbsp; <span class="checkbox-carre"></span>-is</span>
            </div>
            <div class="quiz-ligne">
                <span>3. Que signifie le mot latin « Dominus » ?</span>
                <span><span class="checkbox-carre"></span>Le maître &nbsp; <span class="checkbox-carre"></span>La maison &nbsp; <span class="checkbox-carre"></span>Le temple</span>
            </div>
            <div class="quiz-ligne">
                <span>4. Quel cas latin exprime le Sujet de la phrase ?</span>
                <span><span class="checkbox-carre"></span>L'Ablatif &nbsp; <span class="checkbox-carre"></span>Le Vocatif &nbsp; <span class="checkbox-carre"></span>Le Nominatif</span>
            </div>
            <div style="margin-top: 6px; text-align: right; font-size: 8.5pt; font-weight: bold; color: #555;">
                Score obtenu : ______ / 4 ⭐
            </div>
        </div>
    </div>
</body>
</html>
"""
    return html


def generer_html_flashcards() -> str:
    """Génère le document HTML d'une planche de 8 Flashcards A4 prêtes à découper."""
    css = generer_css_print()

    cartes_html = ""
    for c in FLASHCARDS_DATA:
        cartes_html += f"""
        <div class="carte-decoupe">
            <div style="text-align: right; font-size: 14pt;">{c['icon']}</div>
            <div class="carte-latin">{c['latin']}</div>
            <div class="carte-sens">{c['sens']}</div>
            <div class="carte-citation">
                « {c['citation']} »<br>
                <span style="color: #777;">{c['traduction']}</span>
            </div>
        </div>
        """

    html = f"""<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ludus Latinus — Planche de 8 Flashcards A4 à Découper</title>
    <style>{css}</style>
</head>
<body>
    <div class="no-print-bar">
        <div>
            <strong>🃏 Ludus Latinus — Planche de 8 Flashcards à Découper (A4)</strong>
            <span style="font-size: 9pt; color: #aaa; margin-left: 10px;">Planche détachable / pliable</span>
        </div>
        <div>
            <button class="btn-imprimer" onclick="window.print()">🖨️ Imprimer en A4 / PDF (Ctrl+P)</button>
        </div>
    </div>

    <div class="page-a4">
        <div class="header-romain">
            <div class="header-spqr">SENATVS POPVLVSQVE ROMANVS • LVDVS LATINVS</div>
            <div class="titre-fiche">PLANCHE DE FLASHCARDS DU COLISÉE</div>
            <div class="meta-eleve">
                <span>Vocabulaire fondamental & citations</span>
                <span>Découpez selon les pointillés pour réviser partout !</span>
            </div>
        </div>

        <div class="grille-flashcards">
            {cartes_html}
        </div>

        <div style="margin-top: 8mm; text-align: center; font-size: 8pt; color: #888; border-top: 1px dashed #ccc; padding-top: 4px;">
            Ludus Latinus — Fiches pédagogiques conformes aux programmes scolaires de collège.
        </div>
    </div>
</body>
</html>
"""
    return html


def generer_fichier_html(type_fiche: str = "synthese", sortie_path: Path = None) -> Path:
    """Génère le fichier HTML sur disque et retourne son chemin absolu."""
    if type_fiche == "flashcards":
        contenu = generer_html_flashcards()
        nom_defaut = "ludus_latinus_flashcards_a4.html"
    else:
        contenu = generer_html_fiche_synthese()
        nom_defaut = "ludus_latinus_fiche_synthese_a4.html"

    if sortie_path is None:
        dossier_temp = Path(tempfile.gettempdir())
        sortie_path = dossier_temp / nom_defaut

    sortie_path.write_text(contenu, encoding="utf-8")
    return sortie_path


def ouvrir_fiche_navigateur(type_fiche: str = "synthese") -> Path:
    """Génère la fiche et l'ouvre dans le navigateur web par défaut pour impression / PDF."""
    path = generer_fichier_html(type_fiche)
    webbrowser.open(path.as_uri())
    return path


class FichesExportDialog(tk.Toplevel):
    """Boîte de dialogue permettant de choisir et imprimer les fiches A4 / PDF."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C

        self.title("📄 Fiches & Flashcards A4 / PDF — Ludus Latinus")
        from app.responsive import adapter_geometrie_fenetre
        adapter_geometrie_fenetre(self, 620, 460, min_w=520, min_h=380)
        self.configure(bg="#15161e")

        self._build_ui()
        self.transient(master)
        self.focus_set()

    def _build_ui(self):
        # En-tête
        hdr = tk.Frame(self, bg="#1a1b26", padx=16, pady=12)
        hdr.pack(fill=tk.X)

        tk.Label(hdr, text="📄 IMPRESSION DE FICHES & FLASHCARDS A4",
                 font=police_titre(14), bg="#1a1b26", fg="#ffd700").pack()
        tk.Label(hdr, text="Documents haute définition vectoriels prêts à imprimer ou enregistrer en PDF",
                 font=police_corps(9, italique=True), bg="#1a1b26", fg="#dcd6cd").pack()

        # Corps central
        corps = tk.Frame(self, bg="#15161e", padx=24, pady=16)
        corps.pack(fill=tk.BOTH, expand=True)

        # Option 1 : Fiche de Synthèse Déclinaisons
        cadre1 = tk.Frame(corps, bg="#24283b", bd=2, relief="groove", padx=14, pady=10)
        cadre1.pack(fill=tk.X, pady=8)

        lbl1 = tk.Label(cadre1, text="📜 Fiche de Synthèse Grammaticale (A4)",
                        font=police_titre(12), bg="#24283b", fg="#ffffff")
        lbl1.pack(anchor="w")

        desc1 = tk.Label(cadre1,
                         text="Les 6 cas latins, les tableaux complets des 1ère, 2ème et 3ème déclinaisons,\net un mini-quiz d'auto-évaluation détachable.",
                         font=police_corps(9), bg="#24283b", fg="#a9b1d6", justify="left")
        desc1.pack(anchor="w", pady=(2, 6))

        btn1 = tk.Button(cadre1, text="🖨️ Ouvrir / Imprimer la Fiche Grammaire",
                         font=police_corps(10, gras=True), bg="#d4af37", fg="#1a1b26",
                         activebackground="#ffd700", relief="flat", padx=12, pady=6,
                         command=lambda: self._lancer_export("synthese"))
        btn1.pack(anchor="e")

        # Option 2 : Planche de 8 Flashcards découpables
        cadre2 = tk.Frame(corps, bg="#24283b", bd=2, relief="groove", padx=14, pady=10)
        cadre2.pack(fill=tk.X, pady=8)

        lbl2 = tk.Label(cadre2, text="🃏 Planche de 8 Flashcards à Découper (A4)",
                        font=police_titre(12), bg="#24283b", fg="#ffffff")
        lbl2.pack(anchor="w")

        desc2 = tk.Label(cadre2,
                         text="8 cartes illustrées avec mot latin, traduction, déclinaison et citation célèbre,\navec pointillés de découpe et de pliage pour réviser partout.",
                         font=police_corps(9), bg="#24283b", fg="#a9b1d6", justify="left")
        desc2.pack(anchor="w", pady=(2, 6))

        btn2 = tk.Button(cadre2, text="🖨️ Ouvrir / Imprimer les Flashcards",
                         font=police_corps(10, gras=True), bg="#2ecc71", fg="#1a1b26",
                         activebackground="#27ae60", relief="flat", padx=12, pady=6,
                         command=lambda: self._lancer_export("flashcards"))
        btn2.pack(anchor="e")

        # Astuce impression
        astuce = tk.Label(corps,
                          text="💡 Astuce : Dans le navigateur, choisissez « Enregistrer au format PDF » ou votre imprimante, puis cochez « Graphiques d'arrière-plan » pour imprimer les dorures.",
                          font=police_corps(8, italique=True), bg="#15161e", fg="#ffd700", wraplength=540)
        astuce.pack(pady=10)

    def _lancer_export(self, type_fiche):
        try:
            path = ouvrir_fiche_navigateur(type_fiche)
            messagebox.showinfo(
                "Document Prêt !",
                f"La fiche a été ouverte dans votre navigateur web :\n{path.name}\n\n"
                f"Appuyez sur Ctrl + P dans le navigateur pour imprimer ou générer le PDF !"
            )
        except Exception as e:
            messagebox.showerror("Erreur d'impression", f"Impossible d'ouvrir le navigateur : {e}")
