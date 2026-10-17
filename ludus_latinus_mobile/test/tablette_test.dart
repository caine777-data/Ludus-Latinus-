import 'package:flutter_test/flutter_test.dart';
import 'package:ludus_latinus_mobile/ui/features/lesson/lesson_screen.dart';

void main() {
  test('Bandeau de leçon : 140 points sur téléphone, plus haut sur tablette, plafonné', () {
    expect(hauteurBandeau(360), 140);
    expect(hauteurBandeau(411), 140);
    expect(hauteurBandeau(599), 140);
    // Petite tablette : colonne de 640 - 32 points, rapport 2,4.
    expect(hauteurBandeau(640), closeTo(608 / 2.4, 0.01));
    // Grande tablette : la colonne de lecture plafonne à 760 points, le bandeau à 280.
    expect(hauteurBandeau(800), 280);
    expect(hauteurBandeau(1280), 280);
  });
}
