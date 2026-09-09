"""
Module Thesaurus Linguae Latinae — Le Trésor de la Langue & Générateur de Déclinaisons.

Fournit aux collégiens un dictionnaire bilingue express (Latin <-> Français)
avec recherche en temps réel, écoute vocale, étymologie,
et un générateur interactif de tables complètes de déclinaisons (1re à 5e)
et conjugaisons (Présent, Imparfait, Parfait) avec coloration morphologique.
"""

import tkinter as tk
from tkinter import ttk

from app import audio

# Base dictionnairique bilingue du Collège
DICTIONNAIRE_LATIN = [
    # NOMS
    {"latin": "amica, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "l'amie", "etym": "amical, amitié", "ex": "Amica Marcum videt.", "ex_fr": "L'amie voit Marcus."},
    {"latin": "amicus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "l'ami", "etym": "ami, amical", "ex": "Amicus certus in re incerta cernitur.", "ex_fr": "C'est dans le malheur qu'on reconnaît le véritable ami."},
    {"latin": "aqua, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "l'eau", "etym": "aquatique, aquarium, aqueduc", "ex": "Aqua vitae fons est.", "ex_fr": "L'eau est la source de la vie."},
    {"latin": "aquila, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "l'aigle (emblème de Rome)", "etym": "aquilin", "ex": "Aquila non capit muscas.", "ex_fr": "L'aigle ne chasse pas les mouches."},
    {"latin": "arcus, -us", "cat": "Nom", "genre": "masc. 4e décl.", "fr": "l'arc / la voûte", "etym": "arcade, arceau, arc", "ex": "Arcus triumphalis Romae stat.", "ex_fr": "L'arc de triomphe se dresse à Rome."},
    {"latin": "atrium, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "l'atrium (salle centrale)", "etym": "atrium", "ex": "In atrio ara deorum est.", "ex_fr": "Dans l'atrium se trouve l'autel des dieux."},
    {"latin": "bellum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "la guerre", "etym": "belligérant, belliqueux", "ex": "Si vis pacem, para bellum.", "ex_fr": "Si tu veux la paix, prépare la guerre."},
    {"latin": "canis, -is", "cat": "Nom", "genre": "masc./fém. 3e décl.", "fr": "le chien", "etym": "canin, canicule", "ex": "Cave canem !", "ex_fr": "Prends garde au chien !"},
    {"latin": "civis, -is", "cat": "Nom", "genre": "masc./fém. 3e décl.", "fr": "le citoyen / la citoyenne", "etym": "civique, civisme, civil", "ex": "Civis Romanus sum.", "ex_fr": "Je suis citoyen romain."},
    {"latin": "corpus, -oris", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le corps", "etym": "corporel, corporation, corsage", "ex": "Mens sana in corpore sano.", "ex_fr": "Un esprit sain dans un corps sain."},
    {"latin": "dies, -ei", "cat": "Nom", "genre": "masc./fém. 5e décl.", "fr": "le jour", "etym": "diurne, méridien, midi", "ex": "Carpe diem.", "ex_fr": "Cueille le jour présent."},
    {"latin": "dominus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le maître de maison", "etym": "dominer, domination, dame", "ex": "Dominus servos iubet.", "ex_fr": "Le maître ordonne aux serviteurs."},
    {"latin": "domus, -us", "cat": "Nom", "genre": "fém. 4e décl.", "fr": "la maison / la maisonnée", "etym": "domicile, domestique", "ex": "Domus mea arx mea.", "ex_fr": "Ma maison est ma forteresse."},
    {"latin": "dux, ducis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le chef / le général", "etym": "duc, conduire, conducteur", "ex": "Dux legiones in proelium ducit.", "ex_fr": "Le général mène les légions au combat."},
    {"latin": "equus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le cheval", "etym": "équitation, équestre, équidé", "ex": "Equus celeriter currit.", "ex_fr": "Le cheval court vite."},
    {"latin": "exercitus, -us", "cat": "Nom", "genre": "masc. 4e décl.", "fr": "l'armée", "etym": "exercer, exercice", "ex": "Exercitus castra munit.", "ex_fr": "L'armée fortifie le camp."},
    {"latin": "familia, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la famille / maisonnée", "etym": "familial, famille", "ex": "Tota familia convenit.", "ex_fr": "Toute la famille se réunit."},
    {"latin": "flumen, -inis", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le fleuve / la rivière", "etym": "fluvial, fleuve", "ex": "Tiberis clarum flumen est.", "ex_fr": "Le Tibre est un fleuve célèbre."},
    {"latin": "gladius, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le glaive", "etym": "gladiateur, glaive", "ex": "Gladius miles armat.", "ex_fr": "Le glaive arme le soldat."},
    {"latin": "homo, -inis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "l'homme / l'être humain", "etym": "homicide, hommage, humanité", "ex": "Homo sum, nihil humani a me alienum puto.", "ex_fr": "Je suis homme, et rien d'humain ne m'est étranger."},
    {"latin": "hostis, -is", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "l'ennemi", "etym": "hostile, hostilité", "ex": "Hostes urbem oppugnant.", "ex_fr": "Les ennemis attaquent la ville."},
    {"latin": "insula, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "l'île / l'immeuble romain", "etym": "insulaire, isoler, péninsule", "ex": "Plebs in insulis habitat.", "ex_fr": "La plèbe habite dans des immeubles."},
    {"latin": "lex, legis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la loi", "etym": "légal, légitime, légiférer", "ex": "Dura lex, sed lex.", "ex_fr": "La loi est dure, mais c'est la loi."},
    {"latin": "lupa, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la louve", "etym": "louve, lupanar", "ex": "Lupa Romulum et Remum alit.", "ex_fr": "La louve nourrit Romulus et Rémus."},
    {"latin": "lupus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le loup", "etym": "loup, louveteau", "ex": "Homo homini lupus est.", "ex_fr": "L'homme est un loup pour l'homme."},
    {"latin": "manus, -us", "cat": "Nom", "genre": "fém. 4e décl.", "fr": "la main / la troupe", "etym": "manuel, manucure, manipuler", "ex": "Manus manum lavat.", "ex_fr": "Une main lave l'autre."},
    {"latin": "mare, -is", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "la mer", "etym": "marin, maritime", "ex": "Mare Nostrum navigamus.", "ex_fr": "Nous voguons sur Notre Mer."},
    {"latin": "mater, -tris", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la mère", "etym": "maternel, maternité", "ex": "Mater laeta est.", "ex_fr": "La mère est joyeuse."},
    {"latin": "miles, -itis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le soldat", "etym": "militaire, milice", "ex": "Miles fortiter pugnat.", "ex_fr": "Le soldat combat avec courage."},
    {"latin": "mons, montis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "la montagne / colline", "etym": "mont, montagne", "ex": "Roma in septem montibus est.", "ex_fr": "Rome est assise sur sept collines."},
    {"latin": "navis, -is", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "le navire", "etym": "naval, navigateur, naviguer", "ex": "Navis ad portum pervenit.", "ex_fr": "Le navire arrive au port."},
    {"latin": "nomen, -inis", "cat": "Nom", "genre": "neutre 3e décl.", "fr": "le nom", "etym": "nominal, nommer, prénom", "ex": "Nomen mihi Marcus est.", "ex_fr": "Mon nom est Marcus."},
    {"latin": "pater, -tris", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le père", "etym": "paternel, patrimoine", "ex": "Pater filium monet.", "ex_fr": "Le père avertit son fils."},
    {"latin": "pax, pacis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la paix", "etym": "paix, pacifique, apaiser", "ex": "Pax Romana orbi data est.", "ex_fr": "La paix romaine fut donnée au monde."},
    {"latin": "pecunia, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "l'argent / la richesse", "etym": "pécunier, pécuniaire", "ex": "Pecunia non olet.", "ex_fr": "L'argent n'a pas d'odeur."},
    {"latin": "populus, -i", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "le peuple", "etym": "populaire, population, peuple", "ex": "Senatus Populusque Romanus.", "ex_fr": "Le Sénat et le Peuple Romain (SPQR)."},
    {"latin": "puella, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la jeune fille", "etym": "pucelle (vieux français)", "ex": "Puella flores colligit.", "ex_fr": "La jeune fille cueille des fleurs."},
    {"latin": "puer, pueri", "cat": "Nom", "genre": "masc. 2e décl.", "fr": "l'enfant / le jeune garçon", "etym": "puéril, puériculture", "ex": "Puer in ludo discit.", "ex_fr": "Le garçon apprend à l'école."},
    {"latin": "res, rei", "cat": "Nom", "genre": "fém. 5e décl.", "fr": "la chose / l'affaire", "etym": "réel, réalité, république", "ex": "Res publica.", "ex_fr": "La chose publique (la République)."},
    {"latin": "rex, regis", "cat": "Nom", "genre": "masc. 3e décl.", "fr": "le roi", "etym": "royal, régime, régner", "ex": "Roma septem reges habuit.", "ex_fr": "Rome a eu sept rois."},
    {"latin": "rosa, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la rose", "etym": "rose, rosier, rosace", "ex": "Rosa pulchra est.", "ex_fr": "La rose est belle."},
    {"latin": "scutum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le grand bouclier", "etym": "écu, écuyer, écusson", "ex": "Scuto se tegit.", "ex_fr": "Il se protège de son bouclier."},
    {"latin": "senatus, -us", "cat": "Nom", "genre": "masc. 4e décl.", "fr": "le sénat", "etym": "sénat, sénateur, sénile", "ex": "Senatus censuit.", "ex_fr": "Le Sénat a décrété."},
    {"latin": "silva, -ae", "cat": "Nom", "genre": "fém. 1re décl.", "fr": "la forêt / le bois", "etym": "sylvestre, sylviculture", "ex": "In silva arbores altae sunt.", "ex_fr": "Dans la forêt les arbres sont hauts."},
    {"latin": "templum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le temple", "etym": "temple, templier, contempler", "ex": "In templo sacrificant.", "ex_fr": "Ils sacrifient dans le temple."},
    {"latin": "urbs, urbis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "la ville (Rome par excellence)", "etym": "urbain, urbanisme, urbanité", "ex": "Urbs aeterna.", "ex_fr": "La Ville Éternelle."},
    {"latin": "verbum, -i", "cat": "Nom", "genre": "neutre 2e décl.", "fr": "le mot / la parole", "etym": "verbe, verbal, verbiage", "ex": "Verba volant, scripta manent.", "ex_fr": "Les paroles s'envolent, les écrits restent."},
    {"latin": "virtus, -utis", "cat": "Nom", "genre": "fém. 3e décl.", "fr": "le courage / la vertu", "etym": "vertu, vertueux", "ex": "Virtus in arduis.", "ex_fr": "Le courage dans l'adversité."},

    # VERBES
    {"latin": "amare (amo, amavi, amatum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "aimer", "etym": "ami, amour, amitié", "ex": "Marcus Iuliam amat.", "ex_fr": "Marcus aime Julia."},
    {"latin": "audire (audio, audivi, auditum)", "cat": "Verbe", "genre": "4e conjugaison", "fr": "entendre / écouter", "etym": "audible, auditeur, audition", "ex": "Discipuli magistrum audiunt.", "ex_fr": "Les élèves écoutent le maître."},
    {"latin": "capere (capio, cepi, captum)", "cat": "Verbe", "genre": "3e mixte", "fr": "prendre / capturer", "etym": "capturer, capture, capter", "ex": "Miles hostem capit.", "ex_fr": "Le soldat capture l'ennemi."},
    {"latin": "dicere (dico, dixi, dictum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "dire / parler", "etym": "dictionnaire, diction, prédire", "ex": "Veritatem dicit.", "ex_fr": "Il dit la vérité."},
    {"latin": "docere (doceo, docui, doctum)", "cat": "Verbe", "genre": "2e conjugaison", "fr": "enseigner / instruire", "etym": "docteur, doctrine, document", "ex": "Magister discipulos docet.", "ex_fr": "Le maître instruit les élèves."},
    {"latin": "esse (sum, fui)", "cat": "Verbe", "genre": "irrégulier", "fr": "être / exister", "etym": "essence, essentiel", "ex": "Cogito, ergo sum.", "ex_fr": "Je pense, donc je suis."},
    {"latin": "habere (habeo, habui, habitum)", "cat": "Verbe", "genre": "2e conjugaison", "fr": "avoir / posséder", "etym": "habile, habitude, avoir", "ex": "Pecuniam habet.", "ex_fr": "Il a de l'argent."},
    {"latin": "ire (eo, ii, itum)", "cat": "Verbe", "genre": "irrégulier", "fr": "aller", "etym": "itinéraire, initié", "ex": "Quo vadis ?", "ex_fr": "Où vas-tu ?"},
    {"latin": "legere (lego, legi, lectum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "lire / cueillir / choisir", "etym": "lecture, leçon, lisible", "ex": "Librum legere dulce est.", "ex_fr": "Lire un livre est doux."},
    {"latin": "mittere (mitto, misi, missum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "envoyer", "etym": "mission, émettre, transmettre", "ex": "Litteras mittit.", "ex_fr": "Il envoie une lettre."},
    {"latin": "monere (moneo, monui, monitum)", "cat": "Verbe", "genre": "2e conjugaison", "fr": "avertir / conseiller", "etym": "moniteur, prémonition", "ex": "Periculum monet.", "ex_fr": "Il avertit du danger."},
    {"latin": "posse (possum, potui)", "cat": "Verbe", "genre": "irrégulier", "fr": "pouvoir / être capable", "etym": "possible, puissance, pouvoir", "ex": "Possunt quia posse videntur.", "ex_fr": "Ils peuvent parce qu'ils semblent pouvoir."},
    {"latin": "pugnare (pugno, pugnavi, pugnatum)", "cat": "Verbe", "genre": "1re conjugaison", "fr": "combattre / se battre", "etym": "pugnace, pugilat", "ex": "Pro patria pugnant.", "ex_fr": "Ils combattent pour la patrie."},
    {"latin": "scribere (scribo, scripsi, scriptum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "écrire", "etym": "écrire, script, scribe, écriture", "ex": "Calamo in cera scribit.", "ex_fr": "Il écrit au calame sur la cire."},
    {"latin": "venire (venio, veni, ventum)", "cat": "Verbe", "genre": "4e conjugaison", "fr": "venir / arriver", "etym": "venir, avenir, aventure", "ex": "Veni, vidi, vici.", "ex_fr": "Je suis venu, j'ai vu, j'ai vaincu."},
    {"latin": "videre (video, vidi, visum)", "cat": "Verbe", "genre": "2e conjugaison", "fr": "voir", "etym": "vision, visible, vidéo, évident", "ex": "Video barbam et pallium.", "ex_fr": "Je vois la barbe et le manteau."},
    {"latin": "vincere (vinco, vici, victum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "vaincre / l'emporter", "etym": "vainqueur, victoire, invincible", "ex": "Labor omnia vincit improbus.", "ex_fr": "Le travail acharné vient à bout de tout."},
    {"latin": "vivere (vivo, vixi, victum)", "cat": "Verbe", "genre": "3e conjugaison", "fr": "vivre", "etym": "vivre, vital, vivace, survie", "ex": "Dum spiro, spero.", "ex_fr": "Tant que je respire, j'espère."},

    # ADJECTIFS
    {"latin": "altus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "haut / profond", "etym": "altitude, altier", "ex": "Arbor alta est.", "ex_fr": "L'arbre est haut."},
    {"latin": "bonus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "bon / bienveillant", "etym": "bon, bonté, bonus", "ex": "Bonus civis legibus paret.", "ex_fr": "Le bon citoyen obéit aux lois."},
    {"latin": "brevis, -e", "cat": "Adjectif", "genre": "2e classe (3e décl.)", "fr": "court / bref", "etym": "bref, brièveté, abréger", "ex": "Vita brevis, ars longa.", "ex_fr": "La vie est courte, l'art est long."},
    {"latin": "clarus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "clair / illustre / célèbre", "etym": "clarté, éclairer, clair", "ex": "Clarus imperator.", "ex_fr": "Un illustre empereur."},
    {"latin": "fortis, -e", "cat": "Adjectif", "genre": "2e classe (3e décl.)", "fr": "fort / courageux", "etym": "fort, force, forteresse", "ex": "Fortes fortuna adiuvat.", "ex_fr": "La fortune sourit aux audacieux."},
    {"latin": "magnus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "grand / puissant", "etym": "magnifique, magnitude, majeur", "ex": "Alexander Magnus.", "ex_fr": "Alexandre le Grand."},
    {"latin": "malus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "mauvais / méchant", "etym": "malice, malveillant, malin", "ex": "Mala herba cito crescit.", "ex_fr": "Mauvaise herbe pousse vite."},
    {"latin": "parvus, -a, -um", "cat": "Adjectif", "genre": "1re classe", "fr": "petit", "etym": "parcelle", "ex": "Parva scintilla magnum gignit ignem.", "ex_fr": "Une petite étincelle produit un grand feu."},
    {"latin": "pulcher, -chra, -chrum", "cat": "Adjectif", "genre": "1re classe", "fr": "beau / magnifique", "etym": "pulchritude (littéraire)", "ex": "Urbs pulcherrima est.", "ex_fr": "La ville est très belle."},

    # EXPRESSIONS & DEVISES
    {"latin": "Alea iacta est", "cat": "Devise", "genre": "locution", "fr": "Les dés sont jetés", "etym": "Paroles de César franchissant le Rubicon.", "ex": "Alea iacta est !", "ex_fr": "Le sort en est jeté !"},
    {"latin": "Carpe diem", "cat": "Devise", "genre": "locution poétique", "fr": "Cueille le jour présent", "etym": "Célèbre vers du poète Horace.", "ex": "Carpe diem, quam minimum credula postero.", "ex_fr": "Cueille le jour, sans te fier au lendemain."},
    {"latin": "Festina lente", "cat": "Devise", "genre": "devise d'Auguste", "fr": "Hâte-toi lentement", "etym": "Devise impériale de prudence et d'efficacité.", "ex": "Festina lente in studiis.", "ex_fr": "Travaille vite mais avec rigueur."},
    {"latin": "Veni, vidi, vici", "cat": "Devise", "genre": "rapport militaire", "fr": "Je suis venu, j'ai vu, j'ai vaincu", "etym": "Message laconique de César après Zéla.", "ex": "Veni, vidi, vici.", "ex_fr": "Victoire fulgurante."}
]

# TABLES DE DÉCLINAISONS MODÈLES
TABLES_DECLINAISONS = {
    "1re Déclinaison (rosa, -ae f.)": {
        "rad": "ros",
        "sing": [("Nominatif", "a", "#1e5aa0"), ("Vocatif", "a", "#008b8b"), ("Accusatif", "am", "#a82020"), ("Génitif", "ae", "#2e7d32"), ("Datif", "ae", "#c59b27"), ("Ablatif", "a", "#7b1fa2")],
        "plur": [("Nominatif", "ae", "#1e5aa0"), ("Vocatif", "ae", "#008b8b"), ("Accusatif", "as", "#a82020"), ("Génitif", "arum", "#2e7d32"), ("Datif", "is", "#c59b27"), ("Ablatif", "is", "#7b1fa2")]
    },
    "2e Déclinaison Masc. (dominus, -i m.)": {
        "rad": "domin",
        "sing": [("Nominatif", "us", "#1e5aa0"), ("Vocatif", "e", "#008b8b"), ("Accusatif", "um", "#a82020"), ("Génitif", "i", "#2e7d32"), ("Datif", "o", "#c59b27"), ("Ablatif", "o", "#7b1fa2")],
        "plur": [("Nominatif", "i", "#1e5aa0"), ("Vocatif", "i", "#008b8b"), ("Accusatif", "os", "#a82020"), ("Génitif", "orum", "#2e7d32"), ("Datif", "is", "#c59b27"), ("Ablatif", "is", "#7b1fa2")]
    },
    "2e Déclinaison Neutre (templum, -i n.)": {
        "rad": "templ",
        "sing": [("Nominatif", "um", "#1e5aa0"), ("Vocatif", "um", "#008b8b"), ("Accusatif", "um", "#a82020"), ("Génitif", "i", "#2e7d32"), ("Datif", "o", "#c59b27"), ("Ablatif", "o", "#7b1fa2")],
        "plur": [("Nominatif", "a", "#1e5aa0"), ("Vocatif", "a", "#008b8b"), ("Accusatif", "a", "#a82020"), ("Génitif", "orum", "#2e7d32"), ("Datif", "is", "#c59b27"), ("Ablatif", "is", "#7b1fa2")]
    },
    "3e Déclinaison Consonne (rex, regis m.)": {
        "rad": "reg",
        "sing": [("Nominatif", "(rex)", "#1e5aa0"), ("Vocatif", "(rex)", "#008b8b"), ("Accusatif", "em", "#a82020"), ("Génitif", "is", "#2e7d32"), ("Datif", "i", "#c59b27"), ("Ablatif", "e", "#7b1fa2")],
        "plur": [("Nominatif", "es", "#1e5aa0"), ("Vocatif", "es", "#008b8b"), ("Accusatif", "es", "#a82020"), ("Génitif", "um", "#2e7d32"), ("Datif", "ibus", "#c59b27"), ("Ablatif", "ibus", "#7b1fa2")]
    },
    "3e Déclinaison Neutre (corpus, -oris n.)": {
        "rad": "corpor",
        "sing": [("Nominatif", "(corpus)", "#1e5aa0"), ("Vocatif", "(corpus)", "#008b8b"), ("Accusatif", "(corpus)", "#a82020"), ("Génitif", "is", "#2e7d32"), ("Datif", "i", "#c59b27"), ("Ablatif", "e", "#7b1fa2")],
        "plur": [("Nominatif", "a", "#1e5aa0"), ("Vocatif", "a", "#008b8b"), ("Accusatif", "a", "#a82020"), ("Génitif", "um", "#2e7d32"), ("Datif", "ibus", "#c59b27"), ("Ablatif", "ibus", "#7b1fa2")]
    },
    "4e Déclinaison (manus, -us f.)": {
        "rad": "man",
        "sing": [("Nominatif", "us", "#1e5aa0"), ("Vocatif", "us", "#008b8b"), ("Accusatif", "um", "#a82020"), ("Génitif", "us", "#2e7d32"), ("Datif", "ui", "#c59b27"), ("Ablatif", "u", "#7b1fa2")],
        "plur": [("Nominatif", "us", "#1e5aa0"), ("Vocatif", "us", "#008b8b"), ("Accusatif", "us", "#a82020"), ("Génitif", "uum", "#2e7d32"), ("Datif", "ibus", "#c59b27"), ("Ablatif", "ibus", "#7b1fa2")]
    },
    "5e Déclinaison (res, rei f.)": {
        "rad": "r",
        "sing": [("Nominatif", "es", "#1e5aa0"), ("Vocatif", "es", "#008b8b"), ("Accusatif", "em", "#a82020"), ("Génitif", "ei", "#2e7d32"), ("Datif", "ei", "#c59b27"), ("Ablatif", "e", "#7b1fa2")],
        "plur": [("Nominatif", "es", "#1e5aa0"), ("Vocatif", "es", "#008b8b"), ("Accusatif", "es", "#a82020"), ("Génitif", "erum", "#2e7d32"), ("Datif", "ebus", "#c59b27"), ("Ablatif", "ebus", "#7b1fa2")]
    }
}

TABLES_CONJUGAISONS = {
    "Présent — amare (aimer)": [
        ("1re Sing.", "am", "o", "J'aime"),
        ("2e Sing.", "ama", "s", "Tu aimes"),
        ("3e Sing.", "ama", "t", "Il/Elle aime"),
        ("1re Plur.", "ama", "mus", "Nous aimons"),
        ("2e Plur.", "ama", "tis", "Vous aimez"),
        ("3e Plur.", "ama", "nt", "Ils/Elles aiment")
    ],
    "Imparfait — amare (aimer)": [
        ("1re Sing.", "ama", "bam", "J'aimais"),
        ("2e Sing.", "ama", "bas", "Tu aimais"),
        ("3e Sing.", "ama", "bat", "Il/Elle aimait"),
        ("1re Plur.", "ama", "bamus", "Nous aimions"),
        ("2e Plur.", "ama", "batis", "Vous aimiez"),
        ("3e Plur.", "ama", "bant", "Ils/Elles aimaient")
    ],
    "Parfait — amare (aimer)": [
        ("1re Sing.", "amav", "i", "J'ai aimé / J'aimai"),
        ("2e Sing.", "amav", "isti", "Tu as aimé"),
        ("3e Sing.", "amav", "it", "Il/Elle a aimé"),
        ("1re Plur.", "amav", "imus", "Nous avons aimé"),
        ("2e Plur.", "amav", "istis", "Vous avez aimé"),
        ("3e Plur.", "amav", "erunt", "Ils/Elles ont aimé")
    ],
    "Présent — esse (être)": [
        ("1re Sing.", "", "sum", "Je suis"),
        ("2e Sing.", "", "es", "Tu es"),
        ("3e Sing.", "", "est", "Il/Elle est"),
        ("1re Plur.", "", "sumus", "Nous sommes"),
        ("2e Plur.", "", "estis", "Vous êtes"),
        ("3e Plur.", "", "sunt", "Ils/Elles sont")
    ],
    "Imparfait — esse (être)": [
        ("1re Sing.", "", "eram", "J'étais"),
        ("2e Sing.", "", "eras", "Tu étais"),
        ("3e Sing.", "", "erat", "Il/Elle était"),
        ("1re Plur.", "", "eramus", "Nous étions"),
        ("2e Plur.", "", "eratis", "Vous étiez"),
        ("3e Plur.", "", "erant", "Ils/Elles étaient")
    ]
}


class ThesaurusDialog(tk.Toplevel):
    """Fenêtre du Thesaurus Linguae Latinae & Générateur de Déclinaisons."""

    def __init__(self, master, app):
        super().__init__(master)
        self.app = app
        self.C = app.C
        self.title("📖 Thesaurus Linguae Latinae — Dictionnaire & Déclinaisons")
        self.configure(bg=self.C["panel"])
        self.resizable(False, False)

        w, h = 880, 680
        sw = self.winfo_screenwidth()
        sh = self.winfo_screenheight()
        self.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 2}")

        self.transient(master)
        self.grab_set()

        self.entrees_filtrees = list(DICTIONNAIRE_LATIN)
        self.entree_active = self.entrees_filtrees[0]

        # Ruban d'or supérieur
        tk.Frame(self, bg=self.C["accent"], height=6).pack(fill=tk.X, side=tk.TOP)

        # En-tête
        hdr = tk.Frame(self, bg=self.C["panel"], padx=20, pady=10)
        hdr.pack(fill=tk.X)

        tk.Label(
            hdr,
            text="📖 Thesaurus Linguae Latinae",
            font=(app.title_font.cget("family"), 18, "bold"),
            bg=self.C["panel"],
            fg=self.C["accent"]
        ).pack(anchor="w")

        tk.Label(
            hdr,
            text="Dictionnaire latin-français interactif et générateur complet de déclinaisons & conjugaisons.",
            font=(app.body.cget("family"), 10),
            bg=self.C["panel"],
            fg=self.C["muted"]
        ).pack(anchor="w")

        # Notebook Onglets
        style = ttk.Style(self)
        style.configure("Thesaurus.TNotebook", background=self.C["panel"], borderwidth=0)
        style.configure("Thesaurus.TNotebook.Tab", font=(app.body.cget("family"), 10, "bold"), padding=[16, 6])

        self.nb = ttk.Notebook(self, style="Thesaurus.TNotebook")
        self.nb.pack(fill=tk.BOTH, expand=True, padx=20, pady=6)

        self.tab_dico = tk.Frame(self.nb, bg=self.C["panel"], padx=12, pady=10)
        self.tab_tables = tk.Frame(self.nb, bg=self.C["panel"], padx=12, pady=10)

        self.nb.add(self.tab_dico, text="📚 Dictionnaire Bilingue")
        self.nb.add(self.tab_tables, text="📐 Tables des Déclinaisons")

        self._build_tab_dictionnaire()
        self._build_tab_tables()

        # Barre inférieure
        bottom_bar = tk.Frame(self, bg=self.C["panel"], padx=20, pady=8)
        bottom_bar.pack(fill=tk.X, side=tk.BOTTOM)

        tk.Label(
            bottom_bar,
            text="💡 Astuce : Utilise le Thesaurus pour t'aider dans tes leçons et exercices !",
            font=(app.body.cget("family"), 9, "italic"),
            bg=self.C["panel"],
            fg=self.C["muted"]
        ).pack(side=tk.LEFT)

        ttk.Button(bottom_bar, text="Fermer", command=self.destroy).pack(side=tk.RIGHT)

        self.lift()
        self.focus_force()

    # -----------------------------------------------------------------------
    # ONGLET 1 : DICTIONNAIRE BILINGUE
    # -----------------------------------------------------------------------
    def _build_tab_dictionnaire(self):
        # Barre de recherche & Filtres
        search_frame = tk.Frame(self.tab_dico, bg=self.C["panel"])
        search_frame.pack(fill=tk.X, pady=(0, 8))

        tk.Label(
            search_frame,
            text="🔍 Rechercher :",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg=self.C["panel"],
            fg=self.C["fg"]
        ).pack(side=tk.LEFT, padx=(0, 6))

        self.var_search = tk.StringVar()
        self.var_search.trace_add("write", lambda *args: self._filtrer_dictionnaire())

        self.ent_search = ttk.Entry(search_frame, textvariable=self.var_search, width=32)
        self.ent_search.pack(side=tk.LEFT, padx=(0, 14))

        # Filtres catégories
        self.var_cat = tk.StringVar(value="Tous")
        for cat in ("Tous", "Nom", "Verbe", "Adjectif", "Devise"):
            rb = tk.Radiobutton(
                search_frame,
                text=cat,
                variable=self.var_cat,
                value=cat,
                command=self._filtrer_dictionnaire,
                font=(self.app.body.cget("family"), 9),
                bg=self.C["panel"],
                fg=self.C["fg"],
                selectcolor=self.C["editor"],
                activebackground=self.C["panel"]
            )
            rb.pack(side=tk.LEFT, padx=3)

        # Corps : Liste à gauche + Fiche à droite
        body = tk.Frame(self.tab_dico, bg=self.C["panel"])
        body.pack(fill=tk.BOTH, expand=True)

        # Liste défilante à gauche
        left_box = tk.Frame(body, bg=self.C["editor"], width=280, highlightthickness=1,
                            highlightbackground=self.C["accent"])
        left_box.pack(side=tk.LEFT, fill=tk.Y, padx=(0, 10))
        left_box.pack_propagate(False)

        scroll = ttk.Scrollbar(left_box)
        scroll.pack(side=tk.RIGHT, fill=tk.Y)

        self.lb_mots = tk.Listbox(
            left_box,
            yscrollcommand=scroll.set,
            font=(self.app.body.cget("family"), 10),
            bg=self.C["editor"],
            fg=self.C["fg"],
            selectbackground=self.C["accent"],
            selectforeground="#1a1409",
            relief="flat",
            bd=0
        )
        self.lb_mots.pack(fill=tk.BOTH, expand=True)
        scroll.config(command=self.lb_mots.yview)
        self.lb_mots.bind("<<ListboxSelect>>", self._on_select_mot)

        # Fiche d'identité à droite
        self.right_box = tk.Frame(body, bg=self.C["editor"], padx=20, pady=16, highlightthickness=1,
                                  highlightbackground=self.C["accent"])
        self.right_box.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        self._filtrer_dictionnaire()

    def _filtrer_dictionnaire(self):
        query = self.var_search.get().strip().lower()
        cat_filtre = self.var_cat.get()

        self.entrees_filtrees = []
        for e in DICTIONNAIRE_LATIN:
            if cat_filtre != "Tous" and e["cat"] != cat_filtre:
                continue
            if query and query not in e["latin"].lower() and query not in e["fr"].lower() and query not in e.get("etym", "").lower():
                continue
            self.entrees_filtrees.append(e)

        self.lb_mots.delete(0, tk.END)
        for e in self.entrees_filtrees:
            self.lb_mots.insert(tk.END, f"{e['latin']}  →  {e['fr']}")

        if self.entrees_filtrees:
            self.lb_mots.selection_set(0)
            self.entree_active = self.entrees_filtrees[0]
            self._afficher_fiche_mot(self.entree_active)
        else:
            self._afficher_fiche_mot(None)

    def _on_select_mot(self, event):
        sel = self.lb_mots.curselection()
        if sel and sel[0] < len(self.entrees_filtrees):
            self.entree_active = self.entrees_filtrees[sel[0]]
            self._afficher_fiche_mot(self.entree_active)

    def _afficher_fiche_mot(self, e):
        for w in self.right_box.winfo_children():
            w.destroy()

        if not e:
            tk.Label(
                self.right_box,
                text="Aucun mot correspondant.",
                font=(self.app.body.cget("family"), 11, "italic"),
                bg=self.C["editor"],
                fg=self.C["muted"]
            ).pack(expand=True)
            return

        # En-tête mot
        hdr = tk.Frame(self.right_box, bg=self.C["editor"])
        hdr.pack(fill=tk.X)

        tk.Label(
            hdr,
            text=e["latin"],
            font=(self.app.title_font.cget("family"), 20, "bold"),
            bg=self.C["editor"],
            fg=self.C["accent"]
        ).pack(side=tk.LEFT)

        tk.Button(
            hdr,
            text="🔊 Prononcer",
            font=(self.app.body.cget("family"), 9, "bold"),
            bg="#2e6f40", fg="#ffffff",
            activebackground="#3e8f54",
            padx=10, pady=3, relief="flat", cursor="hand2",
            command=lambda: audio.speak_latin(e["latin"].split()[0].replace(",", ""))
        ).pack(side=tk.RIGHT)

        # Nature grammaticale
        tk.Label(
            self.right_box,
            text=f"{e['cat']} · {e['genre']}",
            font=(self.app.body.cget("family"), 10, "italic"),
            bg=self.C["editor"],
            fg=self.C["muted"]
        ).pack(anchor="w", pady=(2, 10))

        # Traduction française principale
        trans_box = tk.Frame(self.right_box, bg="#fff8e7" if not self.C.get("is_dark", False) else "#30261e",
                             padx=14, pady=8, relief="solid", bd=1)
        trans_box.pack(fill=tk.X, pady=(0, 12))

        tk.Label(
            trans_box,
            text=f"🇫🇷 Traduction :  {e['fr']}",
            font=(self.app.body.cget("family"), 12, "bold"),
            bg=trans_box.cget("bg"),
            fg="#8b2500" if not self.C.get("is_dark", False) else "#ffaa66"
        ).pack(anchor="w")

        # Étymologie & Français moderne
        if e.get("etym"):
            tk.Label(
                self.right_box,
                text=f"🌱 Dérivés & Étymologie :  {e['etym']}",
                font=(self.app.body.cget("family"), 10),
                bg=self.C["editor"],
                fg=self.C["fg"]
            ).pack(anchor="w", pady=(0, 10))

        # Exemple authentique en contexte
        if e.get("ex"):
            ex_box = tk.Frame(self.right_box, bg=self.C["editor"], padx=12, pady=8, relief="groove", bd=1)
            ex_box.pack(fill=tk.X, pady=4)

            tk.Label(
                ex_box,
                text="📜 Exemple en contexte :",
                font=(self.app.body.cget("family"), 9, "bold"),
                bg=self.C["editor"],
                fg=self.C["accent"]
            ).pack(anchor="w")

            tk.Label(
                ex_box,
                text=f"« {e['ex']} »",
                font=(self.app.body.cget("family"), 11, "bold italic"),
                bg=self.C["editor"],
                fg="#2e6f40" if not self.C.get("is_dark", False) else "#66dd88"
            ).pack(anchor="w", pady=(2, 1))

            tk.Label(
                ex_box,
                text=f"= {e['ex_fr']}",
                font=(self.app.body.cget("family"), 9, "italic"),
                bg=self.C["editor"],
                fg=self.C["fg"]
            ).pack(anchor="w")

    # -----------------------------------------------------------------------
    # ONGLET 2 : TABLES DE DÉCLINAISONS & CONJUGAISONS
    # -----------------------------------------------------------------------
    def _build_tab_tables(self):
        top_ctrl = tk.Frame(self.tab_tables, bg=self.C["panel"])
        top_ctrl.pack(fill=tk.X, pady=(0, 8))

        tk.Label(
            top_ctrl,
            text="Modèle grammatical :",
            font=(self.app.body.cget("family"), 10, "bold"),
            bg=self.C["panel"],
            fg=self.C["fg"]
        ).pack(side=tk.LEFT, padx=(0, 10))

        options = list(TABLES_DECLINAISONS.keys()) + ["---"] + list(TABLES_CONJUGAISONS.keys())
        self.var_table = tk.StringVar(value=options[0])

        cb = ttk.Combobox(top_ctrl, textvariable=self.var_table, values=options, state="readonly", width=42)
        cb.pack(side=tk.LEFT)
        cb.bind("<<ComboboxSelected>>", lambda e: self._dessiner_table())

        # Zone d'affichage de la grille
        self.table_container = tk.Frame(self.tab_tables, bg=self.C["editor"], padx=16, pady=14,
                                        highlightthickness=1, highlightbackground=self.C["accent"])
        self.table_container.pack(fill=tk.BOTH, expand=True)

        self._dessiner_table()

    def _dessiner_table(self):
        for w in self.table_container.winfo_children():
            w.destroy()

        modele = self.var_table.get()
        if modele == "---":
            return

        if modele in TABLES_DECLINAISONS:
            table = TABLES_DECLINAISONS[modele]
            rad = table["rad"]

            # En-tête des colonnes
            grid = tk.Frame(self.table_container, bg=self.C["editor"])
            grid.pack(fill=tk.BOTH, expand=True)

            headers = ["Cas Grammatical", "Singulier", "Pluriel"]
            for col, h in enumerate(headers):
                lbl = tk.Label(
                    grid,
                    text=h,
                    font=(self.app.body.cget("family"), 11, "bold"),
                    bg=self.C["accent"],
                    fg="#1a1409",
                    padx=14, pady=6,
                    relief="flat"
                )
                lbl.grid(row=0, column=col, sticky="nsew", padx=2, pady=2)

            # Lignes des 6 cas
            for r in range(6):
                nom_cas, term_s, col_s = table["sing"][r]
                _, term_p, col_p = table["plur"][r]

                # Colonne Cas
                c_lbl = tk.Label(
                    grid,
                    text=f"● {nom_cas}",
                    font=(self.app.body.cget("family"), 10, "bold"),
                    bg="#eeddc5" if not self.C.get("is_dark", False) else "#352b20",
                    fg=col_s,
                    padx=10, pady=5,
                    anchor="w"
                )
                c_lbl.grid(row=r + 1, column=0, sticky="nsew", padx=2, pady=2)

                # Forme Singulier
                s_frame = tk.Frame(grid, bg=self.C["editor"], padx=10, pady=5, relief="groove", bd=1)
                s_frame.grid(row=r + 1, column=1, sticky="nsew", padx=2, pady=2)

                if term_s.startswith("("):
                    tk.Label(s_frame, text=term_s, font=(self.app.body.cget("family"), 11, "bold"),
                             bg=self.C["editor"], fg=col_s).pack(side=tk.LEFT)
                else:
                    tk.Label(s_frame, text=rad, font=(self.app.body.cget("family"), 11),
                             bg=self.C["editor"], fg=self.C["fg"]).pack(side=tk.LEFT)
                    tk.Label(s_frame, text=f"-{term_s}", font=(self.app.body.cget("family"), 11, "bold"),
                             bg=self.C["editor"], fg=col_s).pack(side=tk.LEFT)

                # Forme Pluriel
                p_frame = tk.Frame(grid, bg=self.C["editor"], padx=10, pady=5, relief="groove", bd=1)
                p_frame.grid(row=r + 1, column=2, sticky="nsew", padx=2, pady=2)

                tk.Label(p_frame, text=rad, font=(self.app.body.cget("family"), 11),
                         bg=self.C["editor"], fg=self.C["fg"]).pack(side=tk.LEFT)
                tk.Label(p_frame, text=f"-{term_p}", font=(self.app.body.cget("family"), 11, "bold"),
                         bg=self.C["editor"], fg=col_p).pack(side=tk.LEFT)

            grid.grid_columnconfigure(0, weight=1)
            grid.grid_columnconfigure(1, weight=1)
            grid.grid_columnconfigure(2, weight=1)

        elif modele in TABLES_CONJUGAISONS:
            table = TABLES_CONJUGAISONS[modele]

            grid = tk.Frame(self.table_container, bg=self.C["editor"])
            grid.pack(fill=tk.BOTH, expand=True)

            headers = ["Personne", "Forme Latine Décomposée", "Traduction Française"]
            for col, h in enumerate(headers):
                lbl = tk.Label(
                    grid,
                    text=h,
                    font=(self.app.body.cget("family"), 11, "bold"),
                    bg=self.C["accent"],
                    fg="#1a1409",
                    padx=14, pady=6,
                    relief="flat"
                )
                lbl.grid(row=0, column=col, sticky="nsew", padx=2, pady=2)

            for r, (pers, rad, term, fr) in enumerate(table):
                # Personne
                tk.Label(
                    grid,
                    text=pers,
                    font=(self.app.body.cget("family"), 10, "bold"),
                    bg="#eeddc5" if not self.C.get("is_dark", False) else "#352b20",
                    fg=self.C["fg"],
                    padx=10, pady=5,
                    anchor="w"
                ).grid(row=r + 1, column=0, sticky="nsew", padx=2, pady=2)

                # Forme latine
                lat_frame = tk.Frame(grid, bg=self.C["editor"], padx=10, pady=5, relief="groove", bd=1)
                lat_frame.grid(row=r + 1, column=1, sticky="nsew", padx=2, pady=2)

                if rad:
                    tk.Label(lat_frame, text=rad, font=(self.app.body.cget("family"), 11),
                             bg=self.C["editor"], fg=self.C["fg"]).pack(side=tk.LEFT)
                tk.Label(lat_frame, text=f"-{term}" if rad else term, font=(self.app.body.cget("family"), 11, "bold"),
                         bg=self.C["editor"], fg="#d4af37").pack(side=tk.LEFT)

                # Traduction
                tk.Label(
                    grid,
                    text=fr,
                    font=(self.app.body.cget("family"), 10, "italic"),
                    bg=self.C["editor"],
                    fg="#2e6f40" if not self.C.get("is_dark", False) else "#66dd88",
                    padx=10, pady=5,
                    anchor="w"
                ).grid(row=r + 1, column=2, sticky="nsew", padx=2, pady=2)

            grid.grid_columnconfigure(0, weight=1)
            grid.grid_columnconfigure(1, weight=1)
            grid.grid_columnconfigure(2, weight=1)
