import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_storage.dart';
import '../../login/login_screen.dart';
import '../../../data/models/announcement_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/teacher_model.dart';
import '../../../data/models/teacher_class_summary.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../student/view/student_list_screen.dart';
import '../../bus_tracking/view/bus_tracking_screen.dart';
import '../../timetable/view/timetable_screen.dart';
import '../../results/view/results_screen.dart';
import '../../attendance/view/attendance_screen.dart';
import '../../attendance/view/class_attendance_screen.dart';
import '../../fees/view/fees_screen.dart';
import '../../homework/view/homework_screen.dart';
import 'achievements_screen.dart';
import 'announcement_detail_screen.dart';
import 'announcements_list_screen.dart';
import 'tomorrow_prep_screen.dart';
import 'teacher_pending_hw_screen.dart';
import '../../homework/view/teacher_homework_screen.dart';
import 'class_grades_screen.dart';
import 'subject_performance_screen.dart';
import 'post_reminder_screen.dart';
import '../../attendance/view/take_attendance_screen.dart';
import '../../homework/view/post_homework_screen.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../core/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final UserRole role;
  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<String> _teacherClassKeys = [];
  String? _teacherName;

  bool get _isTeacher => widget.role == UserRole.teacher;

  // Tab bodies differ by role:
  //   Teacher  → [Dashboard, Students, Bus, Timetable]
  //   Student/Parent → [Dashboard, Bus, Timetable]
  int get _timetableTabIndex => _isTeacher ? 3 : 2;

  List<Widget> _buildTabs() => _isTeacher
      ? [
          _DashboardTab(
            role: widget.role,
            onTimetableTap: _goToTimetable,
            onStudentsTap: _goToStudents,
          ),
          StudentListScreen(
            teacherClasses:
                _teacherClassKeys.isEmpty ? null : _teacherClassKeys,
            teacherName: _teacherName,
          ),
          const BusTrackingScreen(),
          TimetableScreen(onBack: _goToDashboard),
        ]
      : [
          _DashboardTab(
            role: widget.role,
            onTimetableTap: _goToTimetable,
          ),
          const BusTrackingScreen(),
          TimetableScreen(onBack: _goToDashboard),
        ];

  void _goToTimetable() => setState(() => _currentIndex = _timetableTabIndex);
  void _goToDashboard() => setState(() => _currentIndex = 0);
  void _goToStudents() => setState(() => _currentIndex = 1);

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeFetchDashboard(widget.role));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoaded && _isTeacher) {
          final keys = state.teacherClasses
              .map((c) => '${c.classGrade}-${c.section}')
              .toList();
          final name = state.currentTeacher?.name;
          if (keys.join() != _teacherClassKeys.join() ||
              name != _teacherName) {
            setState(() {
              _teacherClassKeys = keys;
              _teacherName = name;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _currentIndex,
          children: _buildTabs(),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _isTeacher
        ? [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outlined),
              activeIcon: const Icon(Icons.people),
              label: l10n.navStudents,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.directions_bus_outlined),
              activeIcon: const Icon(Icons.directions_bus),
              label: l10n.navBus,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: l10n.navTimetable,
            ),
          ]
        : [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.directions_bus_outlined),
              activeIcon: const Icon(Icons.directions_bus),
              label: l10n.navBus,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: l10n.navTimetable,
            ),
          ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: items,
      ),
    );
  }
}

// ─────────────────────────── DASHBOARD TAB ───────────────────────────

class _DashboardTab extends StatelessWidget {
  final UserRole role;
  final VoidCallback onTimetableTap;
  final VoidCallback? onStudentsTap;
  const _DashboardTab({
    required this.role,
    required this.onTimetableTap,
    this.onStudentsTap,
  });

  static const double _kMaxWidth = 800;

  Widget _frame(Widget child) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxWidth),
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, state),
            if (state is HomeLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryBrown),
                ),
              )
            else if (state is HomeLoaded) ...[
              SliverToBoxAdapter(child: _buildOverviewSection(context, state)),
              if (!state.isTeacher)
                SliverToBoxAdapter(child: _buildMyTeachersSection(context, state)),
              SliverToBoxAdapter(child: _buildQuickActions(context, state)),
              SliverToBoxAdapter(child: _buildAnnouncementsSection(context, state)),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, HomeState state) {
    final l10n = AppLocalizations.of(context)!;
    final loaded = state is HomeLoaded ? state : null;
    final isParent = loaded?.isParent ?? false;
    final isTeacher = loaded?.isTeacher ?? false;
    // Teacher → teacher's first name; parent → parent's first name; student → student's first name
    final firstName = isTeacher
        ? loaded?.currentTeacher?.firstName
        : isParent
            ? loaded?.parentName?.split(' ').first
            : loaded?.currentStudent?.name.split(' ').first;
    final greeting = _getGreeting(l10n);
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.primaryBrown,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryBrownDark, AppColors.primaryBrown, AppColors.primaryBrownLight],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _kMaxWidth),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: AppColors.gold, width: 2),
                            ),
                            child: ClipOval(
                              child: Image.asset('assets/images/sgm_logo.jpg', fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.schoolName,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.goldLight,
                                  ),
                                ),
                                Text(
                                  greeting,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (firstName != null)
                                  Text(
                                    firstName,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Builder(builder: (ctx) {
                            final unread = state is HomeLoaded
                                ? state.announcements
                                    .where((a) => !state.isRead(a.id))
                                    .length
                                : 0;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        unread > 0
                                            ? Icons.notifications_rounded
                                            : Icons.notifications_outlined,
                                        color: Colors.white,
                                      ),
                                      if (unread > 0)
                                        Positioned(
                                          top: -1,
                                          right: -1,
                                          child: Container(
                                            width: 9,
                                            height: 9,
                                            decoration: BoxDecoration(
                                              color: AppColors.error,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors.primaryBrown,
                                                  width: 1.5),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  onPressed: () => Navigator.push(
                                    ctx,
                                    MaterialPageRoute(
                                      builder: (_) => const AnnouncementsListScreen(
                                          showUnreadOnly: true),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.logout_rounded,
                                      color: Colors.white),
                                  tooltip: 'Log out',
                                  onPressed: () => _confirmLogout(ctx),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context, HomeLoaded state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.isTeacher && state.currentTeacher != null) {
      return _frame(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── My Classes ───────────────────────────────────────
              Text(l10n.teacherMyClasses,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              ...state.teacherClasses.map(
                (classInfo) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TeacherClassCard(classInfo: classInfo, l10n: l10n),
                ),
              ),
              const SizedBox(height: 8),

              // ── School Overview (condensed) ──────────────────────
              Text(l10n.teacherSchoolOverview,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: l10n.homeStatTotalStudents,
                      value: '${state.stats['totalStudents']}',
                      icon: Icons.school,
                      color: AppColors.primaryBrown,
                      bgColor: AppColors.surfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: l10n.homeStatAttendanceToday,
                      value: '${state.stats['todayAttendance']}%',
                      icon: Icons.how_to_reg,
                      color: AppColors.success,
                      bgColor: AppColors.successLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Shared upcoming events computation
    final todayMidnight = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final upcoming = state.announcements
        .where((a) =>
            !a.date.isBefore(todayMidnight) &&
            (a.type == AnnouncementType.exam ||
                a.type == AnnouncementType.event ||
                a.type == AnnouncementType.holiday ||
                a.type == AnnouncementType.sports))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // ── Parent view ───────────────────────────────────────────────────────
    if (state.isParent && state.currentStudent != null) {
      return _frame(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.homeOverview,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (state.children.length > 1) ...[
                _ChildSwitcher(
                  children: state.children,
                  selected: state.currentStudent!,
                ),
                const SizedBox(height: 12),
              ],
              _ParentMonitorRow(
                student: state.currentStudent!,
                onAttendanceTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AttendanceScreen(student: state.currentStudent!),
                  ),
                ),
                onFeesTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeesScreen(student: state.currentStudent!),
                  ),
                ),
                onResultsTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ResultsScreen(student: state.currentStudent!),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ParentAlertsCard(student: state.currentStudent!),
              const SizedBox(height: 12),
              _UpcomingOverviewCard(upcoming: upcoming.take(3).toList()),
            ],
          ),
        ),
      );
    }

    // ── Student view ──────────────────────────────────────────────────────
    final attendancePct = state.currentStudent?.attendancePercent ?? 0.0;

    return _frame(
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeOverview, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _AttendanceOverviewCard(
                      percent: attendancePct,
                      onTap: state.currentStudent != null
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AttendanceScreen(
                                      student: state.currentStudent!),
                                ),
                              )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TomorrowPrepCard(
                      onTap: state.currentStudent != null
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TomorrowPrepScreen(
                                      student: state.currentStudent!),
                                ),
                              )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _UpcomingOverviewCard(upcoming: upcoming.take(3).toList()),
          ],
        ),
      ),
    );
  }

  // ── MY TEACHERS (student / parent only) ──────────────────────
  Widget _buildMyTeachersSection(BuildContext context, HomeLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    final student = state.currentStudent;
    final classTeacher = state.classTeacher;

    // Class teacher first, then remaining subject teachers
    final ordered = [
      if (classTeacher != null) classTeacher,
      ...state.subjectTeachers.where((t) => t.id != classTeacher?.id),
    ];

    return _frame(
      Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                state.isParent && student != null
                    ? l10n.homeParentChildTeachers(student.name.split(' ').first)
                    : l10n.homeMyTeachers,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  student != null ? 'Class ${student.classGrade}-${student.section}' : '',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryBrown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 166,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 9),
              itemCount: ordered.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final teacher = ordered[i];
                final isClassTeacher = teacher.id == classTeacher?.id;
                return _TeacherCard(teacher: teacher, isClassTeacher: isClassTeacher);
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, HomeLoaded state) {
    final l10n = AppLocalizations.of(context)!;

    // Teacher quick actions
    if (state.isTeacher && state.currentTeacher != null) {
      final teacher = state.currentTeacher!;
      final (classGrade, section) = teacher.inchargeClassParts;

      final actions = [
        _QuickAction(
          icon: Icons.how_to_reg_outlined,
          label: l10n.teacherTakeAttendance,
          color: AppColors.success,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TakeAttendanceScreen(
                  classGrade: classGrade, section: section),
            ),
          ),
        ),
        _QuickAction(
          icon: Icons.library_books_outlined,
          label: l10n.teacherPostHomework,
          color: AppColors.info,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostHomeworkScreen(
                  subject: teacher.subject,
                  classes: state.teacherClasses
                      .map((c) => c.classLabel)
                      .toList()),
            ),
          ),
        ),
        _QuickAction(
          icon: Icons.notifications_outlined,
          label: l10n.teacherPostReminder,
          color: AppColors.saffron,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostReminderScreen(
                  classes: state.teacherClasses
                      .map((c) => c.classLabel)
                      .toList()),
            ),
          ),
        ),
        _QuickAction(
          icon: Icons.assignment_outlined,
          label: l10n.teacherMyHomework,
          color: AppColors.lotusPink,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  TeacherHomeworkScreen(teacherName: teacher.name),
            ),
          ),
        ),
        _QuickAction(
          icon: Icons.people_outlined,
          label: l10n.navStudents,
          color: AppColors.primaryBrown,
          onTap: () => onStudentsTap?.call(),
        ),
        _QuickAction(
          icon: Icons.campaign_outlined,
          label: l10n.homeAnnouncements,
          color: AppColors.gold,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnnouncementsListScreen()),
          ),
        ),
      ];

      return _frame(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.homeQuickAccess,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = constraints.maxWidth > 500 ? 6 : 3;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: actions.length,
                    itemBuilder: (context, i) => _buildActionTile(context, actions[i]),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    // Student / parent quick actions
    final actions = [
      _QuickAction(
        icon: Icons.bar_chart_rounded,
        label: l10n.quickResults,
        color: AppColors.primaryBrown,
        onTap: state.currentStudent != null
            ? () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ResultsScreen(student: state.currentStudent!),
                ))
            : null,
      ),
      _QuickAction(
        icon: Icons.event_note_outlined,
        label: l10n.quickTimetable,
        color: AppColors.info,
        onTap: () => onTimetableTap(),
      ),
      _QuickAction(
        icon: Icons.how_to_reg_outlined,
        label: l10n.quickAttendance,
        color: AppColors.success,
        onTap: state.currentStudent != null
            ? () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                      AttendanceScreen(student: state.currentStudent!),
                ))
            : null,
      ),
      _QuickAction(
        icon: Icons.payments_outlined,
        label: l10n.quickFees,
        color: AppColors.saffron,
        onTap: state.currentStudent != null
            ? () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => FeesScreen(student: state.currentStudent!),
                ))
            : null,
      ),
      _QuickAction(
        icon: Icons.library_books_outlined,
        label: l10n.quickHomework,
        color: AppColors.lotusPink,
        onTap: state.currentStudent != null
            ? () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                      HomeworkScreen(student: state.currentStudent!),
                ))
            : null,
      ),
      _QuickAction(
        icon: Icons.military_tech_rounded,
        label: l10n.quickAchievements,
        color: AppColors.gold,
        onTap: state.currentStudent != null
            ? () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                      AchievementsScreen(student: state.currentStudent!),
                ))
            : null,
      ),
    ];

    return _frame(
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeQuickAccess,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth > 500 ? 6 : 3;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: actions.length,
                  itemBuilder: (context, i) => _buildActionTile(context, actions[i]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, _QuickAction a) {
    return GestureDetector(
      onTap: a.onTap,
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: a.color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(a.icon, color: a.color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              a.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementsSection(BuildContext context, HomeLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    return _frame(
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.homeAnnouncements, style: Theme.of(context).textTheme.titleLarge),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AnnouncementsListScreen(),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    l10n.homeViewAll,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryBrown,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...state.announcements.take(4).map(
                  (a) => _AnnouncementCard(
                    announcement: a,
                    isRead: state.isRead(a.id),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true && context.mounted) {
        await AuthStorage.clearSession();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }
      }
    });
  }

  String _getGreeting(AppLocalizations l10n) {
    final h = DateTime.now().hour;
    if (h < 12) return '${l10n.greetingMorning}! 🌤';
    if (h < 17) return '${l10n.greetingAfternoon}! ☀️';
    return '${l10n.greetingEvening}! 🌙';
  }
}

// ─────────────────────────── TEACHER CARD ───────────────────────────

class _TeacherCard extends StatelessWidget {
  final TeacherModel teacher;
  final bool isClassTeacher;

  const _TeacherCard({required this.teacher, required this.isClassTeacher});

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
    final l10n = AppLocalizations.of(context)!;
    final avatarColor = _avatarColors[teacher.avatarColorIndex % _avatarColors.length];

    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isClassTeacher
            ? Border.all(color: AppColors.gold, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: avatarColor,
                child: Text(
                  teacher.photoInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isClassTeacher)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            teacher.name.replaceFirst(RegExp(r'^(Mrs?\.|Ms\.) '), ''),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            isClassTeacher ? l10n.homeClassTeacher : teacher.subject,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isClassTeacher ? AppColors.gold : AppColors.textHint,
              fontWeight: isClassTeacher ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── SHARED WIDGETS ─────────────────────────

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── OVERVIEW CARDS ────────────────────────

class _AttendanceOverviewCard extends StatelessWidget {
  final double percent;
  final VoidCallback? onTap;
  const _AttendanceOverviewCard({required this.percent, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pct = percent.clamp(0.0, 100.0);
    final Color color;
    final Color bgColor;
    final String status;
    if (pct >= 75) {
      color = AppColors.success;
      bgColor = AppColors.successLight;
      status = l10n.attendanceGoodStanding;
    } else if (pct >= 60) {
      color = AppColors.saffron;
      bgColor = AppColors.warningLight;
      status = 'At Risk';
    } else {
      color = AppColors.error;
      bgColor = AppColors.errorLight;
      status = 'At Risk';
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.homeStatMyAttendance,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: pct / 100,
                        strokeWidth: 5,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                      Center(
                        child: Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TomorrowPrepCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _TomorrowPrepCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dayName = DateFormat('EEEE').format(tomorrow);
    final isWeekend = tomorrow.weekday == DateTime.sunday;
    final periodCount =
        isWeekend ? 0 : DummyData.periodsCountFor(dayName);
    final reminderCount =
        isWeekend ? 0 : DummyData.remindersForDay(dayName).length;
    final dayShort = DateFormat('EEE').format(tomorrow);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Tomorrow's Prep",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    size: 16, color: AppColors.textHint),
              ],
            ),
            if (isWeekend)
              Text(
                'Weekend 🎉',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
              )
            else ...[
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calendar_today_outlined,
                        color: AppColors.primaryBrown, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$periodCount periods',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryBrown,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      Text(
                        dayShort,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
              if (reminderCount > 0)
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.saffron,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '$reminderCount reminder${reminderCount == 1 ? '' : 's'} from teachers',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.saffron,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'All clear',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textHint),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UpcomingOverviewCard extends StatelessWidget {
  final List<AnnouncementModel> upcoming;
  const _UpcomingOverviewCard({required this.upcoming});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayMidnight = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_outlined, size: 18, color: AppColors.info),
              const SizedBox(width: 6),
              Text(
                l10n.homeUpcomingEvents,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (upcoming.isEmpty)
            Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Text(
                  l10n.homeNoUpcomingEvents,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            )
          else
            ...upcoming.asMap().entries.map((entry) {
              final i = entry.key;
              final a = entry.value;
              final aMidnight =
                  DateTime(a.date.year, a.date.month, a.date.day);
              final daysAway =
                  aMidnight.difference(todayMidnight).inDays;
              final when = daysAway == 0
                  ? 'Today'
                  : daysAway == 1
                      ? 'Tomorrow'
                      : 'in $daysAway days';
              final color = _typeColor(a.type);
              return Padding(
                padding: EdgeInsets.only(
                    bottom: i < upcoming.length - 1 ? 10 : 0),
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<HomeBloc>()
                        .add(HomeMarkAnnouncementRead(a.id));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AnnouncementDetailScreen(announcement: a),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(_typeIcon(a.type), color: color, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('d MMM').format(a.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.textHint),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          when,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Color _typeColor(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam:
        return AppColors.error;
      case AnnouncementType.holiday:
        return AppColors.success;
      case AnnouncementType.event:
        return AppColors.info;
      case AnnouncementType.fee:
        return AppColors.saffron;
      case AnnouncementType.sports:
        return AppColors.lotusPink;
      case AnnouncementType.general:
        return AppColors.primaryBrown;
    }
  }

  IconData _typeIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam:
        return Icons.quiz_outlined;
      case AnnouncementType.holiday:
        return Icons.beach_access_outlined;
      case AnnouncementType.event:
        return Icons.event_outlined;
      case AnnouncementType.fee:
        return Icons.payments_outlined;
      case AnnouncementType.sports:
        return Icons.sports_outlined;
      case AnnouncementType.general:
        return Icons.campaign_outlined;
    }
  }
}

// ─────────────────────── TEACHER CLASS CARD ─────────────────────────────────

class _TeacherClassCard extends StatelessWidget {
  final TeacherClassSummary classInfo;
  final AppLocalizations l10n;

  const _TeacherClassCard({required this.classInfo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return classInfo.isIncharge
        ? _InchargeCard(classInfo: classInfo, l10n: l10n)
        : _SubjectTeacherCard(classInfo: classInfo, l10n: l10n);
  }
}

// ── Incharge class card (brown gradient, full metrics) ───────────────────────

class _InchargeCard extends StatelessWidget {
  final TeacherClassSummary classInfo;
  final AppLocalizations l10n;
  const _InchargeCard({required this.classInfo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final attendancePct = classInfo.attendancePercent ?? 0;
    final attendanceColor = attendancePct >= 85
        ? AppColors.goldLight
        : attendancePct >= 75
            ? AppColors.saffronLight
            : AppColors.saffron;
    final avgPct = classInfo.classStats.classOverallAverage;
    final avgColor = avgPct >= 80
        ? AppColors.goldLight
        : avgPct >= 60
            ? AppColors.saffronLight
            : AppColors.saffron;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBrownDark, AppColors.primaryBrown],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.teacherClassIncharge.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.75),
                            letterSpacing: 0.8,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      classInfo.classLabel,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        classInfo.subject,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  Text(
                    '${classInfo.todayPeriods}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    "Today's\nPeriods",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                  ),
                ],
              ),
            ],
          ),

          // ── Stats row ────────────────────────────────────────────
          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _InchargeStatCell(
                    icon: Icons.how_to_reg_outlined,
                    label: l10n.teacherClassAttendance,
                    value: '${attendancePct.toStringAsFixed(0)}%',
                    color: attendanceColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClassAttendanceScreen(
                          classGrade: classInfo.classGrade,
                          section: classInfo.section,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.2)),
                Expanded(
                  child: _InchargeStatCell(
                    icon: Icons.school_outlined,
                    label: l10n.teacherAvgGrade,
                    value: '${avgPct.toStringAsFixed(1)}%',
                    color: avgColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClassGradesScreen(
                          classGrade: classInfo.classGrade,
                          section: classInfo.section,
                          stats: classInfo.classStats,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.2)),
                Expanded(
                  child: _InchargeStatCell(
                    icon: Icons.library_books_outlined,
                    label: l10n.teacherPendingHW,
                    value: '${classInfo.pendingHomework}',
                    color: classInfo.pendingHomework > 0
                        ? AppColors.gold
                        : Colors.white,
                    onTap: classInfo.pendingHomework > 0
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TeacherPendingHWScreen(
                                  classGrade: classInfo.classGrade,
                                  section: classInfo.section,
                                ),
                              ),
                            )
                        : null,
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

class _InchargeStatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  const _InchargeStatCell(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    )),
            Text(label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    )),
          ],
        ),
      ),
    );
  }
}

// ── Subject-teacher card (surface card, subject-specific metrics) ─────────────

class _SubjectTeacherCard extends StatelessWidget {
  final TeacherClassSummary classInfo;
  final AppLocalizations l10n;
  const _SubjectTeacherCard({required this.classInfo, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final subjectAvg = classInfo.subjectAvg;
    final avgColor = subjectAvg >= 80
        ? AppColors.success
        : subjectAvg >= 60
            ? AppColors.saffron
            : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(color: AppColors.primaryBrown, width: 4),
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.teacherSubjectTeacher.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primaryBrown,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        classInfo.classLabel,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          classInfo.subject,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: AppColors.primaryBrown,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      '${classInfo.todayPeriods}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    Text(
                      "Today's\nPeriods",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),

            // ── Stats row ──────────────────────────────────────────
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _SubjectStatCell(
                      icon: Icons.bar_chart_outlined,
                      label: l10n.teacherSubjectAvg,
                      value: '${subjectAvg.toStringAsFixed(1)}%',
                      color: avgColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubjectPerformanceScreen(
                            classGrade: classInfo.classGrade,
                            section: classInfo.section,
                            subject: classInfo.subject,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                      width: 1, thickness: 1, color: AppColors.divider),
                  Expanded(
                    child: _SubjectStatCell(
                      icon: Icons.library_books_outlined,
                      label: l10n.teacherPendingHW,
                      value: '${classInfo.pendingHomework}',
                      color: classInfo.pendingHomework > 0
                          ? AppColors.saffron
                          : AppColors.success,
                      onTap: classInfo.pendingHomework > 0
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TeacherPendingHWScreen(
                                    classGrade: classInfo.classGrade,
                                    section: classInfo.section,
                                    subjectFilter: classInfo.subject,
                                  ),
                                ),
                              )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectStatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  const _SubjectStatCell(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    )),
            Text(label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    )),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

class _AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final bool isRead;
  const _AnnouncementCard({required this.announcement, required this.isRead});

  void _onTap(BuildContext context) {
    if (!isRead) {
      context.read<HomeBloc>().add(HomeMarkAnnouncementRead(announcement.id));
    }
    NotificationService.instance.showAnnouncementNotification(announcement);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnnouncementDetailScreen(announcement: announcement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return announcement.isPinned
        ? _buildPinned(context)
        : _buildRegular(context);
  }

  Widget _buildPinned(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typeColor = _typeColor(announcement.type);
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gold banner header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.gold, AppColors.goldLight],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(13),
                      topRight: Radius.circular(13),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.push_pin_rounded, size: 13, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        l10n.announcementPinned,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Spacer(),
                      if (!isRead)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10n.announcementNew,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel(announcement.type, l10n),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                // Card body
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_typeIcon(announcement.type), color: typeColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              announcement.body,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    size: 12, color: AppColors.textHint),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    announcement.postedBy,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: AppColors.textHint),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('d MMM').format(announcement.date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: AppColors.textHint),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegular(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typeColor = _typeColor(announcement.type);
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isRead ? AppColors.surface : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_typeIcon(announcement.type), color: typeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        announcement.body,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isRead ? AppColors.textHint : AppColors.textSecondary,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _typeLabel(announcement.type, l10n),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: typeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('d MMM').format(announcement.date),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: typeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: typeColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _typeColor(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam:
        return AppColors.error;
      case AnnouncementType.holiday:
        return AppColors.success;
      case AnnouncementType.event:
        return AppColors.info;
      case AnnouncementType.fee:
        return AppColors.saffron;
      case AnnouncementType.sports:
        return AppColors.lotusPink;
      case AnnouncementType.general:
        return AppColors.primaryBrown;
    }
  }

  IconData _typeIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam:
        return Icons.quiz_outlined;
      case AnnouncementType.holiday:
        return Icons.beach_access_outlined;
      case AnnouncementType.event:
        return Icons.event_outlined;
      case AnnouncementType.fee:
        return Icons.payments_outlined;
      case AnnouncementType.sports:
        return Icons.sports_outlined;
      case AnnouncementType.general:
        return Icons.campaign_outlined;
    }
  }

  String _typeLabel(AnnouncementType type, AppLocalizations l10n) {
    switch (type) {
      case AnnouncementType.exam:
        return l10n.announcementTypeExam;
      case AnnouncementType.holiday:
        return l10n.announcementTypeHoliday;
      case AnnouncementType.event:
        return l10n.announcementTypeEvent;
      case AnnouncementType.fee:
        return l10n.announcementTypeFee;
      case AnnouncementType.sports:
        return l10n.announcementTypeSports;
      case AnnouncementType.general:
        return l10n.announcementTypeGeneral;
    }
  }
}

// ─────────────────────── CHILD SWITCHER ─────────────────────────────────────

class _ChildSwitcher extends StatelessWidget {
  final List<StudentModel> children;
  final StudentModel selected;
  const _ChildSwitcher({required this.children, required this.selected});

  static const List<Color> _chipColors = [
    AppColors.primaryBrown,
    AppColors.info,
    AppColors.success,
    AppColors.saffron,
    AppColors.lotusPink,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: children.map((child) {
          final isSelected = child.id == selected.id;
          final color =
              _chipColors[children.indexOf(child) % _chipColors.length];
          return GestureDetector(
            onTap: isSelected
                ? null
                : () =>
                    context.read<HomeBloc>().add(HomeSelectChild(child)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : AppColors.divider,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    child.name.split(' ').first,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Class ${child.classGrade}-${child.section}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.85)
                              : AppColors.textHint,
                        ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────── PARENT MONITOR ROW ────────────────────────────────────

class _ParentMonitorRow extends StatelessWidget {
  final StudentModel student;
  final VoidCallback onAttendanceTap;
  final VoidCallback onFeesTap;
  final VoidCallback onResultsTap;

  const _ParentMonitorRow({
    required this.student,
    required this.onAttendanceTap,
    required this.onFeesTap,
    required this.onResultsTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pct = student.attendancePercent.clamp(0.0, 100.0);
    final attendanceColor = pct >= 75
        ? AppColors.success
        : pct >= 60
            ? AppColors.saffron
            : AppColors.error;

    final feeColor = student.feeStatus == 'Paid'
        ? AppColors.success
        : student.feeStatus == 'Overdue'
            ? AppColors.error
            : AppColors.saffron;

    final gradeColor = _gradeColor(student.grade);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _MonitorCell(
                icon: Icons.how_to_reg_outlined,
                label: l10n.homeStatMyAttendance,
                value: '${pct.toStringAsFixed(0)}%',
                color: attendanceColor,
                onTap: onAttendanceTap,
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
            Expanded(
              child: _MonitorCell(
                icon: Icons.school_outlined,
                label: l10n.homeParentGrade,
                value: student.grade,
                color: gradeColor,
                onTap: onResultsTap,
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
            Expanded(
              child: _MonitorCell(
                icon: Icons.payments_outlined,
                label: l10n.homeParentFeeStatus,
                value: student.feeStatus,
                color: feeColor,
                onTap: onFeesTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _gradeColor(String grade) {
    if (grade == 'A1' || grade == 'A2') return AppColors.success;
    if (grade == 'B1' || grade == 'B2') return AppColors.info;
    if (grade == 'C1' || grade == 'C2') return AppColors.saffron;
    return AppColors.error;
  }
}

class _MonitorCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _MonitorCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textHint,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────── PARENT ALERTS CARD ────────────────────────────────────

class _ParentAlertsCard extends StatelessWidget {
  final StudentModel student;
  const _ParentAlertsCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alerts = _buildAlerts(l10n);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active_outlined,
                  size: 18, color: AppColors.primaryBrown),
              const SizedBox(width: 6),
              Text(
                l10n.homeParentAlerts,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 6),
              if (alerts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${alerts.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (alerts.isEmpty)
            Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Text(l10n.homeParentNoAlerts,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textSecondary)),
              ],
            )
          else
            ...alerts.map((a) => _AlertRow(alert: a)),
        ],
      ),
    );
  }

  List<_AlertData> _buildAlerts(AppLocalizations l10n) {
    final alerts = <_AlertData>[];
    final pct = student.attendancePercent;
    if (pct < 75) {
      alerts.add(_AlertData(
        icon: Icons.warning_amber_rounded,
        color: AppColors.error,
        message: l10n.homeParentLowAttendance,
      ));
    }
    if (student.feeStatus == 'Partial' || student.feeStatus == 'Overdue') {
      alerts.add(_AlertData(
        icon: Icons.payments_outlined,
        color: AppColors.saffron,
        message: l10n.homeParentOverdueFees,
      ));
    }
    final overdueCount = DummyData.homeworkFor(student.classGrade, student.section)
        .where((h) => h.isOverdue)
        .length;
    if (overdueCount > 0) {
      alerts.add(_AlertData(
        icon: Icons.library_books_outlined,
        color: AppColors.error,
        message: l10n.homeParentOverdueHomework(overdueCount),
      ));
    }
    return alerts;
  }
}

class _AlertData {
  final IconData icon;
  final Color color;
  final String message;
  const _AlertData(
      {required this.icon, required this.color, required this.message});
}

class _AlertRow extends StatelessWidget {
  final _AlertData alert;
  const _AlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: alert.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(alert.icon, size: 14, color: alert.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              alert.message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
