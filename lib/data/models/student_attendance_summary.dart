import 'package:equatable/equatable.dart';

class StudentAttendanceSummary extends Equatable {
  final String name;
  final String photoInitials;
  final int avatarColorIndex;
  final int presentDays;
  final int absentDays;
  final int lateDays;
  final int totalWorkingDays;

  const StudentAttendanceSummary({
    required this.name,
    required this.photoInitials,
    required this.avatarColorIndex,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.totalWorkingDays,
  });

  double get percentage => totalWorkingDays == 0
      ? 0
      : ((presentDays + lateDays) / totalWorkingDays) * 100;

  String get firstName => name.split(' ').first;

  @override
  List<Object?> get props => [name, avatarColorIndex];
}
