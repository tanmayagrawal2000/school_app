import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/student_subject_mark.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/repositories/student_repository.dart';

class SubjectPerformanceScreen extends StatefulWidget {
  final String classGrade;
  final String section;
  final String subject;

  const SubjectPerformanceScreen({
    super.key,
    required this.classGrade,
    required this.section,
    required this.subject,
  });

  @override
  State<SubjectPerformanceScreen> createState() =>
      _SubjectPerformanceScreenState();
}

class _SubjectPerformanceScreenState extends State<SubjectPerformanceScreen> {
  List<StudentSubjectMark> _students = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final marks = await context.read<StudentRepository>().fetchSubjectMarks(
        widget.classGrade, widget.section, widget.subject);
    if (!mounted) return;
    setState(() {
      _students = marks;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final avg = _students.isEmpty
        ? 0.0
        : _students.map((s) => s.percentage).reduce((a, b) => a + b) /
            _students.length;
    final atRisk = _students.where((s) => s.percentage < 60).toList();
    final subjectModel = SubjectModel.forName(widget.subject);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Subject Performance'),
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
                  'Class ${widget.classGrade}-${widget.section}',
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrown))
          : RefreshIndicator(
              color: AppColors.primaryBrown,
              onRefresh: _loadData,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  _buildHeader(context, avg, _students.length, subjectModel),
                  if (atRisk.isNotEmpty) _buildAtRiskStrip(context, atRisk.length),
                  if (_students.isEmpty)
                    _buildEmpty(context)
                  else
                    _buildStudentList(context, _students),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context, double avg, int count,
      SubjectModel subjectModel) {
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
            percent: (avg / 100).clamp(0.0, 1.0),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${avg.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'avg',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
            progressColor:
                avg >= 80 ? AppColors.goldLight : AppColors.saffronLight,
            backgroundColor: Colors.white24,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(subjectModel.icon,
                          color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.subject,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  avg >= 80
                      ? 'Class performing well'
                      : avg >= 60
                          ? 'Room to improve'
                          : 'Needs attention',
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.people_outlined,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '$count student${count == 1 ? '' : 's'}',
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

  Widget _buildAtRiskStrip(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$count student${count == 1 ? '' : 's'} scoring below 60% — may need extra support',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(
      BuildContext context, List<StudentSubjectMark> students) {
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
        itemCount: students.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 60, color: AppColors.divider),
        itemBuilder: (context, i) => _StudentMarkRow(
          mark: students[i],
          rank: i + 1,
          total: students.length,
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.bar_chart_outlined, size: 56, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            'No marks data available',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ── Student mark row ──────────────────────────────────────────────────────────

class _StudentMarkRow extends StatelessWidget {
  final StudentSubjectMark mark;
  final int rank;
  final int total;

  const _StudentMarkRow(
      {required this.mark, required this.rank, required this.total});

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
    final pct = mark.percentage;
    final barColor = pct >= 80
        ? AppColors.success
        : pct >= 60
            ? AppColors.saffron
            : AppColors.error;
    final avatarColor =
        _avatarColors[mark.avatarColorIndex % _avatarColors.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: avatarColor,
            child: Text(
              mark.photoInitials,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mark.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: barColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        mark.grade,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: barColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${mark.marks}/${mark.maxMarks}',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
