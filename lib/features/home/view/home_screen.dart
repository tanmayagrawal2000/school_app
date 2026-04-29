import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_storage.dart';
import '../../login/login_screen.dart';
import '../../../data/models/announcement_model.dart';
import '../../../data/models/teacher_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../student/view/student_list_screen.dart';
import '../../bus_tracking/view/bus_tracking_screen.dart';
import '../../timetable/view/timetable_screen.dart';
import '../../results/view/results_screen.dart';
import '../../attendance/view/attendance_screen.dart';
import '../../fees/view/fees_screen.dart';
import '../../homework/view/homework_screen.dart';
import 'achievements_screen.dart';
import 'announcement_detail_screen.dart';
import 'announcements_list_screen.dart';
import 'tomorrow_prep_screen.dart';
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

  bool get _isTeacher => widget.role == UserRole.teacher;

  // Tab bodies differ by role:
  //   Teacher  → [Dashboard, Students, Bus, Timetable]
  //   Student/Parent → [Dashboard, Bus, Timetable]
  int get _timetableTabIndex => _isTeacher ? 3 : 2;

  List<Widget> get _tabs => _isTeacher
      ? [
          _DashboardTab(role: widget.role, onTimetableTap: _goToTimetable),
          const StudentListScreen(),
          const BusTrackingScreen(),
          TimetableScreen(onBack: _goToDashboard),
        ]
      : [
          _DashboardTab(role: widget.role, onTimetableTap: _goToTimetable),
          const BusTrackingScreen(),
          TimetableScreen(onBack: _goToDashboard),
        ];

  void _goToTimetable() => setState(() => _currentIndex = _timetableTabIndex);
  void _goToDashboard() => setState(() => _currentIndex = 0);

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeFetchDashboard(widget.role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
  const _DashboardTab({required this.role, required this.onTimetableTap});

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
    final firstName = state is HomeLoaded && state.currentStudent != null
        ? state.currentStudent!.name.split(' ').first
        : null;
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

    if (state.isTeacher) {
      final cards = [
        _StatCard(
          title: l10n.homeStatTotalStudents,
          value: '${state.stats['totalStudents']}',
          icon: Icons.school,
          color: AppColors.primaryBrown,
          bgColor: AppColors.surfaceVariant,
        ),
        _StatCard(
          title: l10n.homeStatTeachers,
          value: '${state.stats['totalTeachers']}',
          icon: Icons.person,
          color: AppColors.info,
          bgColor: AppColors.infoLight,
        ),
        _StatCard(
          title: l10n.homeStatAttendanceToday,
          value: '${state.stats['todayAttendance']}%',
          icon: Icons.how_to_reg,
          color: AppColors.success,
          bgColor: AppColors.successLight,
        ),
        _StatCard(
          title: l10n.homeStatBusesOnRoute,
          value: '${state.stats['busesOnRoute']}',
          icon: Icons.directions_bus,
          color: AppColors.saffron,
          bgColor: AppColors.warningLight,
        ),
      ];
      return _frame(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.homeOverview, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 500;
                  return GridView.count(
                    crossAxisCount: wide ? 4 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: wide ? 2.0 : 1.7,
                    children: cards,
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    // Student / Parent view
    final attendancePct = state.currentStudent?.attendancePercent ?? 0.0;
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
              Text(l10n.homeMyTeachers, style: Theme.of(context).textTheme.titleLarge),
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
    final actions = [
      _QuickAction(icon: Icons.bar_chart_rounded, label: l10n.quickResults, color: AppColors.primaryBrown),
      _QuickAction(icon: Icons.event_note_outlined, label: l10n.quickTimetable, color: AppColors.info),
      _QuickAction(icon: Icons.how_to_reg_outlined, label: l10n.quickAttendance, color: AppColors.success),
      _QuickAction(icon: Icons.payments_outlined, label: l10n.quickFees, color: AppColors.saffron),
      _QuickAction(icon: Icons.library_books_outlined, label: l10n.quickHomework, color: AppColors.lotusPink),
      _QuickAction(icon: Icons.military_tech_rounded, label: l10n.quickAchievements, color: AppColors.gold),
    ];
    return _frame(
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeQuickAccess, style: Theme.of(context).textTheme.titleLarge),
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
                  itemBuilder: (context, i) {
              final a = actions[i];
              return GestureDetector(
                onTap: () {
                  if (a.label == l10n.quickResults && state.currentStudent != null) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => ResultsScreen(student: state.currentStudent!),
                    ));
                  } else if (a.label == l10n.quickAttendance && state.currentStudent != null) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => AttendanceScreen(student: state.currentStudent!),
                    ));
                  } else if (a.label == l10n.quickFees && state.currentStudent != null) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => FeesScreen(student: state.currentStudent!),
                    ));
                  } else if (a.label == l10n.quickHomework && state.currentStudent != null) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => HomeworkScreen(student: state.currentStudent!),
                    ));
                  } else if (a.label == l10n.quickTimetable) {
                    onTimetableTap();
                  } else if (a.label == l10n.quickAchievements && state.currentStudent != null) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => AchievementsScreen(student: state.currentStudent!),
                    ));
                  }
                },
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
                  },
                );
              },
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

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickAction({required this.icon, required this.label, required this.color});
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
