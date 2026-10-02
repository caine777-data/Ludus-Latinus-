# Ludus Latinus 🏛️

Application libre pour apprendre le latin au collège, de la 5e à la 3e.

Le projet propose un parcours d'apprentissage sous forme de jeu sur la Via Appia. L'élève progresse avec la mascotte Lupulus, un louveteau en toge. Il gagne des sesterces, débloque des costumes d'avatar et maintient une série quotidienne.

## Programme du collège 📚

Le curriculum compte 26 mondes et 113 leçons réparties sur trois niveaux scolaires :

### Classe de 5e : Les Origines & La Cité (10 mondes, 49 leçons)
1. Salve ! Premiers pas à Rome (6 leçons)
2. Dans la Maison Romaine (5 leçons)
3. Les Dieux de l'Olympe & Légendes (5 leçons)
4. Les Cas & Travaux d'Hercule (5 leçons)
5. Les Verbes au Présent & L'Action (5 leçons)
6. Les Gladiateurs & le Colisée (4 leçons)
7. Détective des Mots & Devises (4 leçons)
8. La Cité de Rome, Marchés & Vie Quotidienne (5 leçons)
9. L'Armée Romaine & les Légions (5 leçons)
10. Monstres Fabuleux & Métamorphoses (5 leçons)

### Classe de 4e : La République & L'Expansion (8 mondes, 32 leçons)
11. Les Héros de la République (4 leçons)
12. Le Sénat et le Peuple (SPQR) (4 leçons)
13. Mare Nostrum & Les Conquêtes (4 leçons)
14. Les Légions en Marche (4 leçons)
15. Récits d'Autrefois : L'Imparfait (4 leçons)
16. Veni, Vidi, Vici : Le Parfait (4 leçons)
17. César et la Guerre des Gaules (4 leçons)
18. Le Grand Triomphe de la République (4 leçons)

### Classe de 3e : L'Empire & Les Grands Auteurs (8 mondes, 32 leçons)
19. La Paix d'Auguste (Pax Romana) (4 leçons)
20. Les Chemins de l'Empire (4 leçons)
21. Sous la Cendre du Vésuve (4 leçons)
22. Le Secret de l'Ablatif Absolu (4 leçons)
23. Les Échos du Forum : La Voix Passive (4 leçons)
24. La Proposition Infinitive (4 leçons)
25. L'Or des Poètes : Virgile & Ovide (4 leçons)
26. Le Grand Triomphe du Collège (4 leçons)

## Les jeux antiques ⚔️

L'application propose six jeux pour s'entraîner :

- **Duel** : combats d'arène au Colisée contre des boss mythologiques (Minotaure, Sphinx, Lion de Némée, Rétiaire, Mercure).
- **Circus** : courses de quadriges au Circus Maximus où chaque bonne réponse accélère le char.
- **César** : atelier de cryptographie militaire pour décoder des messages secrets avec le chiffre de César.
- **Marché** : boutique des marchés de Trajan avec calculs en chiffres romains et achats en sesterces.
- **Taverne** : jeu de dés romains (*Alea iacta est*) avec paris tactiques de pièces d'or.
- **Memoria** : révision de vocabulaire par répétition espacée (*Memoria Velox*).

## Télécharger l'application 📦

Les paquets prêts à l'emploi sont construits automatiquement par GitHub Actions :

1. Ouvrez l'onglet **Actions** du dépôt GitHub.
2. Cliquez sur le workflow **Ludus Latinus (Android & Windows)**.
3. Choisissez la dernière exécution terminée.
4. Téléchargez le fichier voulu dans la rubrique **Artifacts** :
   - `LudusLatinus.apk` : paquet à installer sur un téléphone Android.
   - `LudusLatinus-Windows.zip` : archive à décompresser sur ordinateur Windows (lancer ensuite `LudusLatinus.exe`).

## Lancer en développement 💻

Le projet principal utilise Flutter. L'ancienne version de bureau en Python reste disponible pour la consultation des données.

### Application mobile (Flutter)

Prérequis : Flutter SDK 3.47+ et un émulateur ou appareil Android.

```bash
cd ludus_latinus_mobile
flutter pub get
flutter analyze
flutter test
flutter run
```

### Application de bureau (Python)

Prérequis : Python 3.10+ avec Tkinter.

```bash
python main.py
python -m unittest discover -s tests
```
