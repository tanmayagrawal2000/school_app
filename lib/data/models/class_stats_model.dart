import 'package:equatable/equatable.dart';

class SubjectClassStat extends Equatable {
  /// Percentage 0–100.
  final String subject;
  final double classAverage;
  final int topperMarks;

  const SubjectClassStat({
    required this.subject,
    required this.classAverage,
    required this.topperMarks,
  });

  factory SubjectClassStat.fromJson(Map<String, dynamic> json) =>
      SubjectClassStat(
        subject: json['subject'] as String,
        classAverage: (json['classAverage'] as num).toDouble(),
        topperMarks: json['topperMarks'] as int,
      );

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'classAverage': classAverage,
        'topperMarks': topperMarks,
      };

  @override
  List<Object?> get props => [subject];
}

class ClassStats extends Equatable {
  final String classGrade;
  final String section;
  final int totalStudents;
  final int studentRank;
  final double classOverallAverage;
  final List<SubjectClassStat> subjects;

  const ClassStats({
    required this.classGrade,
    required this.section,
    required this.totalStudents,
    required this.studentRank,
    required this.classOverallAverage,
    required this.subjects,
  });

  factory ClassStats.fromJson(Map<String, dynamic> json) => ClassStats(
        classGrade: json['classGrade'] as String,
        section: json['section'] as String,
        totalStudents: json['totalStudents'] as int,
        studentRank: json['studentRank'] as int,
        classOverallAverage: (json['classOverallAverage'] as num).toDouble(),
        subjects: (json['subjects'] as List<dynamic>)
            .map((s) =>
                SubjectClassStat.fromJson(s as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'classGrade': classGrade,
        'section': section,
        'totalStudents': totalStudents,
        'studentRank': studentRank,
        'classOverallAverage': classOverallAverage,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      };

  SubjectClassStat? statFor(String subject) {
    try {
      return subjects.firstWhere((s) => s.subject == subject);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [classGrade, section];
}
