class RosterStudent {
  final String id;
  final String name;
  final String photoInitials;
  final int avatarColorIndex;

  const RosterStudent({
    required this.id,
    required this.name,
    required this.photoInitials,
    required this.avatarColorIndex,
  });

  String get firstName => name.split(' ').first;
}
