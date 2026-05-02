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

  factory ClassReminderModel.fromJson(Map<String, dynamic> json) =>
      ClassReminderModel(
        id: json['id'] as String,
        subject: json['subject'] as String,
        teacherName: (json['teacherName'] as String?) ?? '',
        message: json['message'] as String,
        type: ReminderType.values.byName(json['type'] as String),
      );
}
