import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/profile.dart';
import '../../data/models/cursus_honorum.dart';
import '../../data/services/audio_service.dart';
import 'themes.dart';
import 'roman_ornaments.dart';

/// Dialogue solennel de remise de Diplome Imperial du Senat Romain (Cursus Honorum).
class RomanDiplomaDialog extends StatelessWidget {
  final UserProfile profile;

  const RomanDiplomaDialog({super.key, required this.profile});

  /// Ouvre le diplome avec fanfare imperiale
  static void show(BuildContext context, {required UserProfile profile}) {
    AudioService().playTriumph();
    showDialog(
      context: context,
      builder: (_) => RomanDiplomaDialog(profile: profile),
    );
  }

  /// Calcule la date solennelle selon le calendrier romain antique (Anno Urbis Conditae)
  static String getAncientRomanDate() {
    final now = DateTime.now();
    // 753 av. J.-C. : Fondation de Rome (AUC)
    final aucYear = now.year + 753;
    const romanMonths = [
      'Ianuariis',
      'Februariis',
      'Martiis',
      'Aprilibus',
      'Maiis',
      'Iuniis',
      'Iuliis',
      'Augustis',
      'Septembribus',
      'Octobribus',
      'Novembribus',
      'Decembribus'
    ];
    final monthName = romanMonths[now.month - 1];

    // Chiffres romains pour l annee AUC
    String toRoman(int number) {
      const values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
      const symbols = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
      var result = '';
      var rem = number;
      for (var i = 0; i < values.length; i++) {
        while (rem >= values[i]) {
          result += symbols[i];
          rem -= values[i];
        }
      }
      return result;
    }

    final yearRoman = toRoman(aucYear);
    return 'Die \ mensis \ • Anno \ Urbis Conditae';
  }

  @override
  Widget build(BuildContext context) {
    final rank = profile.cursusRank;
    final isFille = profile.genre == 'fille';
    final dateRomaine = getAncientRomanDate();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF6EB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RomanColors.imperialGold, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 28,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: Stack(
            children: [
              // Frise decorative d angle
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 10,
                  decoration: const BoxDecoration(
                    color: RomanColors.imperialPurple,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),

                    // En-tete officiel du Senat
                    const Text(
                      'SENATVS·POPVLVSQVE·ROMANVS',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: RomanColors.imperialPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'CONSVLTVM DE DOCTRINA LATINA',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                        color: RomanColors.goldDark,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),
                    const RomanMeanderDivider(height: 14, strokeWidth: 1.4),
                    const SizedBox(height: 12),

                    // Titre du Diplome
                    const Text(
                      'DIPLOMA HONORIFICVM',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFF3B1E08),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),
                    Text(
                      'Par la volonte souveraine du Senat et du Peuple de Rome, '
                      'il est solennellement atteste et proclame que :',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 11.5,
                        color: Colors.brown.shade800,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    // Nom de l eleve en grande typographie lapidaire
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: RomanColors.goldLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                      ),
                      child: Text(
                        (isFille ? 'NOBILIS DISCIPVLA ' : 'NOBILIS DISCIPVLVS ') + profile.nomHeros.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: RomanColors.imperialPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Titre honorifique atteint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(rank.badge, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rank.titre.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B1D0E),
                              ),
                            ),
                            Text(
                              rank.description,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF6E563B)),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tableau des accomplissements civiques
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RomanColors.marbleBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('📖 Leçons', ''),
                          _buildStatItem('🏛️ Forum', ''),
                          _buildStatItem('🪙 Trésor', '\ HS'),
                          _buildStatItem('🔥 Ferveur', '\ j'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date latine gravee
                    Text(
                      dateRomaine,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: RomanColors.charcoal,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    // Sceau de cire 3D et signatures des Consuls
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Signature Consul 1
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'M. Tullius Cicero',
                                style: TextStyle(fontFamily: 'serif', fontStyle: FontStyle.italic, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text('Consul Romanus', style: TextStyle(fontSize: 9.5, color: Colors.black54)),
                            ],
                          ),
                        ),

                        // Grand Sceau de Cire Imperial 3D
                        RomanWaxSeal(
                          size: 64,
                          label: 'SPQR',
                          sealColor: Color(0xFF91141E),
                          stampColor: Color(0xFFFFD966),
                        ),

                        // Signature Consul 2
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'C. Julius Caesar',
                                style: TextStyle(fontFamily: 'serif', fontStyle: FontStyle.italic, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text('Pontifex Maximus', style: TextStyle(fontSize: 9.5, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const RomanMeanderDivider(height: 12, strokeWidth: 1.2),
                    const SizedBox(height: 12),

                    // Boutons d action
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: RomanColors.imperialPurple,
                              side: const BorderSide(color: RomanColors.imperialPurple),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text('Copier l\'Eloge', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              final eloge = '🏛️ DIPLÔME DU SÉNAT ROMAIN (SPQR)\n'
                                  'Proclamé pour : \
'
                                  'Rang du Cursus Honorum : \
'
                                  'Accomplissements : \ leçons maîtrisées, '
                                  '\ monuments restaurés au Forum.\n'
                                  '';
                              Clipboard.setData(ClipboardData(text: eloge));
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('📜 Éloge impérial copié dans le presse-papier !'),
                                  backgroundColor: RomanColors.laurelGreen,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RomanColors.imperialGold,
                              foregroundColor: const Color(0xFF1F150A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Reconnaissance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bouton Fermer d angle
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: RomanColors.charcoal),
                  tooltip: 'Fermer',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: RomanColors.imperialPurple)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }
}
