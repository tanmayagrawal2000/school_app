import 'package:equatable/equatable.dart';

/// A template that defines the default values for a badge category.
/// Teachers pick a [BadgeTypeModel] and may edit [defaultLabel] and
/// [defaultDescription] before awarding it to a student.
class BadgeTypeModel extends Equatable {
  final String id;
  final String defaultLabel;
  final String defaultDescription;
  final String defaultBannerText;
  final String materialType;
  final String iconName;
  final bool isPremium;

  const BadgeTypeModel({
    required this.id,
    required this.defaultLabel,
    required this.defaultDescription,
    required this.defaultBannerText,
    required this.materialType,
    required this.iconName,
    this.isPremium = false,
  });

  factory BadgeTypeModel.fromJson(Map<String, dynamic> json) => BadgeTypeModel(
        id: json['id'] as String,
        defaultLabel: json['defaultLabel'] as String,
        defaultDescription: json['defaultDescription'] as String,
        defaultBannerText: json['defaultBannerText'] as String,
        materialType: json['materialType'] as String,
        iconName: json['iconName'] as String,
        isPremium: json['isPremium'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'defaultLabel': defaultLabel,
        'defaultDescription': defaultDescription,
        'defaultBannerText': defaultBannerText,
        'materialType': materialType,
        'iconName': iconName,
        'isPremium': isPremium,
      };

  @override
  List<Object?> get props => [id];
}
