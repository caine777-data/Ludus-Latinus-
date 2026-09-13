import 'package:flutter/material.dart';
import 'themes.dart';

/// Rendu du Markdown des leçons (titres, gras, italique, listes, tableaux).
///
/// Le contenu est rédigé côté Python puis exporté dans le dataset : il
/// n'utilise que ce sous-ensemble, d'où un rendu dédié plutôt qu'un paquet.
class MarkdownLite extends StatelessWidget {
  final String data;
  final double fontSize;
  final Color color;

  const MarkdownLite(
    this.data, {
    super.key,
    this.fontSize = 14.5,
    this.color = RomanColors.charcoal,
  });

  /// Texte sans balises, pour les aperçus d'une ligne ou deux.
  static String plainText(String markdown) {
    return markdown
        .split('\n')
        .where((l) => !_isTableSeparator(l.trim()) && !RegExp(r'^\s*#{1,6}\s').hasMatch(l))
        .map((l) => l
            .replaceFirst(RegExp(r'^\s*[-•]\s+'), '')
            .replaceAll('|', ' ')
            .replaceAll('**', '')
            .replaceAll('*', '')
            .trim())
        .where((l) => l.isNotEmpty)
        .join(' ');
  }

  static bool _isTableSeparator(String line) =>
      line.startsWith('|') && RegExp(r'^\|[\s:\-|]+\|?$').hasMatch(line);

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final lines = data.replaceAll('\r\n', '\n').split('\n');
    final paragraph = <String>[];

    void flushParagraph() {
      if (paragraph.isEmpty) return;
      blocks.add(_rich(paragraph.join(' '), TextStyle(fontSize: fontSize, height: 1.5, color: color)));
      paragraph.clear();
    }

    var i = 0;
    while (i < lines.length) {
      final raw = lines[i];
      final line = raw.trim();

      if (line.isEmpty) {
        flushParagraph();
        i++;
        continue;
      }

      final heading = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(line);
      if (heading != null) {
        flushParagraph();
        final level = heading.group(1)!.length;
        blocks.add(Padding(
          padding: EdgeInsets.only(top: blocks.isEmpty ? 0 : 10),
          child: _rich(
            heading.group(2)!,
            TextStyle(
              fontSize: level <= 2 ? fontSize + 3 : fontSize + 1.5,
              height: 1.3,
              fontWeight: FontWeight.bold,
              color: RomanColors.imperialPurple,
            ),
          ),
        ));
        i++;
        continue;
      }

      if (line.startsWith('|')) {
        flushParagraph();
        final rows = <List<String>>[];
        while (i < lines.length && lines[i].trim().startsWith('|')) {
          final l = lines[i].trim();
          if (!_isTableSeparator(l)) {
            final cells = l.split('|').map((c) => c.trim()).toList();
            if (cells.isNotEmpty && cells.first.isEmpty) cells.removeAt(0);
            if (cells.isNotEmpty && cells.last.isEmpty) cells.removeLast();
            rows.add(cells);
          }
          i++;
        }
        blocks.add(_table(rows));
        continue;
      }

      final bullet = RegExp(r'^[-•]\s+(.*)$').firstMatch(line);
      final numbered = RegExp(r'^(\d+)\.\s+(.*)$').firstMatch(line);
      if (bullet != null || numbered != null) {
        flushParagraph();
        final marker = bullet != null ? '•' : '${numbered!.group(1)}.';
        final text = bullet != null ? bullet.group(1)! : numbered!.group(2)!;
        blocks.add(Padding(
          padding: const EdgeInsets.only(left: 4, top: 2, bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 22,
                child: Text(marker,
                    style: TextStyle(
                        fontSize: fontSize, height: 1.5, fontWeight: FontWeight.bold, color: RomanColors.imperialGold)),
              ),
              Expanded(child: _rich(text, TextStyle(fontSize: fontSize, height: 1.5, color: color))),
            ],
          ),
        ));
        i++;
        continue;
      }

      paragraph.add(line);
      i++;
    }
    flushParagraph();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final b in blocks) Padding(padding: const EdgeInsets.only(bottom: 8), child: b),
      ],
    );
  }

  Widget _rich(String text, TextStyle base) {
    return Text.rich(TextSpan(style: base, children: _inline(text)));
  }

  /// Gras (**…**) et italique (*…*), éventuellement imbriqués.
  List<InlineSpan> _inline(String text) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*');
    var last = 0;
    for (final m in pattern.allMatches(text)) {
      if (m.start > last) spans.add(TextSpan(text: text.substring(last, m.start)));
      if (m.group(1) != null) {
        spans.add(TextSpan(
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: _inline(m.group(1)!),
        ));
      } else {
        spans.add(TextSpan(
          style: const TextStyle(fontStyle: FontStyle.italic),
          children: _inline(m.group(2)!),
        ));
      }
      last = m.end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last)));
    return spans;
  }

  Widget _table(List<List<String>> rows) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final columns = rows.map((r) => r.length).reduce((a, b) => a > b ? a : b);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder.all(color: RomanColors.marbleBorder, width: 1),
        children: [
          for (var r = 0; r < rows.length; r++)
            TableRow(
              decoration: BoxDecoration(color: r == 0 ? RomanColors.goldLight : Colors.white),
              children: [
                for (var c = 0; c < columns; c++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: _rich(
                      c < rows[r].length ? rows[r][c] : '',
                      TextStyle(
                        fontSize: fontSize - 1,
                        height: 1.35,
                        color: color,
                        fontWeight: r == 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
