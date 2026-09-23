class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    this.unlocked = false,
  });

  final String id;
  final String title;
  final String description;
  final int target;
  final bool unlocked;

  Achievement copyWith({bool? unlocked}) => Achievement(
    id: id,
    title: title,
    description: description,
    target: target,
    unlocked: unlocked ?? this.unlocked,
  );
}
