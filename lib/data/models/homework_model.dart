import 'package:equatable/equatable.dart';

enum HomeworkPriority { high, medium, low }

class HomeworkItem extends Equatable {
  final String id;
  final String subject;
  final String teacherName;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isSubmitted;
  final HomeworkPriority priority;

  const HomeworkItem({
    required this.id,
    required this.subject,
    required this.teacherName,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isSubmitted,
    required this.priority,
  });

  factory HomeworkItem.fromJson(Map<String, dynamic> json) => HomeworkItem(
        id: json['id'] as String,
        subject: json['subject'] as String,
        teacherName: json['teacherName'] as String? ?? '',
        title: json['title'] as String,
        description: json['description'] as String,
        dueDate: DateTime.parse(json['dueDate'] as String),
        isSubmitted: json['isSubmitted'] as bool,
        priority: HomeworkPriority.values.byName(json['priority'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'teacherName': teacherName,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'isSubmitted': isSubmitted,
        'priority': priority.name,
      };

  bool get isOverdue => !isSubmitted && dueDate.isBefore(DateTime.now());

  @override
  List<Object?> get props => [id];
}
