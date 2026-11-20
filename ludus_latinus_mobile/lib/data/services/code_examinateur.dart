import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Code examinateur : ouvre l'Édition complète sans achat, pour les
/// examinateurs de Google, qui ne peuvent pas payer (déclaration
/// « Informations de connexion » de la Play Console).
///
/// L'appli ne garde que l'empreinte SHA-256 du code : le lire dans l'APK
/// décompilé ne donne pas le code. Le code en clair est rangé hors du dépôt,
/// avec la clé d'upload (`Documents\LudusLatinus-cle\code_examinateur.txt`).
/// Pour en changer : nouveau code, nouvelle empreinte ici, nouvelle version.
const String _empreinteCode = '9796634cf3ef22d77ce6f59d0a988b80c6ddd211b4becd8d85af1c3df91e2f70';

/// Nombre d'appuis rapides sur la ligne « Version » de l'écran À propos pour
/// ouvrir la saisie du code : le geste des options cachées d'Android.
const int kAppuisCodeExaminateur = 7;

/// Vrai si [saisie] est le code examinateur. Espaces et casse ignorés :
/// le code est recopié à la main depuis le formulaire de Google.
bool codeExaminateurValide(String saisie) {
  final normalise = saisie.replaceAll(RegExp(r'\s'), '').toUpperCase();
  if (normalise.isEmpty) return false;
  return sha256.convert(utf8.encode(normalise)).toString() == _empreinteCode;
}
