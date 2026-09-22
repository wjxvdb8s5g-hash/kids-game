enum PowerUpType { freeze, shield, magnet, doubleSpeed }

class PowerUp {
  const PowerUp({
    required this.type,
    required this.name,
    required this.description,
    required this.cooldownMs,
    this.available = true,
  });

  final PowerUpType type;
  final String name;
  final String description;
  final int cooldownMs;
  final bool available;

  PowerUp copyWith({bool? available}) => PowerUp(
    type: type,
    name: name,
    description: description,
    cooldownMs: cooldownMs,
    available: available ?? this.available,
  );
}
