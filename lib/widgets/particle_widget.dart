import 'package:flutter/material.dart';

import '../core/particle_engine.dart';

class ParticleWidget extends StatelessWidget {
  const ParticleWidget({super.key, required this.particles});

  final List<ParticleSpec> particles;

  @override
  Widget build(BuildContext context) {
    if (particles.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(particles),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.particles);

  final List<ParticleSpec> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    for (final particle in particles) {
      canvas.drawCircle(particle.start, 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
