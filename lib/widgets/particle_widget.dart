import 'package:flutter/material.dart';
import 'dart:async';

import '../core/particle_engine.dart';

class ParticleWidget extends StatefulWidget {
  const ParticleWidget({super.key, required this.particles});

  final List<ParticleSpec> particles;

  @override
  State<ParticleWidget> createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget> {
  Timer? _ticker;

  @override
  void didUpdateWidget(covariant ParticleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ticker?.cancel();
    if (widget.particles.isNotEmpty) {
      _ticker = Timer.periodic(const Duration(milliseconds: 16), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.particles.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(widget.particles),
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
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final particle in particles) {
      final age = now - particle.birthEpochMs;
      if (age < 0 || age > particle.lifeMs) {
        continue;
      }
      final t = age / 1000.0;
      final drag = 0.87;
      final pos = Offset(
        particle.start.dx + particle.velocity.dx * t * drag,
        particle.start.dy + particle.velocity.dy * t * drag + (28 * t * t),
      );
      canvas.drawCircle(pos, 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
