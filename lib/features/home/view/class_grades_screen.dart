import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/class_stats_model.dart';
import '../../../data/models/subject_model.dart';

class ClassGradesScreen extends StatelessWidget {
  final String classGrade;
  final String section;
  final ClassStats stats;

  const ClassGradesScreen({
    super.key,
    required this.classGrade,
    required this.section,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    // Sort worst to best so teacher sees problem areas first
    final subjects = List.of(stats.subjects)
      ..sort((a, b) => a.classAverage.compareTo(b.classAverage));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Class Performance'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Class $classGrade-$section',
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
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _buildHeader(context, stats.classOverallAverage, subjects.length),
          _buildSubjectList(context, subjects),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, double overall, int subjectCount) {
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
            color: AppColors.primaryBrown.withValues(alpha: 0.3),
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
            percent: (overall / 100).clamp(0.0, 1.0),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${overall.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'overall',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
            progressColor:
                overall >= 80 ? AppColors.goldLight : AppColors.saffronLight,
            backgroundColor: Colors.white24,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overall >= 80
                      ? 'Performing Well'
                      : overall >= 60
                          ? 'Room to Improve'
                          : 'Needs Attention',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Average across $subjectCount subject${subjectCount == 1 ? '' : 's'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.people_outlined,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${stats.totalStudents} students',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectList(
      BuildContext context, List<SubjectClassStat> subjects) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subjects.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 60, color: AppColors.divider),
        itemBuilder: (context, i) =>
            _SubjectRow(stat: subjects[i], rank: i + 1, total: subjects.length),
      ),
    );
  }
}

// ── Subject row ───────────────────────────────────────────────────────────────

class _SubjectRow extends StatelessWidget {
  final SubjectClassStat stat;
  final int rank;   // position in sorted list (1 = weakest)
  final int total;

  const _SubjectRow(
      {required this.stat, required this.rank, required this.total});

  @override
  Widget build(BuildContext context) {
    final subject = SubjectModel.forName(stat.subject);
    final pct = stat.classAverage;
    final barColor = pct >= 80
        ? AppColors.success
        : pct >= 60
            ? AppColors.warning
            : AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Subject icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: subject.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(subject.icon, color: subject.color, size: 18),
          ),
          const SizedBox(width: 12),

          // Name + bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stat.subject,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${pct.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: barColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (pct / 100).clamp(0.0, 1.0),
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Topper: ${stat.topperMarks}/100',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
