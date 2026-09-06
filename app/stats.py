"""
Logique « motivation » (sans dépendance à l'interface, donc testable) :
séries de jours (streak), répétition espacée (SRS) et certificat HTML.
"""

import datetime

# Intervalles de révision (en jours), de plus en plus espacés.
INTERVALLES = [1, 3, 7, 16, 35, 90]

# Points d'expérience.
XP_PAR_ITEM = 10      # chaque exercice/quiz réussi
XP_PAR_BADGE = 50     # chaque parcours terminé
XP_PAR_NIVEAU = 100   # paliers réguliers


RANGS_ROMAINS = [
    (1, "Tiro", "🟢", "Jeune recrue — Premiers pas à Rome"),
    (3, "Discipulus", "📜", "Élève appliqué — Tu maîtrises les mots"),
    (6, "Explorator", "🧭", "Explorateur — Les mythes n'ont plus de secret"),
    (10, "Legionarius", "🛡️", "Légionnaire — Tu déchiffres les cas"),
    (15, "Centurio", "⚔️", "Centurion — Triomphe dans l'Arène"),
    (20, "Senator", "🏛️", "Sénateur — Sage de la Cité de Rome"),
    (25, "Triumphator", "👑", "Grand Triomphateur — Maître absolu du Latin"),
]


def rang_romain(niv):
    """Détermine le rang romain selon le niveau actuel."""
    actuel = RANGS_ROMAINS[0]
    for palier, titre, icone, desc in RANGS_ROMAINS:
        if niv >= palier:
            actuel = (palier, titre, icone, desc)
    return {"titre": actuel[1], "icone": actuel[2], "desc": actuel[3]}


def xp_total(completed, badges):
    """Expérience accumulée : items réussis + bonus de badges."""
    return XP_PAR_ITEM * len(completed) + XP_PAR_BADGE * len(badges)


def niveau(xp):
    """Traduit l'XP en (niveau, progression dans le niveau, palier et rang romain).

    Niveau 1 dès 0 XP ; chaque niveau demande XP_PAR_NIVEAU points.
    """
    niv = xp // XP_PAR_NIVEAU + 1
    dans = xp % XP_PAR_NIVEAU
    rang = rang_romain(niv)
    return {
        "niveau": niv,
        "dans_niveau": dans,
        "pour_suivant": XP_PAR_NIVEAU,
        "xp": xp,
        "rang_titre": rang["titre"],
        "rang_icone": rang["icone"],
        "rang_desc": rang["desc"],
    }



def cette_semaine(historique, today):
    """Nombre d'activités depuis lundi de la semaine en cours (inclus)."""
    lundi = today - datetime.timedelta(days=today.weekday())
    total = 0
    for d, c in historique.items():
        try:
            jour = datetime.date.fromisoformat(d)
        except ValueError:
            continue
        if lundi <= jour <= today:
            total += c
    return total


def prochaine_action(ordre_ids, completed, ids_dus):
    """Recommande quoi faire ensuite.

    - s'il y a des révisions dues  -> ("revision", id)
    - sinon la première leçon non faite -> ("nouvelle", id)
    - sinon tout est terminé -> ("termine", None)
    `ordre_ids` est la liste de tous les item_ids dans l'ordre du curriculum.
    """
    faits = set(completed)
    dus_a_faire = [i for i in ids_dus if i in set(ordre_ids)]
    if dus_a_faire:
        return ("revision", dus_a_faire[0])
    for item_id in ordre_ids:
        if item_id not in faits:
            return ("nouvelle", item_id)
    return ("termine", None)



# ------------------------------------------------------- notions difficiles
# En dessous de deux échecs sur un même exercice, on ne parle pas encore de
# difficulté : se tromper une fois fait partie de l'apprentissage.
SEUIL_DIFFICILE = 2


def notions_difficiles(echecs, ordre_ids, limite=3, seuil=SEUIL_DIFFICILE):
    """Les exercices les plus souvent ratés, du plus difficile au moins.

    L'application comptait déjà les échecs sans jamais s'en servir. C'est
    pourtant la meilleure indication de ce qu'il faut retravailler : bien
    plus fiable qu'un ordre de parcours, qui suppose que tout le monde
    bute aux mêmes endroits.

    `ordre_ids` sert à écarter les exercices qui n'existent plus, le
    curriculum pouvant changer d'une version à l'autre. Le tri est
    déterministe (nombre d'échecs, puis identifiant) pour que deux
    affichages successifs ne changent pas d'ordre sans raison.
    """
    connus = set(ordre_ids)
    candidats = [(item, nombre) for item, nombre in echecs.items()
                 if nombre >= seuil and item in connus]
    candidats.sort(key=lambda couple: (-couple[1], couple[0]))
    return candidats[:limite]


def resume_accueil(data, ordre_ids, today, total=None):
    """Tout ce qu'affiche l'écran d'accueil, calculé en un seul endroit.

    L'interface n'a plus qu'à mettre en forme : la logique reste ici, donc
    testable sans écran.
    """
    completed = data.get("completed", [])
    historique = data.get("historique", {})
    connus = set(ordre_ids)
    ids_dus = dus(data.get("srs", {}), today, completed)

    return {
        "serie": streak(historique, today),
        "meilleure_serie": meilleur_streak(historique),
        "niveau": niveau(xp_total(completed, data.get("badges", []))),
        "faits": len([item for item in completed if item in connus]),
        "total": len(ordre_ids) if total is None else total,
        "aujourdhui": historique.get(today.isoformat(), 0),
        "objectif": data.get("objectif_quotidien", 3),
        "revisions": len(ids_dus),
        "prochaine": prochaine_action(ordre_ids, completed, ids_dus),
        "difficiles": notions_difficiles(data.get("echecs", {}), ordre_ids),
    }


# --------------------------------------------------------------- séries (streak)
def streak(historique, today):
    """Nombre de jours consécutifs d'activité se terminant aujourd'hui (ou hier)."""
    jour = today
    if historique.get(jour.isoformat(), 0) == 0:
        jour = jour - datetime.timedelta(days=1)
    s = 0
    while historique.get(jour.isoformat(), 0) > 0:
        s += 1
        jour -= datetime.timedelta(days=1)
    return s


def meilleur_streak(historique):
    jours = sorted(datetime.date.fromisoformat(d)
                   for d, c in historique.items() if c > 0)
    if not jours:
        return 0
    best = cur = 1
    for i in range(1, len(jours)):
        if (jours[i] - jours[i - 1]).days == 1:
            cur += 1
            best = max(best, cur)
        else:
            cur = 1
    return best


def sept_jours(historique, today, n=7):
    """Liste (label JJ/MM, nombre) pour les n derniers jours (ancien→récent)."""
    out = []
    for k in range(n - 1, -1, -1):
        d = today - datetime.timedelta(days=k)
        out.append((d.strftime("%d/%m"), historique.get(d.isoformat(), 0)))
    return out


# ------------------------------------------------------- répétition espacée (SRS)
def prochain_intervalle(courant):
    for v in INTERVALLES:
        if v > courant:
            return v
    return INTERVALLES[-1]


def planifier(srs, item_id, today, reussi=True):
    """Programme la prochaine révision d'un item (avance si réussi, sinon repart à 1)."""
    courant = srs.get(item_id, {}).get("interval", 0)
    inter = prochain_intervalle(courant) if reussi else 1
    srs[item_id] = {
        "interval": inter,
        "due": (today + datetime.timedelta(days=inter)).isoformat(),
    }
    return srs[item_id]


def dus(srs, today, completed):
    """Items dont la révision est due (et qui sont bien terminés)."""
    iso = today.isoformat()
    return [iid for iid, e in srs.items()
            if iid in completed and e.get("due", "") <= iso]


# ----------------------------------------------------------------- certificat
def certificat_html(nom, parcours, date_str, auteur=None, lang="fr"):
    """Renvoie le HTML d'un certificat imprimable (autonome, sans dépendance)."""
    signature = f" — par {auteur}" if auteur else ""
    titre_h1 = "Certificate of Completion" if lang == "en" else "Certificat de réussite"
    phrase = "has successfully completed the track" if lang == "en" else "a terminé avec succès le parcours"
    page_title = f"Certificate — {parcours}" if lang == "en" else f"Certificat — {parcours}"
    return f"""<!DOCTYPE html>
<html lang="{lang}"><head><meta charset="utf-8">
<title>{page_title}</title>
<style>
  body {{ font-family: Georgia, 'Times New Roman', serif; background:#f0f2f5;
         display:flex; justify-content:center; padding:40px; }}
  .cert {{ background:#fff; width:760px; padding:60px; text-align:center;
          border:12px solid #4d8bf0; border-radius:8px;
          box-shadow:0 8px 30px rgba(0,0,0,.15); }}
  .cert h1 {{ font-size:40px; color:#27406b; margin:0 0 6px; letter-spacing:2px; }}
  .sub {{ color:#7a8190; text-transform:uppercase; letter-spacing:4px; font-size:13px; }}
  .nom {{ font-size:34px; color:#1c1d22; margin:34px 0 6px; }}
  .ligne {{ width:300px; border-bottom:1px solid #cdd2db; margin:0 auto 20px; }}
  .parcours {{ font-size:22px; color:#4d8bf0; margin:10px 0 30px; }}
  .pied {{ display:flex; justify-content:space-between; margin-top:40px;
           color:#7a8190; font-size:14px; }}
  .badge {{ font-size:54px; }}
</style></head>
<body><div class="cert">
  <div class="badge">🏛️</div>
  <h1>{titre_h1}</h1>
  <div class="sub">Ludus Latinus</div>
  <div class="nom">{nom}</div>
  <div class="ligne"></div>
  <p>{phrase}</p>
  <div class="parcours">{parcours}</div>
  <div class="pied"><span>Ludus Latinus 🏛️{signature}</span><span>{date_str}</span></div>
</div>
<script>window.onload = () => {{ /* imprimable via Ctrl+P */ }};</script>
</body></html>"""


def cheatsheet_html(titre, sections, auteur=None, lang="fr"):
    """Antisèche imprimable (HTML autonome) à partir de sections.

    `sections` = liste de (titre_section, [(code, explication), ...]).
    """
    import html as _html

    pied = f" — par {auteur}" if auteur else ""
    sub_title = "Ludus Latinus — printable cheat sheet (Ctrl+P)" if lang == "en" else "Ludus Latinus — mémo imprimable (Ctrl+P)"
    footer_text = f"Ludus Latinus 🏛️ — essential Latin{_html.escape(pied)}" if lang == "en" else f"Ludus Latinus 🏛️ — l'essentiel du latin{_html.escape(pied)}"
    blocs = []
    for nom_section, lignes in sections:
        items = "\n".join(
            f'      <tr><td class="code">{_html.escape(code)}</td>'
            f'<td class="desc">{_html.escape(desc)}</td></tr>'
            for code, desc in lignes
        )
        blocs.append(
            f'  <section><h2>{_html.escape(nom_section)}</h2>'
            f'<table>\n{items}\n  </table></section>'
        )
    corps = "\n".join(blocs)

    return f"""<!DOCTYPE html>
<html lang="{lang}"><head><meta charset="utf-8">
<title>{_html.escape(titre)} — Ludus Latinus</title>
<style>
  body {{ font-family:-apple-system, Segoe UI, Roboto, Helvetica, sans-serif;
          max-width:960px; margin:24px auto; padding:0 20px; color:#202124; }}
  h1 {{ font-size:26px; margin:0 0 4px; color:#1a73e8; }}
  .sub {{ color:#5f6368; font-size:13px; margin-bottom:20px; }}
  .grille {{ display:grid; grid-template-columns:repeat(auto-fit, minmax(280px, 1fr));
             gap:16px; }}
  .sec {{ border:1px solid #dadce0; border-radius:8px; padding:12px 14px;
          background:#fafafa; break-inside:avoid; }}
  h2 {{ font-size:15px; margin:0 0 8px; color:#202124;
        border-bottom:2px solid #1a73e8; padding-bottom:4px; }}
  table {{ width:100%; border-collapse:collapse; font-size:12px; }}
  td {{ padding:4px 6px; vertical-align:top; }}
  td.code {{ font-family:Consolas, Monaco, monospace; color:#d93025;
             white-space:nowrap; font-weight:600; width:45%; }}
  td.desc {{ color:#3c4043; }}
  tr:nth-child(even) {{ background:#f1f3f4; }}
  .pied {{ margin-top:30px; font-size:11px; color:#70757a; text-align:center; }}
  @media print {{
    body {{ max-width:100%; margin:0; padding:10mm; }}
    .sec {{ border:1px solid #ccc; }}
    .pied {{ position:fixed; bottom:5mm; left:0; right:0; }}
  }}
</style></head>
<body>
  <h1>{_html.escape(titre)}</h1>
  <div class="sub">{sub_title}</div>
  <div class="grille">
{corps}
  </div>
  <div class="pied">{footer_text}</div>
</body></html>"""


def badge_svg(streak=0, termines=0, total=34, lang="fr"):
    """Génère un badge SVG vectoriel propre et moderne représentant le niveau et les stats."""
    pourcent = round((termines / total) * 100) if total else 0
    titre_label = "Ludus Latinus" if lang == "en" else "Profil Ludus Latinus"
    streak_label = f"🔥 {streak} days" if lang == "en" else f"🔥 {streak} jours"
    prog_label = f"✓ {termines}/{total} ({pourcent}%)"
    niveau_label = "Senator" if pourcent >= 75 else ("Centurio" if pourcent >= 35 else "Tiro")
    if lang != "en":
        niveau_label = "Sénateur" if pourcent >= 75 else ("Centurion" if pourcent >= 35 else "Tiro (Recrue)")
    bar_width = max(12, int(3.12 * pourcent)) if pourcent > 0 else 0

    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="360" height="140" viewBox="0 0 360 140" fill="none">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#1e1f26"/>
      <stop offset="100%" stop-color="#272935"/>
    </linearGradient>
    <linearGradient id="barGrad" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#c99738"/>
      <stop offset="100%" stop-color="#991b1b"/>
    </linearGradient>
  </defs>
  <rect width="360" height="140" rx="14" fill="url(#bgGrad)" stroke="#3a3d4d" stroke-width="1.5"/>
  <text x="24" y="34" font-family="-apple-system, Segoe UI, Roboto, sans-serif" font-size="16" font-weight="bold" fill="#ffffff">🏛️ {titre_label}</text>
  <text x="336" y="34" text-anchor="end" font-family="-apple-system, Segoe UI, Roboto, sans-serif" font-size="13" font-weight="600" fill="#e8c26f">{niveau_label}</text>

  <text x="24" y="68" font-family="-apple-system, Segoe UI, Roboto, sans-serif" font-size="13" fill="#9aa0b4">{streak_label}</text>
  <text x="336" y="68" text-anchor="end" font-family="-apple-system, Segoe UI, Roboto, sans-serif" font-size="13" font-weight="600" fill="#e6e6e6">{prog_label}</text>

  <!-- Barre de progression -->
  <rect x="24" y="86" width="312" height="12" rx="6" fill="#15161c"/>
  <rect x="24" y="86" width="{bar_width}" height="12" rx="6" fill="url(#barGrad)"/>

  <text x="180" y="122" text-anchor="middle" font-family="-apple-system, Segoe UI, Roboto, sans-serif" font-size="11" fill="#637777">ludus latinus • 100% standard library</text>
</svg>"""


def defi_du_jour(curriculum, today=None):
    """Sélectionne de façon déterministe une leçon/exercice pour le défi du jour."""
    if today is None:
        today = datetime.date.today()

    items = []
    for level in curriculum:
        for lesson in level.get("lessons", []):
            lid = lesson.get("id")
            if lid:
                items.append({
                    "id": lid,
                    "title": lesson.get("title", ""),
                    "title_en": lesson.get("title_en", ""),
                    "level_id": level.get("id", ""),
                    "level_title": level.get("title", ""),
                    "level_title_en": level.get("level_title_en", ""),
                    "type": lesson.get("type", "code")
                })
    if not items:
        return None

    jour_num = today.toordinal()
    idx = (jour_num * 13 + 7) % len(items)
    return items[idx]


def export_anki_tsv(glossaire, curriculum=None, lang="fr"):
    """Génère un contenu texte tabulé (.tsv) importable dans Anki/Quizlet."""
    lignes = ["#separator:tab", "#html:true", "#tags column:3"]
    # 1. Cartes de vocabulaire / glossaire
    for terme, defn in glossaire:
        t_clean = terme.replace("\t", " ").replace("\n", "<br>")
        d_clean = defn.replace("\t", " ").replace("\n", "<br>")
        tag = "luduslatinus::vocabulaire" if lang == "fr" else "luduslatinus::vocabulary"
        lignes.append(f"{t_clean}\t{d_clean}\t{tag}")

    # 2. Questions de quiz du curriculum
    if curriculum:
        for level in curriculum:
            tag = f"luduslatinus::{level.get('id', 'quiz')}"
            for lesson in level.get("lessons", []):
                if lesson.get("type") == "quiz":
                    q = lesson.get("question_en" if lang == "en" else "question", "")
                    options = lesson.get("options_en" if lang == "en" else "options", [])
                    ans_idx = lesson.get("answer", 0)
                    exp = lesson.get("explanation_en" if lang == "en" else "explanation", "")
                    if q and options and 0 <= ans_idx < len(options):
                        reponse = options[ans_idx]
                        if exp:
                            reponse += f"<br><small style='color:gray'>{exp}</small>"
                        q_clean = q.replace("\t", " ").replace("\n", "<br>")
                        r_clean = reponse.replace("\t", " ").replace("\n", "<br>")
                        lignes.append(f"{q_clean}\t{r_clean}\t{tag}")

    return "\n".join(lignes) + "\n"


