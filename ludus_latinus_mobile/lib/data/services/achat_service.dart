import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'storage_service.dart';

/// Édition complète : un achat unique par Google Play Billing (décision de
/// Cédric : 3,99 €, sans abonnement, sans publicité, sesterces jamais vendus).
///
/// L'achat ne s'active qu'avec `--dart-define=EDITION_PAYANTE=true` : le test
/// fermé se fait avec la version complète gratuite, et la version de test PC
/// reste complète (pas de Play Store sous Windows).
const bool kEditionPayante = bool.fromEnvironment('EDITION_PAYANTE');

/// Où en est l'achat, pour l'écran de l'Édition complète.
enum EtatAchat {
  /// Connexion au Play Store en cours, ou pas encore tentée.
  chargement,

  /// Le produit est connu : le bouton d'achat affiche son prix.
  pret,

  /// Play Store injoignable (hors ligne) ou produit introuvable.
  indisponible,

  /// La fenêtre de paiement de Google est ouverte.
  enCours,

  /// Paiement différé (espèces, carte cadeau) : Google confirmera plus tard.
  enAttente,

  /// Le paiement a échoué ; l'élève peut réessayer.
  erreur,
}

/// Contrat commun : l'achat réel, la version offerte et le double des tests.
abstract class AchatService extends ChangeNotifier {
  /// Vrai quand toutes les leçons sont ouvertes.
  bool get editionComplete;

  /// Faux quand l'Édition complète est offerte : rien à vendre ni à restaurer,
  /// les Paramètres n'en parlent pas.
  bool get estPayant;

  /// Prix affiché par le Play Store, dans la monnaie de l'élève (« 3,99 € »).
  String? get prix;

  EtatAchat get etat;

  /// Lit l'achat mémorisé sur l'appareil, puis se connecte au Play Store
  /// sans faire attendre le démarrage.
  Future<void> init();

  /// Ouvre la fenêtre de paiement ; le résultat arrive par [etat].
  Future<void> acheter();

  /// Cherche un achat fait sur le même compte Google ; vrai s'il est retrouvé.
  Future<bool> restaurer();

  /// Choisit le service selon la compilation et la plateforme.
  static AchatService pourCetteCompilation(StorageService stockage) {
    if (!kEditionPayante || !Platform.isAndroid) return AchatOffert();
    return AchatPlay(stockage);
  }
}

/// Édition complète offerte : test fermé, version PC, tests automatiques.
class AchatOffert extends AchatService {
  @override
  bool get editionComplete => true;
  @override
  bool get estPayant => false;
  @override
  String? get prix => null;
  @override
  EtatAchat get etat => EtatAchat.pret;
  @override
  Future<void> init() async {}
  @override
  Future<void> acheter() async {}
  @override
  Future<bool> restaurer() async => true;
}

/// Achat simulé, sans Play Store : tests et essais de l'écran d'achat.
class AchatSimule extends AchatService {
  bool _complete;
  EtatAchat _etat = EtatAchat.pret;

  AchatSimule({bool complete = false}) : _complete = complete;

  @override
  bool get editionComplete => _complete;
  @override
  bool get estPayant => true;
  @override
  String? get prix => '3,99 €';
  @override
  EtatAchat get etat => _etat;
  @override
  Future<void> init() async {}

  @override
  Future<void> acheter() async {
    _complete = true;
    _etat = EtatAchat.pret;
    notifyListeners();
  }

  @override
  Future<bool> restaurer() async => _complete;
}

/// Achat réel par Google Play Billing (paquet officiel in_app_purchase).
///
/// Pas de vérification sur serveur : l'appli n'en a pas et reste hors ligne.
/// Pour un achat unique à 3,99 €, la confirmation de Google suffit.
class AchatPlay extends AchatService {
  /// Identifiant du produit intégré à créer dans la Play Console
  /// (produit unique, non consommable).
  static const String idProduit = 'edition_complete';

  final StorageService _stockage;
  final InAppPurchase _magasin = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _abonnement;
  ProductDetails? _produit;
  bool _complete = false;
  EtatAchat _etat = EtatAchat.chargement;

  AchatPlay(this._stockage);

  @override
  bool get editionComplete => _complete;
  @override
  bool get estPayant => true;
  @override
  String? get prix => _produit?.price;
  @override
  EtatAchat get etat => _etat;

  @override
  Future<void> init() async {
    // L'achat mémorisé ouvre les leçons même hors ligne.
    _complete = await _stockage.lireEditionComplete();
    // Écouter avant toute demande : Google peut renvoyer un achat en attente
    // dès la connexion.
    _abonnement = _magasin.purchaseStream.listen(
      _traiter,
      onError: (Object e) {
        debugPrint('[AchatPlay] Flux d\'achats interrompu : $e');
        _changer(EtatAchat.erreur);
      },
    );
    unawaited(_connecter());
  }

  Future<void> _connecter() async {
    try {
      if (!await _magasin.isAvailable()) return _changer(EtatAchat.indisponible);
      final reponse = await _magasin.queryProductDetails({idProduit});
      _produit = reponse.productDetails.where((p) => p.id == idProduit).firstOrNull;
      _changer(_produit == null ? EtatAchat.indisponible : EtatAchat.pret);
      // Réinstallation ou nouvel appareil : l'achat revient sans que l'élève
      // ait à le chercher.
      if (!_complete) await _magasin.restorePurchases();
    } catch (e) {
      debugPrint('[AchatPlay] Play Store injoignable : $e');
      _changer(EtatAchat.indisponible);
    }
  }

  @override
  Future<void> acheter() async {
    final produit = _produit;
    if (produit == null || _complete) return;
    _changer(EtatAchat.enCours);
    try {
      await _magasin.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: produit));
    } catch (e) {
      debugPrint('[AchatPlay] Achat refusé au lancement : $e');
      _changer(EtatAchat.erreur);
    }
  }

  @override
  Future<bool> restaurer() async {
    if (_complete) return true;
    try {
      // Sur Android, les achats retrouvés passent par le flux avant la fin
      // de cet appel : _complete est donc à jour au retour.
      await _magasin.restorePurchases();
    } catch (e) {
      debugPrint('[AchatPlay] Restauration impossible : $e');
    }
    return _complete;
  }

  Future<void> _traiter(List<PurchaseDetails> achats) async {
    for (final achat in achats) {
      if (achat.productID != idProduit) continue;
      switch (achat.status) {
        case PurchaseStatus.pending:
          _changer(EtatAchat.enAttente);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _complete = true;
          await _stockage.ecrireEditionComplete();
          _changer(EtatAchat.pret);
        case PurchaseStatus.error:
          debugPrint('[AchatPlay] Paiement refusé : ${achat.error}');
          _changer(EtatAchat.erreur);
        case PurchaseStatus.canceled:
          _changer(EtatAchat.pret);
      }
      // Sans cette confirmation, Google rembourse l'achat au bout de 3 jours.
      if (achat.pendingCompletePurchase) await _magasin.completePurchase(achat);
    }
  }

  void _changer(EtatAchat etat) {
    _etat = etat;
    notifyListeners();
  }

  @override
  void dispose() {
    _abonnement?.cancel();
    super.dispose();
  }
}
