import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/class_stats_model.dart';
import '../../../data/repositories/student_repository.dart';
import '../bloc/results_bloc.dart';
import '../bloc/results_event.dart';
import '../bloc/results_state.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class ResultsScreen extends StatelessWidget {
  final StudentModel student;
  const ResultsScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ResultsBloc(ctx.read<StudentRepository>())
        ..add(ResultsFetch(
            classGrade: student.classGrade, section: student.section)),
      child: _ResultsView(student: student),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final StudentModel student;
  const _ResultsView({required this.student});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.resultsScreenTitle(student.name.split(' ').first)),
      ),
      body: BlocBuilder<ResultsBloc, ResultsState>(
        builder: (context, state) {
          final classStats = state is ResultsLoaded ? state.classStats : null;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(context, classStats),
              const SizedBox(height: 16),
              _buildChart(context, classStats),
              const SizedBox(height: 16),
              _buildSubjectList(context, classStats),
            ],
          );
        },
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, ClassStats? cs) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBrownDark, AppColors.primaryBrown],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.resultsTitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  'Class ${student.classGrade}-${student.section}  •  ${l10n.resultsSession}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SummaryBadge(
                        label: l10n.resultsGrade,
                        value: student.grade,
                        color: _gradeColorBright(student.overallPercent)),
                    _SummaryBadge(
                        label: l10n.resultsScore,
                        value:
                            '${student.overallPercent.toStringAsFixed(1)}%',
                        color: AppColors.gold),
                    if (cs != null)
                      _SummaryBadge(
                          label: l10n.resultsClassRank,
                          value: '#${cs.studentRank} / ${cs.totalStudents}',
                          color: AppColors.saffronLight),
                  ],
                ),
                if (cs != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.people_outline,
                          color: Colors.white54, size: 13),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.resultsClassAvgValue('${cs.classOverallAverage.toStringAsFixed(1)}%'),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _DeltaBadge(
                          delta: student.overallPercent -
                              cs.classOverallAverage),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularPercentIndicator(
            radius: 52,
            lineWidth: 9,
            percent: student.overallPercent / 100,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  student.grade,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
                Text(
                  '${student.overallPercent.toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
            progressColor: AppColors.gold,
            backgroundColor: Colors.white24,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }

  // ── GROUPED BAR CHART ────────────────────────────────────────────────
  Widget _buildChart(BuildContext context, ClassStats? cs) {
    final l10n = AppLocalizations.of(context)!;
    final hasComparison = cs != null;

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
              Expanded(
                child: Text(l10n.resultsSubjectPerformance,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              // Legend
              if (hasComparison) ...[
                _LegendDot(color: AppColors.primaryBrown, label: l10n.resultsYou),
                const SizedBox(width: 10),
                _LegendDot(
                    color: AppColors.divider.withValues(alpha: 1.0),
                    label: l10n.resultsClassAvg,
                    textColor: AppColors.textHint),
              ],
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? l10n.resultsYou : l10n.resultsClassAvg;
                      return BarTooltipItem(
                        '$label: ${rod.toY.toInt()}%',
                        const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i >= student.results.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _subjectAbbr(student.results[i].subject),
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textHint),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (v) =>
                      const FlLine(color: AppColors.divider, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: student.results.asMap().entries.map((entry) {
                  final i = entry.key;
                  final r = entry.value;
                  final stat = cs?.statFor(r.subject);
                  final barW = hasComparison ? 10.0 : 22.0;

                  return BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: r.percentage,
                        color: _gradeColor(r.percentage),
                        width: barW,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      if (stat != null)
                        BarChartRodData(
                          toY: stat.classAverage,
                          color: const Color(0xFFBDBDBD),
                          width: barW,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── DETAILED MARKS WITH COMPARISON ──────────────────────────────────
  Widget _buildSubjectList(BuildContext context, ClassStats? cs) {
    final l10n = AppLocalizations.of(context)!;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(l10n.resultsDetailedMarks,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(l10n.resultsSubjectHeader,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.textHint))),
                Expanded(
                    flex: 2,
                    child: Text(l10n.resultsMarksHeader,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.textHint),
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text(l10n.resultsGradeHeader,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.textHint),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...student.results.asMap().entries.map((entry) {
            final r = entry.value;
            final gradeClr = _gradeColor(r.percentage);
            final stat = cs?.statFor(r.subject);
            final delta =
                stat != null ? r.percentage - stat.classAverage : null;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.subject,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            // Student progress bar
                            LinearPercentIndicator(
                              lineHeight: 6,
                              percent: r.percentage / 100,
                              backgroundColor: AppColors.surfaceVariant,
                              progressColor: gradeClr,
                              barRadius: const Radius.circular(3),
                              padding: EdgeInsets.zero,
                            ),
                            if (stat != null) ...[
                              const SizedBox(height: 4),
                              // Class avg bar (lighter)
                              LinearPercentIndicator(
                                lineHeight: 4,
                                percent: stat.classAverage / 100,
                                backgroundColor: AppColors.surfaceVariant,
                                progressColor:
                                    const Color(0xFFBDBDBD),
                                barRadius: const Radius.circular(2),
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Avg ${stat.classAverage.toStringAsFixed(0)}%  •  Topper ${stat.topperMarks}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                              color: AppColors.textHint,
                                              fontSize: 10),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  if (delta != null)
                                    _DeltaBadge(delta: delta, small: true),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${r.obtainedMarks}/${r.maxMarks}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: gradeClr.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(r.grade,
                                style: TextStyle(
                                    color: gradeClr,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (entry.key < student.results.length - 1)
                  const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Color _gradeColor(double pct) {
    if (pct >= 91) return AppColors.success;
    if (pct >= 81) return AppColors.info;
    if (pct >= 61) return AppColors.saffron;
    return AppColors.error;
  }

  // Bright variants readable on the dark brown gradient header
  Color _gradeColorBright(double pct) {
    if (pct >= 91) return const Color(0xFF69F0AE); // bright green
    if (pct >= 81) return const Color(0xFF82B1FF); // bright blue
    if (pct >= 61) return AppColors.saffronLight;
    return const Color(0xFFFF8A80); // bright red
  }

  String _subjectAbbr(String subject) {
    final words = subject.split(' ');
    if (words.length == 1) return subject.substring(0, 3).toUpperCase();
    return words.map((w) => w[0]).join().toUpperCase();
  }
}

// ── SHARED WIDGETS ────────────────────────────────────────────────────────

class _DeltaBadge extends StatelessWidget {
  final double delta;
  final bool small;
  const _DeltaBadge({required this.delta, this.small = false});

  @override
  Widget build(BuildContext context) {
    final isAbove = delta >= 0;
    final color = isAbove ? AppColors.success : AppColors.error;
    final bg = isAbove ? AppColors.successLight : AppColors.errorLight;
    final sign = isAbove ? '+' : '';
    final fontSize = small ? 9.0 : 11.0;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 5 : 7, vertical: small ? 2 : 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        '$sign${delta.toStringAsFixed(1)}%',
        style: TextStyle(
            color: color, fontSize: fontSize, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final Color textColor;
  const _LegendDot(
      {required this.color,
      required this.label,
      this.textColor = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _SummaryBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 15)),
          Text(label,
              style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10)),
        ],
      ),
    );
  }
}
