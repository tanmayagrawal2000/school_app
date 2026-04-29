import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Single source of truth for every academic subject's visual identity.
///
/// Add a new subject by adding a [SubjectModel] constant and including it
/// in [all]. [forName] resolves it everywhere in the UI automatically.
class SubjectModel {
  final String name;
  final String shortName;
  final Color color;
  final Color lightColor;
  final IconData icon;

  const SubjectModel({
    required this.name,
    required this.shortName,
    required this.color,
    required this.lightColor,
    required this.icon,
  });

  // ── Subject catalog ──────────────────────────────────────────────────────

  static const mathematics = SubjectModel(
    name: 'Mathematics',
    shortName: 'Maths',
    color: AppColors.primaryBrown,
    lightColor: AppColors.surfaceVariant,
    icon: Icons.calculate_outlined,
  );

  static const science = SubjectModel(
    name: 'Science',
    shortName: 'Science',
    color: AppColors.success,
    lightColor: AppColors.successLight,
    icon: Icons.science_outlined,
  );

  static const english = SubjectModel(
    name: 'English',
    shortName: 'English',
    color: AppColors.info,
    lightColor: AppColors.infoLight,
    icon: Icons.menu_book_outlined,
  );

  static const hindi = SubjectModel(
    name: 'Hindi',
    shortName: 'Hindi',
    color: AppColors.saffron,
    lightColor: AppColors.warningLight,
    icon: Icons.translate_outlined,
  );

  static const socialScience = SubjectModel(
    name: 'Social Science',
    shortName: 'SST',
    color: AppColors.lotusPink,
    lightColor: Color(0xFFFCE4EC),
    icon: Icons.public_outlined,
  );

  static const computerScience = SubjectModel(
    name: 'Computer Science',
    shortName: 'CS',
    color: Color(0xFF6A1B9A),
    lightColor: Color(0xFFF3E5F5),
    icon: Icons.computer_outlined,
  );

  static const physicalEducation = SubjectModel(
    name: 'Physical Education',
    shortName: 'PE',
    color: AppColors.gold,
    lightColor: AppColors.warningLight,
    icon: Icons.sports_outlined,
  );

  static const artAndCraft = SubjectModel(
    name: 'Art & Craft',
    shortName: 'Art',
    color: Color(0xFFAD1457),
    lightColor: Color(0xFFFCE4EC),
    icon: Icons.palette_outlined,
  );

  static const library = SubjectModel(
    name: 'Library',
    shortName: 'Lib',
    color: Color(0xFF00838F),
    lightColor: Color(0xFFE0F7FA),
    icon: Icons.library_books_outlined,
  );

  static const unknown = SubjectModel(
    name: 'Other',
    shortName: '?',
    color: AppColors.primaryBrownLight,
    lightColor: AppColors.surfaceVariant,
    icon: Icons.school_outlined,
  );

  // ── Ordered catalog ──────────────────────────────────────────────────────

  static const List<SubjectModel> all = [
    mathematics,
    science,
    english,
    hindi,
    socialScience,
    computerScience,
    physicalEducation,
    artAndCraft,
    library,
  ];

  // ── Lookup ───────────────────────────────────────────────────────────────

  /// Returns the [SubjectModel] for [name], falling back to [unknown].
  ///
  /// Matches by exact name or shortName first, then by keyword so partial
  /// or abbreviated names resolve correctly.
  static SubjectModel forName(String name) {
    final n = name.toLowerCase().trim();
    for (final s in all) {
      if (s.name.toLowerCase() == n || s.shortName.toLowerCase() == n) return s;
    }
    if (n.contains('math')) return mathematics;
    if (n.contains('science')) return science;
    if (n.contains('english')) return english;
    if (n.contains('hindi')) return hindi;
    if (n.contains('social')) return socialScience;
    if (n.contains('computer')) return computerScience;
    if (n.contains('physical') || n.contains('sport')) return physicalEducation;
    if (n.contains('art')) return artAndCraft;
    if (n.contains('library')) return library;
    return unknown;
  }
}
