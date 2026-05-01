import 'package:equatable/equatable.dart';
import 'class_stats_model.dart';

class TeacherClassSummary extends Equatable {
  final String classGrade;
  final String section;
  final bool isIncharge;
  final String subject;
  final ClassStats classStats;
  final double? attendancePercent;
  final int pendingHomework;
  final int todayPeriods;

  const TeacherClassSummary({
    required this.classGrade,
    required this.section,
    required this.isIncharge,
    required this.subject,
    required this.classStats,
    this.attendancePercent,
    required this.pendingHomework,
    required this.todayPeriods,
  });

  String get classLabel => 'Class $classGrade-$section';

  double get subjectAvg =>
      classStats.statFor(subject)?.classAverage ?? classStats.classOverallAverage;

  @override
  List<Object?> get props => [classGrade, section, isIncharge, subject];
}
