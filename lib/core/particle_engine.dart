import 'dart:math';
import 'dart:ui';

class ParticleSpec {
  const ParticleSpec({
    required this.start,
    required this.velocity,
    required this.lifeMs,
  });

  final Offset start;
  final Offset velocity;
  final int lifeMs;
}

class ParticleEngine {
  List<ParticleSpec> createBurst({required Offset origin, required int level}) {
    final random = Random(level * 31);
    final count = (10 + level * 1.3).toInt().clamp(12, 28);
    return List.generate(count, (_) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 40 + random.nextDouble() * 120;
      return ParticleSpec(
        start: origin,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        lifeMs: 600 + random.nextInt(700),
      );
    });
  }
}
