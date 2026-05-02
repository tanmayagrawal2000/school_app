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

  factory RosterStudent.fromJson(Map<String, dynamic> json) => RosterStudent(
        id: json['id'] as String,
        name: json['name'] as String,
        photoInitials: json['photoInitials'] as String,
        avatarColorIndex: json['avatarColorIndex'] as int,
      );
}
