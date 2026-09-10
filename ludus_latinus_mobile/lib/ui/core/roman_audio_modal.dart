import 'package:flutter/material.dart';
import 'themes.dart';
import 'roman_ornaments.dart';
import '../../data/services/audio_service.dart';

/// Modale de réglage et de banc d'essai sonore antique pour Ludus Latinus.
/// Habillée avec le parchemin d'Herculanum, les méandres romains et les sceaux impériaux.
class RomanAudioModal extends StatefulWidget {
  const RomanAudioModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RomanAudioModal(),
    );
  }

  @override
  State<RomanAudioModal> createState() => _RomanAudioModalState();
}

class _RomanAudioModalState extends State<RomanAudioModal> {
  final AudioService _audio = AudioService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: RomanColors.palatinCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 24,
            offset: Offset(0, -6),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée supérieure antique
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: RomanColors.marbleBorder.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // En-tête avec Sceau de Cire et Titre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const RomanWaxSeal(
                    size: 40,
                    label: 'SON',
                    sealColor: Color(0xFF8B1A1A),
                    stampColor: Color(0xFFFFDF85),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HARMONIA ANTIQUA',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: RomanColors.imperialPurple,
                          ),
                        ),
                        Text(
                          "Sons & Résonances de l'Empire",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: RomanColors.charcoal,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: RomanColors.imperialPurple),
                    tooltip: 'Fermer',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const RomanMeanderDivider(height: 14, color: RomanColors.imperialGold),
            const SizedBox(height: 8),

            // Corps défilable
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1 : Contrôles Maîtres (Mute & Volume & Haptique)
                    RomanParchmentCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Interrupteur Sourdine
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _audio.isMuted
                                      ? Colors.red.withOpacity(0.12)
                                      : RomanColors.imperialGold.withOpacity(0.16),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _audio.isMuted
                                      ? Icons.volume_off_rounded
                                      : Icons.volume_up_rounded,
                                  color: _audio.isMuted
                                      ? Colors.red.shade700
                                      : RomanColors.goldDark,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sonorités de Rome',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: RomanColors.imperialPurple,
                                      ),
                                    ),
                                    Text(
                                      _audio.isMuted
                                          ? 'Sourdine activée (silence du temple)'
                                          : 'Bruitages authentiques actifs',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: RomanColors.charcoal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: !_audio.isMuted,
                                activeColor: RomanColors.goldDark,
                                onChanged: (active) {
                                  setState(() {
                                    _audio.toggleMute();
                                  });
                                  if (active) {
                                    _audio.playSesterces();
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          const Divider(color: RomanColors.marbleBorder, height: 1),
                          const SizedBox(height: 14),

                          // Curseur de Volume Maître
                          Row(
                            children: [
                              Text(
                                'Volume Maître',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: RomanColors.imperialPurple,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: RomanColors.imperialGold.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: RomanColors.imperialGold, width: 0.8),
                                ),
                                child: Text(
                                  _audio.isMuted ? '0%' : '${(_audio.volume * 100).round()}%',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: RomanColors.goldDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: RomanColors.goldDark,
                              inactiveTrackColor: RomanColors.marbleBorder.withOpacity(0.4),
                              thumbColor: RomanColors.imperialGold,
                              overlayColor: RomanColors.imperialGold.withOpacity(0.2),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: _audio.volume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: _audio.isMuted
                                  ? null
                                  : (v) {
                                      setState(() {
                                        _audio.setVolume(v);
                                      });
                                    },
                              onChangeEnd: (v) {
                                _audio.playCoinTick();
                              },
                            ),
                          ),

                          const SizedBox(height: 6),
                          const Divider(color: RomanColors.marbleBorder, height: 1),
                          const SizedBox(height: 14),

                          // Interrupteur Retours Tactiles & Vibrations
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: RomanColors.imperialPurple.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.vibration_rounded,
                                  color: RomanColors.imperialPurple,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Retours Haptiques',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: RomanColors.imperialPurple,
                                      ),
                                    ),
                                    Text(
                                      _audio.hapticsEnabled
                                          ? 'Vibrations du glaive & des victoires'
                                          : 'Vibrations désactivées',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: RomanColors.charcoal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: _audio.hapticsEnabled,
                                activeColor: RomanColors.goldDark,
                                onChanged: (active) {
                                  setState(() {
                                    _audio.setHapticsEnabled(active);
                                  });
                                  if (active) {
                                    _audio.playCoinTick();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Section 2 : Banc d'Essai Sonore (Soundboard Antique)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.music_note_rounded, size: 18, color: RomanColors.goldDark),
                          const SizedBox(width: 6),
                          Text(
                            "BANC D'ESSAI ACOUSTIQUE",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildSoundboardList(context),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundboardList(BuildContext context) {
    final sounds = [
      {
        'title': "Sesterces d'Or",
        'subtitle': 'Tintement de pièces impériales',
        'icon': Icons.monetization_on_rounded,
        'action': () => _audio.playSesterces(),
      },
      {
        'title': 'Alea & Fritillus',
        'subtitle': 'Roulement des osselets et dés',
        'icon': Icons.casino_rounded,
        'action': () => _audio.playDiceRoll(),
      },
      {
        'title': 'Fanfare de Triomphe',
        'subtitle': 'Tubae & buccinae de victoire',
        'icon': Icons.emoji_events_rounded,
        'action': () => _audio.playTriumph(),
      },
      {
        'title': 'Colosseum',
        'subtitle': 'Clameur de la plèbe romaine',
        'icon': Icons.stadium_rounded,
        'action': () => _audio.playCrowdCheer(),
      },
      {
        'title': 'Glaive & Scutum',
        'subtitle': "Choc métallique d'acier et bronze",
        'icon': Icons.shield_rounded,
        'action': () => _audio.playSwordClash(),
      },
      {
        'title': 'Roue de César',
        'subtitle': 'Engrenage mécanique chiffré',
        'icon': Icons.settings_suggest_rounded,
        'action': () => _audio.playWheelClick(),
      },
      {
        'title': 'Parchemin & Carte',
        'subtitle': 'Froissement velouté du vélin',
        'icon': Icons.history_edu_rounded,
        'action': () => _audio.playCardFlip(),
      },
    ];

    return Column(
      children: sounds.map((s) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: s['action'] as VoidCallback,
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: RomanColors.marbleBorder.withOpacity(0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: RomanColors.imperialGold.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        s['icon'] as IconData,
                        color: RomanColors.goldDark,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: RomanColors.imperialPurple,
                            ),
                          ),
                          Text(
                            s['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: RomanColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: RomanColors.goldDark,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
