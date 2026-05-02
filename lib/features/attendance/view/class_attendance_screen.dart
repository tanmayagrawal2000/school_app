import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/student_attendance_summary.dart';
import '../../../data/repositories/student_repository.dart';

class ClassAttendanceScreen extends StatefulWidget {
  final String classGrade;
  final String section;

  const ClassAttendanceScreen({
    super.key,
    required this.classGrade,
    required this.section,
  });

  @override
  State<ClassAttendanceScreen> createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen> {
  List<StudentAttendanceSummary> _students = [];
  double _overallPct = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = context.read<StudentRepository>();
    final results = await Future.wait([
      repo.fetchClassAttendanceSummary(widget.classGrade, widget.section),
      repo.fetchClassAvgAttendance(widget.classGrade, widget.section),
    ]);
    if (!mounted) return;
    setState(() {
      _students = results[0] as List<StudentAttendanceSummary>;
      _overallPct = results[1] as double;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final atRisk = _students.where((s) => s.percentage < 75).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Class Attendance'),
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
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                _buildHeader(context, _students.length, _overallPct),
                if (atRisk.isNotEmpty) _buildAtRiskStrip(context, atRisk.length),
                _buildStudentList(context, _students),
              ],
            ),
    );
  }

  Widget _buildHeader(BuildContext context, int totalStudents, double overallPct) {
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
            percent: (overallPct / 100).clamp(0.0, 1.0),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${overallPct.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'avg',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
            progressColor: overallPct >= 85
                ? AppColors.goldLight
                : AppColors.saffronLight,
            backgroundColor: Colors.white24,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overallPct >= 85 ? 'Good Standing' : 'Needs Attention',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  overallPct >= 85
                      ? 'Class attendance is healthy overall.'
                      : 'Some students need follow-up.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.people_outlined,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '$totalStudents students',
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Text(
            '$count student${count == 1 ? '' : 's'} below 75% attendance',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(
      BuildContext context, List<StudentAttendanceSummary> students) {
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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: students.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 72, color: AppColors.divider),
        itemBuilder: (context, i) => _StudentAttendanceRow(student: students[i]),
      ),
    );
  }
}

// ── Per-student row ───────────────────────────────────────────────────────────

class _StudentAttendanceRow extends StatelessWidget {
  final StudentAttendanceSummary student;

  static const List<Color> _avatarColors = [
    AppColors.primaryBrown,
    AppColors.info,
    AppColors.success,
    AppColors.saffron,
    AppColors.lotusPink,
    AppColors.gold,
    AppColors.primaryBrownLight,
  ];

  const _StudentAttendanceRow({required this.student});

  @override
  Widget build(BuildContext context) {
    final pct = student.percentage;
    final barColor = pct >= 85
        ? AppColors.success
        : pct >= 75
            ? AppColors.warning
            : AppColors.error;
    final avatarColor =
        _avatarColors[student.avatarColorIndex % _avatarColors.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarColor,
            child: Text(
              student.photoInitials,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      student.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
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
                  '${student.presentDays + student.lateDays} / ${student.totalWorkingDays} days'
                  '  ·  ${student.absentDays} absent'
                  '${student.lateDays > 0 ? '  ·  ${student.lateDays} late' : ''}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textHint,
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
