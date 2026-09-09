import 'package:flutter/material.dart';
import '../../core/themes.dart';
import '../../../data/models/world.dart';
import '../../../data/models/lesson.dart';
import '../../../data/repositories/game_repository.dart';
import '../lesson/lesson_screen.dart';

/// La Carte d'Aventure de la Via Appia tactile verticale adaptée au smartphone.
class MapScreen extends StatelessWidget {
  final GameRepository repo;

  const MapScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final worlds = repo.worlds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛣️ VIA APPIA PANORAMIQUE'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '🪙 ${repo.profile.sesterces} HS',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB8860B),
                ),
              ),
            ),
          ),
        ],
      ),
      body: worlds.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: worlds.length,
              itemBuilder: (context, index) {
                final world = worlds[index];
                return _buildWorldSection(context, world, index);
              },
            ),
    );
  }

  Widget _buildWorldSection(BuildContext context, World world, int worldIndex) {
    return Column(
      children: [
        // 🏛️ Arc de Triomphe Monumental entre les mondes
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [RomanColors.imperialPurple, Color(0xFF5A1400)],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: RomanColors.imperialGold, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3),
                blurRadius: 4,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏛️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  world.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Étapes milliaires romaines le long de la chaussée
        ...List.generate(world.lessons.length, (lessonIndex) {
          final lesson = world.lessons[lessonIndex];
          final isCompleted = repo.isLessonCompleted(lesson.id);
          final isUnlocked = isCompleted ||
              lessonIndex == 0 ||
              repo.isLessonCompleted(world.lessons[lessonIndex - 1].id);

          // Alternance visuelle gauche / centre / droite pour créer le serpentin
          final double offsetFactor = (lessonIndex % 3 == 0)
              ? -40
              : (lessonIndex % 3 == 1)
                  ? 40
                  : 0;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Transform.translate(
              offset: Offset(offsetFactor, 0),
              child: _buildMilestoneNode(
                context,
                lesson: lesson,
                index: lessonIndex + 1,
                isCompleted: isCompleted,
                isUnlocked: isUnlocked,
              ),
            ),
          );
        }),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMilestoneNode(
    BuildContext context, {
    required Lesson lesson,
    required int index,
    required bool isCompleted,
    required bool isUnlocked,
  }) {
    Color bg = isCompleted
        ? RomanColors.laurelGreen
        : isUnlocked
            ? RomanColors.imperialGold
            : const Color(0xFF9E9E9E);

    return InkWell(
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonScreen(repo: repo, lesson: lesson),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(35),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bg,
              border: Border.all(
                color: isUnlocked ? Colors.white : Colors.black26,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isUnlocked ? Colors.black38 : Colors.black12,
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 30)
                  : isUnlocked
                      ? Text(
                          _toRoman(index),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1409),
                          ),
                        )
                      : const Icon(Icons.lock, color: Colors.white70, size: 24),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12),
            ),
            child: Text(
              lesson.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                color: isUnlocked ? Colors.black87 : Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _toRoman(int n) {
    const map = [
      [10, 'X'],
      [9, 'IX'],
      [5, 'V'],
      [4, 'IV'],
      [1, 'I'],
    ];
    String res = '';
    for (var pair in map) {
      int val = pair[0] as int;
      String sym = pair[1] as String;
      while (n >= val) {
        res += sym;
        n -= val;
      }
    }
    return res.isEmpty ? '$n' : res;
  }
}
