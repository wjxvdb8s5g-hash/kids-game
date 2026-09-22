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
  void initState() {
    super.initState();
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant ParticleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTicker();
  }

  void _syncTicker() {
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
      final progress = (age / particle.lifeMs).clamp(0.0, 1.0);
      final progressCurve = progress * (1 - progress * 0.22);
      const drag = 0.87;
      final pos = Offset(
        particle.start.dx + particle.velocity.dx * progressCurve * drag,
        particle.start.dy + particle.velocity.dy * progressCurve * drag + (28 * progress * progress),
      );
      canvas.drawCircle(pos, 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
