import 'package:equatable/equatable.dart';
import '../../../data/models/attendance_model.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceRecord> records;
  final DateTime focusedMonth;

  const AttendanceLoaded({
    required this.records,
    required this.focusedMonth,
  });

  List<AttendanceRecord> get recordsForMonth => records.where((r) {
        return r.date.year == focusedMonth.year &&
            r.date.month == focusedMonth.month;
      }).toList();

  int get presentCount =>
      records.where((r) => r.status == AttendanceStatus.present).length;

  int get absentCount =>
      records.where((r) => r.status == AttendanceStatus.absent).length;

  int get lateCount =>
      records.where((r) => r.status == AttendanceStatus.late).length;

  int get totalWorkingDays => records
      .where((r) =>
          r.status != AttendanceStatus.sunday &&
          r.status != AttendanceStatus.holiday)
      .length;

  double get overallPercentage => totalWorkingDays == 0
      ? 0
      : ((presentCount + lateCount) / totalWorkingDays) * 100;

  List<AttendanceRecord> get absentRecords =>
      records.where((r) => r.status == AttendanceStatus.absent).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  AttendanceLoaded copyWith({DateTime? focusedMonth}) {
    return AttendanceLoaded(
      records: records,
      focusedMonth: focusedMonth ?? this.focusedMonth,
    );
  }

  @override
  List<Object?> get props => [records, focusedMonth];
}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);
  @override
  List<Object?> get props => [message];
}
