import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, absent, late, holiday, sunday }

class AttendanceRecord extends Equatable {
  final DateTime date;
  final AttendanceStatus status;

  const AttendanceRecord({required this.date, required this.status});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        date: DateTime.parse(json['date'] as String),
        status: AttendanceStatus.values.byName(json['status'] as String),
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'status': status.name,
      };

  @override
  List<Object?> get props => [date, status];
}

class MonthlyAttendance extends Equatable {
  final int month;
  final int year;
  final List<AttendanceRecord> records;

  const MonthlyAttendance({
    required this.month,
    required this.year,
    required this.records,
  });

  factory MonthlyAttendance.fromJson(Map<String, dynamic> json) =>
      MonthlyAttendance(
        month: json['month'] as int,
        year: json['year'] as int,
        records: (json['records'] as List<dynamic>)
            .map((r) => AttendanceRecord.fromJson(r as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'month': month,
        'year': year,
        'records': records.map((r) => r.toJson()).toList(),
      };

  int get totalWorkingDays => records
      .where((r) =>
          r.status != AttendanceStatus.sunday &&
          r.status != AttendanceStatus.holiday)
      .length;

  int get presentDays => records
      .where((r) =>
          r.status == AttendanceStatus.present ||
          r.status == AttendanceStatus.late)
      .length;

  double get percentage =>
      totalWorkingDays == 0 ? 0 : (presentDays / totalWorkingDays) * 100;

  @override
  List<Object?> get props => [month, year];
}
