import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/attendance_model.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';

class StudentDetailScreen extends StatefulWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<StudentBloc>().add(StudentFetchDetail(widget.studentId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryBrown)),
          );
        }
        if (state is StudentDetailLoaded) {
          return _buildDetail(context, state.student, state.attendance);
        }
        return const Scaffold(body: Center(child: Text('Error loading student')));
      },
    );
  }

  Widget _buildDetail(BuildContext context, StudentModel student, List<AttendanceRecord> attendance) {
    final avatarColors = [
      AppColors.primaryBrown, AppColors.info, AppColors.success,
      AppColors.saffron, AppColors.lotusPink, AppColors.gold, AppColors.primaryBrownLight,
    ];
    final avatarColor = avatarColors[student.avatarColorIndex % avatarColors.length];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryBrown,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryBrownDark, AppColors.primaryBrown],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: avatarColor,
                        child: Text(
                          student.photoInitials,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        student.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Class ${student.classGrade}-${student.section} | Roll No. ${student.rollNo}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.goldLight),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _HeaderBadge(label: student.house, icon: Icons.shield_outlined),
                          const SizedBox(width: 8),
                          _HeaderBadge(label: student.bloodGroup, icon: Icons.water_drop_outlined),
                          const SizedBox(width: 8),
                          _HeaderBadge(label: student.gender, icon: Icons.person_outline),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.gold,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Profile'),
                Tab(text: 'Results'),
                Tab(text: 'Attendance'),
                Tab(text: 'Fee'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _ProfileTab(student: student),
            _ResultsTab(student: student),
            _AttendanceTab(attendance: attendance),
            _FeeTab(student: student),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── PROFILE TAB ────────────────────────
class _ProfileTab extends StatelessWidget {
  final StudentModel student;
  const _ProfileTab({required this.student});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionCard(
          title: 'Personal Information',
          icon: Icons.person_outline,
          children: [
            _InfoRow('Admission No.', student.admissionNo),
            _InfoRow('Date of Birth', student.dateOfBirth),
            _InfoRow('Gender', student.gender),
            _InfoRow('Blood Group', student.bloodGroup),
            _InfoRow('House', student.house),
          ],
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: 'Parent Information',
          icon: Icons.family_restroom_outlined,
          children: [
            _InfoRow("Father's Name", student.fatherName),
            _InfoRow("Mother's Name", student.motherName),
            _InfoRow('Contact', student.contactNumber),
            _InfoRow('Address', student.address),
          ],
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: 'Transport',
          icon: Icons.directions_bus_outlined,
          children: [
            _InfoRow('Bus Route', student.busRoute),
            _InfoRow('Bus Number', student.busNumber),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────── RESULTS TAB ────────────────────────
class _ResultsTab extends StatelessWidget {
  final StudentModel student;
  const _ResultsTab({required this.student});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryBrown, AppColors.primaryBrownLight],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overall Performance', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(
                      '${student.overallPercent.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('Grade: ${student.grade}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.goldLight)),
                  ],
                ),
              ),
              CircularPercentIndicator(
                radius: 50,
                lineWidth: 8,
                percent: student.overallPercent / 100,
                center: Text(
                  student.grade,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                ),
                progressColor: AppColors.gold,
                backgroundColor: Colors.white24,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...student.results.map((r) => _ResultCard(result: r)),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final SubjectResult result;
  const _ResultCard({required this.result});

  Color get _gradeColor {
    if (result.percentage >= 91) return AppColors.success;
    if (result.percentage >= 81) return AppColors.info;
    if (result.percentage >= 61) return AppColors.saffron;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(result.subject, style: Theme.of(context).textTheme.titleSmall),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.grade,
                  style: TextStyle(color: _gradeColor, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearPercentIndicator(
                  lineHeight: 8,
                  percent: result.percentage / 100,
                  backgroundColor: AppColors.surfaceVariant,
                  progressColor: _gradeColor,
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${result.obtainedMarks}/${result.maxMarks}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────── ATTENDANCE TAB ────────────────────────
class _AttendanceTab extends StatefulWidget {
  final List<AttendanceRecord> attendance;
  const _AttendanceTab({required this.attendance});

  @override
  State<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<_AttendanceTab> {
  DateTime _focusedDay = DateTime.now();
  late List<AttendanceRecord> _records;
  late Map<DateTime, AttendanceStatus> _statusMap;

  @override
  void initState() {
    super.initState();
    _records = widget.attendance;
    _statusMap = {for (final r in _records) _normalize(r.date): r.status};
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  AttendanceStatus? _statusFor(DateTime day) => _statusMap[_normalize(day)];

  @override
  Widget build(BuildContext context) {
    final present = _records.where((r) => r.status == AttendanceStatus.present || r.status == AttendanceStatus.late).length;
    final absent = _records.where((r) => r.status == AttendanceStatus.absent).length;
    final working = _records.where((r) => r.status != AttendanceStatus.sunday && r.status != AttendanceStatus.holiday).length;
    final pct = working > 0 ? (present / working * 100) : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            _AttendanceStat(label: 'Present', value: '$present', color: AppColors.success),
            const SizedBox(width: 10),
            _AttendanceStat(label: 'Absent', value: '$absent', color: AppColors.error),
            const SizedBox(width: 10),
            _AttendanceStat(label: 'Attendance', value: '${pct.toStringAsFixed(1)}%', color: AppColors.primaryBrown),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: TableCalendar(
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2025, 12, 31),
            focusedDay: _focusedDay,
            onPageChanged: (d) => setState(() => _focusedDay = d),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: Theme.of(context).textTheme.titleMedium!,
              headerPadding: const EdgeInsets.symmetric(vertical: 8),
              leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primaryBrown),
              rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.primaryBrown),
            ),
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(fontSize: 13),
              weekendTextStyle: TextStyle(fontSize: 13, color: AppColors.error),
              outsideTextStyle: TextStyle(fontSize: 13, color: AppColors.textHint),
              todayDecoration: BoxDecoration(color: AppColors.primaryBrown, shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final status = _statusFor(day);
                if (status == null) return null;
                Color? bg;
                switch (status) {
                  case AttendanceStatus.present:
                    bg = AppColors.success;
                    break;
                  case AttendanceStatus.absent:
                    bg = AppColors.error;
                    break;
                  case AttendanceStatus.late:
                    bg = AppColors.saffron;
                    break;
                  case AttendanceStatus.holiday:
                    bg = AppColors.info.withOpacity(0.7);
                    break;
                  default:
                    return null;
                }
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(context),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _LegendItem(color: AppColors.success, label: 'Present'),
        _LegendItem(color: AppColors.error, label: 'Absent'),
        _LegendItem(color: AppColors.saffron, label: 'Late'),
        _LegendItem(color: AppColors.info.withOpacity(0.7), label: 'Holiday'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _AttendanceStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _AttendanceStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── FEE TAB ────────────────────────
class _FeeTab extends StatelessWidget {
  final StudentModel student;
  const _FeeTab({required this.student});

  @override
  Widget build(BuildContext context) {
    final balance = student.totalFee - student.paidFee;
    final paidPct = student.totalFee > 0 ? (student.paidFee / student.totalFee) : 0.0;
    final statusColor = student.feeStatus == 'Paid'
        ? AppColors.success
        : student.feeStatus == 'Partial'
            ? AppColors.saffron
            : AppColors.error;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [statusColor, statusColor.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text('Fee Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      student.feeStatus,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                lineHeight: 10,
                percent: paidPct.clamp(0.0, 1.0),
                backgroundColor: Colors.white30,
                progressColor: Colors.white,
                barRadius: const Radius.circular(5),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FeeAmount(label: 'Total Fee', amount: student.totalFee, color: Colors.white),
                  _FeeAmount(label: 'Paid', amount: student.paidFee, color: Colors.white),
                  _FeeAmount(label: 'Balance', amount: balance, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Fee Breakup',
          icon: Icons.receipt_outlined,
          children: [
            _InfoRow('Tuition Fee', '₹30,000'),
            _InfoRow('Activity Fee', '₹5,000'),
            _InfoRow('Exam Fee', '₹3,000'),
            _InfoRow('Transport Fee', '₹7,000'),
            _InfoRow('Total', '₹${student.totalFee.toStringAsFixed(0)}'),
          ],
        ),
        if (balance > 0) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.payment_outlined),
              label: const Text('Pay Now'),
            ),
          ),
        ],
      ],
    );
  }
}

class _FeeAmount extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const _FeeAmount({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

// ──────────────────────── SHARED WIDGETS ────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primaryBrown, size: 16),
                ),
                const SizedBox(width: 10),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textHint)),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  const _HeaderBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
