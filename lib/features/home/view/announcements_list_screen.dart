import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/announcement_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'announcement_detail_screen.dart';
import '../../../core/services/notification_service.dart';
import 'package:sgm_school_app/l10n/app_localizations.dart';

class AnnouncementsListScreen extends StatefulWidget {
  final bool showUnreadOnly;
  const AnnouncementsListScreen({super.key, this.showUnreadOnly = false});

  @override
  State<AnnouncementsListScreen> createState() => _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState extends State<AnnouncementsListScreen> {
  AnnouncementType? _filter;
  late bool _unreadOnly;

  @override
  void initState() {
    super.initState();
    _unreadOnly = widget.showUnreadOnly;
  }

  static const _typeOrder = [
    AnnouncementType.exam,
    AnnouncementType.event,
    AnnouncementType.sports,
    AnnouncementType.holiday,
    AnnouncementType.fee,
    AnnouncementType.general,
  ];

  List<AnnouncementModel> _filtered(
      List<AnnouncementModel> all, Set<String> readIds) {
    var list = _unreadOnly ? all.where((a) => !readIds.contains(a.id)).toList() : all;
    if (_filter != null) list = list.where((a) => a.type == _filter).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! HomeLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrown),
            );
          }

          final all = state.announcements;
          final unreadCount = all.where((a) => !state.isRead(a.id)).length;
          final filtered = _filtered(all, state.readIds);

          // Collect types that actually have items
          final presentTypes = _typeOrder.where((t) => all.any((a) => a.type == t)).toList();

          return RefreshIndicator(
            color: AppColors.primaryBrown,
            onRefresh: () async {
              final completer = Completer<void>();
              context.read<HomeBloc>().add(HomeRefresh(completer: completer));
              await completer.future;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
              _buildAppBar(context, unreadCount, l10n),
              SliverToBoxAdapter(
                child: _buildFilterRow(context, all, presentTypes, unreadCount, l10n),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _unreadOnly
                              ? Icons.done_all_rounded
                              : Icons.inbox_outlined,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _unreadOnly
                              ? l10n.announcementsAllCaughtUp
                              : l10n.announcementsNone,
                          style: const TextStyle(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _AnnouncementListCard(
                        announcement: filtered[i],
                        isRead: state.isRead(filtered[i].id),
                        onTap: () {
                          if (!state.isRead(filtered[i].id)) {
                            context
                                .read<HomeBloc>()
                                .add(HomeMarkAnnouncementRead(filtered[i].id));
                          }
                          NotificationService.instance
                              .showAnnouncementNotification(filtered[i]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AnnouncementDetailScreen(
                                announcement: filtered[i],
                              ),
                            ),
                          );
                        },
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, int unreadCount, AppLocalizations l10n) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 100,
      backgroundColor: AppColors.primaryBrown,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBrownDark,
                AppColors.primaryBrown,
                AppColors.primaryBrownLight,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.announcementsTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            l10n.announcementsUnreadCount(unreadCount),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(
    BuildContext context,
    List<AnnouncementModel> all,
    List<AnnouncementType> types,
    int unreadCount,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: l10n.filterAll,
              count: all.length,
              selected: !_unreadOnly && _filter == null,
              color: AppColors.primaryBrown,
              onTap: () => setState(() {
                _unreadOnly = false;
                _filter = null;
              }),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: l10n.filterUnread,
              count: unreadCount,
              selected: _unreadOnly,
              color: AppColors.error,
              onTap: () => setState(() {
                _unreadOnly = !_unreadOnly;
                _filter = null;
              }),
            ),
            ...types.map((t) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _FilterChip(
                    label: _typeLabel(t, l10n),
                    count: all.where((a) => a.type == t).length,
                    selected: !_unreadOnly && _filter == t,
                    color: _typeColor(t),
                    onTap: () => setState(() {
                      _unreadOnly = false;
                      _filter = _filter == t ? null : t;
                    }),
                  ),
                )),
            const SizedBox(width: 16),
          ],
        ),
      ),
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

// ─────────────────────── FILTER CHIP ────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.color,
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
          color: selected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : AppColors.divider,
            width: selected ? 0 : 1,
          ),
          boxShadow: selected
              ? [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: selected ? Colors.white : color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── LIST CARD ──────────────────────────────────

class _AnnouncementListCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final bool isRead;
  final VoidCallback onTap;

  const _AnnouncementListCard({
    required this.announcement,
    required this.isRead,
    required this.onTap,
  });

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
      onTap: onTap,
      child: Container(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gold, AppColors.goldLight]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.push_pin_rounded, size: 13, color: Colors.white),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      l10n.announcementPinned,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                          letterSpacing: 0.6,
                        ),
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
                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 12, color: AppColors.textHint),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                announcement.postedBy,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: AppColors.textHint),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('d MMM yyyy').format(announcement.date),
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
    );
  }

  Widget _buildRegular(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typeColor = _typeColor(announcement.type);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
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
                            DateFormat('d MMM yyyy').format(announcement.date),
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
