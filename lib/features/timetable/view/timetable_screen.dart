import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/timetable_model.dart';
import '../../../data/repositories/teacher_repository.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_state.dart';
import '../bloc/timetable_bloc.dart';
import '../bloc/timetable_event.dart';
import '../bloc/timetable_state.dart';

enum _TeacherView { mySchedule, classSchedule }

class TimetableScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const TimetableScreen({super.key, this.onBack});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
  ];

  // Teacher-mode state
  bool _isTeacherMode = false;
  bool _hasInchargeClass = false;
  _TeacherView _teacherView = _TeacherView.mySchedule;
  Map<String, List<TimetablePeriod>> _teacherSchedule = {};
  String _teacherInchargeLabel = ''; // e.g. "Class 10-A"

  // Unified selected day (used for both teacher schedule and TimetableBloc)
  String _selectedDay = _todayName();

  void _fetchFor(String classGrade, String section) {
    context.read<TimetableBloc>().add(
      TimetableFetch(classGrade: classGrade, section: section),
    );
  }

  static String _todayName() {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    final idx = DateTime.now().weekday - 1;
    return idx < 6 ? days[idx] : days[0]; // default Monday on Sunday
  }

  @override
  void initState() {
    super.initState();
    // HomeBloc may still be loading when IndexedStack builds all tabs at once,
    // so only configure now if the state is already resolved. Otherwise the
    // BlocListener in build() will call _setupFromHomeState when HomeLoaded fires.
    final homeState = context.read<HomeBloc>().state;
    if (homeState is HomeLoaded) _setupFromHomeState(homeState);
  }

  Future<void> _setupFromHomeState(HomeLoaded state) async {
    if (state.isTeacher && state.currentTeacher != null) {
      final teacher = state.currentTeacher!;
      final schedule = await context
          .read<TeacherRepository>()
          .fetchSchedule(teacher.name);
      if (!mounted) return;
      final (classGrade, section) = teacher.inchargeClassParts;
      setState(() {
        _isTeacherMode = true;
        _hasInchargeClass = teacher.classIncharge.isNotEmpty;
        _teacherSchedule = schedule;
        _teacherInchargeLabel = 'Class $classGrade-$section';
      });
      _fetchFor(classGrade, section);
    } else if (state.currentStudent != null) {
      _fetchFor(state.currentStudent!.classGrade, state.currentStudent!.section);
    }
  }

  // Sync TimetableBloc day selection whenever _selectedDay changes
  void _onDaySelected(String day) {
    setState(() => _selectedDay = day);
    context.read<TimetableBloc>().add(TimetableSelectDay(day));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.timetableTitle),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        automaticallyImplyLeading: widget.onBack == null,
        actions: [
          if (!_isTeacherMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: BlocBuilder<TimetableBloc, TimetableState>(
                  builder: (context, state) {
                    if (state is TimetableLoaded) {
                      return _ClassBadge(
                          classGrade: state.classGrade, section: state.section);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
        ],
      ),
      body: _isTeacherMode
          ? _buildTeacherBody(context)
          : _buildStudentParentBody(context),
    );

    // Listen for the initial HomeLoaded event (covers the race where IndexedStack
    // builds this tab before HomeBloc has finished loading) and for student/parent
    // child switches.
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) {
        if (curr is! HomeLoaded) return false;
        if (prev is! HomeLoaded) return true; // first load
        if (curr.isTeacher) return false;     // teacher state doesn't change mid-session
        return prev.currentStudent?.id != curr.currentStudent?.id;
      },
      listener: (context, state) {
        if (state is HomeLoaded) _setupFromHomeState(state);
      },
      child: scaffold,
    );
  }

  // ── Teacher body ───────────────────────────────────────────────

  Widget _buildTeacherBody(BuildContext context) {
    return Column(
      children: [
        // View toggle: "My Schedule" + "Class X-A"
        _buildTeacherViewToggle(context),
        // Day selector
        _buildDaySelector(context),
        // Content
        Expanded(
          child: _teacherView == _TeacherView.mySchedule
              ? _buildMyScheduleList(context)
              : _buildClassScheduleList(context),
        ),
      ],
    );
  }

  Widget _buildTeacherViewToggle(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          _ViewChip(
            label: 'My Schedule',
            icon: Icons.person_outline,
            isSelected: _teacherView == _TeacherView.mySchedule,
            onTap: () => setState(() => _teacherView = _TeacherView.mySchedule),
          ),
          if (_hasInchargeClass) ...[
            const SizedBox(width: 8),
            _ViewChip(
              label: _teacherInchargeLabel,
              icon: Icons.class_outlined,
              isSelected: _teacherView == _TeacherView.classSchedule,
              onTap: () =>
                  setState(() => _teacherView = _TeacherView.classSchedule),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMyScheduleList(BuildContext context) {
    final periods = _teacherSchedule[_selectedDay] ?? [];
    if (periods.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.free_breakfast_outlined,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(
              'No teaching periods on $_selectedDay',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: periods.length,
      itemBuilder: (context, i) => _PeriodCard(
        period: periods[i],
        index: i,
        subtitleLabel: 'Class',
      ),
    );
  }

  Widget _buildClassScheduleList(BuildContext context) {
    return BlocBuilder<TimetableBloc, TimetableState>(
      builder: (context, state) {
        if (state is TimetableLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBrown),
          );
        }
        if (state is TimetableLoaded) {
          final periods = state.timetable[_selectedDay] ?? [];
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: periods.length,
            itemBuilder: (context, i) => _PeriodCard(
              period: periods[i],
              index: i,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  // ── Student / parent body ──────────────────────────────────────

  Widget _buildStudentParentBody(BuildContext context) {
    return BlocBuilder<TimetableBloc, TimetableState>(
      builder: (context, state) {
        if (state is TimetableLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBrown),
          );
        }
        if (state is TimetableLoaded) {
          return Column(
            children: [
              _buildDaySelector(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: state.periodsForSelectedDay.length,
                  itemBuilder: (context, i) => _PeriodCard(
                    period: state.periodsForSelectedDay[i],
                    index: i,
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  // ── Shared day selector ────────────────────────────────────────

  Widget _buildDaySelector(BuildContext context) {
    return Container(
      height: 52,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _days.length,
        itemBuilder: (context, i) {
          final day = _days[i];
          final isSelected = day == _selectedDay;
          return GestureDetector(
            onTap: () => _onDaySelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBrown
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  day.substring(0, 3),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────── VIEW TOGGLE CHIP ───────────────────────────────

class _ViewChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBrown : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBrown.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── CLASS BADGE ────────────────────────────────────

class _ClassBadge extends StatelessWidget {
  final String classGrade;
  final String section;
  const _ClassBadge({required this.classGrade, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
    );
  }
}

// ─────────────────────────── PERIOD CARD ────────────────────────────────────

class _PeriodCard extends StatelessWidget {
  final TimetablePeriod period;
  final int index;
  /// When set, replaces the "teacher name" label with this prefix (e.g. "Class").
  final String? subtitleLabel;

  const _PeriodCard({
    required this.period,
    required this.index,
    this.subtitleLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (period.isBreak) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(child: Divider(color: AppColors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    period.subject == 'Lunch'
                        ? Icons.lunch_dining_outlined
                        : Icons.coffee_outlined,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${period.subject} • ${period.time}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Expanded(child: Divider(color: AppColors.divider)),
          ],
        ),
      );
    }

    final subject = SubjectModel.forName(period.subject);
    final color = subject.color;
    // For teacher's own schedule, period.teacher holds the class label ("Class 10-A")
    final subtitle = period.teacher.isNotEmpty ? period.teacher : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  period.time.split(' - ')[0],
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  width: 1.5,
                  height: 60,
                  color: AppColors.divider,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
                Text(
                  period.time.split(' - ')[1],
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border(left: BorderSide(color: color, width: 4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(subject.icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(period.subject,
                            style: Theme.of(context).textTheme.titleSmall),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textHint),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (period.room.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(period.room,
                          style: Theme.of(context).textTheme.labelSmall),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
