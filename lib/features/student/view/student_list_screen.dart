import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/student_model.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import 'student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(const StudentFetchAll());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.studentsTitle),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(l10n),
          Expanded(
            child: BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                if (state is StudentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryBrown),
                  );
                }
                if (state is StudentListLoaded) {
                  if (state.filtered.isEmpty) {
                    return _buildEmpty(l10n);
                  }
                  return _buildList(state.filtered);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (q) => context.read<StudentBloc>().add(StudentSearch(q)),
        decoration: InputDecoration(
          hintText: l10n.studentsSearchHint,
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 20),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    context.read<StudentBloc>().add(const StudentSearch(''));
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildList(List<StudentModel> students) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: students.length,
      itemBuilder: (context, index) {
        return _StudentCard(student: students[index]);
      },
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(l10n.studentsNoneFound, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentModel student;
  const _StudentCard({required this.student});

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
    final avatarColor = _avatarColors[student.avatarColorIndex % _avatarColors.length];
    final attendanceColor = student.attendancePercent >= 90
        ? AppColors.success
        : student.attendancePercent >= 75
            ? AppColors.saffron
            : AppColors.error;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<StudentBloc>(),
              child: StudentDetailScreen(studentId: student.id),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: avatarColor,
              child: Text(
                student.photoInitials,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _InfoChip(label: 'Class ${student.classGrade}-${student.section}', icon: Icons.class_outlined),
                      const SizedBox(width: 6),
                      _InfoChip(label: 'Roll ${student.rollNo}', icon: Icons.tag),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.admissionNo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: attendanceColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${student.attendancePercent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: attendanceColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  student.house,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textHint),
                ),
                const SizedBox(height: 2),
                const Icon(Icons.chevron_right, color: AppColors.textHint, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.textSecondary),
          const SizedBox(width: 3),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
