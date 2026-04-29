class TimetablePeriod {
  final String time;
  final String subject;
  final String teacher;
  final String room;

  const TimetablePeriod({
    required this.time,
    required this.subject,
    required this.teacher,
    required this.room,
  });

  factory TimetablePeriod.fromJson(Map<String, dynamic> json) =>
      TimetablePeriod(
        time: json['time'] as String,
        subject: json['subject'] as String,
        teacher: json['teacher'] as String,
        room: json['room'] as String,
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'subject': subject,
        'teacher': teacher,
        'room': room,
      };

  bool get isBreak => subject == 'Break' || subject == 'Lunch';
}
