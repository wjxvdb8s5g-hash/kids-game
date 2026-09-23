import 'dart:math';
import 'dart:ui';

class ParticleSpec {
  const ParticleSpec({
    required this.start,
    required this.velocity,
    required this.lifeMs,
    required this.birthEpochMs,
  });

  final Offset start;
  final Offset velocity;
  final int lifeMs;
  final int birthEpochMs;
}

class ParticleEngine {
  final Random _random = Random();

  List<ParticleSpec> createBurst({required Offset origin, required int level}) {
    final count = (10 + level * 1.3).toInt().clamp(12, 28);
    return List.generate(count, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 40 + _random.nextDouble() * 120;
      return ParticleSpec(
        start: origin,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        lifeMs: 600 + _random.nextInt(700),
        birthEpochMs: DateTime.now().millisecondsSinceEpoch,
      );
    });
  }
}
