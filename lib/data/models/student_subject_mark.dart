import 'package:equatable/equatable.dart';

class StudentSubjectMark extends Equatable {
  final String name;
  final String photoInitials;
  final int avatarColorIndex;
  final int marks;
  final int maxMarks;

  const StudentSubjectMark({
    required this.name,
    required this.photoInitials,
    required this.avatarColorIndex,
    required this.marks,
    required this.maxMarks,
  });

  double get percentage => maxMarks == 0 ? 0 : (marks / maxMarks) * 100;

  String get grade {
    final p = percentage;
    if (p >= 91) return 'A1';
    if (p >= 81) return 'A2';
    if (p >= 71) return 'B1';
    if (p >= 61) return 'B2';
    if (p >= 51) return 'C1';
    if (p >= 41) return 'C2';
    if (p >= 33) return 'D';
    return 'E';
  }

  String get firstName => name.split(' ').first;

  factory StudentSubjectMark.fromJson(Map<String, dynamic> json) =>
      StudentSubjectMark(
        name: json['name'] as String,
        photoInitials: json['photoInitials'] as String,
        avatarColorIndex: json['avatarColorIndex'] as int,
        marks: json['marks'] as int,
        maxMarks: json['maxMarks'] as int,
      );

  @override
  List<Object?> get props => [name, avatarColorIndex, marks];
}
