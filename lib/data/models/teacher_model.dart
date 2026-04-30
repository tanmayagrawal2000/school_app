import 'package:equatable/equatable.dart';

class TeacherModel extends Equatable {
  final String id;
  final String name;
  final String employeeId;
  final String subject;
  final String classIncharge;
  final String qualification;
  final String contactNumber;
  final int experience;
  final String photoInitials;
  final int avatarColorIndex;

  const TeacherModel({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.subject,
    required this.classIncharge,
    required this.qualification,
    required this.contactNumber,
    required this.experience,
    required this.photoInitials,
    required this.avatarColorIndex,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) => TeacherModel(
        id: json['id'] as String,
        name: json['name'] as String,
        employeeId: json['employeeId'] as String,
        subject: json['subject'] as String,
        classIncharge: json['classIncharge'] as String,
        qualification: json['qualification'] as String,
        contactNumber: json['contactNumber'] as String,
        experience: json['experience'] as int,
        photoInitials: json['photoInitials'] as String,
        avatarColorIndex: json['avatarColorIndex'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'employeeId': employeeId,
        'subject': subject,
        'classIncharge': classIncharge,
        'qualification': qualification,
        'contactNumber': contactNumber,
        'experience': experience,
        'photoInitials': photoInitials,
        'avatarColorIndex': avatarColorIndex,
      };

  String get firstName {
    final noTitle = name.replaceFirst(RegExp(r'^(Mrs?\.|Ms\.) '), '');
    return noTitle.split(' ').first;
  }

  /// Returns (classGrade, section) parsed from classIncharge ("Class 10-A" → ("10", "A")).
  (String classGrade, String section) get inchargeClassParts {
    final raw = classIncharge.replaceFirst('Class ', '');
    final parts = raw.split('-');
    return (parts.first, parts.length > 1 ? parts[1] : 'A');
  }

  @override
  List<Object?> get props => [id];
}
