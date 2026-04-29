import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/timetable_model.dart';
import '../bloc/timetable_bloc.dart';
import '../bloc/timetable_event.dart';
import '../bloc/timetable_state.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<TimetableBloc>().add(
      const TimetableFetch(classGrade: '10', section: 'A'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: BlocBuilder<TimetableBloc, TimetableState>(
                builder: (context, state) {
                  if (state is TimetableLoaded) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Class ${state.classGrade}-${state.section}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TimetableBloc, TimetableState>(
        builder: (context, state) {
          if (state is TimetableLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrown),
            );
          }
          if (state is TimetableLoaded) {
            return Column(
              children: [
                _buildDaySelector(context, state),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context, TimetableLoaded state) {
    return Container(
      height: 52,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _days.length,
        itemBuilder: (context, i) {
          final day = _days[i];
          final isSelected = day == state.selectedDay;
          return GestureDetector(
            onTap: () => context.read<TimetableBloc>().add(TimetableSelectDay(day)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBrown : AppColors.surfaceVariant,
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

class _PeriodCard extends StatelessWidget {
  final TimetablePeriod period;
  final int index;
  const _PeriodCard({required this.period, required this.index});


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
                      color: color.withOpacity(0.12),
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
                        if (period.teacher.isNotEmpty)
                          Text(
                            period.teacher,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
