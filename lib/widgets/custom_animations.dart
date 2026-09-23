import 'dart:ui';

class CustomAnimations {
  const CustomAnimations();

  double smoothStep(double t) {
    final clamped = t.clamp(0.0, 1.0);
    return clamped * clamped * (3 - 2 * clamped);
  }

  Offset elasticLerp(Offset a, Offset b, double t) {
    final eased = smoothStep(t);
    final overshoot = (1 - t) * 0.08;
    return Offset.lerp(a, b, (eased + overshoot).clamp(0, 1)) ?? b;
  }
}
