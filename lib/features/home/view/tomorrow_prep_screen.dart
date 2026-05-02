import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/class_reminder_model.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/timetable_model.dart';
import '../../../data/repositories/homework_repository.dart';
import '../../../data/repositories/reminder_repository.dart';
import '../../../data/repositories/timetable_repository.dart';

class TomorrowPrepScreen extends StatefulWidget {
  final StudentModel student;
  const TomorrowPrepScreen({super.key, required this.student});

  @override
  State<TomorrowPrepScreen> createState() => _TomorrowPrepScreenState();
}

class _TomorrowPrepScreenState extends State<TomorrowPrepScreen> {
  late final DateTime _tomorrow;
  late final String _dayName;
  late final bool _isWeekend;

  List<TimetablePeriod> _periods = [];
  List<ClassReminderModel> _reminders = [];
  List<HomeworkItem> _dueHomework = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tomorrow = DateTime.now().add(const Duration(days: 1));
    _dayName = DateFormat('EEEE').format(_tomorrow);
    _isWeekend = _tomorrow.weekday == DateTime.sunday;
    if (!_isWeekend) {
      _loadData();
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadData() async {
    final timetableRepo = context.read<TimetableRepository>();
    final homeworkRepo = context.read<HomeworkRepository>();
    final reminderRepo = context.read<ReminderRepository>();
    final results = await Future.wait([
      timetableRepo.fetchTimetable(
          widget.student.classGrade, widget.student.section),
      homeworkRepo.fetchHomework(
          widget.student.classGrade, widget.student.section, widget.student.id),
      reminderRepo.fetchRemindersForDay(_dayName),
    ]);
    if (!mounted) return;

    final timetableMap = results[0] as Map<String, List<TimetablePeriod>>;
    final homework = results[1] as List<HomeworkItem>;
    final reminders = results[2] as List<ClassReminderModel>;

    // Show homework due today or tomorrow so students can prepare in advance
    final tomorrowEnd = DateTime(
        _tomorrow.year, _tomorrow.month, _tomorrow.day, 23, 59);
    setState(() {
      _periods = timetableMap[_dayName] ?? [];
      _reminders = reminders;
      _dueHomework = homework
          .where((h) => !h.isSubmitted && !h.dueDate.isAfter(tomorrowEnd))
          .toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEEE, d MMMM').format(_tomorrow);
    final nonBreakCount = _periods.where((p) => !p.isBreak).length;
    final subtitle = _isWeekend
        ? dateLabel
        : '$dateLabel  ·  $nonBreakCount periods';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Tomorrow's Prep",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text(subtitle,
                style:
                    const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrown))
          : _isWeekend
              ? _buildWeekendView(context)
              : RefreshIndicator(
                  color: AppColors.primaryBrown,
                  onRefresh: _loadData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
                      if (_reminders.isNotEmpty || _dueHomework.isNotEmpty)
                        _buildPackingList(context),
                      _buildSchedule(context),
                    ],
                  ),
                ),
    );
  }

  // ── Weekend ──────────────────────────────────────────────────────────────

  Widget _buildWeekendView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏖', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Enjoy your weekend!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'No school tomorrow.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ── What to Pack ─────────────────────────────────────────────────────────

  Widget _buildPackingList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎒', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text('What to Pack',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          ..._reminders.map((r) => _PackingItem(
                icon: _iconForType(r.type),
                iconColor: _colorForType(r.type),
                subject: r.subject,
                message: r.message,
              )),
          ..._dueHomework.map((h) => _PackingItem(
                icon: Icons.library_books_outlined,
                iconColor: AppColors.info,
                subject: h.subject,
                message:
                    '${h.title} — due ${DateFormat('d MMM').format(h.dueDate)}',
              )),
        ],
      ),
    );
  }

  // ── Schedule ─────────────────────────────────────────────────────────────

  Widget _buildSchedule(BuildContext context) {
    if (_periods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text('No schedule found for $_dayName.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary)),
        ),
      );
    }

    final nonBreakCount = _periods.where((p) => !p.isBreak).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule_outlined,
                  size: 18, color: AppColors.primaryBrown),
              const SizedBox(width: 6),
              Text('Schedule',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrown.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$nonBreakCount periods',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryBrown,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._periods.map((p) => p.isBreak
              ? _BreakDivider(period: p)
              : _PeriodCard(
                  period: p,
                  reminder: _reminders
                      .where((r) => r.subject == p.subject)
                      .firstOrNull,
                  homework: _dueHomework
                      .where((h) => h.subject == p.subject)
                      .firstOrNull,
                )),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  IconData _iconForType(ReminderType type) {
    switch (type) {
      case ReminderType.bring:
        return Icons.backpack_outlined;
      case ReminderType.prepare:
        return Icons.edit_note_outlined;
      case ReminderType.read:
        return Icons.menu_book_outlined;
      case ReminderType.submit:
        return Icons.upload_file_outlined;
      case ReminderType.general:
        return Icons.info_outline;
    }
  }

  Color _colorForType(ReminderType type) {
    switch (type) {
      case ReminderType.bring:
        return AppColors.primaryBrown;
      case ReminderType.prepare:
        return AppColors.error;
      case ReminderType.read:
        return AppColors.info;
      case ReminderType.submit:
        return AppColors.saffron;
      case ReminderType.general:
        return AppColors.textSecondary;
    }
  }
}

// ─────────────────────────── PACKING ITEM ───────────────────────────────────

class _PackingItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String subject;
  final String message;

  const _PackingItem({
    required this.icon,
    required this.iconColor,
    required this.subject,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── BREAK DIVIDER ──────────────────────────────────

class _BreakDivider extends StatelessWidget {
  final TimetablePeriod period;
  const _BreakDivider({required this.period});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.divider)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${period.subject}  ·  ${period.time}',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.textHint),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.divider)),
        ],
      ),
    );
  }
}

// ─────────────────────────── PERIOD CARD ────────────────────────────────────

class _PeriodCard extends StatelessWidget {
  final TimetablePeriod period;
  final ClassReminderModel? reminder;
  final HomeworkItem? homework;

  const _PeriodCard({required this.period, this.reminder, this.homework});

  @override
  Widget build(BuildContext context) {
    final color = SubjectModel.forName(period.subject).color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject + Room
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              period.subject,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (period.room.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                period.room,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: color,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Teacher + Time
                      Row(
                        children: [
                          if (period.teacher.isNotEmpty) ...[
                            const Icon(Icons.person_outline,
                                size: 12, color: AppColors.textHint),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                period.teacher,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: AppColors.textHint),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else
                            const Spacer(),
                          Text(
                            period.time,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      // Teacher reminder
                      if (reminder != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.warningLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.push_pin_rounded,
                                  size: 13, color: AppColors.saffron),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  reminder!.message,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Homework due
                      if (homework != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.infoLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.library_books_outlined,
                                  size: 13, color: AppColors.info),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${homework!.title} — due ${DateFormat('d MMM').format(homework!.dueDate)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColors.info,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
