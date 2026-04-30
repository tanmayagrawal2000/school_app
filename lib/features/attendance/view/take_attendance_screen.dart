import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final String classGrade;
  final String section;

  const TakeAttendanceScreen({
    super.key,
    required this.classGrade,
    required this.section,
  });

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  // Demo roll list for the class — replace with StudentRepository.fetchStudents() in real app
  static const _demoRoll = [
    (rollNo: 1, name: 'Amit Chauhan'),
    (rollNo: 3, name: 'Arjun Sharma'),
    (rollNo: 7, name: 'Deepa Mishra'),
    (rollNo: 11, name: 'Kavita Yadav'),
    (rollNo: 15, name: 'Mohit Pandey'),
    (rollNo: 18, name: 'Neha Gupta'),
    (rollNo: 21, name: 'Priya Tiwari'),
    (rollNo: 24, name: 'Rahul Verma'),
    (rollNo: 28, name: 'Sonal Joshi'),
    (rollNo: 31, name: 'Vivek Singh'),
  ];

  late final Map<int, bool> _attendance;

  @override
  void initState() {
    super.initState();
    // Default everyone to present
    _attendance = {for (final s in _demoRoll) s.rollNo: true};
  }

  int get _presentCount => _attendance.values.where((v) => v).length;
  int get _absentCount => _attendance.values.where((v) => !v).length;

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.teacherAttendanceSaved),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.teacherSubmitAttendance,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              'Class ${widget.classGrade}-${widget.section}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            color: AppColors.primaryBrown,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _SummaryChip(
                  label: 'Present',
                  count: _presentCount,
                  color: AppColors.success,
                ),
                const SizedBox(width: 10),
                _SummaryChip(
                  label: 'Absent',
                  count: _absentCount,
                  color: AppColors.error,
                ),
                const Spacer(),
                Text(
                  '${_demoRoll.length} students',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
          // Student list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _demoRoll.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final student = _demoRoll[i];
                final isPresent = _attendance[student.rollNo] ?? true;
                return _AttendanceTile(
                  rollNo: student.rollNo,
                  name: student.name,
                  isPresent: isPresent,
                  onToggle: (val) =>
                      setState(() => _attendance[student.rollNo] = val),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrown,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              l10n.teacherSubmitAttendance,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final int rollNo;
  final String name;
  final bool isPresent;
  final ValueChanged<bool> onToggle;

  const _AttendanceTile({
    required this.rollNo,
    required this.name,
    required this.isPresent,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPresent ? AppColors.success : AppColors.error;
    final label = isPresent ? 'Present' : 'Absent';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPresent
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Text(
            '$rollNo',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: GestureDetector(
          onTap: () => onToggle(!isPresent),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
