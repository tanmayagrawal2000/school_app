import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/pending_homework_entry.dart';
import '../../../data/models/roster_student.dart';
import '../../../data/models/subject_model.dart';

class TeacherPendingHWScreen extends StatelessWidget {
  final String classGrade;
  final String section;
  final String? subjectFilter;

  const TeacherPendingHWScreen({
    super.key,
    required this.classGrade,
    required this.section,
    this.subjectFilter,
  });

  @override
  Widget build(BuildContext context) {
    final entries = DummyData.pendingSubmissionsFor(
      classGrade,
      section,
      subjectFilter: subjectFilter,
    );
    final totalMissing =
        entries.fold(0, (sum, e) => sum + e.missingCount);
    final classLabel = 'Class $classGrade-$section';
    final subtitle =
        subjectFilter != null ? '$classLabel · $subjectFilter' : classLabel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overdue Submissions'),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: entries.isEmpty
          ? _EmptyState(subjectFilter: subjectFilter)
          : Column(
              children: [
                _SummaryStrip(
                    assignmentCount: entries.length,
                    missingCount: totalMissing),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _PendingHWCard(entry: entries[i]),
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Summary strip ─────────────────────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  final int assignmentCount;
  final int missingCount;
  const _SummaryStrip(
      {required this.assignmentCount, required this.missingCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _SummaryChip(
            icon: Icons.assignment_outlined,
            label: '$assignmentCount assignment${assignmentCount == 1 ? '' : 's'}',
            color: AppColors.primaryBrown,
          ),
          const SizedBox(width: 12),
          _SummaryChip(
            icon: Icons.person_off_outlined,
            label: '$missingCount missing',
            color: missingCount > 0 ? AppColors.saffron : AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SummaryChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                )),
      ],
    );
  }
}

// ── Per-assignment card ───────────────────────────────────────────────────────

class _PendingHWCard extends StatelessWidget {
  final PendingHomeworkEntry entry;
  const _PendingHWCard({required this.entry});

  static const List<Color> _avatarColors = [
    AppColors.primaryBrown,
    AppColors.info,
    AppColors.success,
    AppColors.saffron,
    AppColors.lotusPink,
    AppColors.gold,
    AppColors.primaryBrownLight,
  ];

  @override
  Widget build(BuildContext context) {
    final hw = entry.homework;
    final subject = SubjectModel.forName(hw.subject);
    final borderColor = subject.color;

    final daysUntilDue = hw.dueDate.difference(DateTime.now()).inDays;
    final dueColor = daysUntilDue <= 1
        ? AppColors.error
        : daysUntilDue <= 3
            ? AppColors.saffron
            : AppColors.textSecondary;

    final priorityColor = hw.priority == HomeworkPriority.high
        ? AppColors.error
        : hw.priority == HomeworkPriority.medium
            ? AppColors.saffron
            : AppColors.info;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ─────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: subject.lightColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(subject.icon, size: 12, color: subject.color),
                      const SizedBox(width: 4),
                      Text(
                        hw.subject,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: subject.color,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    hw.priority.name[0].toUpperCase() +
                        hw.priority.name.substring(1),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: priorityColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Title ──────────────────────────────────────────────
            Text(
              hw.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),

            // ── Teacher name ───────────────────────────────────────
            if (hw.teacherName.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 13, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    hw.teacherName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
            const SizedBox(height: 4),

            // ── Due date ───────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 13, color: dueColor),
                const SizedBox(width: 4),
                Text(
                  'Due ${_formatDate(hw.dueDate)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: dueColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),

            // ── Submission status ───────────────────────────────────
            if (entry.missingCount == 0)
              Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'All ${entry.totalStudents} students submitted',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              )
            else ...[
              Row(
                children: [
                  const Icon(Icons.pending_outlined,
                      size: 15, color: AppColors.saffron),
                  const SizedBox(width: 6),
                  Text(
                    'Not submitted · ${entry.missingCount} of ${entry.totalStudents}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    '${entry.submittedCount} submitted',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.notSubmitted
                    .map((s) => _StudentChip(
                          student: s,
                          avatarColor: _avatarColors[
                              s.avatarColorIndex % _avatarColors.length],
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]}';
  }
}

// ── Student chip ──────────────────────────────────────────────────────────────

class _StudentChip extends StatelessWidget {
  final RosterStudent student;
  final Color avatarColor;
  const _StudentChip({required this.student, required this.avatarColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: avatarColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: avatarColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: avatarColor,
            child: Text(
              student.photoInitials,
              style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            student.firstName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String? subjectFilter;
  const _EmptyState({this.subjectFilter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline,
              size: 64, color: AppColors.success.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            subjectFilter != null
                ? 'No overdue $subjectFilter submissions'
                : 'No overdue submissions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'All students submitted on time.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
        ],
      ),
    );
  }
}
