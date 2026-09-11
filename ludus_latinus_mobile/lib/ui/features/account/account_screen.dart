import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/roman_ornaments.dart';
import '../../core/roman_audio_modal.dart';
import '../../core/roman_diploma_dialog.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';

/// Écran Tabularium : Compte Cloud, Tessera Hospitalis et profil de l''élève (Style Monument Valley).
class AccountScreen extends StatefulWidget {
  final GameRepository repo;

  const AccountScreen({super.key, required this.repo});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.repo.profile.email;
    _nameController.text = widget.repo.profile.nomHeros;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _syncNow() async {
    HapticFeedback.mediumImpact();
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    widget.repo.profile.lastSyncDate = DateTime.now().toString().substring(0, 16);
    widget.repo.storageService.saveProfile(widget.repo.profile);
    if (mounted) {
      setState(() => _isSyncing = false);
      HapticFeedback.heavyImpact();
      AudioService().playTriumph();
      RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: RomanColors.laurelGreen,
          content: Text('⚡ Parchemins synchronisés avec les archives du Tabularium !'),
        ),
      );
    }
  }

  void _saveProfileChanges() {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      AudioService().playSesterces();
      widget.repo.updateProfileName(newName, widget.repo.profile.genre);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: RomanColors.imperialPurple,
          content: Text('Profil mis à jour : Salve, $newName !'),
        ),
      );
    }
  }

  void _toggleGender() {
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    final newGender = widget.repo.profile.genre == 'garcon' ? 'fille' : 'garcon';
    final defaultName = newGender == 'garcon' ? 'Marcus' : 'Julia';
    widget.repo.updateProfileName(defaultName, newGender);
    _nameController.text = defaultName;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        final profile = widget.repo.profile;
        final avatarImg = profile.genre == 'fille'
            ? 'assets/images/avatar_fille_medaillon_140.png'
            : 'assets/images/avatar_garcon_medaillon_140.png';

        return Scaffold(
          appBar: AppBar(
            title: const Text('TABULARIUM'),
            actions: [
              IconButton(
                icon: Icon(
                  widget.repo.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: widget.repo.isDarkMode ? RomanColors.imperialGold : RomanColors.imperialPurple,
                ),
                tooltip: widget.repo.isDarkMode ? 'Mode Lux Romana (Jour)' : 'Mode Noctis Romana (Nuit)',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  AudioService().playCardFlip();
                  widget.repo.toggleThemeMode();
                },
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialPurple),
                tooltip: 'Harmonia Antiqua (Réglages Audio & Bruitages)',
                onPressed: () => RomanAudioModal.show(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Tablette de Cire Antique & Diplôme Impérial (Tabula Cerata)
              RomanParchmentCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleGender,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              RomanMedallion(
                                imagePath: avatarImg,
                                size: 70,
                                fallbackEmoji: profile.genre == 'fille' ? '👸' : '🤴',
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: RomanColors.imperialPurple,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.cached_rounded, size: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _nameController,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'serif',
                                  color: RomanColors.imperialPurple,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Nom du citoyen',
                                  labelStyle: TextStyle(fontSize: 12),
                                  isDense: true,
                                  suffixIcon: Icon(Icons.edit, size: 16),
                                ),
                                onSubmitted: (_) => _saveProfileChanges(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.genre == 'fille'
                                    ? 'Élève Julia • Touche l''avatar pour changer'
                                    : 'Élève Marcus • Touche l''avatar pour changer',
                                style: const TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const RomanWaxSeal(size: 54, label: 'SPQR'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const RomanMeanderDivider(height: 10, strokeWidth: 1.2, margin: EdgeInsets.symmetric(vertical: 4)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCol('Leçons', '${profile.completedLessons.length}', '📜'),
                        _buildStatCol('Sesterces', '${profile.sesterces} HS', '🪙'),
                        _buildStatCol('Série', '${profile.streakDays} j', '🔥'),
                        _buildStatCol('Monuments', '${profile.restoredMonuments.length}/6', '🏛️'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RomanColors.imperialPurple,
                          foregroundColor: RomanColors.goldLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: RomanColors.imperialGold, width: 1.2),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        icon: const Icon(Icons.workspace_premium_rounded, color: RomanColors.imperialGold, size: 20),
                        label: const Text(
                          'DIPLÔME DU SÉNAT • TESTIMONIVM (SPQR)',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        onPressed: () => RomanDiplomaDialog.show(context, profile: profile),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Vitrine des Trophées & Médaillons Débloqués
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('🏆 ', style: TextStyle(fontSize: 18)),
                        Text(
                          'Panthéon des Trophées',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                            color: RomanColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTrophyItem(
                          iconPath: 'assets/images/trophee_triomphe_medaillon_130.png',
                          title: 'Premier Pas',
                          unlocked: profile.completedLessons.isNotEmpty,
                        ),
                        _buildTrophyItem(
                          iconPath: 'assets/images/logo_centurion_64.png',
                          title: 'Centurion',
                          unlocked: profile.completedLessons.length >= 5,
                        ),
                        _buildTrophyItem(
                          iconPath: 'assets/images/musee_circus.png',
                          title: 'Aurige',
                          unlocked: profile.streakDays >= 3,
                        ),
                        _buildTrophyItem(
                          iconPath: 'assets/images/musee_louve.png',
                          title: 'Bâtisseur',
                          unlocked: profile.restoredMonuments.isNotEmpty,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Tessera Hospitalis (Jeton de Transfert Express)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('🏛️ ', style: TextStyle(fontSize: 18)),
                        Text(
                          'Tessera Hospitalis (Jeton d’Hospitalité)',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A5901),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ce jeton secret permet de transférer immédiatement tous tes progrès vers un smartphone, une tablette ou ton ordinateur en classe.',
                      style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RomanColors.imperialGold),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            profile.tesseraCode,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: RomanColors.charcoal,
                              fontFamily: 'monospace',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, color: RomanColors.imperialPurple, size: 20),
                            tooltip: 'Copier la Tessera',
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              AudioService().playSesterces();
                              Clipboard.setData(ClipboardData(text: profile.tesseraCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: RomanColors.imperialPurple,
                                  content: Text('Tessera Hospitalis copiée dans le presse-papier !'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Compte Tabularium Cloud (Mail & Sync)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud_done_outlined, color: RomanColors.imperialPurple, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Sauvegarde & Compte Cloud',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: RomanColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Associe ton adresse courriel pour sauvegarder ta progression sur les serveurs du Tabularium.',
                      style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Adresse courriel (email)',
                        hintText: 'eleve@latin.ac-paris.fr',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RomanColors.imperialPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 11),
                            ),
                            icon: _isSyncing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.cloud_upload_outlined, size: 18),
                            label: Text(_isSyncing ? 'Synchronisation...' : 'Enregistrer & Synchroniser'),
                            onPressed: _isSyncing
                                ? null
                                : () {
                                    final mail = _emailController.text.trim();
                                    if (mail.isNotEmpty && mail.contains('@')) {
                                      widget.repo.registerAccount(mail);
                                      _syncNow();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text('Veuillez saisir une adresse courriel valide.'),
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                    if (profile.lastSyncDate != null) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Dernière synchronisation : ${profile.lastSyncDate != null && profile.lastSyncDate!.length >= 16 ? profile.lastSyncDate!.substring(0, 16).replaceAll('T', ' à ') : (profile.lastSyncDate ?? 'Jamais')}',
                          style: const TextStyle(fontSize: 11, color: Colors.black54, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCol(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: RomanColors.imperialPurple,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildTrophyItem({
    required String iconPath,
    required String title,
    required bool unlocked,
  }) {
    return GestureDetector(
      onTap: () {
        if (unlocked) {
          AudioService().playTriumph();
          RomanParticlesOverlay.show(context, type: ParticleType.marbleSparks);
        } else {
          AudioService().playError();
        }
      },
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked ? RomanColors.goldLight : Colors.black12,
              border: Border.all(
                color: unlocked ? RomanColors.imperialGold : Colors.black26,
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: Opacity(
                opacity: unlocked ? 1.0 : 0.35,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(child: Text('🏆')),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
                color: unlocked ? RomanColors.charcoal : Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}