class TapSample {
  const TapSample({
    required this.pressure,
    required this.holdMs,
    required this.travelDistance,
  });

  final double pressure;
  final int holdMs;
  final double travelDistance;
}

class GestureAnalyzer {
  bool isLikelyAccidental(TapSample sample) {
    if (sample.holdMs < 40 && sample.pressure < 0.15) {
      return true;
    }
    if (sample.travelDistance > 42 && sample.holdMs < 80) {
      return true;
    }
    return false;
  }

  int normalizedReactionMs(TapSample sample) {
    final reaction = sample.holdMs + (sample.travelDistance * 2).toInt();
    return reaction.clamp(120, 2000);
  }
}
