enum ReminderType { bring, prepare, read, submit, general }

class ClassReminderModel {
  final String id;
  final String subject;
  final String teacherName;
  final String message;
  final ReminderType type;

  const ClassReminderModel({
    required this.id,
    required this.subject,
    required this.teacherName,
    required this.message,
    required this.type,
  });
}
