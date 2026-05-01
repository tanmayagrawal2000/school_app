import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/badge_model.dart';
import '../../../data/models/badge_type_model.dart';
import '../../../data/repositories/badge_repository.dart';

class AwardBadgeScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String teacherName;

  const AwardBadgeScreen({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.teacherName,
  });

  @override
  State<AwardBadgeScreen> createState() => _AwardBadgeScreenState();
}

class _AwardBadgeScreenState extends State<AwardBadgeScreen> {
  List<BadgeTypeModel> _types = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final types = await context.read<BadgeRepository>().fetchBadgeTypes();
    if (mounted) setState(() { _types = types; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Award Badge',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            Text(
              widget.studentName,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrown))
          : _types.isEmpty
              ? const Center(child: Text('No badge types available.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _types.length,
                  itemBuilder: (context, i) => _BadgeTypeCard(
                    type: _types[i],
                    onTap: () => _showAwardSheet(context, _types[i]),
                  ),
                ),
    );
  }

  void _showAwardSheet(BuildContext context, BadgeTypeModel type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RepositoryProvider.value(
        value: context.read<BadgeRepository>(),
        child: _AwardSheet(
          type: type,
          studentId: widget.studentId,
          studentName: widget.studentName,
          teacherName: widget.teacherName,
          onAwarded: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

// ── Badge type grid card ──────────────────────────────────────────────────────

class _BadgeTypeCard extends StatelessWidget {
  final BadgeTypeModel type;
  final VoidCallback onTap;
  const _BadgeTypeCard({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _materialColor(type.materialType);
    final icon = _iconData(type.iconName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(icon, size: 30, color: color),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              type.defaultLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                type.defaultDescription,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Award bottom sheet ────────────────────────────────────────────────────────

class _AwardSheet extends StatefulWidget {
  final BadgeTypeModel type;
  final String studentId;
  final String studentName;
  final String teacherName;
  final VoidCallback onAwarded;

  const _AwardSheet({
    required this.type,
    required this.studentId,
    required this.studentName,
    required this.teacherName,
    required this.onAwarded,
  });

  @override
  State<_AwardSheet> createState() => _AwardSheetState();
}

class _AwardSheetState extends State<_AwardSheet> {
  late final TextEditingController _labelCtrl;
  late final TextEditingController _descCtrl;
  bool _isAwarding = false;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.type.defaultLabel);
    _descCtrl = TextEditingController(text: widget.type.defaultDescription);
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _award() async {
    setState(() => _isAwarding = true);
    try {
      final badge = BadgeModel(
        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
        studentId: widget.studentId,
        badgeTypeId: widget.type.id,
        label: _labelCtrl.text.trim().isEmpty
            ? widget.type.defaultLabel
            : _labelCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty
            ? widget.type.defaultDescription
            : _descCtrl.text.trim(),
        bannerText: widget.type.defaultBannerText,
        materialType: widget.type.materialType,
        iconName: widget.type.iconName,
        year: DateTime.now().year,
        awardedBy: widget.teacherName,
        awardedAt: DateTime.now(),
        isPremium: widget.type.isPremium,
      );
      await context.read<BadgeRepository>().awardBadge(badge);
      if (!mounted) return;
      Navigator.pop(context); // close sheet
      widget.onAwarded();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${_labelCtrl.text.trim().isEmpty ? widget.type.defaultLabel : _labelCtrl.text.trim()} awarded to ${widget.studentName}'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to award badge. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isAwarding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _materialColor(widget.type.materialType);
    final icon = _iconData(widget.type.iconName);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            // drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Badge preview
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(child: FaIcon(icon, size: 36, color: color)),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Awarding to ${widget.studentName}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Label field
            Text('Badge Label',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _labelCtrl,
              decoration: _inputDecoration('Badge name'),
            ),
            const SizedBox(height: 16),

            // Description field
            Text('Description',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              decoration: _inputDecoration('What did the student achieve?'),
              maxLines: 3,
            ),
            const SizedBox(height: 28),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isAwarding ? null : _award,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isAwarding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Award Badge',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryBrown, width: 1.5),
        ),
      );
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Color _materialColor(String material) => switch (material) {
      'gold' => const Color(0xFFD4AF37),
      'blueEnamel' => AppColors.info,
      'bronze' => const Color(0xFFCD7F32),
      'darkWood' => const Color(0xFF6D4C41),
      'marble' => const Color(0xFF78909C),
      'copper' => const Color(0xFFB87333),
      _ => AppColors.primaryBrown,
    };

FaIconData _iconData(String name) => switch (name) {
      'calendarCheck' => FontAwesomeIcons.calendarCheck,
      'bookOpen' => FontAwesomeIcons.bookOpen,
      'wandMagicSparkles' => FontAwesomeIcons.wandMagicSparkles,
      'chessKing' => FontAwesomeIcons.chessKing,
      'medal' => FontAwesomeIcons.medal,
      'graduationCap' => FontAwesomeIcons.graduationCap,
      'crown' => FontAwesomeIcons.crown,
      'trophy' => FontAwesomeIcons.trophy,
      'chartLine' => FontAwesomeIcons.chartLine,
      'gem' => FontAwesomeIcons.gem,
      'calculator' => FontAwesomeIcons.calculator,
      'atom' => FontAwesomeIcons.atom,
      'flask' => FontAwesomeIcons.flask,
      'microchip' => FontAwesomeIcons.microchip,
      'earthAsia' => FontAwesomeIcons.earthAsia,
      'penNib' => FontAwesomeIcons.penNib,
      'star' => FontAwesomeIcons.star,
      _ => FontAwesomeIcons.award,
    };
