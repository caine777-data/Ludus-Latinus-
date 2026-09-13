import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/particles_overlay.dart';
import '../../core/roman_ornaments.dart';
import '../../core/roman_audio_modal.dart';
import '../../core/roman_diploma_dialog.dart';
import '../boutique/boutique_modal.dart';
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
                icon: const Icon(Icons.shopping_bag_outlined, color: RomanColors.imperialPurple, size: 24),
                tooltip: 'Taberna Romana (Boutique de Goodies)',
                onPressed: () => BoutiqueModal.show(context, repo: widget.repo),
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

              const SizedBox(height: 14),

              // 1.5 Taberna & Penderie Impériale (Boutique de Goodies)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => BoutiqueModal.show(context, repo: widget.repo),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFFDF8), Color(0xFFFBF4E8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: RomanColors.imperialGold, width: 1.4),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0E3D1A10), blurRadius: 8, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: RomanColors.goldLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: RomanColors.imperialGold, width: 1.2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/animated/lupulus_salut.webp',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Text('🏛️', style: TextStyle(fontSize: 22)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Taberna & Vestiaire Impérial',
                                style: TextStyle(
                                  fontFamily: RomanFonts.imperial,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: RomanColors.imperialPurple,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Toge : ${(profile.equippedGoodies['toge'] ?? 'lin blanc').replaceAll('_', ' ')} • ${profile.sesterces} HS',
                                style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A5901), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RomanColors.imperialPurple,
                            foregroundColor: RomanColors.goldLight,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: RomanColors.imperialGold, width: 1),
                            ),
                          ),
                          icon: const Icon(Icons.shopping_bag_outlined, size: 16, color: RomanColors.goldLight),
                          label: const Text(
                            'Vestiaire',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => BoutiqueModal.show(context, repo: widget.repo),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Vitrine des Trophées & Médaillons Débloqués sur Piédestaux en Marbre
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RomanColors.marbleBorder, width: 1.2),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0C000000), blurRadius: 8, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                        Text(
                          'Touche un piédestal',
                          style: TextStyle(fontSize: 10, color: Colors.black45, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTrophyItem(
                          iconPath: 'assets/images/trophee_triomphe_medaillon_130.png',
                          title: 'Premier Pas',
                          romanNum: 'I',
                          condition: 'Terminer ta toute première leçon de latin.',
                          unlocked: profile.completedLessons.isNotEmpty,
                        ),
                        _buildTrophyItem(
                          iconPath: 'assets/images/logo_centurion_64.png',
                          title: 'Centurion',
                          romanNum: 'V',
                          condition: 'Valider 5 leçons complètes du Ludus.',
                          unlocked: profile.completedLessons.length >= 5,
                        ),
                        _buildTrophyItem(
                          iconPath: 'assets/images/musee_circus.png',
                          title: 'Aurige',
                          romanNum: 'III',
                          condition: 'Atteindre une série de 3 jours consécutifs.',
                          unlocked: profile.streakDays >= 3,
                        ),
                        _buildTrophyItem(
                          iconPath: 'assets/images/musee_louve.png',
                          title: 'Bâtisseur',
                          romanNum: 'X',
                          condition: 'Restaurer au moins un monument du Forum.',
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
    required String romanNum,
    required String condition,
    required bool unlocked,
  }) {
    return RomanPedestal(
      width: 68,
      inscription: romanNum,
      isUnlocked: unlocked,
      glowColor: RomanColors.imperialGold,
      onTap: () {
        HapticFeedback.mediumImpact();
        if (unlocked) {
          AudioService().playTriumph();
          RomanParticlesOverlay.show(context, type: ParticleType.laurelRain);
          _showTrophyDialog(
            title: title,
            romanNum: romanNum,
            condition: condition,
            unlocked: true,
            iconPath: iconPath,
          );
        } else {
          AudioService().playError();
          _showTrophyDialog(
            title: title,
            romanNum: romanNum,
            condition: condition,
            unlocked: false,
            iconPath: iconPath,
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Médaillon avec couronne de laurier dorée
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unlocked ? RomanColors.goldLight : const Color(0xFFE0E0E0),
                  border: Border.all(
                    color: unlocked ? RomanColors.imperialGold : Colors.black26,
                    width: unlocked ? 2.0 : 1.2,
                  ),
                  boxShadow: unlocked
                      ? const [
                          BoxShadow(
                            color: Color(0x33B8860B),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
                child: ClipOval(
                  child: Opacity(
                    opacity: unlocked ? 1.0 : 0.35,
                    child: Image.asset(
                      iconPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text('🏆', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                  ),
                ),
              ),
              if (!unlocked)
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x44000000),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock_rounded, color: Colors.white70, size: 18),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
                color: unlocked ? RomanColors.charcoal : Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTrophyDialog({
    required String title,
    required String romanNum,
    required String condition,
    required bool unlocked,
    required String iconPath,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFDF8), Color(0xFFF7EEDC), Color(0xFFECE0C9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: unlocked ? RomanColors.imperialGold : RomanColors.marbleBorder,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), offset: Offset(0, 8), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const RomanWaxSeal(size: 34, label: 'SPQR'),
                  const SizedBox(width: 8),
                  Text(
                    'TROPHÆVM $romanNum',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: RomanColors.imperialPurple,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unlocked ? RomanColors.goldLight : Colors.black12,
                  border: Border.all(
                    color: unlocked ? RomanColors.imperialGold : Colors.black26,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Opacity(
                    opacity: unlocked ? 1.0 : 0.35,
                    child: Image.asset(
                      iconPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text('🏆', style: TextStyle(fontSize: 32)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                  color: RomanColors.charcoal,
                ),
              ),
              const SizedBox(height: 6),
              const RomanMeanderDivider(
                height: 8,
                strokeWidth: 0.9,
                color: RomanColors.imperialGold,
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: unlocked ? const Color(0x184CAF50) : const Color(0x18000000),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: unlocked ? Colors.green.shade600 : Colors.black26,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      unlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                      color: unlocked ? Colors.green.shade700 : Colors.black54,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        unlocked ? 'Trophée débloqué et exposé au Panthéon !' : 'Condition : $condition',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: unlocked ? Colors.green.shade800 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RomanColors.imperialPurple,
                  foregroundColor: RomanColors.goldLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: RomanColors.imperialGold),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OPTICAS GRACIAS (Fermer)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}