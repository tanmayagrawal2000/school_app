import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/announcement_model.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementModel announcement;
  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typeColor = _typeColor(announcement.type);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, typeColor, l10n),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMeta(context, typeColor, l10n),
                  const SizedBox(height: 20),
                  _buildBody(context),
                  const SizedBox(height: 24),
                  _buildFooter(context, typeColor, l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Color typeColor, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: announcement.isPinned ? 160 : 130,
      pinned: true,
      backgroundColor: announcement.isPinned ? AppColors.gold : AppColors.primaryBrown,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: announcement.isPinned
                  ? [AppColors.goldDark, AppColors.gold, AppColors.goldLight]
                  : [AppColors.primaryBrownDark, AppColors.primaryBrown, AppColors.primaryBrownLight],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_typeIcon(announcement.type), size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              _typeLabel(announcement.type, l10n),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      if (announcement.isPinned) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.push_pin_rounded, size: 11, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(l10n.announcementPinned,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    announcement.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeta(BuildContext context, Color typeColor, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon(announcement.type), color: typeColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 13, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        announcement.postedBy,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 13, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('EEEE, d MMMM yyyy').format(announcement.date),
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
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Text(
        announcement.body,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.7,
              color: AppColors.textPrimary,
            ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, Color typeColor, AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: typeColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_typeIcon(announcement.type), size: 14, color: typeColor),
              const SizedBox(width: 5),
              Text(
                _typeLabel(announcement.type, l10n),
                style: TextStyle(
                    color: typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          DateFormat('d MMM yyyy').format(announcement.date),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }

  Color _typeColor(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam: return AppColors.error;
      case AnnouncementType.holiday: return AppColors.success;
      case AnnouncementType.event: return AppColors.info;
      case AnnouncementType.fee: return AppColors.saffron;
      case AnnouncementType.sports: return AppColors.lotusPink;
      case AnnouncementType.general: return AppColors.primaryBrown;
    }
  }

  IconData _typeIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.exam: return Icons.quiz_outlined;
      case AnnouncementType.holiday: return Icons.beach_access_outlined;
      case AnnouncementType.event: return Icons.event_outlined;
      case AnnouncementType.fee: return Icons.payments_outlined;
      case AnnouncementType.sports: return Icons.sports_outlined;
      case AnnouncementType.general: return Icons.campaign_outlined;
    }
  }

  String _typeLabel(AnnouncementType type, AppLocalizations l10n) {
    switch (type) {
      case AnnouncementType.exam: return l10n.announcementTypeExam;
      case AnnouncementType.holiday: return l10n.announcementTypeHoliday;
      case AnnouncementType.event: return l10n.announcementTypeEvent;
      case AnnouncementType.fee: return l10n.announcementTypeFee;
      case AnnouncementType.sports: return l10n.announcementTypeSports;
      case AnnouncementType.general: return l10n.announcementTypeGeneral;
    }
  }
}
