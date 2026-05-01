import 'homework_model.dart';
import 'roster_student.dart';

class PendingHomeworkEntry {
  final HomeworkItem homework;
  final List<RosterStudent> notSubmitted;
  final int totalStudents;

  const PendingHomeworkEntry({
    required this.homework,
    required this.notSubmitted,
    required this.totalStudents,
  });

  int get submittedCount => totalStudents - notSubmitted.length;
  int get missingCount => notSubmitted.length;
}
