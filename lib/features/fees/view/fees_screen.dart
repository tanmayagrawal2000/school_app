import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/fee_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/repositories/student_repository.dart';
import '../bloc/fees_bloc.dart';
import '../bloc/fees_event.dart';
import '../bloc/fees_state.dart';

class FeesScreen extends StatelessWidget {
  final StudentModel student;
  const FeesScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FeesBloc(ctx.read<StudentRepository>())
        ..add(FeesFetch(student.id)),
      child: const _FeesView(),
    );
  }
}

class _FeesView extends StatelessWidget {
  const _FeesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.feesTitle),
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<FeesBloc, FeesState>(
        builder: (context, state) {
          if (state is FeesLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBrown));
          }
          if (state is FeesError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: AppColors.error)));
          }
          if (state is FeesLoaded) {
            return _FeesContent(state: state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _FeesContent extends StatelessWidget {
  final FeesLoaded state;
  const _FeesContent({required this.state});

  static final _currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        _buildHeader(context),
        _buildSummaryRow(context),
        _buildInstallments(context),
      ],
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = _statusColor(state.student.feeStatus);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBrownDark, AppColors.primaryBrown],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrown.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.student.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.feesAdmissionNo(state.student.admissionNo),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Class ${state.student.classGrade}-${state.student.section}  •  ${l10n.feesSession}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.6)),
                ),
                child: Text(
                  _localizedFeeStatus(state.student.feeStatus, l10n),
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: LinearPercentIndicator(
                  lineHeight: 10,
                  percent: state.paidPercent,
                  backgroundColor: Colors.white24,
                  progressColor: state.paidPercent >= 1.0
                      ? AppColors.goldLight
                      : AppColors.saffronLight,
                  barRadius: const Radius.circular(5),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(state.paidPercent * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _FeeStat(
                  label: l10n.feesTotalFee,
                  value: _currency.format(state.student.totalFee),
                  color: Colors.white70),
              const SizedBox(width: 16),
              _FeeStat(
                  label: l10n.feesPaid,
                  value: _currency.format(state.paidAmount),
                  color: AppColors.goldLight),
              const SizedBox(width: 16),
              _FeeStat(
                  label: l10n.feesBalance,
                  value: _currency.format(state.balanceAmount),
                  color: state.balanceAmount > 0
                      ? AppColors.saffronLight
                      : Colors.white70),
            ],
          ),
        ],
      ),
    );
  }

  // ── SUMMARY CARDS ────────────────────────────────────────────────────
  Widget _buildSummaryRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final paid = state.installments
        .where((i) => i.status == FeeInstallmentStatus.paid)
        .length;
    final pending = state.installments
        .where((i) => i.status == FeeInstallmentStatus.pending)
        .length;
    final overdue = state.installments
        .where((i) => i.status == FeeInstallmentStatus.overdue)
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _MiniCard(
              label: l10n.feesStatusPaid, count: paid, color: AppColors.success, bg: AppColors.successLight),
          const SizedBox(width: 12),
          _MiniCard(
              label: l10n.feesStatusPending, count: pending, color: AppColors.warning, bg: AppColors.warningLight),
          const SizedBox(width: 12),
          _MiniCard(
              label: l10n.feesStatusOverdue, count: overdue, color: AppColors.error, bg: AppColors.errorLight),
        ],
      ),
    );
  }

  // ── INSTALLMENT CARDS ────────────────────────────────────────────────
  Widget _buildInstallments(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.feesInstallmentDetails,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...state.installments.map((inst) => _InstallmentCard(inst: inst)),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Paid':
        return AppColors.goldLight;
      case 'Partial':
        return AppColors.saffronLight;
      default:
        return const Color(0xFFFF7043);
    }
  }

  String _localizedFeeStatus(String status, AppLocalizations l10n) {
    switch (status) {
      case 'Paid':
        return l10n.feesStatusPaid;
      case 'Pending':
        return l10n.feesStatusPending;
      case 'Overdue':
        return l10n.feesStatusOverdue;
      case 'Partial':
        return l10n.feesStatusPartial;
      default:
        return status;
    }
  }
}

// ── INSTALLMENT CARD ────────────────────────────────────────────────────

class _InstallmentCard extends StatelessWidget {
  final FeeInstallment inst;
  const _InstallmentCard({required this.inst});

  static final _currency =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  static final _dateFmt = DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (color, bg, icon, label) = _statusProps(l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(inst.term,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(inst.period,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textHint)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: bg, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 12, color: color),
                      const SizedBox(width: 4),
                      Text(label,
                          style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _InfoChip(
                    icon: Icons.currency_rupee,
                    label: _currency.format(inst.amount),
                    color: color),
                _InfoChip(
                    icon: Icons.event_outlined,
                    label: l10n.feesDue(_dateFmt.format(inst.dueDate)),
                    color: AppColors.textSecondary),
                if (inst.paidDate != null)
                  _InfoChip(
                      icon: Icons.check_circle_outline,
                      label: l10n.feesPaidDate(_dateFmt.format(inst.paidDate!)),
                      color: AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color, IconData, String) _statusProps(AppLocalizations l10n) {
    switch (inst.status) {
      case FeeInstallmentStatus.paid:
        return (AppColors.success, AppColors.successLight,
            Icons.check_circle_outline, l10n.feesStatusPaid);
      case FeeInstallmentStatus.overdue:
        return (AppColors.error, AppColors.errorLight,
            Icons.warning_amber_outlined, l10n.feesStatusOverdue);
      case FeeInstallmentStatus.partial:
        return (AppColors.warning, AppColors.warningLight,
            Icons.timelapse_outlined, l10n.feesStatusPartial);
      case FeeInstallmentStatus.pending:
        return (AppColors.info, AppColors.infoLight,
            Icons.schedule_outlined, l10n.feesStatusPending);
    }
  }
}

// ── SHARED SMALL WIDGETS ─────────────────────────────────────────────────

class _FeeStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _FeeStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 10)),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bg;
  const _MiniCard(
      {required this.label,
      required this.count,
      required this.color,
      required this.bg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text('$count',
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    color: color.withValues(alpha: 0.8), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
