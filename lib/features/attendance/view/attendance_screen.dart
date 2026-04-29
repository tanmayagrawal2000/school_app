import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/repositories/student_repository.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class AttendanceScreen extends StatelessWidget {
  final StudentModel student;
  const AttendanceScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AttendanceBloc(ctx.read<StudentRepository>())
        ..add(AttendanceFetch(student.id)),
      child: _AttendanceView(student: student),
    );
  }
}

class _AttendanceView extends StatelessWidget {
  final StudentModel student;
  const _AttendanceView({required this.student});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.attendanceTitle),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Class ${student.classGrade}-${student.section}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrown),
            );
          }
          if (state is AttendanceError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: AppColors.error)),
            );
          }
          if (state is AttendanceLoaded) {
            return _AttendanceContent(state: state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _AttendanceContent extends StatelessWidget {
  final AttendanceLoaded state;
  const _AttendanceContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _buildHeader(context),
        _buildSummaryCards(context),
        _buildCalendar(context),
        _buildLegend(context),
        if (state.absentRecords.isNotEmpty) _buildAbsentList(context),
      ],
    );
  }

  // ── HEADER WITH CIRCULAR PERCENTAGE ─────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pct = state.overallPercentage;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBrownDark, AppColors.primaryBrown],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 52,
            lineWidth: 8,
            percent: (pct / 100).clamp(0.0, 1.0),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${pct.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  l10n.attendanceOverall,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
            progressColor:
                pct >= 75 ? AppColors.goldLight : AppColors.saffronLight,
            backgroundColor: Colors.white24,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pct >= 75 ? l10n.attendanceGoodStanding : l10n.attendanceLow,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pct >= 75
                      ? l10n.attendanceGoodMessage
                      : l10n.attendanceLowMessage,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _AttendanceMiniBar(
                  label: l10n.attendancePresent,
                  count: state.presentCount,
                  total: state.totalWorkingDays,
                  color: AppColors.goldLight,
                ),
                const SizedBox(height: 4),
                _AttendanceMiniBar(
                  label: l10n.attendanceAbsent,
                  count: state.absentCount,
                  total: state.totalWorkingDays,
                  color: AppColors.saffronLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SUMMARY STAT CARDS ───────────────────────────────────────────────
  Widget _buildSummaryCards(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cards = [
      _SummaryItem(
        label: l10n.attendancePresent,
        count: state.presentCount,
        icon: Icons.check_circle_outline,
        color: AppColors.success,
        bg: AppColors.successLight,
      ),
      _SummaryItem(
        label: l10n.attendanceAbsent,
        count: state.absentCount,
        icon: Icons.cancel_outlined,
        color: AppColors.error,
        bg: AppColors.errorLight,
      ),
      _SummaryItem(
        label: l10n.attendanceLate,
        count: state.lateCount,
        icon: Icons.watch_later_outlined,
        color: AppColors.warning,
        bg: AppColors.warningLight,
      ),
      _SummaryItem(
        label: l10n.attendanceWorkingDays,
        count: state.totalWorkingDays,
        icon: Icons.event_available_outlined,
        color: AppColors.info,
        bg: AppColors.infoLight,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.4,
        children: cards
            .map((c) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: c.bg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(c.icon, color: c.color, size: 22),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${c.count}',
                            style: TextStyle(
                              color: c.color,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          Text(
                            c.label,
                            style: TextStyle(
                              color: c.color.withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ── CALENDAR ────────────────────────────────────────────────────────
  Widget _buildCalendar(BuildContext context) {
    final recordMap = <DateTime, AttendanceStatus>{};
    for (final r in state.records) {
      final key = DateTime(r.date.year, r.date.month, r.date.day);
      recordMap[key] = r.status;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime(DateTime.now().year - 1, 6, 1),
        lastDay: DateTime.now(),
        focusedDay: state.focusedMonth,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        availableGestures: AvailableGestures.horizontalSwipe,
        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AppColors.primaryBrown,
                fontWeight: FontWeight.w700,
              ),
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left,
              color: AppColors.primaryBrown),
          rightChevronIcon: const Icon(Icons.chevron_right,
              color: AppColors.primaryBrown),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600),
          weekendStyle: TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
        onPageChanged: (focused) {
          context
              .read<AttendanceBloc>()
              .add(AttendanceMonthChanged(focused));
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) =>
              _dayCell(day, recordMap),
          todayBuilder: (context, day, focusedDay) =>
              _dayCell(day, recordMap, isToday: true),
          outsideBuilder: (context, day, focusedDay) => _dayCell(day, {},
              isOutside: true),
        ),
      ),
    );
  }

  Widget _dayCell(
    DateTime day,
    Map<DateTime, AttendanceStatus> recordMap, {
    bool isToday = false,
    bool isOutside = false,
  }) {
    final key = DateTime(day.year, day.month, day.day);
    final status = recordMap[key];

    Color? bg;
    Color textColor = isOutside ? AppColors.textHint : AppColors.textPrimary;

    if (!isOutside && status != null) {
      switch (status) {
        case AttendanceStatus.present:
          bg = AppColors.successLight;
          textColor = AppColors.success;
          break;
        case AttendanceStatus.absent:
          bg = AppColors.errorLight;
          textColor = AppColors.error;
          break;
        case AttendanceStatus.late:
          bg = AppColors.warningLight;
          textColor = AppColors.warning;
          break;
        case AttendanceStatus.holiday:
          bg = AppColors.infoLight;
          textColor = AppColors.info;
          break;
        case AttendanceStatus.sunday:
          textColor = AppColors.textHint;
          break;
      }
    }

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: AppColors.primaryBrown, width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // ── COLOUR LEGEND ────────────────────────────────────────────────────
  Widget _buildLegend(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _LegendItem(l10n.attendancePresent, AppColors.success, AppColors.successLight),
      _LegendItem(l10n.attendanceAbsent, AppColors.error, AppColors.errorLight),
      _LegendItem(l10n.attendanceLate, AppColors.warning, AppColors.warningLight),
      _LegendItem('Holiday', AppColors.info, AppColors.infoLight),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: items
            .map((it) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: it.bg,
                        shape: BoxShape.circle,
                        border: Border.all(color: it.color, width: 1.5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      it.label,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  // ── ABSENT DATES LIST ────────────────────────────────────────────────
  Widget _buildAbsentList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cancel_outlined,
                  color: AppColors.error, size: 18),
              const SizedBox(width: 6),
              Text(l10n.attendanceAbsentDates,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${state.absentCount}',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.absentRecords.length,
              separatorBuilder: (_, __) => const Divider(
                  height: 1, indent: 16, color: AppColors.divider),
              itemBuilder: (context, i) {
                final r = state.absentRecords[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${r.date.day}',
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE').format(r.date),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormat('MMMM yyyy').format(r.date),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textHint),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.attendanceAbsent,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── SHARED PRIVATE MODELS & WIDGETS ─────────────────────────────────────

class _SummaryItem {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final Color bg;
  const _SummaryItem(
      {required this.label,
      required this.count,
      required this.icon,
      required this.color,
      required this.bg});
}

class _LegendItem {
  final String label;
  final Color color;
  final Color bg;
  const _LegendItem(this.label, this.color, this.bg);
}

class _AttendanceMiniBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;
  const _AttendanceMiniBar(
      {required this.label,
      required this.count,
      required this.total,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : (count / total).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
