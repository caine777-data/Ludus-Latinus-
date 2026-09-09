import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/monument.dart';
import '../models/srs_card.dart';
import '../models/thesaurus_entry.dart';
import '../models/world.dart';

/// Service responsable du chargement du dataset universel JSON.
class DataService {
  List<SchoolClass> classes = [];
  List<World> worlds = [];
  List<ThesaurusEntry> thesaurus = [];
  List<ForumMonument> monuments = [];
  List<SrsCard> srsCards = [];
  Map<String, dynamic> rawData = {};

  bool isLoaded = false;

  Future<void> loadDataset() async {
    if (isLoaded) return;
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/ludus_latinus_dataset.json');
      rawData = json.decode(jsonString) as Map<String, dynamic>;

      // Parsing des classes
      var rawClasses = rawData['classes'] as List<dynamic>? ?? [];
      classes = rawClasses
          .map((c) => SchoolClass.fromJson(c as Map<String, dynamic>))
          .toList();

      // Parsing des mondes
      var rawWorlds = rawData['mondes'] as List<dynamic>? ?? [];
      worlds = rawWorlds
          .map((w) => World.fromJson(w as Map<String, dynamic>))
          .toList();

      // Parsing du Thesaurus
      var rawThes = rawData['thesaurus'] as Map<String, dynamic>? ?? {};
      var rawDico = rawThes['dictionnaire'] as List<dynamic>? ?? [];
      thesaurus = rawDico
          .map((d) => ThesaurusEntry.fromJson(d as Map<String, dynamic>))
          .toList();

      // Parsing des Monuments du Forum
      var rawMonuments = rawData['forum_monuments'] as List<dynamic>? ?? [];
      monuments = rawMonuments
          .map((m) => ForumMonument.fromJson(m as Map<String, dynamic>))
          .toList();

      // Parsing des cartes SRS
      var rawSrs = rawData['memoria_srs'] as List<dynamic>? ?? [];
      srsCards = rawSrs
          .map((s) => SrsCard.fromJson(s as Map<String, dynamic>))
          .toList();

      isLoaded = true;
    } catch (e) {
      // ignore: avoid_print
      print('Erreur lors du chargement du dataset Ludus Latinus : $e');
    }
  }

  World? findWorld(String worldId) {
    try {
      return worlds.firstWhere((w) => w.id == worldId);
    } catch (_) {
      return null;
    }
  }
}
