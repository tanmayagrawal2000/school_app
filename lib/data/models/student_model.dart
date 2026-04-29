import 'package:equatable/equatable.dart';

class StudentModel extends Equatable {
  final String id;
  final String name;
  final String admissionNo;
  final int rollNo;
  final String classGrade;
  final String section;
  final String dateOfBirth;
  final String gender;
  final String bloodGroup;
  final String fatherName;
  final String motherName;
  final String contactNumber;
  final String address;
  final String busRoute;
  final String busNumber;
  final double attendancePercent;
  final String house;
  final String photoInitials;
  final int avatarColorIndex;
  final List<SubjectResult> results;
  final String feeStatus;
  final double totalFee;
  final double paidFee;

  const StudentModel({
    required this.id,
    required this.name,
    required this.admissionNo,
    required this.rollNo,
    required this.classGrade,
    required this.section,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.fatherName,
    required this.motherName,
    required this.contactNumber,
    required this.address,
    required this.busRoute,
    required this.busNumber,
    required this.attendancePercent,
    required this.house,
    required this.photoInitials,
    required this.avatarColorIndex,
    required this.results,
    required this.feeStatus,
    required this.totalFee,
    required this.paidFee,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json['id'] as String,
        name: json['name'] as String,
        admissionNo: json['admissionNo'] as String,
        rollNo: json['rollNo'] as int,
        classGrade: json['classGrade'] as String,
        section: json['section'] as String,
        dateOfBirth: json['dateOfBirth'] as String,
        gender: json['gender'] as String,
        bloodGroup: json['bloodGroup'] as String,
        fatherName: json['fatherName'] as String,
        motherName: json['motherName'] as String,
        contactNumber: json['contactNumber'] as String,
        address: json['address'] as String,
        busRoute: json['busRoute'] as String,
        busNumber: json['busNumber'] as String,
        attendancePercent: (json['attendancePercent'] as num).toDouble(),
        house: json['house'] as String,
        photoInitials: json['photoInitials'] as String,
        avatarColorIndex: json['avatarColorIndex'] as int,
        results: (json['results'] as List<dynamic>)
            .map((r) => SubjectResult.fromJson(r as Map<String, dynamic>))
            .toList(),
        feeStatus: json['feeStatus'] as String,
        totalFee: (json['totalFee'] as num).toDouble(),
        paidFee: (json['paidFee'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'admissionNo': admissionNo,
        'rollNo': rollNo,
        'classGrade': classGrade,
        'section': section,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'fatherName': fatherName,
        'motherName': motherName,
        'contactNumber': contactNumber,
        'address': address,
        'busRoute': busRoute,
        'busNumber': busNumber,
        'attendancePercent': attendancePercent,
        'house': house,
        'photoInitials': photoInitials,
        'avatarColorIndex': avatarColorIndex,
        'results': results.map((r) => r.toJson()).toList(),
        'feeStatus': feeStatus,
        'totalFee': totalFee,
        'paidFee': paidFee,
      };

  double get overallPercent {
    if (results.isEmpty) return 0;
    return results.fold<double>(0, (sum, r) => sum + r.percentage) /
        results.length;
  }

  String get grade {
    final p = overallPercent;
    if (p >= 91) return 'A1';
    if (p >= 81) return 'A2';
    if (p >= 71) return 'B1';
    if (p >= 61) return 'B2';
    if (p >= 51) return 'C1';
    if (p >= 41) return 'C2';
    if (p >= 33) return 'D';
    return 'E';
  }

  @override
  List<Object?> get props => [id];
}

class SubjectResult extends Equatable {
  final String subject;
  final int maxMarks;
  final int obtainedMarks;
  final String grade;

  const SubjectResult({
    required this.subject,
    required this.maxMarks,
    required this.obtainedMarks,
    required this.grade,
  });

  factory SubjectResult.fromJson(Map<String, dynamic> json) => SubjectResult(
        subject: json['subject'] as String,
        maxMarks: json['maxMarks'] as int,
        obtainedMarks: json['obtainedMarks'] as int,
        grade: json['grade'] as String,
      );

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'maxMarks': maxMarks,
        'obtainedMarks': obtainedMarks,
        'grade': grade,
      };

  double get percentage => (obtainedMarks / maxMarks) * 100;

  @override
  List<Object?> get props => [subject, obtainedMarks];
}
