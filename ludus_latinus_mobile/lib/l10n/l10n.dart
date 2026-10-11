import 'package:flutter/widgets.dart';

import 'app_localizations.dart';
import 'app_localizations_fr.dart';

export 'app_localizations.dart';

/// Accès court aux textes de l'interface : `context.l10n.homeTitle`.
///
/// Si le contexte n'a pas de délégué (un widget monté sans `MaterialApp`
/// localisé, par exemple dans un test), on retombe sur le français.
extension L10nContext on BuildContext {
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      AppLocalizationsFr();
}
