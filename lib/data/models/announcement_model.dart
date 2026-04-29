import 'package:equatable/equatable.dart';

enum AnnouncementType { exam, holiday, event, general, fee, sports }

class AnnouncementModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final AnnouncementType type;
  final bool isPinned;
  final String postedBy;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.type,
    this.isPinned = false,
    required this.postedBy,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementModel(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        date: DateTime.parse(json['date'] as String),
        type: AnnouncementType.values.byName(json['type'] as String),
        isPinned: json['isPinned'] as bool? ?? false,
        postedBy: json['postedBy'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'date': date.toIso8601String(),
        'type': type.name,
        'isPinned': isPinned,
        'postedBy': postedBy,
      };

  @override
  List<Object?> get props => [id];
}
