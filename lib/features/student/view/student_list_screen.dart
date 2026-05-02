import 'dart:async';
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
  /// When provided, only students from these class keys (e.g. "11-A", "10-A")
  /// are shown and a class filter chip bar appears at the top.
  final List<String>? teacherClasses;

  /// When provided, the student detail screen shows an "Award Badge" FAB.
  final String? teacherName;

  const StudentListScreen({super.key, this.teacherClasses, this.teacherName});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  String _searchQuery = '';
  String? _selectedClass; // null = show all teacher classes
  int _displayCount = 20;

  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(const StudentFetchAll());
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final max = _scrollCtrl.position.maxScrollExtent;
    if (max > 0 && _scrollCtrl.offset >= max * 0.85) {
      setState(() => _displayCount += 20);
    }
  }

  List<StudentModel> _applyFilters(List<StudentModel> all) {
    // 1. Restrict to teacher's classes when applicable
    var result = widget.teacherClasses != null
        ? all
            .where((s) =>
                widget.teacherClasses!.contains('${s.classGrade}-${s.section}'))
            .toList()
        : all;

    // 2. Class chip selection
    if (_selectedClass != null) {
      result = result
          .where((s) => '${s.classGrade}-${s.section}' == _selectedClass)
          .toList();
    }

    // 3. Text search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((s) =>
              s.name.toLowerCase().contains(q) ||
              s.classGrade.contains(q) ||
              s.admissionNo.toLowerCase().contains(q) ||
              s.section.toLowerCase().contains(q))
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasClassFilter =
        widget.teacherClasses != null && widget.teacherClasses!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.studentsTitle),
      ),
      body: Column(
        children: [
          _buildSearchBar(l10n),
          if (hasClassFilter) _buildClassFilterBar(widget.teacherClasses!),
          Expanded(
            child: BlocBuilder<StudentBloc, StudentState>(
              buildWhen: (prev, curr) =>
                  curr is StudentListLoaded ||
                  (curr is StudentLoading && prev is StudentInitial),
              builder: (context, state) {
                if (state is StudentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryBrown),
                  );
                }
                if (state is StudentListLoaded) {
                  final students = _applyFilters(state.students);
                  if (students.isEmpty) return _buildEmpty(l10n);
                  return RefreshIndicator(
                    color: AppColors.primaryBrown,
                    onRefresh: () async {
                      setState(() => _displayCount = 20);
                      final completer = Completer<void>();
                      context.read<StudentBloc>().add(StudentRefresh(completer: completer));
                      await completer.future;
                    },
                    child: _buildList(students),
                  );
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
        onChanged: (q) => setState(() => _searchQuery = q),
        decoration: InputDecoration(
          hintText: l10n.studentsSearchHint,
          prefixIcon:
              const Icon(Icons.search, color: AppColors.textHint, size: 20),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildClassFilterBar(List<String> classes) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          _ClassChip(
            label: 'All',
            selected: _selectedClass == null,
            onTap: () => setState(() => _selectedClass = null),
          ),
          ...classes.map((cls) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _ClassChip(
                  label: 'Class $cls',
                  selected: _selectedClass == cls,
                  onTap: () => setState(() => _selectedClass = cls),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildList(List<StudentModel> students) {
    final count = students.length < _displayCount ? students.length : _displayCount;
    return ListView.builder(
      controller: _scrollCtrl,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: count,
      itemBuilder: (context, index) {
        return _StudentCard(student: students[index], teacherName: widget.teacherName);
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
          Text(
            l10n.studentsNoneFound,
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

// ── Class filter chip ─────────────────────────────────────────────────────────

class _ClassChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ClassChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBrown : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primaryBrown : AppColors.divider,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBrown.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Student card ──────────────────────────────────────────────────────────────

class _StudentCard extends StatelessWidget {
  final StudentModel student;
  final String? teacherName;
  const _StudentCard({required this.student, this.teacherName});

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
    final avatarColor =
        _avatarColors[student.avatarColorIndex % _avatarColors.length];
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
              child: StudentDetailScreen(
                studentId: student.id,
                teacherName: teacherName,
              ),
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
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: avatarColor,
              child: Text(
                student.photoInitials,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _InfoChip(
                          label:
                              'Class ${student.classGrade}-${student.section}',
                          icon: Icons.class_outlined),
                      const SizedBox(width: 6),
                      _InfoChip(
                          label: 'Roll ${student.rollNo}', icon: Icons.tag),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.admissionNo,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: attendanceColor.withValues(alpha: 0.1),
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
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.textHint),
                ),
                const SizedBox(height: 2),
                const Icon(Icons.chevron_right,
                    color: AppColors.textHint, size: 18),
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
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
