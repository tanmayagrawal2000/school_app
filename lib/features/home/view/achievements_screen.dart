import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/badge_model.dart';
import '../../../data/models/badge_type_model.dart';
import '../../../data/models/student_model.dart';
import '../../../data/repositories/badge_repository.dart';
import '../../../features/achievements/bloc/badge_bloc.dart';
import '../../../features/achievements/bloc/badge_event.dart';
import '../../../features/achievements/bloc/badge_state.dart';
import '../../../l10n/app_localizations.dart';

// ─── Material definitions ────────────────────────────────────────────────────

class _BadgeMaterial {
  final LinearGradient gradient;
  final bool hasGloss;
  final bool hasVeins;
  final Color borderColor;
  final Color innerHighlight;
  final Color bannerBg;
  final Color bannerLabel;
  final Color iconColor;
  final Color iconShadow;

  const _BadgeMaterial({
    required this.gradient,
    this.hasGloss = false,
    this.hasVeins = false,
    required this.borderColor,
    required this.innerHighlight,
    required this.bannerBg,
    required this.bannerLabel,
    required this.iconColor,
    required this.iconShadow,
  });

  static const gold = _BadgeMaterial(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFEDD56A),
        Color(0xFFD4A020),
        Color(0xFF6B4A00),
        Color(0xFFCE9A18),
        Color(0xFF5A3D00),
      ],
      stops: [0.0, 0.28, 0.50, 0.72, 1.0],
    ),
    borderColor: Color(0xFF8B6000),
    innerHighlight: Color(0xFFFFE88A),
    bannerBg: Color(0xFF5A3A00),
    bannerLabel: Color(0xFFFFE066),
    iconColor: Color(0xFF4A2A00),
    iconShadow: Color(0xFF1E0E00),
  );

  static const blueEnamel = _BadgeMaterial(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF4090E0),
        Color(0xFF1555B5),
        Color(0xFF0A3590),
        Color(0xFF082878),
      ],
      stops: [0.0, 0.35, 0.65, 1.0],
    ),
    hasGloss: true,
    borderColor: Color(0xFF0A2060),
    innerHighlight: Color(0xFF80C0FF),
    bannerBg: Color(0xFF071848),
    bannerLabel: Color(0xFF90C8FF),
    iconColor: Color(0xFFFFFFFF),
    iconShadow: Color(0xFF061040),
  );

  static const bronze = _BadgeMaterial(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFD4A078),
        Color(0xFFB06030),
        Color(0xFF6B3010),
        Color(0xFFA05828),
        Color(0xFF4A1E08),
      ],
      stops: [0.0, 0.28, 0.52, 0.72, 1.0],
    ),
    borderColor: Color(0xFF3C1808),
    innerHighlight: Color(0xFFFFD0A0),
    bannerBg: Color(0xFF3A1208),
    bannerLabel: Color(0xFFFFD0A8),
    iconColor: Color(0xFFFFF0E8),
    iconShadow: Color(0xFF1E0800),
  );

  static const darkWood = _BadgeMaterial(
    gradient: LinearGradient(
      begin: Alignment(-0.6, -1.0),
      end: Alignment(0.6, 1.0),
      colors: [
        Color(0xFF6B3822),
        Color(0xFF2E1408),
        Color(0xFF503020),
        Color(0xFF1C0A04),
        Color(0xFF3E2010),
      ],
      stops: [0.0, 0.25, 0.50, 0.75, 1.0],
    ),
    borderColor: Color(0xFF180800),
    innerHighlight: Color(0xFFAA7050),
    bannerBg: Color(0xFF100600),
    bannerLabel: Color(0xFFD4A080),
    iconColor: Color(0xFFEED0B0),
    iconShadow: Color(0xFF080200),
  );

  static const marble = _BadgeMaterial(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A3070),
        Color(0xFF0C1848),
        Color(0xFF182860),
        Color(0xFF080E30),
      ],
      stops: [0.0, 0.33, 0.66, 1.0],
    ),
    hasGloss: true,
    hasVeins: true,
    borderColor: Color(0xFF08102A),
    innerHighlight: Color(0xFF5080D0),
    bannerBg: Color(0xFF060C20),
    bannerLabel: Color(0xFFD4A820),
    iconColor: Color(0xFFD4C060),
    iconShadow: Color(0xFF030610),
  );

  static const copper = _BadgeMaterial(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFE8A070),
        Color(0xFFC07040),
        Color(0xFF804020),
        Color(0xFFB06838),
        Color(0xFF602818),
      ],
      stops: [0.0, 0.28, 0.52, 0.72, 1.0],
    ),
    borderColor: Color(0xFF401808),
    innerHighlight: Color(0xFFFFCCA0),
    bannerBg: Color(0xFF301008),
    bannerLabel: Color(0xFFFFCCA0),
    iconColor: Color(0xFFFFF0E0),
    iconShadow: Color(0xFF1A0804),
  );
}

// ─── Presentation helpers ─────────────────────────────────────────────────────

_BadgeMaterial _materialFor(String type) => switch (type) {
      'gold' => _BadgeMaterial.gold,
      'blueEnamel' => _BadgeMaterial.blueEnamel,
      'bronze' => _BadgeMaterial.bronze,
      'darkWood' => _BadgeMaterial.darkWood,
      'marble' => _BadgeMaterial.marble,
      'copper' => _BadgeMaterial.copper,
      _ => _BadgeMaterial.bronze,
    };

FaIconData _iconFor(String name) => switch (name) {
      'calendarCheck' => FontAwesomeIcons.calendarCheck,
      'bookOpen' => FontAwesomeIcons.bookOpen,
      'wandMagicSparkles' => FontAwesomeIcons.wandMagicSparkles,
      'chessKing' => FontAwesomeIcons.chessKing,
      'medal' => FontAwesomeIcons.medal,
      'graduationCap' => FontAwesomeIcons.graduationCap,
      'crown' => FontAwesomeIcons.crown,
      'chartLine' => FontAwesomeIcons.chartLine,
      'trophy' => FontAwesomeIcons.trophy,
      'gem' => FontAwesomeIcons.gem,
      'calculator' => FontAwesomeIcons.calculator,
      'atom' => FontAwesomeIcons.atom,
      'flask' => FontAwesomeIcons.flask,
      'microchip' => FontAwesomeIcons.microchip,
      'earthAsia' => FontAwesomeIcons.earthAsia,
      'star' => FontAwesomeIcons.solidStar,
      _ => FontAwesomeIcons.penNib,
    };

// ─── Screen ──────────────────────────────────────────────────────────────────

class AchievementsScreen extends StatelessWidget {
  final StudentModel student;
  const AchievementsScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => BadgeBloc(ctx.read<BadgeRepository>())
        ..add(BadgesFetch(student.id)),
      child: _AchievementsView(student: student),
    );
  }
}

class _AchievementsView extends StatefulWidget {
  final StudentModel student;
  const _AchievementsView({required this.student});

  @override
  State<_AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<_AchievementsView> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BadgeBloc, BadgeState>(
        builder: (context, state) {
          // Only show earned badges.
          final earnedTypes = state is BadgesLoaded
              ? state.badgeTypes
                  .where((t) => state.earnedFor(t.id) != null)
                  .toList()
              : <BadgeTypeModel>[];

          BadgeTypeModel? selType;
          BadgeModel? selEarned;
          if (state is BadgesLoaded && _selectedIndex != null &&
              _selectedIndex! < earnedTypes.length) {
            selType = earnedTypes[_selectedIndex!];
            selEarned = state.earnedFor(selType.id);
          }

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(
                      context,
                      l10n,
                      earned: state is BadgesLoaded
                          ? state.earnedBadges.length
                          : null,
                    ),
                    if (state is BadgesLoading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state is BadgesError)
                      SliverFillRemaining(
                        child: Center(child: Text(state.message)),
                      )
                    else if (state is BadgesLoaded)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final type = earnedTypes[i];
                              final earned = state.earnedFor(type.id);
                              return _BadgeTile(
                                type: type,
                                earned: earned,
                                selected: _selectedIndex == i,
                                onTap: () => setState(() {
                                  _selectedIndex =
                                      _selectedIndex == i ? null : i;
                                }),
                              );
                            },
                            childCount: earnedTypes.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 28,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.82,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildDescriptionCard(context, selType, selEarned),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n, {
    int? earned,
  }) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppColors.primaryBrown,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(l10n.achievementsTitle,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700)),
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student.name.split(' ').first,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: AppColors.goldLight),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        l10n.achievementsTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                      ),
                      if (earned != null) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.goldLight.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '$earned ${earned == 1 ? 'Badge' : 'Badges'}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.goldLight,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Your hard work, recognized',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(
      BuildContext context, BadgeTypeModel? type, BadgeModel? earned) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      child: type == null
          ? _HintCard(key: const ValueKey('hint'))
          : _DetailCard(
              key: ValueKey(type.id),
              type: type,
              earned: earned,
            ),
    );
  }
}

// ─── Shield painter ──────────────────────────────────────────────────────────

class _ShieldPainter extends CustomPainter {
  final _BadgeMaterial material;
  final String bannerText;
  final int? year;
  final bool selected;

  const _ShieldPainter({
    required this.material,
    required this.bannerText,
    this.year,
    this.selected = false,
  });

  Path _buildPath(Size size, {double inset = 0}) {
    final l = inset;
    final t = inset;
    final w = size.width - inset * 2;
    final h = size.height - inset * 2;
    final cx = l + w / 2;
    final cr = w * 0.13;

    return Path()
      ..moveTo(l + cr, t)
      ..lineTo(l + w - cr, t)
      ..quadraticBezierTo(l + w, t, l + w, t + cr)
      ..lineTo(l + w, t + h * 0.52)
      ..quadraticBezierTo(l + w, t + h * 0.76, cx, t + h)
      ..quadraticBezierTo(l, t + h * 0.76, l, t + h * 0.52)
      ..lineTo(l, t + cr)
      ..quadraticBezierTo(l, t, l + cr, t)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);
    final rect = Offset.zero & size;

    // ── Drop shadow
    canvas.drawPath(
      path.shift(Offset(0, selected ? 4 : 2)),
      Paint()
        ..color = material.borderColor
            .withValues(alpha: selected ? 0.55 : 0.28)
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, selected ? 16 : 8),
    );

    // ── Main gradient fill
    canvas.drawPath(
      path,
      Paint()
        ..shader = material.gradient.createShader(rect),
    );

    // ── Gloss overlay (enamel / marble)
    if (material.hasGloss) {
      canvas.save();
      canvas.clipPath(path);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.30, size.height * 0.20),
          width: size.width * 0.62,
          height: size.height * 0.28,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.20),
      );
      canvas.restore();
    }

    // ── Marble veins
    if (material.hasVeins) {
      canvas.save();
      canvas.clipPath(path);
      final vein = Paint()
        ..color = const Color(0xFFD4A820).withValues(alpha: 0.38)
        ..strokeWidth = 0.9
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
          Offset(size.width * 0.12, 0),
          Offset(size.width * 0.72, size.height * 0.68),
          vein);
      canvas.drawLine(
          Offset(size.width * 0.42, 0),
          Offset(size.width, size.height * 0.52),
          vein);
      canvas.drawLine(
          Offset(0, size.height * 0.22),
          Offset(size.width * 0.60, size.height * 0.88),
          vein);
      canvas.restore();
    }

    // ── Inner highlight frame
    canvas.drawPath(
      _buildPath(size, inset: 4.0),
      Paint()
        ..color = material.innerHighlight.withValues(alpha: 0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // ── Outer border
    canvas.drawPath(
      path,
      Paint()
        ..color = material.borderColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // ── Bottom banner
    _drawBanner(canvas, size);
  }

  void _drawBanner(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.825;
    final bw = size.width * 0.66;
    // Taller banner when year is present to fit two lines
    final bh = year != null ? 19.0 : 13.0;
    const br = Radius.circular(3);

    final bannerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: bw, height: bh),
      br,
    );

    // Banner fill
    canvas.drawRRect(
        bannerRect, Paint()..color = material.bannerBg.withValues(alpha: 0.90));

    // Banner border
    canvas.drawRRect(
        bannerRect,
        Paint()
          ..color = material.innerHighlight.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8);

    if (year != null) {
      // Year (top line, prominent)
      final yearTp = TextPainter(
        text: TextSpan(
          text: year.toString(),
          style: TextStyle(
            color: material.bannerLabel,
            fontSize: 7.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Label (bottom line, smaller)
      final labelTp = TextPainter(
        text: TextSpan(
          text: bannerText,
          style: TextStyle(
            color: material.bannerLabel.withValues(alpha: 0.75),
            fontSize: 5.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final top = cy - bh / 2 + 1.5;
      yearTp.paint(canvas, Offset(cx - yearTp.width / 2, top));
      labelTp.paint(canvas,
          Offset(cx - labelTp.width / 2, top + yearTp.height + 0.5));
    } else {
      // Single-line fallback
      final tp = TextPainter(
        text: TextSpan(
          text: bannerText,
          style: TextStyle(
            color: material.bannerLabel,
            fontSize: 6.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_ShieldPainter old) => old.selected != selected;
}

// ─── Badge tile ──────────────────────────────────────────────────────────────

class _BadgeTile extends StatelessWidget {
  final BadgeTypeModel type;
  final BadgeModel? earned;
  final bool selected;
  final VoidCallback onTap;

  const _BadgeTile({
    required this.type,
    required this.earned,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mat = _materialFor(type.materialType);
    final icon = _iconFor(type.iconName);
    final bannerText = earned?.bannerText ?? type.defaultBannerText;
    final year = earned?.year;

    const double baseW = 72;
    const double baseH = 82;
    final double w = selected ? baseW + 10 : baseW;
    final double h = selected ? baseH + 11 : baseH;
    final double iconSize = selected ? 26 : 22;

    final shield = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: w,
      height: h,
      child: CustomPaint(
        painter: _ShieldPainter(
          material: mat,
          bannerText: bannerText,
          year: year,
          selected: selected,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(1.0, 1.0),
                  child:
                      FaIcon(icon, color: mat.iconShadow, size: iconSize),
                ),
                FaIcon(icon, color: mat.iconColor, size: iconSize),
              ],
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(child: shield),
    );
  }
}

// ─── Description cards ───────────────────────────────────────────────────────

class _HintCard extends StatelessWidget {
  const _HintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(FontAwesomeIcons.handPointer,
              color: AppColors.textHint, size: 20),
          const SizedBox(height: 6),
          Text(
            'Tap a badge to learn more',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final BadgeTypeModel type;
  final BadgeModel? earned;
  const _DetailCard({super.key, required this.type, this.earned});

  @override
  Widget build(BuildContext context) {
    final mat = _materialFor(type.materialType);
    final icon = _iconFor(type.iconName);
    final label = earned?.label ?? type.defaultLabel;
    final description = earned?.description ?? type.defaultDescription;
    final bannerText = earned?.bannerText ?? type.defaultBannerText;
    final year = earned?.year;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: mat.borderColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 55,
            child: CustomPaint(
              painter: _ShieldPainter(
                material: mat,
                bannerText: bannerText,
                year: year,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Center(
                  child: FaIcon(icon, color: mat.iconColor, size: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (earned != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'By ${earned!.awardedBy}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textHint,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
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
