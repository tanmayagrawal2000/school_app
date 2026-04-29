import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/repositories/homework_repository.dart';
import '../bloc/homework_bloc.dart';
import '../bloc/homework_event.dart';
import '../bloc/homework_state.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class HomeworkScreen extends StatelessWidget {
  final StudentModel student;
  const HomeworkScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => HomeworkBloc(ctx.read<HomeworkRepository>())
        ..add(HomeworkFetch(
            classGrade: student.classGrade, section: student.section)),
      child: _HomeworkView(student: student),
    );
  }
}

class _HomeworkView extends StatelessWidget {
  final StudentModel student;
  const _HomeworkView({required this.student});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.homeworkTitle),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Class ${student.classGrade}-${student.section}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          if (state is HomeworkLoading) {
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryBrown));
          }
          if (state is HomeworkError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: AppColors.error)));
          }
          if (state is HomeworkLoaded) {
            return _HomeworkContent(state: state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _HomeworkContent extends StatelessWidget {
  final HomeworkLoaded state;
  const _HomeworkContent({required this.state});

  static const _filters = ['All', 'Pending', 'Submitted'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatsBar(context),
        _buildFilterChips(context),
        Expanded(child: _buildList(context)),
      ],
    );
  }

  // ── STATS BAR ────────────────────────────────────────────────────────
  Widget _buildStatsBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppColors.primaryBrown,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          _StatPill(
              label: l10n.homeworkStatTotal,
              count: state.allItems.length,
              color: Colors.white70),
          const SizedBox(width: 10),
          _StatPill(
              label: l10n.homeworkStatPending,
              count: state.pendingCount,
              color: AppColors.saffronLight),
          const SizedBox(width: 10),
          _StatPill(
              label: l10n.homeworkStatSubmitted,
              count: state.submittedCount,
              color: AppColors.goldLight),
          if (state.overdueCount > 0) ...[
            const SizedBox(width: 10),
            _StatPill(
                label: l10n.homeworkStatOverdue,
                count: state.overdueCount,
                color: const Color(0xFFFF8A80)),
          ],
        ],
      ),
    );
  }

  // ── FILTER CHIPS ─────────────────────────────────────────────────────
  Widget _buildFilterChips(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: _filters.map((f) {
          final isSelected = state.filter == f;
          final displayLabel = f == 'All'
              ? l10n.filterAll
              : f == 'Pending'
                  ? l10n.homeworkStatPending
                  : l10n.homeworkStatSubmitted;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => context
                  .read<HomeworkBloc>()
                  .add(HomeworkFilterChanged(f)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBrown
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  displayLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── HOMEWORK LIST ────────────────────────────────────────────────────
  Widget _buildList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = state.filtered;
    if (items.isEmpty) {
      final emptyMsg = state.filter == 'All'
          ? l10n.homeworkEmpty
          : state.filter == 'Pending'
              ? l10n.homeworkEmptyPending
              : l10n.homeworkEmptySubmitted;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_turned_in_outlined,
                size: 56, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(emptyMsg,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.textHint)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, i) => _HomeworkCard(item: items[i]),
    );
  }
}

// ── HOMEWORK CARD ─────────────────────────────────────────────────────────

class _HomeworkCard extends StatelessWidget {
  final HomeworkItem item;
  const _HomeworkCard({required this.item});

  static final _dateFmt = DateFormat('d MMM');


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sub = SubjectModel.forName(item.subject);
    final subjectColor = sub.color;
    final subjectIcon = sub.icon;
    final (dueColor, dueBg) = _dueStyle();
    final (priorityColor, priorityBg, priorityLabel) = _priorityStyle(l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: subjectColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: subjectColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(subjectIcon, color: subjectColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subject,
                        style: TextStyle(
                            color: subjectColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(item.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                if (item.isSubmitted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 11, color: AppColors.success),
                        const SizedBox(width: 3),
                        Text(l10n.homeworkSubmitted,
                            style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Due date chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: dueBg,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isOverdue
                            ? Icons.warning_amber_outlined
                            : Icons.event_outlined,
                        size: 11,
                        color: dueColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.isOverdue
                            ? l10n.homeworkOverdue(_dateFmt.format(item.dueDate))
                            : l10n.homeworkDue(_dateFmt.format(item.dueDate)),
                        style: TextStyle(
                            color: dueColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Priority badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: priorityBg,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    priorityLabel,
                    style: TextStyle(
                        color: priorityColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _dueStyle() {
    if (item.isSubmitted) return (AppColors.success, AppColors.successLight);
    if (item.isOverdue) return (AppColors.error, AppColors.errorLight);
    final daysLeft = item.dueDate.difference(DateTime.now()).inDays;
    if (daysLeft <= 1) return (AppColors.error, AppColors.errorLight);
    if (daysLeft <= 3) return (AppColors.warning, AppColors.warningLight);
    return (AppColors.info, AppColors.infoLight);
  }

  (Color, Color, String) _priorityStyle(AppLocalizations l10n) {
    switch (item.priority) {
      case HomeworkPriority.high:
        return (AppColors.error, AppColors.errorLight, l10n.homeworkPriorityHigh);
      case HomeworkPriority.medium:
        return (AppColors.warning, AppColors.warningLight, l10n.homeworkPriorityMedium);
      case HomeworkPriority.low:
        return (AppColors.success, AppColors.successLight, l10n.homeworkPriorityLow);
    }
  }
}

// ── SHARED SMALL WIDGETS ─────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatPill(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count',
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}
