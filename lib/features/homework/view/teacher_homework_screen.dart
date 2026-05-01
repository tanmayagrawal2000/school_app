import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/homework_model.dart';
import '../../../data/models/roster_student.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/repositories/homework_repository.dart';

class TeacherHomeworkScreen extends StatefulWidget {
  final String teacherName;
  const TeacherHomeworkScreen({super.key, required this.teacherName});

  @override
  State<TeacherHomeworkScreen> createState() => _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState extends State<TeacherHomeworkScreen> {
  // classKey → homework list, e.g. "11-A" → [...]
  late Map<String, List<HomeworkItem>> _byClass;

  // 'all' | 'upcoming' | 'overdue'
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _byClass = DummyData.homeworkByClassForTeacher(widget.teacherName);
  }

  List<_HWEntry> get _entries {
    final now = DateTime.now();
    final list = <_HWEntry>[];
    for (final entry in _byClass.entries) {
      final parts = entry.key.split('-');
      final grade = parts[0];
      final section = parts[1];
      for (final hw in entry.value) {
        final isOverdue = hw.dueDate.isBefore(now);
        if (_filter == 'upcoming' && isOverdue) continue;
        if (_filter == 'overdue' && !isOverdue) continue;
        list.add(_HWEntry(classGrade: grade, section: section, hw: hw));
      }
    }
    // overdue first, then upcoming; within each group sort by due date
    list.sort((a, b) {
      final aOver = a.hw.dueDate.isBefore(now);
      final bOver = b.hw.dueDate.isBefore(now);
      if (aOver != bOver) return aOver ? -1 : 1;
      return a.hw.dueDate.compareTo(b.hw.dueDate);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Homework')),
      body: Column(
        children: [
          _buildFilterBar(context),
          Expanded(
            child: entries.isEmpty
                ? _EmptyState(filter: _filter)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    itemCount: entries.length,
                    itemBuilder: (context, i) => _HomeworkCard(
                      entry: entries[i],
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TeacherMarkSubmissionsScreen(
                              entry: entries[i],
                            ),
                          ),
                        );
                        setState(_reload);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    const filters = [
      ('all', 'All'),
      ('overdue', 'Overdue'),
      ('upcoming', 'Upcoming'),
    ];
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: filters.map((f) {
          final isSelected = _filter == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filter = f.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBrown
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  f.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Entry model ───────────────────────────────────────────────────────────────

class _HWEntry {
  final String classGrade;
  final String section;
  final HomeworkItem hw;
  const _HWEntry(
      {required this.classGrade, required this.section, required this.hw});
  String get classLabel => 'Class $classGrade-$section';
}

// ── Homework card ─────────────────────────────────────────────────────────────

class _HomeworkCard extends StatelessWidget {
  final _HWEntry entry;
  final VoidCallback onTap;
  const _HomeworkCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hw = entry.hw;
    final subject = SubjectModel.forName(hw.subject);
    final now = DateTime.now();
    final isOverdue = hw.dueDate.isBefore(now);
    final daysLeft = hw.dueDate.difference(now).inDays;

    final dueLabelColor = isOverdue
        ? AppColors.error
        : daysLeft <= 2
            ? AppColors.saffron
            : AppColors.success;
    final dueLabel = isOverdue
        ? 'Overdue · ${_fmtDate(hw.dueDate)}'
        : daysLeft == 0
            ? 'Due today'
            : 'Due ${_fmtDate(hw.dueDate)}';

    final submitted = DummyData.submittedCountFor(
        hw.id, entry.classGrade, entry.section);
    final total = DummyData.classRosterFor(entry.classGrade, entry.section).length;
    final allDone = submitted == total;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: subject.color, width: 4)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ───────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: subject.lightColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(subject.icon, size: 11, color: subject.color),
                        const SizedBox(width: 4),
                        Text(hw.subject,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: subject.color,
                                    fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(entry.classLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                  _PriorityBadge(priority: hw.priority),
                ],
              ),
              const SizedBox(height: 8),

              // ── Title ────────────────────────────────────────────
              Text(hw.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),

              // ── Due date ─────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 12, color: dueLabelColor),
                  const SizedBox(width: 4),
                  Text(dueLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: dueLabelColor, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 10),

              // ── Submission bar ────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : submitted / total,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            allDone ? AppColors.success : AppColors.primaryBrown),
                        minHeight: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$submitted / $total submitted',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: allDone
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right_rounded,
                      size: 16, color: AppColors.textHint),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const m = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${d.day} ${m[d.month - 1]}';
  }
}

class _PriorityBadge extends StatelessWidget {
  final HomeworkPriority priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (priority) {
      HomeworkPriority.high => ('High', AppColors.error),
      HomeworkPriority.medium => ('Medium', AppColors.saffron),
      HomeworkPriority.low => ('Low', AppColors.success),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined,
              size: 56, color: AppColors.textHint.withValues(alpha: 0.4)),
          const SizedBox(height: 14),
          Text(
            filter == 'overdue'
                ? 'No overdue assignments'
                : filter == 'upcoming'
                    ? 'No upcoming assignments'
                    : 'No homework assigned yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── MARK SUBMISSIONS SCREEN ─────────────────────────────

class TeacherMarkSubmissionsScreen extends StatefulWidget {
  final _HWEntry entry;
  const TeacherMarkSubmissionsScreen({super.key, required this.entry});

  @override
  State<TeacherMarkSubmissionsScreen> createState() =>
      _TeacherMarkSubmissionsScreenState();
}

class _TeacherMarkSubmissionsScreenState
    extends State<TeacherMarkSubmissionsScreen> {
  late List<RosterStudent> _roster;

  // Local draft — switches update this; Save commits it via the repository.
  late Set<String> _localSubmitted;

  bool _isSaving = false;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

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
  void initState() {
    super.initState();
    _roster = DummyData.classRosterFor(
        widget.entry.classGrade, widget.entry.section);
    // Seed local draft from currently saved state
    final hwId = widget.entry.hw.id;
    _localSubmitted = Set.of(
      _roster
          .where((s) => DummyData.isSubmittedBy(hwId, s.id))
          .map((s) => s.id),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<RosterStudent> get _filtered {
    if (_searchQuery.isEmpty) return _roster;
    final q = _searchQuery.toLowerCase();
    return _roster.where((s) => s.name.toLowerCase().contains(q)).toList();
  }

  void _toggleLocal(String studentId) {
    setState(() {
      if (_localSubmitted.contains(studentId)) {
        _localSubmitted.remove(studentId);
      } else {
        _localSubmitted.add(studentId);
      }
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await context
          .read<HomeworkRepository>()
          .saveSubmissions(widget.entry.hw.id, _localSubmitted);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submissions saved'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save submissions. Please try again.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hw = widget.entry.hw;
    final subject = SubjectModel.forName(hw.subject);
    final submittedCount = _localSubmitted.length;
    final total = _roster.length;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mark Submissions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.entry.classLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85)),
            ),
          ],
        ),
      ),
      // ── Sticky Save bar ──────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: const Offset(0, -4)),
          ],
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, 12 + MediaQuery.of(context).viewPadding.bottom),
            child: Row(
              children: [
                // Running count
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$submittedCount / $total',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: submittedCount == total
                                ? AppColors.success
                                : AppColors.primaryBrown,
                          ),
                    ),
                    Text('submitted',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Save Submissions'),
                  ),
                ),
              ],
            ),
          ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          // ── Assignment info ───────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: subject.color, width: 4)),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: subject.lightColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(subject.icon, size: 11, color: subject.color),
                          const SizedBox(width: 4),
                          Text(hw.subject,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: subject.color,
                                      fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _PriorityBadge(priority: hw.priority),
                  ],
                ),
                const SizedBox(height: 10),
                Text(hw.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                if (hw.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(hw.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary)),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 13, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      'Due ${_fmtDate(hw.dueDate)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Search bar ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (q) => setState(() => _searchQuery = q),
              decoration: InputDecoration(
                hintText: 'Search student…',
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textHint, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
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
          ),

          // ── Section label ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Submission Status',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w700),
            ),
          ),

          // ── Student list ──────────────────────────────────────────
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text('No students found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textHint)),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, indent: 72, color: AppColors.divider),
                itemBuilder: (context, i) {
                  final student = filtered[i];
                  final isSubmitted = _localSubmitted.contains(student.id);
                  final avatarColor = _avatarColors[
                      student.avatarColorIndex % _avatarColors.length];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: avatarColor,
                      child: Text(
                        student.photoInitials,
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    title: Text(student.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      isSubmitted ? 'Submitted' : 'Not submitted',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSubmitted
                              ? AppColors.success
                              : AppColors.textHint),
                    ),
                    trailing: Switch(
                      value: isSubmitted,
                      onChanged: (_) => _toggleLocal(student.id),
                      activeColor: AppColors.success,
                      activeTrackColor:
                          AppColors.success.withValues(alpha: 0.3),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${m[d.month - 1]}';
  }
}
