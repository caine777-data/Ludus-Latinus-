import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/themes.dart';
import '../../core/widgets.dart';
import '../../../data/repositories/game_repository.dart';

/// Écran Tabularium : Compte Cloud, Tessera Hospitalis et profil de l''élève.
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
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    widget.repo.profile.lastSyncDate = DateTime.now().toString().substring(0, 16);
    widget.repo.storageService.saveProfile(widget.repo.profile);
    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: RomanColors.laurelGreen,
          content: Text('⚡ Parchemins synchronisés avec le Tabularium Cloud !'),
        ),
      );
    }
  }

  void _saveProfileChanges() {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      widget.repo.updateProfileName(newName, widget.repo.profile.genre);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: RomanColors.imperialPurple,
          content: Text('Profil mis à jour : Salve,  !'),
        ),
      );
    }
  }

  void _toggleGender() {
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

        return Scaffold(
          appBar: AppBar(
            title: const Text('🏛️ TABULARIUM'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Identité du Citoyen
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RomanColors.travertinWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RomanColors.imperialGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleGender,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: RomanColors.goldLight,
                                  border: Border.all(color: RomanColors.imperialGold, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    profile.genre == 'fille' ? '👸' : '🤴',
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: RomanColors.imperialPurple,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.sync, size: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _nameController,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                                profile.genre == 'fille' ? 'Élève Julia (Fille)' : 'Élève Marcus (Garçon)',
                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCol('Leçons', '', '📜'),
                        _buildStatCol('Sesterces', ' HS', '🪙'),
                        _buildStatCol('Série', ' j', '🔥'),
                        _buildStatCol('Monuments', '', '🏛️'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Compte Tabularium Cloud (Mail & Sync)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_done_outlined, color: RomanColors.imperialPurple, size: 22),
                        const SizedBox(width: 8),
                        const Text(
                          'Sauvegarde & Compte Cloud',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: RomanColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Associez votre adresse email pour sauvegarder votre progression sur les serveurs du Tabularium et jouer sur plusieurs appareils.',
                      style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Adresse courriel (email)',
                        hintText: 'eleve@latin.ac-paris.fr',
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: _isSyncing
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.cloud_upload_outlined),
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
                          'Dernière synchronisation : ',
                          style: const TextStyle(fontSize: 11, color: Colors.black54, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Tessera Hospitalis (Transfert instantané)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC59B27), width: 1.2),
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A5901),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ce code secret permet de transférer immédiatement tous vos progrès vers un téléphone Android, une tablette ou votre ordinateur de classe.',
                      style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: RomanColors.imperialGold),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            profile.tesseraCode,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: RomanColors.charcoal,
                              fontFamily: 'monospace',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: RomanColors.imperialPurple, size: 20),
                            tooltip: 'Copier la Tessera',
                            onPressed: () {
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: RomanColors.imperialPurple,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}