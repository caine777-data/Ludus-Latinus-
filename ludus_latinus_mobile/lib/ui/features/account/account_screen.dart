import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../album/album_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../core/roman_diploma_dialog.dart';
import '../boutique/boutique_modal.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/services/audio_service.dart';
import '../../core/avatar_assets.dart';
import '../../../l10n/l10n.dart';

/// Écran Tabularium : profil de l'élève, trophées et sauvegarde par fichier (Style Monument Valley).
class AccountScreen extends StatefulWidget {
  final GameRepository repo;

  const AccountScreen({super.key, required this.repo});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.repo.profile.nomHeros;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Exporte la progression dans un fichier JSON choisi par l'élève.
  Future<void> _exportBackup() async {
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    String deux(int n) => n.toString().padLeft(2, '0');
    final nom = 'ludus_latinus_sauvegarde_${now.year}-${deux(now.month)}-${deux(now.day)}.json';
    final octets = Uint8List.fromList(utf8.encode(widget.repo.exportSauvegarde()));
    try {
      final destination = await FilePicker.saveFile(
        fileName: nom,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: octets,
      );
      // Annulé par l'élève : on n'affiche rien.
      if (destination == null) return;
      // Sur Windows, le plugin ne reçoit que le chemin et n'écrit pas toujours
      // les octets : on écrit nous-mêmes le fichier pour être sûr qu'il existe.
      if (Platform.isWindows && destination.scheme == 'file') {
        await File(destination.toFilePath()).writeAsBytes(octets, flush: true);
      }
      if (!mounted) return;
      AudioService().playSesterces();
      _afficherMessageSauvegarde(context.l10n.accountBackupExported, RomanColors.laurelGreen);
    } catch (_) {
      // Écriture impossible (dossier protégé, plugin absent) : rien n'a été exporté.
      if (!mounted) return;
      _afficherMessageSauvegarde(context.l10n.accountBackupExportFailed, Colors.redAccent);
    }
  }

  /// Importe une sauvegarde : choix du fichier, confirmation, puis remplacement.
  Future<void> _importBackup() async {
    HapticFeedback.lightImpact();
    String? contenu;
    try {
      final fichier = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      // Annulé par l'élève : on n'affiche rien.
      if (fichier == null) return;
      // file_picker 13 ne fournit plus `withData` : on lit le fichier choisi.
      contenu = utf8.decode(await fichier.readAsBytes());
    } catch (_) {
      contenu = null;
    }
    if (!mounted) return;
    // Fichier illisible ou qui n'est pas une sauvegarde : on le dit tout de
    // suite, sans demander de confirmer un remplacement qui échouerait.
    if (contenu == null || !widget.repo.estSauvegardeValide(contenu)) {
      _afficherMessageSauvegarde(context.l10n.accountBackupInvalid, Colors.redAccent);
      return;
    }

    // Le remplacement est définitif : on demande confirmation avant d'écraser.
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.accountBackupImportConfirmTitle),
        content: Text(ctx.l10n.accountBackupImportConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.accountBackupCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.accountBackupImportConfirm),
          ),
        ],
      ),
    );
    if (confirme != true || !mounted) return;

    if (widget.repo.importerSauvegarde(contenu)) {
      // Le nom du héros a pu changer : le champ de saisie doit le refléter.
      _nameController.text = widget.repo.profile.nomHeros;
      AudioService().playTriumph();
      setState(() {});
      _afficherMessageSauvegarde(context.l10n.accountBackupImported, RomanColors.laurelGreen);
    } else {
      _afficherMessageSauvegarde(context.l10n.accountBackupInvalid, Colors.redAccent);
    }
  }

  void _afficherMessageSauvegarde(String texte, Color couleur) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: couleur, content: Text(texte)),
    );
  }

  void _saveProfileChanges() {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      AudioService().playSesterces();
      widget.repo.updateProfileName(newName, widget.repo.profile.genre);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: RomanColors.imperialPurple,
          content: Text(context.l10n.accountProfileUpdated(newName)),
        ),
      );
    }
  }

  void _toggleGender() {
    HapticFeedback.selectionClick();
    AudioService().playCardFlip();
    final newGender = widget.repo.profile.genre == 'garcon' ? 'fille' : 'garcon';
    final currentName = widget.repo.profile.nomHeros;
    final String chosenName = (currentName == 'Marcus' || currentName == 'Julia')
        ? (newGender == 'garcon' ? 'Marcus' : 'Julia')
        : currentName;
    widget.repo.updateProfileName(chosenName, newGender);
    _nameController.text = chosenName;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repo,
      builder: (context, _) {
        final profile = widget.repo.profile;
        final avatarImg = AvatarAssets.medaillon(profile);

        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.accountTitle),
            actions: [
              if (GameRepository.modeSombreDisponible)
              IconButton(
                icon: Icon(
                  widget.repo.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: widget.repo.isDarkMode ? RomanColors.imperialGold : RomanColors.imperialPurple,
                ),
                tooltip: widget.repo.isDarkMode ? context.l10n.accountTooltipDayMode : context.l10n.accountTooltipNightMode,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  AudioService().playCardFlip();
                  widget.repo.toggleThemeMode();
                },
              ),
              IconButton(
                icon: const IconeBourse(taille: 26),
                tooltip: context.l10n.accountTooltipShop,
                onPressed: () => BoutiqueModal.show(context, repo: widget.repo),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, color: RomanColors.imperialPurple),
                tooltip: context.l10n.accountTooltipAudio,
                onPressed: () => RomanAudioModal.show(context),
              ),
            ],
          ),
          body: ColonneLecture(largeurMax: 900, child: ListView(
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
                                decoration: InputDecoration(
                                  labelText: context.l10n.accountCitizenName,
                                  labelStyle: const TextStyle(fontSize: 12),
                                  isDense: true,
                                  suffixIcon: const Icon(Icons.edit, size: 16),
                                ),
                                onSubmitted: (_) => _saveProfileChanges(),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.genre == 'fille'
                                    ? context.l10n.accountStudentFemaleHint
                                    : context.l10n.accountStudentMaleHint,
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
                    // Chaque statistique a un quart de la largeur et se réduit si besoin.
                    Row(
                      children: [
                        Expanded(child: _buildStatCol(context.l10n.accountStatLessons, '${profile.completedLessons.length}', '📜')),
                        Expanded(child: _buildStatCol(context.l10n.accountStatSesterces, context.l10n.accountSesterceAmount(profile.sesterces), '🪙')),
                        Expanded(child: _buildStatCol(context.l10n.accountStatStreak, context.l10n.accountDaysShort(profile.currentStreak()), '🔥')),
                        Expanded(child: _buildStatCol(context.l10n.accountStatMonuments, '${profile.restoredMonuments.length}/6', '🏛️')),
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
                        label: Text(
                          context.l10n.accountDiplomaButton,
                          style: const TextStyle(
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
                        // Le bouton est sous le texte : à côté, il écrasait la colonne.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.accountWardrobeTitle,
                                style: const TextStyle(
                                  fontFamily: RomanFonts.imperial,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: RomanColors.imperialPurple,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                context.l10n.accountTogeLine((profile.equippedGoodies['toge'] ?? 'lin blanc').replaceAll('_', ' '), profile.sesterces),
                                style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A5901), fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RomanColors.imperialPurple,
                            foregroundColor: RomanColors.goldLight,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: RomanColors.imperialGold, width: 1),
                            ),
                          ),
                          icon: const IconeBourse(taille: 18),
                          label: Text(
                            context.l10n.accountWardrobeButton,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => BoutiqueModal.show(context, repo: widget.repo),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Album « Héros et Créatures » (remplace les 5 trophées écrits en dur)
              ResumeAlbum(repo: widget.repo),

              const SizedBox(height: 16),

              // 3. Sauvegarde de la progression (export / import par fichier)
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
                    Row(
                      children: [
                        const Icon(Icons.save_alt_rounded, color: Color(0xFF7A5901), size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.accountBackupTitle,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A5901),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.accountBackupDescription,
                      style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    // Wrap : sur un écran étroit, le second bouton passe à la ligne.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RomanColors.imperialPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          ),
                          icon: const Icon(Icons.file_upload_outlined, size: 18),
                          label: Text(context.l10n.accountBackupExport),
                          onPressed: _exportBackup,
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: RomanColors.imperialPurple,
                            side: const BorderSide(color: RomanColors.imperialPurple),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          ),
                          icon: const Icon(Icons.file_download_outlined, size: 18),
                          label: Text(context.l10n.accountBackupImport),
                          onPressed: _importBackup,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          )),
        );
      },
    );
  }

  Widget _buildStatCol(String label, String value, String emoji) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
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
      ),
    );
  }
}
