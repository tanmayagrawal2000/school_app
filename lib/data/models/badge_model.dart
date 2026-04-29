import 'package:equatable/equatable.dart';

class BadgeModel extends Equatable {
  final String id;
  final String studentId;

  /// References the [BadgeTypeModel.id] this badge was created from.
  final String badgeTypeId;

  /// Teacher-editable label (defaults to [BadgeTypeModel.defaultLabel]).
  final String label;

  /// Teacher-editable description (defaults to [BadgeTypeModel.defaultDescription]).
  final String description;

  final String bannerText;

  /// Maps to a visual material. Valid values:
  /// 'gold' | 'blueEnamel' | 'bronze' | 'darkWood' | 'marble' | 'copper'
  final String materialType;

  /// Icon key mapped to a FontAwesome icon in the UI layer.
  /// Valid values: 'calendarCheck' | 'bookOpen' | 'wandMagicSparkles' |
  /// 'chessKing' | 'medal' | 'graduationCap' | 'crown' | 'trophy' |
  /// 'chartLine' | 'gem' | 'calculator' | 'atom' | 'flask' | 'microchip' |
  /// 'earthAsia' | 'penNib' | 'star'
  final String iconName;

  final int year;
  final String awardedBy;
  final DateTime awardedAt;
  final bool isPremium;

  const BadgeModel({
    required this.id,
    required this.studentId,
    required this.badgeTypeId,
    required this.label,
    required this.description,
    required this.bannerText,
    required this.materialType,
    required this.iconName,
    required this.year,
    required this.awardedBy,
    required this.awardedAt,
    this.isPremium = false,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) => BadgeModel(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        badgeTypeId: json['badgeTypeId'] as String,
        label: json['label'] as String,
        description: json['description'] as String,
        bannerText: json['bannerText'] as String,
        materialType: json['materialType'] as String,
        iconName: json['iconName'] as String,
        year: json['year'] as int,
        awardedBy: json['awardedBy'] as String,
        awardedAt: DateTime.parse(json['awardedAt'] as String),
        isPremium: json['isPremium'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'badgeTypeId': badgeTypeId,
        'label': label,
        'description': description,
        'bannerText': bannerText,
        'materialType': materialType,
        'iconName': iconName,
        'year': year,
        'awardedBy': awardedBy,
        'awardedAt': awardedAt.toIso8601String(),
        'isPremium': isPremium,
      };

  @override
  List<Object?> get props => [id];
}
