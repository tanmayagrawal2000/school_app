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

  factory TeacherClassSummary.fromJson(Map<String, dynamic> json) =>
      TeacherClassSummary(
        classGrade: json['classGrade'] as String,
        section: json['section'] as String,
        isIncharge: json['isIncharge'] as bool,
        subject: json['subject'] as String,
        classStats: ClassStats.fromJson(json['classStats'] as Map<String, dynamic>),
        attendancePercent: (json['attendancePercent'] as num?)?.toDouble(),
        pendingHomework: json['pendingHomework'] as int,
        todayPeriods: json['todayPeriods'] as int,
      );

  @override
  List<Object?> get props => [classGrade, section, isIncharge, subject];
}
