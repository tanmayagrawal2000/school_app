import 'package:latlong2/latlong.dart';
import '../models/student_model.dart';
import '../models/bus_model.dart';
import '../models/announcement_model.dart';
import '../models/attendance_model.dart';
import '../models/teacher_model.dart';
import '../models/timetable_model.dart';
import '../models/fee_model.dart';
import '../models/homework_model.dart';
import '../models/class_stats_model.dart';
import '../models/badge_model.dart';
import '../models/badge_type_model.dart';
import '../models/class_reminder_model.dart';
import '../models/parent_model.dart';
import '../models/teacher_class_summary.dart';
import '../models/roster_student.dart';
import '../models/pending_homework_entry.dart';
import '../models/student_attendance_summary.dart';
import '../models/student_subject_mark.dart';

export '../models/timetable_model.dart';

// School location: Indira Nagar, Kanpur
// Approx center: 26.4812° N, 80.2775° E
const LatLng kSchoolLocation = LatLng(26.4812, 80.2775);

class DummyData {
  // ───────────────────────── STUDENTS ──────────────────────────
  static List<StudentModel> get students => [
        StudentModel(
          id: 's001',
          name: 'Arjun Sharma',
          admissionNo: 'SGM/2024/001',
          rollNo: 15,
          classGrade: '10',
          section: 'A',
          dateOfBirth: '12 March 2010',
          gender: 'Male',
          bloodGroup: 'O+',
          fatherName: 'Rakesh Sharma',
          motherName: 'Sunita Sharma',
          contactNumber: '+91 98765 43210',
          address: '24, Indira Nagar, Kanpur – 208026',
          busRoute: 'Route 1',
          busNumber: 'UP32 BX 4521',
          attendancePercent: 91.5,
          house: 'Tagore',
          photoInitials: 'AS',
          avatarColorIndex: 0,
          feeStatus: 'Paid',
          totalFee: 45000,
          paidFee: 45000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 92, grade: 'A1'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 85, grade: 'A2'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 79, grade: 'B1'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 83, grade: 'A2'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 95, grade: 'A1'),
          ],
        ),
        StudentModel(
          id: 's002',
          name: 'Priya Singh',
          admissionNo: 'SGM/2024/002',
          rollNo: 7,
          classGrade: '8',
          section: 'B',
          dateOfBirth: '5 July 2012',
          gender: 'Female',
          bloodGroup: 'A+',
          fatherName: 'Suresh Singh',
          motherName: 'Kavita Singh',
          contactNumber: '+91 87654 32109',
          address: '7, Vikas Nagar, Kanpur – 208024',
          busRoute: 'Route 2',
          busNumber: 'UP32 CY 7832',
          attendancePercent: 96.2,
          house: 'Vivekananda',
          photoInitials: 'PS',
          avatarColorIndex: 1,
          feeStatus: 'Paid',
          totalFee: 38000,
          paidFee: 38000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 97, grade: 'A1'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 94, grade: 'A1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 91, grade: 'A1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 89, grade: 'A2'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 93, grade: 'A1'),
            const SubjectResult(subject: 'Sanskrit', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
          ],
        ),
        StudentModel(
          id: 's003',
          name: 'Rahul Gupta',
          admissionNo: 'SGM/2023/045',
          rollNo: 23,
          classGrade: '12',
          section: 'A',
          dateOfBirth: '18 November 2007',
          gender: 'Male',
          bloodGroup: 'B+',
          fatherName: 'Mohan Gupta',
          motherName: 'Reena Gupta',
          contactNumber: '+91 76543 21098',
          address: '58, Govind Nagar, Kanpur – 208006',
          busRoute: 'Route 3',
          busNumber: 'UP32 DZ 1122',
          attendancePercent: 87.3,
          house: 'Gandhi',
          photoInitials: 'RG',
          avatarColorIndex: 2,
          feeStatus: 'Partial',
          totalFee: 52000,
          paidFee: 30000,
          results: [
            const SubjectResult(subject: 'Physics', maxMarks: 100, obtainedMarks: 78, grade: 'B1'),
            const SubjectResult(subject: 'Chemistry', maxMarks: 100, obtainedMarks: 72, grade: 'B1'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 85, grade: 'A2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 69, grade: 'B2'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 91, grade: 'A1'),
          ],
        ),
        StudentModel(
          id: 's004',
          name: 'Ananya Verma',
          admissionNo: 'SGM/2025/012',
          rollNo: 3,
          classGrade: '5',
          section: 'A',
          dateOfBirth: '22 January 2015',
          gender: 'Female',
          bloodGroup: 'AB+',
          fatherName: 'Deepak Verma',
          motherName: 'Pooja Verma',
          contactNumber: '+91 65432 10987',
          address: '11, Kalyanpur, Kanpur – 208017',
          busRoute: 'Route 1',
          busNumber: 'UP32 BX 4521',
          attendancePercent: 98.1,
          house: 'Tagore',
          photoInitials: 'AV',
          avatarColorIndex: 3,
          feeStatus: 'Paid',
          totalFee: 28000,
          paidFee: 28000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 96, grade: 'A1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 98, grade: 'A1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 92, grade: 'A1'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 94, grade: 'A1'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 90, grade: 'A1'),
          ],
        ),
        StudentModel(
          id: 's005',
          name: 'Vikram Tiwari',
          admissionNo: 'SGM/2024/078',
          rollNo: 18,
          classGrade: '7',
          section: 'C',
          dateOfBirth: '9 September 2013',
          gender: 'Male',
          bloodGroup: 'O-',
          fatherName: 'Ajay Tiwari',
          motherName: 'Shikha Tiwari',
          contactNumber: '+91 54321 09876',
          address: '33, Kidwai Nagar, Kanpur – 208011',
          busRoute: 'Route 2',
          busNumber: 'UP32 CY 7832',
          attendancePercent: 83.6,
          house: 'Bose',
          photoInitials: 'VT',
          avatarColorIndex: 4,
          feeStatus: 'Paid',
          totalFee: 33000,
          paidFee: 33000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 71, grade: 'B1'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 68, grade: 'B2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 74, grade: 'B1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 82, grade: 'A2'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 77, grade: 'B1'),
          ],
        ),
        StudentModel(
          id: 's006',
          name: 'Riya Mishra',
          admissionNo: 'SGM/2024/034',
          rollNo: 11,
          classGrade: '9',
          section: 'B',
          dateOfBirth: '14 April 2011',
          gender: 'Female',
          bloodGroup: 'A-',
          fatherName: 'Santosh Mishra',
          motherName: 'Asha Mishra',
          contactNumber: '+91 43210 98765',
          address: '5, Kakadeo, Kanpur – 208025',
          busRoute: 'Route 3',
          busNumber: 'UP32 DZ 1122',
          attendancePercent: 94.7,
          house: 'Vivekananda',
          photoInitials: 'RM',
          avatarColorIndex: 5,
          feeStatus: 'Paid',
          totalFee: 42000,
          paidFee: 42000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 91, grade: 'A1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 86, grade: 'A2'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 90, grade: 'A1'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 87, grade: 'A2'),
          ],
        ),
        StudentModel(
          id: 's007',
          name: 'Aditya Kumar',
          admissionNo: 'SGM/2025/021',
          rollNo: 1,
          classGrade: '1',
          section: 'A',
          dateOfBirth: '30 June 2019',
          gender: 'Male',
          bloodGroup: 'B-',
          fatherName: 'Rajesh Kumar',
          motherName: 'Savita Kumar',
          contactNumber: '+91 32109 87654',
          address: '88, Barra, Kanpur – 208027',
          busRoute: 'Route 1',
          busNumber: 'UP32 BX 4521',
          attendancePercent: 89.3,
          house: 'Gandhi',
          photoInitials: 'AK',
          avatarColorIndex: 6,
          feeStatus: 'Pending',
          totalFee: 22000,
          paidFee: 0,
          results: [
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 91, grade: 'A1'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 85, grade: 'A2'),
            const SubjectResult(subject: 'EVS', maxMarks: 100, obtainedMarks: 93, grade: 'A1'),
          ],
        ),
        StudentModel(
          id: 's008',
          name: 'Sneha Pandey',
          admissionNo: 'SGM/2023/067',
          rollNo: 29,
          classGrade: '11',
          section: 'B',
          dateOfBirth: '3 December 2008',
          gender: 'Female',
          bloodGroup: 'O+',
          fatherName: 'Vikas Pandey',
          motherName: 'Meena Pandey',
          contactNumber: '+91 21098 76543',
          address: '17, Arya Nagar, Kanpur – 208002',
          busRoute: 'Route 2',
          busNumber: 'UP32 CY 7832',
          attendancePercent: 92.8,
          house: 'Bose',
          photoInitials: 'SP',
          avatarColorIndex: 1,
          feeStatus: 'Paid',
          totalFee: 50000,
          paidFee: 50000,
          results: [
            const SubjectResult(subject: 'Biology', maxMarks: 100, obtainedMarks: 94, grade: 'A1'),
            const SubjectResult(subject: 'Chemistry', maxMarks: 100, obtainedMarks: 89, grade: 'A2'),
            const SubjectResult(subject: 'Physics', maxMarks: 100, obtainedMarks: 83, grade: 'A2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 87, grade: 'A2'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 79, grade: 'B1'),
          ],
        ),

        // ── Class 10-A (additional students) ─────────────────────────────────
        StudentModel(
          id: 's009',
          name: 'Divya Kapoor',
          admissionNo: 'SGM/2024/019',
          rollNo: 7,
          classGrade: '10',
          section: 'A',
          dateOfBirth: '28 May 2010',
          gender: 'Female',
          bloodGroup: 'A+',
          fatherName: 'Sunil Kapoor',
          motherName: 'Rekha Kapoor',
          contactNumber: '+91 98200 10009',
          address: '42, Naubasta, Kanpur – 208021',
          busRoute: 'Route 1',
          busNumber: 'UP32 BX 4521',
          attendancePercent: 93.3,
          house: 'Vivekananda',
          photoInitials: 'DK',
          avatarColorIndex: 1,
          feeStatus: 'Paid',
          totalFee: 45000,
          paidFee: 45000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 89, grade: 'A2'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 91, grade: 'A1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 94, grade: 'A1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 86, grade: 'A2'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 90, grade: 'A1'),
          ],
        ),
        StudentModel(
          id: 's010',
          name: 'Sanjay Mehta',
          admissionNo: 'SGM/2024/031',
          rollNo: 23,
          classGrade: '10',
          section: 'A',
          dateOfBirth: '11 October 2010',
          gender: 'Male',
          bloodGroup: 'B+',
          fatherName: 'Dinesh Mehta',
          motherName: 'Sunanda Mehta',
          contactNumber: '+91 98200 10010',
          address: '9, Govind Nagar, Kanpur – 208006',
          busRoute: 'Route 3',
          busNumber: 'UP32 DZ 1122',
          attendancePercent: 85.0,
          house: 'Gandhi',
          photoInitials: 'SM',
          avatarColorIndex: 2,
          feeStatus: 'Partial',
          totalFee: 45000,
          paidFee: 22500,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 74, grade: 'B1'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 69, grade: 'B2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 77, grade: 'B1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 81, grade: 'A2'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 72, grade: 'B1'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 83, grade: 'A2'),
          ],
        ),
        StudentModel(
          id: 's011',
          name: 'Pooja Verma',
          admissionNo: 'SGM/2024/043',
          rollNo: 3,
          classGrade: '10',
          section: 'A',
          dateOfBirth: '17 February 2010',
          gender: 'Female',
          bloodGroup: 'O+',
          fatherName: 'Harish Verma',
          motherName: 'Lata Verma',
          contactNumber: '+91 98200 10011',
          address: '63, Shyam Nagar, Kanpur – 208013',
          busRoute: 'Route 2',
          busNumber: 'UP32 CY 7832',
          attendancePercent: 75.0,
          house: 'Tagore',
          photoInitials: 'PV',
          avatarColorIndex: 3,
          feeStatus: 'Overdue',
          totalFee: 45000,
          paidFee: 0,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 62, grade: 'B2'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 58, grade: 'C1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 71, grade: 'B1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 75, grade: 'B1'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 64, grade: 'B2'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 68, grade: 'B2'),
          ],
        ),
        StudentModel(
          id: 's012',
          name: 'Kiran Singh',
          admissionNo: 'SGM/2024/057',
          rollNo: 11,
          classGrade: '10',
          section: 'A',
          dateOfBirth: '4 August 2010',
          gender: 'Female',
          bloodGroup: 'AB-',
          fatherName: 'Mahendra Singh',
          motherName: 'Geeta Singh',
          contactNumber: '+91 98200 10012',
          address: '31, Rawatpur, Kanpur – 208019',
          busRoute: 'Route 1',
          busNumber: 'UP32 BX 4521',
          attendancePercent: 76.7,
          house: 'Bose',
          photoInitials: 'KS',
          avatarColorIndex: 4,
          feeStatus: 'Paid',
          totalFee: 45000,
          paidFee: 45000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 67, grade: 'B2'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 73, grade: 'B1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 80, grade: 'A2'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 84, grade: 'A2'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 70, grade: 'B1'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 76, grade: 'B1'),
          ],
        ),

        // ── Class 7-C (additional students) ──────────────────────────────────
        StudentModel(
          id: 's013',
          name: 'Rashmi Dubey',
          admissionNo: 'SGM/2025/033',
          rollNo: 5,
          classGrade: '7',
          section: 'C',
          dateOfBirth: '19 March 2013',
          gender: 'Female',
          bloodGroup: 'A+',
          fatherName: 'Arun Dubey',
          motherName: 'Vandana Dubey',
          contactNumber: '+91 98200 10013',
          address: '14, Birhana Road, Kanpur – 208001',
          busRoute: 'Route 2',
          busNumber: 'UP32 CY 7832',
          attendancePercent: 93.3,
          house: 'Vivekananda',
          photoInitials: 'RD',
          avatarColorIndex: 5,
          feeStatus: 'Paid',
          totalFee: 33000,
          paidFee: 33000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 87, grade: 'A2'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 82, grade: 'A2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 90, grade: 'A1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 85, grade: 'A2'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
          ],
        ),
        StudentModel(
          id: 's014',
          name: 'Aryan Shukla',
          admissionNo: 'SGM/2025/041',
          rollNo: 12,
          classGrade: '7',
          section: 'C',
          dateOfBirth: '7 December 2013',
          gender: 'Male',
          bloodGroup: 'B-',
          fatherName: 'Pradeep Shukla',
          motherName: 'Nirmala Shukla',
          contactNumber: '+91 98200 10014',
          address: '77, Swaroop Nagar, Kanpur – 208002',
          busRoute: 'Route 3',
          busNumber: 'UP32 DZ 1122',
          attendancePercent: 66.7,
          house: 'Tagore',
          photoInitials: 'AS',
          avatarColorIndex: 6,
          feeStatus: 'Pending',
          totalFee: 33000,
          paidFee: 0,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 55, grade: 'C1'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 61, grade: 'B2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 58, grade: 'C1'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 70, grade: 'B1'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 63, grade: 'B2'),
          ],
        ),
        StudentModel(
          id: 's015',
          name: 'Meera Jain',
          admissionNo: 'SGM/2025/052',
          rollNo: 20,
          classGrade: '7',
          section: 'C',
          dateOfBirth: '23 June 2013',
          gender: 'Female',
          bloodGroup: 'O+',
          fatherName: 'Sushil Jain',
          motherName: 'Kavita Jain',
          contactNumber: '+91 98200 10015',
          address: '6, Gwaltoli, Kanpur – 208001',
          busRoute: 'Route 1',
          busNumber: 'UP32 BX 4521',
          attendancePercent: 90.0,
          house: 'Gandhi',
          photoInitials: 'MJ',
          avatarColorIndex: 0,
          feeStatus: 'Paid',
          totalFee: 33000,
          paidFee: 33000,
          results: [
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 79, grade: 'B1'),
            const SubjectResult(subject: 'Science', maxMarks: 100, obtainedMarks: 76, grade: 'B1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 83, grade: 'A2'),
            const SubjectResult(subject: 'Hindi', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
            const SubjectResult(subject: 'Social Science', maxMarks: 100, obtainedMarks: 80, grade: 'A2'),
          ],
        ),

        // ── Class 11-A (additional students) ─────────────────────────────────
        StudentModel(
          id: 's016',
          name: 'Deepak Rao',
          admissionNo: 'SGM/2023/011',
          rollNo: 8,
          classGrade: '11',
          section: 'A',
          dateOfBirth: '2 April 2009',
          gender: 'Male',
          bloodGroup: 'B+',
          fatherName: 'Narayan Rao',
          motherName: 'Sudha Rao',
          contactNumber: '+91 98200 10016',
          address: '22, Colonelganj, Kanpur – 208001',
          busRoute: 'Route 2',
          busNumber: 'UP32 CY 7832',
          attendancePercent: 91.7,
          house: 'Gandhi',
          photoInitials: 'DR',
          avatarColorIndex: 2,
          feeStatus: 'Paid',
          totalFee: 50000,
          paidFee: 50000,
          results: [
            const SubjectResult(subject: 'Physics', maxMarks: 100, obtainedMarks: 82, grade: 'A2'),
            const SubjectResult(subject: 'Chemistry', maxMarks: 100, obtainedMarks: 78, grade: 'B1'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 88, grade: 'A2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 74, grade: 'B1'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 91, grade: 'A1'),
          ],
        ),
        StudentModel(
          id: 's017',
          name: 'Prachi Saxena',
          admissionNo: 'SGM/2023/028',
          rollNo: 19,
          classGrade: '11',
          section: 'A',
          dateOfBirth: '15 September 2008',
          gender: 'Female',
          bloodGroup: 'A-',
          fatherName: 'Alok Saxena',
          motherName: 'Poonam Saxena',
          contactNumber: '+91 98200 10017',
          address: '48, Ashok Nagar, Kanpur – 208012',
          busRoute: 'Route 1',
          busNumber: 'UP32 BX 4521',
          attendancePercent: 95.0,
          house: 'Vivekananda',
          photoInitials: 'PS',
          avatarColorIndex: 1,
          feeStatus: 'Paid',
          totalFee: 50000,
          paidFee: 50000,
          results: [
            const SubjectResult(subject: 'Physics', maxMarks: 100, obtainedMarks: 71, grade: 'B1'),
            const SubjectResult(subject: 'Chemistry', maxMarks: 100, obtainedMarks: 68, grade: 'B2'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 76, grade: 'B1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 84, grade: 'A2'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 79, grade: 'B1'),
          ],
        ),
        StudentModel(
          id: 's018',
          name: 'Nikhil Gupta',
          admissionNo: 'SGM/2023/039',
          rollNo: 14,
          classGrade: '11',
          section: 'A',
          dateOfBirth: '8 January 2009',
          gender: 'Male',
          bloodGroup: 'O-',
          fatherName: 'Pankaj Gupta',
          motherName: 'Anita Gupta',
          contactNumber: '+91 98200 10018',
          address: '3, Tilak Nagar, Kanpur – 208002',
          busRoute: 'Route 3',
          busNumber: 'UP32 DZ 1122',
          attendancePercent: 87.5,
          house: 'Tagore',
          photoInitials: 'NG',
          avatarColorIndex: 3,
          feeStatus: 'Partial',
          totalFee: 50000,
          paidFee: 25000,
          results: [
            const SubjectResult(subject: 'Physics', maxMarks: 100, obtainedMarks: 65, grade: 'B2'),
            const SubjectResult(subject: 'Chemistry', maxMarks: 100, obtainedMarks: 62, grade: 'B2'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 70, grade: 'B1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 67, grade: 'B2'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 74, grade: 'B1'),
          ],
        ),
        StudentModel(
          id: 's019',
          name: 'Shruti Tiwari',
          admissionNo: 'SGM/2023/051',
          rollNo: 26,
          classGrade: '11',
          section: 'A',
          dateOfBirth: '20 July 2008',
          gender: 'Female',
          bloodGroup: 'AB+',
          fatherName: 'Ramakant Tiwari',
          motherName: 'Suman Tiwari',
          contactNumber: '+91 98200 10019',
          address: '55, Azad Nagar, Kanpur – 208003',
          busRoute: 'Route 2',
          busNumber: 'UP32 CY 7832',
          attendancePercent: 90.0,
          house: 'Bose',
          photoInitials: 'ST',
          avatarColorIndex: 5,
          feeStatus: 'Paid',
          totalFee: 50000,
          paidFee: 50000,
          results: [
            const SubjectResult(subject: 'Physics', maxMarks: 100, obtainedMarks: 77, grade: 'B1'),
            const SubjectResult(subject: 'Chemistry', maxMarks: 100, obtainedMarks: 73, grade: 'B1'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 81, grade: 'A2'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 79, grade: 'B1'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 85, grade: 'A2'),
          ],
        ),
        StudentModel(
          id: 's020',
          name: 'Varun Mishra',
          admissionNo: 'SGM/2023/062',
          rollNo: 31,
          classGrade: '11',
          section: 'A',
          dateOfBirth: '13 November 2008',
          gender: 'Male',
          bloodGroup: 'B+',
          fatherName: 'Sanjay Mishra',
          motherName: 'Rekha Mishra',
          contactNumber: '+91 98200 10020',
          address: '19, Ratan Lal Nagar, Kanpur – 208022',
          busRoute: 'Route 3',
          busNumber: 'UP32 DZ 1122',
          attendancePercent: 62.5,
          house: 'Gandhi',
          photoInitials: 'VM',
          avatarColorIndex: 0,
          feeStatus: 'Overdue',
          totalFee: 50000,
          paidFee: 10000,
          results: [
            const SubjectResult(subject: 'Physics', maxMarks: 100, obtainedMarks: 51, grade: 'C1'),
            const SubjectResult(subject: 'Chemistry', maxMarks: 100, obtainedMarks: 48, grade: 'C2'),
            const SubjectResult(subject: 'Mathematics', maxMarks: 100, obtainedMarks: 55, grade: 'C1'),
            const SubjectResult(subject: 'English', maxMarks: 100, obtainedMarks: 60, grade: 'B2'),
            const SubjectResult(subject: 'Computer Science', maxMarks: 100, obtainedMarks: 63, grade: 'B2'),
          ],
        ),
      ];

  // ───────────────────────── TEACHERS ──────────────────────────
  static List<TeacherModel> get teachers => [
        const TeacherModel(
          id: 't001',
          name: 'Mrs. Sunita Sharma',
          employeeId: 'SGM/T/001',
          subject: 'Mathematics',
          classIncharge: 'Class 10-A',
          qualification: 'M.Sc. Mathematics, B.Ed.',
          contactNumber: '+91 98100 11001',
          experience: 15,
          photoInitials: 'SS',
          avatarColorIndex: 0,
        ),
        const TeacherModel(
          id: 't002',
          name: 'Mr. Ramesh Kumar',
          employeeId: 'SGM/T/002',
          subject: 'Science / Physics',
          classIncharge: 'Class 12-A',
          qualification: 'M.Sc. Physics, B.Ed.',
          contactNumber: '+91 98100 22002',
          experience: 20,
          photoInitials: 'RK',
          avatarColorIndex: 2,
        ),
        const TeacherModel(
          id: 't003',
          name: 'Mrs. Anita Gupta',
          employeeId: 'SGM/T/003',
          subject: 'English',
          classIncharge: 'Class 8-B',
          qualification: 'MA English, B.Ed.',
          contactNumber: '+91 98100 33003',
          experience: 12,
          photoInitials: 'AG',
          avatarColorIndex: 3,
        ),
        const TeacherModel(
          id: 't004',
          name: 'Mr. Suresh Verma',
          employeeId: 'SGM/T/004',
          subject: 'Hindi',
          classIncharge: 'Class 6-A',
          qualification: 'MA Hindi, B.Ed.',
          contactNumber: '+91 98100 44004',
          experience: 18,
          photoInitials: 'SV',
          avatarColorIndex: 4,
        ),
        const TeacherModel(
          id: 't005',
          name: 'Ms. Pooja Singh',
          employeeId: 'SGM/T/005',
          subject: 'Social Science',
          classIncharge: 'Class 9-B',
          qualification: 'MA History, B.Ed.',
          contactNumber: '+91 98100 55005',
          experience: 8,
          photoInitials: 'PS',
          avatarColorIndex: 5,
        ),
        const TeacherModel(
          id: 't006',
          name: 'Mr. Anil Dubey',
          employeeId: 'SGM/T/006',
          subject: 'Computer Science',
          classIncharge: 'Class 11-A',
          qualification: 'MCA, B.Ed.',
          contactNumber: '+91 98100 66006',
          experience: 10,
          photoInitials: 'AD',
          avatarColorIndex: 6,
        ),
      ];

  // ───────────────────────── BUS ROUTES ────────────────────────
  static List<BusRoute> get busRoutes => [
        BusRoute(
          id: 'b001',
          routeName: 'Indira Nagar – School',
          busNumber: 'UP32 BX 4521',
          driverName: 'Ram Bahadur Yadav',
          driverContact: '+91 90000 11111',
          conductorName: 'Shyam Lal',
          currentPosition: const LatLng(26.4765, 80.2642),
          nextStopIndex: 2,
          status: BusStatus.onRoute,
          estimatedMinutes: 12,
          stops: const [
            BusStop(name: 'Barra Bus Stand', position: LatLng(26.4601, 80.2503), arrivalTime: '06:45 AM', isPassed: true),
            BusStop(name: 'Kalyanpur Main', position: LatLng(26.4685, 80.2571), arrivalTime: '07:00 AM', isPassed: true),
            BusStop(name: 'Indira Nagar Gate', position: LatLng(26.4748, 80.2638), arrivalTime: '07:15 AM'),
            BusStop(name: 'Sector H Chowk', position: LatLng(26.4782, 80.2710), arrivalTime: '07:22 AM'),
            BusStop(name: 'SGM International School', position: LatLng(26.4812, 80.2775), arrivalTime: '07:30 AM'),
          ],
        ),
        BusRoute(
          id: 'b002',
          routeName: 'Kidwai Nagar – School',
          busNumber: 'UP32 CY 7832',
          driverName: 'Amar Nath Singh',
          driverContact: '+91 90000 22222',
          conductorName: 'Dinesh Chauhan',
          currentPosition: const LatLng(26.4890, 80.3120),
          nextStopIndex: 1,
          status: BusStatus.onRoute,
          estimatedMinutes: 20,
          stops: const [
            BusStop(name: 'Kidwai Nagar Depot', position: LatLng(26.4934, 80.3250), arrivalTime: '06:50 AM', isPassed: true),
            BusStop(name: 'Govind Nagar Square', position: LatLng(26.4895, 80.3140), arrivalTime: '07:05 AM'),
            BusStop(name: 'Vikas Nagar Turn', position: LatLng(26.4858, 80.3020), arrivalTime: '07:15 AM'),
            BusStop(name: 'Shastri Nagar', position: LatLng(26.4840, 80.2910), arrivalTime: '07:22 AM'),
            BusStop(name: 'SGM International School', position: LatLng(26.4812, 80.2775), arrivalTime: '07:35 AM'),
          ],
        ),
        BusRoute(
          id: 'b003',
          routeName: 'Kakadeo – School',
          busNumber: 'UP32 DZ 1122',
          driverName: 'Sunil Kushwaha',
          driverContact: '+91 90000 33333',
          conductorName: 'Manoj Yadav',
          currentPosition: const LatLng(26.4680, 80.3310),
          nextStopIndex: 0,
          status: BusStatus.atStop,
          estimatedMinutes: 28,
          stops: const [
            BusStop(name: 'Kakadeo Market', position: LatLng(26.4672, 80.3322), arrivalTime: '06:55 AM'),
            BusStop(name: 'Civil Lines Cross', position: LatLng(26.4710, 80.3245), arrivalTime: '07:08 AM'),
            BusStop(name: 'Swaroop Nagar', position: LatLng(26.4751, 80.3080), arrivalTime: '07:18 AM'),
            BusStop(name: 'Arya Nagar', position: LatLng(26.4790, 80.2920), arrivalTime: '07:25 AM'),
            BusStop(name: 'SGM International School', position: LatLng(26.4812, 80.2775), arrivalTime: '07:40 AM'),
          ],
        ),
      ];

  // ──────────────────────── ANNOUNCEMENTS ──────────────────────
  static List<AnnouncementModel> get announcements => [
        AnnouncementModel(
          id: 'a001',
          title: 'Half-Yearly Exam Schedule Released',
          body: 'The Half-Yearly Examination for classes 6–12 will commence from 15th May 2025. Students are advised to collect their admit cards from the school office. Detailed timetable is available on the school website.',
          date: DateTime(2025, 4, 20),
          type: AnnouncementType.exam,
          isPinned: true,
          postedBy: "Principal's Office",
        ),
        AnnouncementModel(
          id: 'a002',
          title: 'Annual Sports Day – 10th May 2025',
          body: 'SGM International School\'s Annual Sports Day will be held on 10th May 2025 at the school ground. Parents are cordially invited. Events include track & field, relay races, and cultural performances.',
          date: DateTime(2025, 4, 18),
          type: AnnouncementType.sports,
          isPinned: true,
          postedBy: 'Sports Committee',
        ),
        AnnouncementModel(
          id: 'a003',
          title: 'Summer Vacation Notice',
          body: 'The school will remain closed for Summer Vacation from 25th May to 30th June 2025. Classes will resume on 1st July 2025. Students are encouraged to complete their vacation homework before school reopens.',
          date: DateTime(2025, 4, 15),
          type: AnnouncementType.holiday,
          postedBy: 'Administration',
        ),
        AnnouncementModel(
          id: 'a004',
          title: 'Fee Submission Reminder – Last Date 30 April',
          body: 'This is a reminder to all parents that the last date for submitting Annual School Fees is 30th April 2025. A late fine of ₹50 per day will be levied after the due date. Please visit the school accounts department.',
          date: DateTime(2025, 4, 12),
          type: AnnouncementType.fee,
          postedBy: 'Accounts Department',
        ),
        AnnouncementModel(
          id: 'a005',
          title: 'Science Exhibition – 3rd May 2025',
          body: 'Classes 9–12 students are invited to participate in the Inter-School Science Exhibition. Register with your respective Science teacher before 28th April. Models, projects, and presentations are welcome.',
          date: DateTime(2025, 4, 10),
          type: AnnouncementType.event,
          postedBy: 'Science Department',
        ),
        AnnouncementModel(
          id: 'a006',
          title: 'Parent-Teacher Meeting – 26th April',
          body: 'A Parent-Teacher Meeting is scheduled for 26th April 2025 from 9:00 AM to 1:00 PM. Parents of all classes are requested to attend and discuss their ward\'s academic progress.',
          date: DateTime(2025, 4, 8),
          type: AnnouncementType.general,
          postedBy: "Principal's Office",
        ),
      ];

  // ──────────────────────── TIMETABLE ──────────────────────────
  static Map<String, List<TimetablePeriod>> get timetableClass10A => {
        'Monday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Mathematics', teacher: 'Mrs. Sunita Sharma', room: 'Room 12'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Science', teacher: 'Mr. Ramesh Kumar', room: 'Lab 1'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'English', teacher: 'Mrs. Anita Gupta', room: 'Room 12'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Hindi', teacher: 'Mr. Suresh Verma', room: 'Room 12'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Social Science', teacher: 'Ms. Pooja Singh', room: 'Room 12'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Mathematics', teacher: 'Mrs. Sunita Sharma', room: 'Room 12'),
        ],
        'Tuesday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'English', teacher: 'Mrs. Anita Gupta', room: 'Room 12'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Mathematics', teacher: 'Mrs. Sunita Sharma', room: 'Room 12'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Social Science', teacher: 'Ms. Pooja Singh', room: 'Room 12'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Science', teacher: 'Mr. Ramesh Kumar', room: 'Lab 1'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Hindi', teacher: 'Mr. Suresh Verma', room: 'Room 12'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Physical Education', teacher: 'Mr. Deepak Rai', room: 'Ground'),
        ],
        'Wednesday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Hindi', teacher: 'Mr. Suresh Verma', room: 'Room 12'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Mathematics', teacher: 'Mrs. Sunita Sharma', room: 'Room 12'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'English', teacher: 'Mrs. Anita Gupta', room: 'Room 12'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Science', teacher: 'Mr. Ramesh Kumar', room: 'Lab 1'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Social Science', teacher: 'Ms. Pooja Singh', room: 'Room 12'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Art & Craft', teacher: 'Mrs. Lalita Soni', room: 'Art Room'),
        ],
        'Thursday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Science', teacher: 'Mr. Ramesh Kumar', room: 'Lab 1'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Social Science', teacher: 'Ms. Pooja Singh', room: 'Room 12'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Mathematics', teacher: 'Mrs. Sunita Sharma', room: 'Room 12'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Hindi', teacher: 'Mr. Suresh Verma', room: 'Room 12'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'English', teacher: 'Mrs. Anita Gupta', room: 'Room 12'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Library', teacher: 'Mr. Suresh Verma', room: 'Library'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
        ],
        'Friday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Hindi', teacher: 'Mr. Suresh Verma', room: 'Room 12'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Science', teacher: 'Mr. Ramesh Kumar', room: 'Lab 1'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Mathematics', teacher: 'Mrs. Sunita Sharma', room: 'Room 12'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'English', teacher: 'Mrs. Anita Gupta', room: 'Room 12'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Social Science', teacher: 'Ms. Pooja Singh', room: 'Room 12'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Physical Education', teacher: 'Mr. Deepak Rai', room: 'Ground'),
        ],
        'Saturday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Mathematics', teacher: 'Mrs. Sunita Sharma', room: 'Room 12'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'English', teacher: 'Mrs. Anita Gupta', room: 'Room 12'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Hindi', teacher: 'Mr. Suresh Verma', room: 'Room 12'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Science', teacher: 'Mr. Ramesh Kumar', room: 'Lab 1'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Social Science', teacher: 'Ms. Pooja Singh', room: 'Room 12'),
        ],
      };

  // ── Class 5-A (Primary) ──────────────────────────────────────
  static Map<String, List<TimetablePeriod>> get timetableClass5A => {
        'Monday': [
          const TimetablePeriod(time: '08:00 - 08:40', subject: 'English', teacher: 'Mrs. Rekha Tiwari', room: 'Room 5'),
          const TimetablePeriod(time: '08:40 - 09:20', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
          const TimetablePeriod(time: '09:20 - 10:00', subject: 'Hindi', teacher: 'Mrs. Seema Mishra', room: 'Room 5'),
          const TimetablePeriod(time: '10:00 - 10:15', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:15 - 10:55', subject: 'Science', teacher: 'Mrs. Meena Joshi', room: 'Room 5'),
          const TimetablePeriod(time: '10:55 - 11:35', subject: 'Social Science', teacher: 'Mr. Vijay Kumar', room: 'Room 5'),
          const TimetablePeriod(time: '11:35 - 12:15', subject: 'Art & Craft', teacher: 'Mrs. Lalita Soni', room: 'Art Room'),
          const TimetablePeriod(time: '12:15 - 12:45', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Physical Education', teacher: 'Mr. Deepak Rai', room: 'Ground'),
        ],
        'Tuesday': [
          const TimetablePeriod(time: '08:00 - 08:40', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
          const TimetablePeriod(time: '08:40 - 09:20', subject: 'Science', teacher: 'Mrs. Meena Joshi', room: 'Room 5'),
          const TimetablePeriod(time: '09:20 - 10:00', subject: 'English', teacher: 'Mrs. Rekha Tiwari', room: 'Room 5'),
          const TimetablePeriod(time: '10:00 - 10:15', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:15 - 10:55', subject: 'Hindi', teacher: 'Mrs. Seema Mishra', room: 'Room 5'),
          const TimetablePeriod(time: '10:55 - 11:35', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
          const TimetablePeriod(time: '11:35 - 12:15', subject: 'Social Science', teacher: 'Mr. Vijay Kumar', room: 'Room 5'),
          const TimetablePeriod(time: '12:15 - 12:45', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'English', teacher: 'Mrs. Rekha Tiwari', room: 'Room 5'),
        ],
        'Wednesday': [
          const TimetablePeriod(time: '08:00 - 08:40', subject: 'Hindi', teacher: 'Mrs. Seema Mishra', room: 'Room 5'),
          const TimetablePeriod(time: '08:40 - 09:20', subject: 'English', teacher: 'Mrs. Rekha Tiwari', room: 'Room 5'),
          const TimetablePeriod(time: '09:20 - 10:00', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
          const TimetablePeriod(time: '10:00 - 10:15', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:15 - 10:55', subject: 'Art & Craft', teacher: 'Mrs. Lalita Soni', room: 'Art Room'),
          const TimetablePeriod(time: '10:55 - 11:35', subject: 'Science', teacher: 'Mrs. Meena Joshi', room: 'Room 5'),
          const TimetablePeriod(time: '11:35 - 12:15', subject: 'Hindi', teacher: 'Mrs. Seema Mishra', room: 'Room 5'),
          const TimetablePeriod(time: '12:15 - 12:45', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Social Science', teacher: 'Mr. Vijay Kumar', room: 'Room 5'),
        ],
        'Thursday': [
          const TimetablePeriod(time: '08:00 - 08:40', subject: 'Science', teacher: 'Mrs. Meena Joshi', room: 'Room 5'),
          const TimetablePeriod(time: '08:40 - 09:20', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
          const TimetablePeriod(time: '09:20 - 10:00', subject: 'Social Science', teacher: 'Mr. Vijay Kumar', room: 'Room 5'),
          const TimetablePeriod(time: '10:00 - 10:15', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:15 - 10:55', subject: 'English', teacher: 'Mrs. Rekha Tiwari', room: 'Room 5'),
          const TimetablePeriod(time: '10:55 - 11:35', subject: 'Hindi', teacher: 'Mrs. Seema Mishra', room: 'Room 5'),
          const TimetablePeriod(time: '11:35 - 12:15', subject: 'Physical Education', teacher: 'Mr. Deepak Rai', room: 'Ground'),
          const TimetablePeriod(time: '12:15 - 12:45', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
        ],
        'Friday': [
          const TimetablePeriod(time: '08:00 - 08:40', subject: 'Social Science', teacher: 'Mr. Vijay Kumar', room: 'Room 5'),
          const TimetablePeriod(time: '08:40 - 09:20', subject: 'Hindi', teacher: 'Mrs. Seema Mishra', room: 'Room 5'),
          const TimetablePeriod(time: '09:20 - 10:00', subject: 'Science', teacher: 'Mrs. Meena Joshi', room: 'Room 5'),
          const TimetablePeriod(time: '10:00 - 10:15', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:15 - 10:55', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
          const TimetablePeriod(time: '10:55 - 11:35', subject: 'English', teacher: 'Mrs. Rekha Tiwari', room: 'Room 5'),
          const TimetablePeriod(time: '11:35 - 12:15', subject: 'Art & Craft', teacher: 'Mrs. Lalita Soni', room: 'Art Room'),
          const TimetablePeriod(time: '12:15 - 12:45', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Physical Education', teacher: 'Mr. Deepak Rai', room: 'Ground'),
        ],
        'Saturday': [
          const TimetablePeriod(time: '08:00 - 08:40', subject: 'Mathematics', teacher: 'Mrs. Priya Gupta', room: 'Room 5'),
          const TimetablePeriod(time: '08:40 - 09:20', subject: 'English', teacher: 'Mrs. Rekha Tiwari', room: 'Room 5'),
          const TimetablePeriod(time: '09:20 - 10:00', subject: 'Hindi', teacher: 'Mrs. Seema Mishra', room: 'Room 5'),
          const TimetablePeriod(time: '10:00 - 10:15', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:15 - 10:55', subject: 'Science', teacher: 'Mrs. Meena Joshi', room: 'Room 5'),
          const TimetablePeriod(time: '10:55 - 11:35', subject: 'Social Science', teacher: 'Mr. Vijay Kumar', room: 'Room 5'),
        ],
      };

  // ── Class 7-C (Middle School) ─────────────────────────────────
  static Map<String, List<TimetablePeriod>> get timetableClass7C => {
        'Monday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Mathematics', teacher: 'Mr. Rajan Verma', room: 'Room 7'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'English', teacher: 'Mr. Prakash Nair', room: 'Room 7'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Science', teacher: 'Mrs. Kavita Rao', room: 'Lab 2'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Hindi', teacher: 'Mrs. Usha Pandey', room: 'Room 7'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Social Science', teacher: 'Ms. Nandini Joshi', room: 'Room 7'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Mathematics', teacher: 'Mr. Rajan Verma', room: 'Room 7'),
        ],
        'Tuesday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Hindi', teacher: 'Mrs. Usha Pandey', room: 'Room 7'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Science', teacher: 'Mrs. Kavita Rao', room: 'Lab 2'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Mathematics', teacher: 'Mr. Rajan Verma', room: 'Room 7'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'English', teacher: 'Mr. Prakash Nair', room: 'Room 7'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Social Science', teacher: 'Ms. Nandini Joshi', room: 'Room 7'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Physical Education', teacher: 'Mr. Deepak Rai', room: 'Ground'),
        ],
        'Wednesday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'English', teacher: 'Mr. Prakash Nair', room: 'Room 7'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Hindi', teacher: 'Mrs. Usha Pandey', room: 'Room 7'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Social Science', teacher: 'Ms. Nandini Joshi', room: 'Room 7'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Mathematics', teacher: 'Mr. Rajan Verma', room: 'Room 7'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Science', teacher: 'Mrs. Kavita Rao', room: 'Lab 2'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Art & Craft', teacher: 'Mrs. Lalita Soni', room: 'Art Room'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Hindi', teacher: 'Mrs. Usha Pandey', room: 'Room 7'),
        ],
        'Thursday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Science', teacher: 'Mrs. Kavita Rao', room: 'Lab 2'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Mathematics', teacher: 'Mr. Rajan Verma', room: 'Room 7'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'English', teacher: 'Mr. Prakash Nair', room: 'Room 7'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Hindi', teacher: 'Mrs. Usha Pandey', room: 'Room 7'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Library', teacher: 'Mr. Suresh Verma', room: 'Library'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Social Science', teacher: 'Ms. Nandini Joshi', room: 'Room 7'),
        ],
        'Friday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Social Science', teacher: 'Ms. Nandini Joshi', room: 'Room 7'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Mathematics', teacher: 'Mr. Rajan Verma', room: 'Room 7'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'Hindi', teacher: 'Mrs. Usha Pandey', room: 'Room 7'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Science', teacher: 'Mrs. Kavita Rao', room: 'Lab 2'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'English', teacher: 'Mr. Prakash Nair', room: 'Room 7'),
          const TimetablePeriod(time: '12:00 - 12:45', subject: 'Computer Science', teacher: 'Mr. Anil Dubey', room: 'Computer Lab'),
          const TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch', teacher: '', room: ''),
          const TimetablePeriod(time: '01:15 - 02:00', subject: 'Physical Education', teacher: 'Mr. Deepak Rai', room: 'Ground'),
        ],
        'Saturday': [
          const TimetablePeriod(time: '08:00 - 08:45', subject: 'Mathematics', teacher: 'Mr. Rajan Verma', room: 'Room 7'),
          const TimetablePeriod(time: '08:45 - 09:30', subject: 'Science', teacher: 'Mrs. Kavita Rao', room: 'Lab 2'),
          const TimetablePeriod(time: '09:30 - 10:15', subject: 'English', teacher: 'Mr. Prakash Nair', room: 'Room 7'),
          const TimetablePeriod(time: '10:15 - 10:30', subject: 'Break', teacher: '', room: ''),
          const TimetablePeriod(time: '10:30 - 11:15', subject: 'Hindi', teacher: 'Mrs. Usha Pandey', room: 'Room 7'),
          const TimetablePeriod(time: '11:15 - 12:00', subject: 'Social Science', teacher: 'Ms. Nandini Joshi', room: 'Room 7'),
        ],
      };

  // ── Class 11-A (Senior Secondary – Science stream) ───────────────────────
  static Map<String, List<TimetablePeriod>> get timetableClass11A => {
        'Monday': const [
          TimetablePeriod(time: '08:00 - 08:45', subject: 'Physics',           teacher: 'Mr. Ramesh Kumar',       room: 'Lab 1'),
          TimetablePeriod(time: '08:45 - 09:30', subject: 'Mathematics',        teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
          TimetablePeriod(time: '09:30 - 10:15', subject: 'Chemistry',          teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
          TimetablePeriod(time: '10:15 - 10:30', subject: 'Break',              teacher: '',                       room: ''),
          TimetablePeriod(time: '10:30 - 11:15', subject: 'English',            teacher: 'Mrs. Lalita Deshpande',  room: 'Room 11'),
          TimetablePeriod(time: '11:15 - 12:00', subject: 'Computer Science',   teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '12:00 - 12:45', subject: 'Mathematics',        teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
          TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch',              teacher: '',                       room: ''),
          TimetablePeriod(time: '01:15 - 02:00', subject: 'Physical Education', teacher: 'Mr. Deepak Rai',         room: 'Ground'),
        ],
        'Tuesday': const [
          TimetablePeriod(time: '08:00 - 08:45', subject: 'Mathematics',       teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
          TimetablePeriod(time: '08:45 - 09:30', subject: 'Computer Science',  teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '09:30 - 10:15', subject: 'Physics',           teacher: 'Mr. Ramesh Kumar',       room: 'Lab 1'),
          TimetablePeriod(time: '10:15 - 10:30', subject: 'Break',             teacher: '',                       room: ''),
          TimetablePeriod(time: '10:30 - 11:15', subject: 'Chemistry',         teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
          TimetablePeriod(time: '11:15 - 12:00', subject: 'English',           teacher: 'Mrs. Lalita Deshpande',  room: 'Room 11'),
          TimetablePeriod(time: '12:00 - 12:45', subject: 'Computer Science',  teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch',             teacher: '',                       room: ''),
          TimetablePeriod(time: '01:15 - 02:00', subject: 'Physics',           teacher: 'Mr. Ramesh Kumar',       room: 'Lab 1'),
        ],
        'Wednesday': const [
          TimetablePeriod(time: '08:00 - 08:45', subject: 'English',           teacher: 'Mrs. Lalita Deshpande',  room: 'Room 11'),
          TimetablePeriod(time: '08:45 - 09:30', subject: 'Chemistry',         teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
          TimetablePeriod(time: '09:30 - 10:15', subject: 'Mathematics',       teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
          TimetablePeriod(time: '10:15 - 10:30', subject: 'Break',             teacher: '',                       room: ''),
          TimetablePeriod(time: '10:30 - 11:15', subject: 'Computer Science',  teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '11:15 - 12:00', subject: 'Physics',           teacher: 'Mr. Ramesh Kumar',       room: 'Lab 1'),
          TimetablePeriod(time: '12:00 - 12:45', subject: 'Chemistry',         teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
          TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch',             teacher: '',                       room: ''),
          TimetablePeriod(time: '01:15 - 02:00', subject: 'Mathematics',       teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
        ],
        'Thursday': const [
          TimetablePeriod(time: '08:00 - 08:45', subject: 'Chemistry',         teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
          TimetablePeriod(time: '08:45 - 09:30', subject: 'English',           teacher: 'Mrs. Lalita Deshpande',  room: 'Room 11'),
          TimetablePeriod(time: '09:30 - 10:15', subject: 'Physics',           teacher: 'Mr. Ramesh Kumar',       room: 'Lab 1'),
          TimetablePeriod(time: '10:15 - 10:30', subject: 'Break',             teacher: '',                       room: ''),
          TimetablePeriod(time: '10:30 - 11:15', subject: 'Mathematics',       teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
          TimetablePeriod(time: '11:15 - 12:00', subject: 'Computer Science',  teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '12:00 - 12:45', subject: 'Library',           teacher: '',                       room: 'Library'),
          TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch',             teacher: '',                       room: ''),
          TimetablePeriod(time: '01:15 - 02:00', subject: 'Chemistry',         teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
        ],
        'Friday': const [
          TimetablePeriod(time: '08:00 - 08:45', subject: 'Computer Science',   teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '08:45 - 09:30', subject: 'Physics',            teacher: 'Mr. Ramesh Kumar',       room: 'Lab 1'),
          TimetablePeriod(time: '09:30 - 10:15', subject: 'English',            teacher: 'Mrs. Lalita Deshpande',  room: 'Room 11'),
          TimetablePeriod(time: '10:15 - 10:30', subject: 'Break',              teacher: '',                       room: ''),
          TimetablePeriod(time: '10:30 - 11:15', subject: 'Chemistry',          teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
          TimetablePeriod(time: '11:15 - 12:00', subject: 'Mathematics',        teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
          TimetablePeriod(time: '12:00 - 12:45', subject: 'Computer Science',   teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '12:45 - 01:15', subject: 'Lunch',              teacher: '',                       room: ''),
          TimetablePeriod(time: '01:15 - 02:00', subject: 'Physical Education', teacher: 'Mr. Deepak Rai',         room: 'Ground'),
        ],
        'Saturday': const [
          TimetablePeriod(time: '08:00 - 08:45', subject: 'Mathematics',       teacher: 'Mr. Keshav Nair',        room: 'Room 11'),
          TimetablePeriod(time: '08:45 - 09:30', subject: 'Physics',           teacher: 'Mr. Ramesh Kumar',       room: 'Lab 1'),
          TimetablePeriod(time: '09:30 - 10:15', subject: 'Chemistry',         teacher: 'Dr. Priya Kapoor',       room: 'Lab 3'),
          TimetablePeriod(time: '10:15 - 10:30', subject: 'Break',             teacher: '',                       room: ''),
          TimetablePeriod(time: '10:30 - 11:15', subject: 'Computer Science',  teacher: 'Mr. Anil Dubey',         room: 'Computer Lab'),
          TimetablePeriod(time: '11:15 - 12:00', subject: 'English',           teacher: 'Mrs. Lalita Deshpande',  room: 'Room 11'),
        ],
      };

  // ── Timetable lookup ──────────────────────────────────────────
  static Map<String, List<TimetablePeriod>> timetableFor(
      String classGrade, String section) {
    switch ('$classGrade-$section') {
      case '5-A':
        return timetableClass5A;
      case '7-C':
        return timetableClass7C;
      case '11-A':
        return timetableClass11A;
      default:
        return timetableClass10A;
    }
  }

  // ──────────────────────── ATTENDANCE ─────────────────────────
  static List<AttendanceRecord> generateAttendance(
    String studentId, {
    double targetPercent = 85.0,
  }) {
    final now = DateTime.now();
    final seed =
        int.parse(studentId.replaceAll(RegExp(r'[^0-9]'), '0'));

    // Collect working days up to today (exclude Sunday and fixed holidays)
    final workingDays = <int>[];
    for (int i = 1; i <= 27; i++) {
      final date = DateTime(now.year, now.month, i);
      if (date.isAfter(now)) break;
      if (date.weekday == DateTime.sunday || i == 14 || i == 15) continue;
      workingDays.add(i);
    }

    // Derive absent-day indices from targetPercent, seeded by student ID
    final absentCount =
        ((1 - targetPercent / 100) * workingDays.length).round();
    final absentDays = <int>{};
    for (int k = 0;
        absentDays.length < absentCount && k < workingDays.length * 10;
        k++) {
      absentDays.add(workingDays[(seed + k * 7) % workingDays.length]);
    }

    // Build the full record list
    final records = <AttendanceRecord>[];
    for (int i = 1; i <= 27; i++) {
      final date = DateTime(now.year, now.month, i);
      if (date.isAfter(now)) break;
      if (date.weekday == DateTime.sunday) {
        records.add(
            AttendanceRecord(date: date, status: AttendanceStatus.sunday));
        continue;
      }
      if (i == 14 || i == 15) {
        records.add(
            AttendanceRecord(date: date, status: AttendanceStatus.holiday));
        continue;
      }
      final status = absentDays.contains(i)
          ? AttendanceStatus.absent
          : AttendanceStatus.present;
      records.add(AttendanceRecord(date: date, status: status));
    }
    return records;
  }

  // ──────────────────────── STATS ──────────────────────────────
  static Map<String, dynamic> get dashboardStats => {
        'totalStudents': 1240,
        'totalTeachers': 68,
        'todayAttendance': 94.2,
        'upcomingExams': 3,
        'activeAnnouncements': 6,
        'busesOnRoute': 3,
      };

  // ──────────────────────── TEACHER HELPERS ────────────────────
  // Returns the class incharge teacher for a given class/section.
  static TeacherModel? classTeacherFor(String classGrade, String section) {
    final key = 'Class $classGrade-$section';
    try {
      return teachers.firstWhere((t) => t.classIncharge == key);
    } catch (_) {
      return null;
    }
  }

  // Returns all subject teachers who teach a given class (derived from timetable).
  // For the demo all teachers in the list teach Class 10-A.
  static List<TeacherModel> subjectTeachersFor(String classGrade, String section) {
    return teachers;
  }

  // Counts non-break periods for a given day name (e.g. 'Monday').
  static int periodsCountFor(String dayName) {
    final periods = timetableClass10A[dayName] ?? [];
    return periods.where((p) => !p.isBreak).length;
  }

  // The logged-in demo teacher — Anil Dubey teaches CS in multiple classes,
  // demonstrating the multi-class dashboard (incharge 11-A + subject in 10-A & 7-C).
  static TeacherModel get currentTeacher => teachers[5];

  /// Builds a personal teaching schedule for [teacherName] by scanning all
  /// known class timetables.  The returned periods use the class label
  /// ("Class 10-A") in the `teacher` field so callers can show which class
  /// each slot belongs to.
  static Map<String, List<TimetablePeriod>> teacherSchedule(String teacherName) {
    final allTimetables = <String, Map<String, List<TimetablePeriod>>>{
      '10-A': timetableClass10A,
      '7-C':  timetableClass7C,
      '5-A':  timetableClass5A,
      '11-A': timetableClass11A,
    };

    const dayOrder = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
    ];

    final result = <String, List<TimetablePeriod>>{};

    for (final classEntry in allTimetables.entries) {
      final classLabel = 'Class ${classEntry.key}';
      for (final dayEntry in classEntry.value.entries) {
        final dayName = dayEntry.key;
        for (final period in dayEntry.value) {
          if (period.isBreak) continue;
          if (period.teacher == teacherName) {
            result.putIfAbsent(dayName, () => []).add(
              TimetablePeriod(
                time: period.time,
                subject: period.subject,
                teacher: classLabel,
                room: period.room,
              ),
            );
          }
        }
      }
    }

    // Sort each day's periods chronologically and return in day order
    final ordered = <String, List<TimetablePeriod>>{};
    for (final day in dayOrder) {
      final periods = result[day];
      if (periods != null) {
        periods.sort((a, b) => a.time.compareTo(b.time));
        ordered[day] = periods;
      }
    }
    return ordered;
  }

  // Demo attendance % for a class — replace with real aggregation once backend is ready.
  static double classAttendancePct(String classGrade, String section) {
    switch ('$classGrade-$section') {
      case '10-A': return 87.5;
      case '12-A': return 92.3;
      case '8-B': return 94.1;
      case '6-A': return 89.7;
      case '9-B': return 85.4;
      case '11-A': return 88.6;
      default: return 85.0;
    }
  }

  // Demo overall grade for a class.
  static String classAvgGrade(String classGrade, String section) {
    switch ('$classGrade-$section') {
      case '10-A': return 'B1';
      case '12-A': return 'B2';
      case '8-B': return 'A2';
      case '6-A': return 'B1';
      case '9-B': return 'B2';
      case '11-A': return 'B1';
      default: return 'B1';
    }
  }

  // Count of not-submitted, not-overdue assignments for a class.
  static int pendingHomeworkCount(String classGrade, String section) {
    return homeworkFor(classGrade, section)
        .where((h) => !h.isSubmitted && !h.isOverdue)
        .length;
  }

  // Pending homework count filtered to a specific subject.
  static int pendingHomeworkCountForSubject(
      String classGrade, String section, String subject) {
    return homeworkFor(classGrade, section)
        .where((h) => !h.isSubmitted && !h.isOverdue && h.subject == subject)
        .length;
  }

  /// Returns one [TeacherClassSummary] per class the teacher is involved with:
  /// the incharge class is always first; any additional classes where the teacher
  /// appears in the timetable follow as subject-teacher entries.
  static List<TeacherClassSummary> teacherClassSummaries(
      TeacherModel teacher, String todayName) {
    final allTimetables = <String, Map<String, List<TimetablePeriod>>>{
      '10-A': timetableClass10A,
      '7-C': timetableClass7C,
      '5-A': timetableClass5A,
    };

    // classKey → subject taught by this teacher in that class
    final classesTaught = <String, String>{};
    for (final classEntry in allTimetables.entries) {
      for (final dayPeriods in classEntry.value.values) {
        for (final period in dayPeriods) {
          if (!period.isBreak && period.teacher == teacher.name) {
            classesTaught.putIfAbsent(classEntry.key, () => period.subject);
          }
        }
      }
    }

    int periodsToday(String classKey) {
      final timetable = allTimetables[classKey];
      if (timetable == null) return 0;
      return (timetable[todayName] ?? [])
          .where((p) => !p.isBreak && p.teacher == teacher.name)
          .length;
    }

    final (inchargeGrade, inchargeSection) = teacher.inchargeClassParts;
    final inchargeKey = '$inchargeGrade-$inchargeSection';

    final summaries = <TeacherClassSummary>[];

    // Incharge class — always shown first regardless of timetable coverage
    summaries.add(TeacherClassSummary(
      classGrade: inchargeGrade,
      section: inchargeSection,
      isIncharge: true,
      subject: classesTaught[inchargeKey] ?? teacher.subject,
      classStats: classStatsFor(inchargeGrade, inchargeSection),
      attendancePercent: classAvgAttendancePct(inchargeGrade, inchargeSection),
      pendingHomework: pendingHomeworkCount(inchargeGrade, inchargeSection),
      todayPeriods: periodsToday(inchargeKey),
    ));

    // Classes where this teacher is only a subject teacher
    for (final entry in classesTaught.entries) {
      if (entry.key == inchargeKey) continue;
      final parts = entry.key.split('-');
      final grade = parts[0];
      final sec = parts.length > 1 ? parts[1] : 'A';
      summaries.add(TeacherClassSummary(
        classGrade: grade,
        section: sec,
        isIncharge: false,
        subject: entry.value,
        classStats: classStatsFor(grade, sec),
        pendingHomework: pendingHomeworkCountForSubject(grade, sec, entry.value),
        todayPeriods: periodsToday(entry.key),
      ));
    }

    return summaries;
  }

  // ───────────── CLASS REMINDERS (teacher-posted, per day-of-week) ─────────
  static List<ClassReminderModel> remindersForDay(String dayName) {
    const data = <String, List<ClassReminderModel>>{
      'Monday': [
        ClassReminderModel(
          id: 'r_mon_01',
          subject: 'Mathematics',
          teacherName: 'Mrs. Sunita Sharma',
          message: 'Bring compass box and ruler — construction exercise.',
          type: ReminderType.bring,
        ),
        ClassReminderModel(
          id: 'r_mon_02',
          subject: 'Computer Science',
          teacherName: 'Mr. Anil Dubey',
          message: 'Submit HTML project on a USB drive.',
          type: ReminderType.submit,
        ),
      ],
      'Tuesday': [
        ClassReminderModel(
          id: 'r_tue_01',
          subject: 'Science',
          teacherName: 'Mr. Ramesh Kumar',
          message: 'Lab session — bring lab coat and notebook.',
          type: ReminderType.bring,
        ),
        ClassReminderModel(
          id: 'r_tue_02',
          subject: 'English',
          teacherName: 'Mrs. Anita Gupta',
          message: 'Read Chapter 8 before class — short quiz at the start.',
          type: ReminderType.read,
        ),
      ],
      'Wednesday': [
        ClassReminderModel(
          id: 'r_wed_01',
          subject: 'Social Science',
          teacherName: 'Ms. Pooja Singh',
          message: 'Bring atlas — map work on river systems.',
          type: ReminderType.bring,
        ),
        ClassReminderModel(
          id: 'r_wed_02',
          subject: 'Hindi',
          teacherName: 'Mr. Suresh Verma',
          message: 'Prepare a 2-minute oral on your favourite festival.',
          type: ReminderType.prepare,
        ),
      ],
      'Thursday': [
        ClassReminderModel(
          id: 'r_thu_01',
          subject: 'Mathematics',
          teacherName: 'Mrs. Sunita Sharma',
          message: 'Unit test — revise Arithmetic Progressions (Chapter 5).',
          type: ReminderType.prepare,
        ),
      ],
      'Friday': [
        ClassReminderModel(
          id: 'r_fri_01',
          subject: 'Science',
          teacherName: 'Mr. Ramesh Kumar',
          message: 'Bring all previous lab reports for term assessment.',
          type: ReminderType.submit,
        ),
        ClassReminderModel(
          id: 'r_fri_02',
          subject: 'Computer Science',
          teacherName: 'Mr. Anil Dubey',
          message: 'Open-book test on Python basics — bring your notes.',
          type: ReminderType.prepare,
        ),
      ],
      'Saturday': [
        ClassReminderModel(
          id: 'r_sat_01',
          subject: 'English',
          teacherName: 'Mrs. Anita Gupta',
          message: 'Bring your creative writing portfolio for peer review.',
          type: ReminderType.bring,
        ),
      ],
    };
    return data[dayName] ?? const [];
  }

  // ──────────────────────── CLASS STATS ────────────────────────
  static ClassStats classStatsFor(String classGrade, String section) {
    switch ('$classGrade-$section') {
      case '11-A':
        return const ClassStats(
          classGrade: '11',
          section: 'A',
          totalStudents: 38,
          studentRank: 1,
          classOverallAverage: 73.2,
          subjects: [
            SubjectClassStat(subject: 'Computer Science', classAverage: 78.4, topperMarks: 91),
            SubjectClassStat(subject: 'English',          classAverage: 78.2, topperMarks: 95),
            SubjectClassStat(subject: 'Mathematics',      classAverage: 74.1, topperMarks: 99),
            SubjectClassStat(subject: 'Physics',          classAverage: 69.4, topperMarks: 94),
            SubjectClassStat(subject: 'Chemistry',        classAverage: 65.8, topperMarks: 91),
          ],
        );
      case '10-A':
        return const ClassStats(
          classGrade: '10',
          section: 'A',
          totalStudents: 42,
          studentRank: 8,
          classOverallAverage: 78.8,
          subjects: [
            SubjectClassStat(subject: 'Computer Science', classAverage: 82.4, topperMarks: 95),
            SubjectClassStat(subject: 'English',          classAverage: 81.4, topperMarks: 94),
            SubjectClassStat(subject: 'Hindi',            classAverage: 81.0, topperMarks: 86),
            SubjectClassStat(subject: 'Mathematics',      classAverage: 76.8, topperMarks: 92),
            SubjectClassStat(subject: 'Social Science',   classAverage: 75.4, topperMarks: 88),
            SubjectClassStat(subject: 'Science',          classAverage: 75.8, topperMarks: 91),
          ],
        );
      case '7-C':
        return const ClassStats(
          classGrade: '7',
          section: 'C',
          totalStudents: 38,
          studentRank: 5,
          classOverallAverage: 76.0,
          subjects: [
            SubjectClassStat(subject: 'Hindi',            classAverage: 81.3, topperMarks: 88),
            SubjectClassStat(subject: 'English',          classAverage: 76.3, topperMarks: 90),
            SubjectClassStat(subject: 'Computer Science', classAverage: 76.5, topperMarks: 88),
            SubjectClassStat(subject: 'Social Science',   classAverage: 77.0, topperMarks: 88),
            SubjectClassStat(subject: 'Mathematics',      classAverage: 73.0, topperMarks: 87),
            SubjectClassStat(subject: 'Science',          classAverage: 71.8, topperMarks: 82),
          ],
        );
      default:
        return ClassStats(
          classGrade: classGrade,
          section: section,
          totalStudents: 42,
          studentRank: 8,
          classOverallAverage: 73.8,
          subjects: const [
            SubjectClassStat(subject: 'English',          classAverage: 75.6, topperMarks: 94),
            SubjectClassStat(subject: 'Hindi',            classAverage: 72.8, topperMarks: 91),
            SubjectClassStat(subject: 'Science',          classAverage: 71.2, topperMarks: 96),
            SubjectClassStat(subject: 'Social Science',   classAverage: 70.1, topperMarks: 95),
            SubjectClassStat(subject: 'Mathematics',      classAverage: 68.4, topperMarks: 98),
            SubjectClassStat(subject: 'Computer Science', classAverage: 65.3, topperMarks: 99),
          ],
        );
    }
  }

  // ──────────────────────── FEE INSTALLMENTS ───────────────────
  static List<FeeInstallment> feeInstallmentsFor(String studentId) {
    final student = students.firstWhere(
      (s) => s.id == studentId,
      orElse: () => students.first,
    );
    final total = student.totalFee;
    final paid = student.paidFee;

    final termAmounts = [
      (total * 0.30).roundToDouble(),
      (total * 0.235).roundToDouble(),
      (total * 0.235).roundToDouble(),
      0.0,
    ];
    termAmounts[3] = total - termAmounts[0] - termAmounts[1] - termAmounts[2];

    const terms = ['Term 1 (Admission)', 'Term 2', 'Term 3', 'Term 4'];
    const periods = [
      'April – June 2025',
      'July – September 2025',
      'October – December 2025',
      'January – March 2026',
    ];
    final dueDates = [
      DateTime(2025, 4, 30),
      DateTime(2025, 7, 31),
      DateTime(2025, 10, 31),
      DateTime(2026, 1, 31),
    ];
    final paidDates = [
      DateTime(2025, 3, 28),
      DateTime(2025, 6, 30),
      DateTime(2025, 9, 25),
      DateTime(2025, 12, 28),
    ];

    double remaining = paid;
    return List.generate(4, (i) {
      final amount = termAmounts[i];
      FeeInstallmentStatus status;
      DateTime? actualPaidDate;

      if (remaining >= amount) {
        status = FeeInstallmentStatus.paid;
        remaining -= amount;
        actualPaidDate = paidDates[i];
      } else if (dueDates[i].isBefore(DateTime.now())) {
        status = FeeInstallmentStatus.overdue;
      } else {
        status = FeeInstallmentStatus.pending;
      }

      return FeeInstallment(
        term: terms[i],
        period: periods[i],
        amount: amount,
        status: status,
        dueDate: dueDates[i],
        paidDate: actualPaidDate,
      );
    });
  }

  // ──────────────────────── HOMEWORK ────────────────────────────
  // ───────────────────────── PARENTS ────────────────────────────────────
  static const List<ParentModel> parents = [
    ParentModel(id: 'p001', name: 'Rakesh Sharma'),
  ];

  static ParentModel? parentFor(String parentId) {
    try {
      return parents.firstWhere((p) => p.id == parentId);
    } catch (_) {
      return null;
    }
  }

  // ───────────────────────── PARENT → CHILDREN ──────────────────────────
  static const Map<String, List<String>> _parentChildIds = {
    // Demo parent p001 has three children across different classes
    'p001': ['s001', 's004', 's005'],
  };

  static List<String> childIdsForParent(String parentId) =>
      _parentChildIds[parentId] ?? [];

  static List<StudentModel> childrenForParent(String parentId) {
    final ids = childIdsForParent(parentId);
    return students.where((s) => ids.contains(s.id)).toList();
  }

  // ── Class 11-A CS homework (Mr. Anil Dubey) ───────────────────────────────
  static final List<HomeworkItem> _homework11A = [
    HomeworkItem(
      id: 'hw_11a_cs_01',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'Database Design – ER Diagrams',
      description: 'Draw ER diagrams for a Library Management System. Include entities, attributes and all relationships.',
      dueDate: DateTime(2026, 4, 24),
      isSubmitted: false,
      priority: HomeworkPriority.high,
    ),
    HomeworkItem(
      id: 'hw_11a_cs_02',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'SQL Queries – Practice Set 3',
      description: 'Complete all 15 SQL queries covering CREATE, INSERT and SELECT with JOIN operations.',
      dueDate: DateTime(2026, 5, 3),
      isSubmitted: false,
      priority: HomeworkPriority.medium,
    ),
    HomeworkItem(
      id: 'hw_11a_cs_03',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'Python OOP – Classes & Inheritance',
      description: 'Implement a Student class with attributes and methods. Extend with a GraduateStudent subclass.',
      dueDate: DateTime(2026, 5, 8),
      isSubmitted: false,
      priority: HomeworkPriority.medium,
    ),
  ];

  // ── Class 7-C CS homework (Mr. Anil Dubey) ────────────────────────────────
  static final List<HomeworkItem> _homework7C = [
    HomeworkItem(
      id: 'hw_7c_cs_01',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'Python Basics – Variables & Data Types',
      description: 'Complete exercises 1–10 on variables, integers, strings and type casting from the worksheet.',
      dueDate: DateTime(2026, 4, 20),
      isSubmitted: false,
      priority: HomeworkPriority.medium,
    ),
    HomeworkItem(
      id: 'hw_7c_cs_02',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'Control Structures – If-Else & Loops',
      description: 'Write Python programs for Q1–Q8 covering if-else conditions, for loops and while loops.',
      dueDate: DateTime(2026, 4, 26),
      isSubmitted: false,
      priority: HomeworkPriority.high,
    ),
    HomeworkItem(
      id: 'hw_7c_cs_03',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'Functions in Python – Practice Problems',
      description: 'Define and call functions for the 6 given problems. Include docstrings for each function.',
      dueDate: DateTime(2026, 5, 5),
      isSubmitted: false,
      priority: HomeworkPriority.medium,
    ),
    HomeworkItem(
      id: 'hw_7c_cs_04',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'Mini Project – Simple Calculator',
      description: 'Build a Python calculator that handles +, -, *, / operations using functions and a menu loop.',
      dueDate: DateTime(2026, 5, 12),
      isSubmitted: false,
      priority: HomeworkPriority.high,
    ),
  ];

  static List<HomeworkItem> homeworkFor(
    String classGrade,
    String section, {
    String? studentId,
  }) {
    final key = '$classGrade-$section';
    final base = key == '7-C'
        ? _homework7C
        : key == '11-A'
            ? _homework11A
            : _homework10A;
    if (studentId == null) return base;
    return base.map((hw) {
      final submitted = _hwSubmittedIds[hw.id]?.contains(studentId) ?? false;
      return HomeworkItem(
        id: hw.id,
        subject: hw.subject,
        teacherName: hw.teacherName,
        title: hw.title,
        description: hw.description,
        dueDate: hw.dueDate,
        isSubmitted: submitted,
        priority: hw.priority,
      );
    }).toList();
  }

  static final List<HomeworkItem> _homework10A = [
    HomeworkItem(
      id: 'hw001',
      subject: 'Mathematics',
      teacherName: 'Mrs. Sunita Sharma',
      title: 'Quadratic Equations – Exercise 4.3',
      description: 'Solve all problems from Exercise 4.3 (Q1–Q15). Show full working for each step.',
      dueDate: DateTime(2026, 4, 28),
      isSubmitted: false,
      priority: HomeworkPriority.high,
    ),
    HomeworkItem(
      id: 'hw002',
      subject: 'Science',
      teacherName: 'Mr. Ramesh Kumar',
      title: 'Chapter 12 Notes – Electricity',
      description: 'Prepare detailed notes on Ohm\'s Law, series and parallel circuits. Include diagrams.',
      dueDate: DateTime(2026, 4, 30),
      isSubmitted: false,
      priority: HomeworkPriority.medium,
    ),
    HomeworkItem(
      id: 'hw003',
      subject: 'English',
      teacherName: 'Mrs. Anita Gupta',
      title: 'Essay – Impact of Technology',
      description: 'Write a 500-word essay on the impact of technology on modern education.',
      dueDate: DateTime(2026, 4, 25),
      isSubmitted: false,
      priority: HomeworkPriority.medium,
    ),
    HomeworkItem(
      id: 'hw004',
      subject: 'Hindi',
      teacherName: 'Mr. Suresh Verma',
      title: 'Kabir Ke Dohe – Summary',
      description: 'Write meanings and summary of 10 selected dohas from the textbook.',
      dueDate: DateTime(2026, 4, 22),
      isSubmitted: false,
      priority: HomeworkPriority.low,
    ),
    HomeworkItem(
      id: 'hw005',
      subject: 'Social Science',
      teacherName: 'Ms. Pooja Singh',
      title: 'Map Work – Nationalism in India',
      description: 'Mark and label all important places related to the Indian Freedom Struggle on the outline map.',
      dueDate: DateTime(2026, 5, 2),
      isSubmitted: false,
      priority: HomeworkPriority.medium,
    ),
    HomeworkItem(
      id: 'hw006',
      subject: 'Computer Science',
      teacherName: 'Mr. Anil Dubey',
      title: 'Python Program – File Handling',
      description: 'Write a Python program to read a file and count the frequency of each word.',
      dueDate: DateTime(2026, 4, 27),
      isSubmitted: false,
      priority: HomeworkPriority.high,
    ),
    HomeworkItem(
      id: 'hw007',
      subject: 'Science',
      teacherName: 'Mr. Ramesh Kumar',
      title: 'Lab Report – Acid-Base Reaction',
      description: 'Write the complete lab report for the acid-base experiment conducted in class.',
      dueDate: DateTime(2026, 4, 20),
      isSubmitted: false,
      priority: HomeworkPriority.high,
    ),
    HomeworkItem(
      id: 'hw008',
      subject: 'Mathematics',
      teacherName: 'Mrs. Sunita Sharma',
      title: 'Probability – Practice Sheet',
      description: 'Complete all 20 questions from the probability practice sheet distributed in class.',
      dueDate: DateTime(2026, 5, 5),
      isSubmitted: false,
      priority: HomeworkPriority.low,
    ),
  ];

  // ──────────────────────── BADGE TYPES ────────────────────────────
  static List<BadgeTypeModel> get badgeTypes => [
        const BadgeTypeModel(
          id: 'attendance_100',
          defaultLabel: '100% Attendance',
          defaultDescription:
              'Awarded for achieving perfect attendance — not a single day '
              'missed! Your commitment and dedication are truly extraordinary.',
          defaultBannerText: '100%',
          materialType: 'gold',
          iconName: 'calendarCheck',
          isPremium: true,
        ),
        const BadgeTypeModel(
          id: 'homework_hero',
          defaultLabel: 'Homework Hero',
          defaultDescription:
              'Awarded for consistently submitting all homework on time and '
              'to the highest standard. A true champion of hard work!',
          defaultBannerText: 'HERO',
          materialType: 'blueEnamel',
          iconName: 'bookOpen',
        ),
        const BadgeTypeModel(
          id: 'creative_spark',
          defaultLabel: 'Creative Spark',
          defaultDescription:
              'Recognized for bringing exceptional creativity and original '
              'thinking to the classroom. Your ideas inspire everyone around you!',
          defaultBannerText: 'SPARK',
          materialType: 'copper',
          iconName: 'wandMagicSparkles',
        ),
        const BadgeTypeModel(
          id: 'leadership',
          defaultLabel: 'Leadership',
          defaultDescription:
              'Awarded for demonstrating outstanding leadership qualities — '
              'guiding peers, taking initiative, and leading by example.',
          defaultBannerText: 'LEAD',
          materialType: 'darkWood',
          iconName: 'chessKing',
          isPremium: true,
        ),
        const BadgeTypeModel(
          id: 'extra_curricular',
          defaultLabel: 'Extra Curricular',
          defaultDescription:
              'Recognized for excellent participation and achievement in '
              'activities beyond the classroom. A well-rounded star student!',
          defaultBannerText: 'EXTRA',
          materialType: 'marble',
          iconName: 'medal',
        ),
        const BadgeTypeModel(
          id: 'academic',
          defaultLabel: 'Academic Excellence',
          defaultDescription:
              'Awarded for outstanding academic performance across subjects. '
              'Your dedication to learning sets a brilliant example for all!',
          defaultBannerText: 'ACAD',
          materialType: 'bronze',
          iconName: 'graduationCap',
        ),
      ];

  // ──────────────────────── BADGES ──────────────────────────────
  static List<BadgeModel> badgesForStudent(String studentId) {
    return allBadges.where((b) => b.studentId == studentId).toList()
      ..sort((a, b) => b.awardedAt.compareTo(a.awardedAt));
  }

  static final List<BadgeModel> allBadges = [
    // ── Arjun Sharma (s001) ──────────────────────────────────────
    BadgeModel(
      id: 'b001',
      studentId: 's001',
      badgeTypeId: 'attendance_100',
      label: '100% Attendance',
      description:
          'Arjun has maintained perfect attendance this term — not a single '
          'day missed. His dedication to showing up is truly commendable!',
      bannerText: '100%',
      materialType: 'gold',
      iconName: 'calendarCheck',
      year: 2026,
      awardedBy: 'Mrs. Kavita Sharma',
      awardedAt: DateTime(2026, 4, 15),
      isPremium: true,
    ),
    BadgeModel(
      id: 'b002',
      studentId: 's001',
      badgeTypeId: 'homework_hero',
      label: 'Homework Hero',
      description:
          'Arjun has submitted every homework assignment on time this term, '
          'always with thorough and well-presented work. Keep it up!',
      bannerText: 'HERO',
      materialType: 'blueEnamel',
      iconName: 'bookOpen',
      year: 2026,
      awardedBy: 'Mr. Rajesh Verma',
      awardedAt: DateTime(2026, 4, 10),
    ),
    BadgeModel(
      id: 'b003',
      studentId: 's001',
      badgeTypeId: 'academic',
      label: 'Academic Excellence',
      description:
          'Arjun has delivered outstanding results across all subjects this '
          'session. His consistent effort and focus are truly impressive!',
      bannerText: 'ACAD',
      materialType: 'bronze',
      iconName: 'graduationCap',
      year: 2026,
      awardedBy: 'Mrs. Kavita Sharma',
      awardedAt: DateTime(2026, 4, 5),
    ),
    BadgeModel(
      id: 'b004',
      studentId: 's001',
      badgeTypeId: 'extra_curricular',
      label: 'Extra Curricular',
      description:
          'Arjun actively participates in the school science club and '
          'inter-house quiz competitions. A truly all-round student!',
      bannerText: 'EXTRA',
      materialType: 'marble',
      iconName: 'medal',
      year: 2026,
      awardedBy: 'Mr. Sunil Pandey',
      awardedAt: DateTime(2026, 3, 28),
    ),

    // ── Priya Singh (s002) ───────────────────────────────────────
    BadgeModel(
      id: 'b005',
      studentId: 's002',
      badgeTypeId: 'attendance_100',
      label: '100% Attendance',
      description:
          'Priya has achieved perfect attendance with zero absences this '
          'term. Her discipline and commitment are an inspiration to all!',
      bannerText: '100%',
      materialType: 'gold',
      iconName: 'calendarCheck',
      year: 2026,
      awardedBy: 'Mrs. Anita Gupta',
      awardedAt: DateTime(2026, 4, 15),
      isPremium: true,
    ),
    BadgeModel(
      id: 'b006',
      studentId: 's002',
      badgeTypeId: 'leadership',
      label: 'Leadership',
      description:
          'Priya served as class monitor this term and led her group with '
          'grace, maturity, and genuine care for her fellow students.',
      bannerText: 'LEAD',
      materialType: 'darkWood',
      iconName: 'chessKing',
      year: 2026,
      awardedBy: 'Mrs. Anita Gupta',
      awardedAt: DateTime(2026, 4, 12),
      isPremium: true,
    ),
    BadgeModel(
      id: 'b007',
      studentId: 's002',
      badgeTypeId: 'academic',
      label: 'Academic Excellence',
      description:
          'Priya has scored above 90% in every subject this session — '
          'a phenomenal achievement that reflects her brilliance and hard work!',
      bannerText: 'ACAD',
      materialType: 'bronze',
      iconName: 'graduationCap',
      year: 2026,
      awardedBy: 'Mr. Rajesh Verma',
      awardedAt: DateTime(2026, 4, 8),
    ),
    BadgeModel(
      id: 'b008',
      studentId: 's002',
      badgeTypeId: 'creative_spark',
      label: 'Creative Spark',
      description:
          'Priya\'s science project on sustainable energy showed remarkable '
          'creativity and original thinking that wowed all the judges!',
      bannerText: 'SPARK',
      materialType: 'copper',
      iconName: 'wandMagicSparkles',
      year: 2026,
      awardedBy: 'Mrs. Rekha Mishra',
      awardedAt: DateTime(2026, 3, 30),
    ),
    BadgeModel(
      id: 'b009',
      studentId: 's002',
      badgeTypeId: 'homework_hero',
      label: 'Homework Hero',
      description:
          'Every assignment delivered on time, every single time — Priya\'s '
          'work ethic and consistency are a model for the whole class.',
      bannerText: 'HERO',
      materialType: 'blueEnamel',
      iconName: 'bookOpen',
      year: 2026,
      awardedBy: 'Mrs. Anita Gupta',
      awardedAt: DateTime(2026, 3, 22),
    ),

    // ── Rahul Gupta (s003) ───────────────────────────────────────
    BadgeModel(
      id: 'b010',
      studentId: 's003',
      badgeTypeId: 'extra_curricular',
      label: 'Extra Curricular',
      description:
          'Rahul represented the school in the inter-school coding '
          'competition and brought home a silver medal. Proud of you!',
      bannerText: 'EXTRA',
      materialType: 'marble',
      iconName: 'medal',
      year: 2026,
      awardedBy: 'Mrs. Priya Joshi',
      awardedAt: DateTime(2026, 4, 12),
    ),
    BadgeModel(
      id: 'b011',
      studentId: 's003',
      badgeTypeId: 'creative_spark',
      label: 'Creative Spark',
      description:
          'Rahul designed an original app prototype for the school tech '
          'fair that impressed both teachers and students alike!',
      bannerText: 'SPARK',
      materialType: 'copper',
      iconName: 'wandMagicSparkles',
      year: 2026,
      awardedBy: 'Mr. Sunil Pandey',
      awardedAt: DateTime(2026, 3, 22),
    ),

    // ── Ananya Verma (s004) ──────────────────────────────────────
    BadgeModel(
      id: 'b012',
      studentId: 's004',
      badgeTypeId: 'attendance_100',
      label: '100% Attendance',
      description:
          'Ananya has not missed a single school day this term. Her '
          'enthusiasm and presence brighten every classroom she walks into!',
      bannerText: '100%',
      materialType: 'gold',
      iconName: 'calendarCheck',
      year: 2026,
      awardedBy: 'Mrs. Sunita Rao',
      awardedAt: DateTime(2026, 4, 15),
      isPremium: true,
    ),
    BadgeModel(
      id: 'b013',
      studentId: 's004',
      badgeTypeId: 'homework_hero',
      label: 'Homework Hero',
      description:
          'Ananya consistently submits neat, detailed homework before '
          'deadlines. Her love for learning shines through in every page!',
      bannerText: 'HERO',
      materialType: 'blueEnamel',
      iconName: 'bookOpen',
      year: 2026,
      awardedBy: 'Mrs. Sunita Rao',
      awardedAt: DateTime(2026, 4, 10),
    ),
    BadgeModel(
      id: 'b014',
      studentId: 's004',
      badgeTypeId: 'academic',
      label: 'Academic Excellence',
      description:
          'Ananya has topped her class in Mathematics and English this '
          'session — a remarkable achievement for such a young learner!',
      bannerText: 'ACAD',
      materialType: 'bronze',
      iconName: 'graduationCap',
      year: 2026,
      awardedBy: 'Mrs. Sunita Rao',
      awardedAt: DateTime(2026, 4, 5),
    ),
    BadgeModel(
      id: 'b015',
      studentId: 's004',
      badgeTypeId: 'creative_spark',
      label: 'Creative Spark',
      description:
          'Ananya\'s painting was selected for the school\'s annual art '
          'exhibition. Her creativity and imagination are a true gift!',
      bannerText: 'SPARK',
      materialType: 'copper',
      iconName: 'wandMagicSparkles',
      year: 2026,
      awardedBy: 'Mrs. Sunita Rao',
      awardedAt: DateTime(2026, 3, 28),
    ),
  ];

  // ── CLASS ROSTERS (for teacher pending-HW view) ───────────────────────────
  // Lightweight student records per class — separate from the main students
  // list which represents the currently logged-in student for each role.
  static const Map<String, List<RosterStudent>> _classRosters = {
    '10-A': [
      RosterStudent(id: 's001',    name: 'Arjun Sharma',  photoInitials: 'AS', avatarColorIndex: 0),
      RosterStudent(id: 'r_10a_2', name: 'Divya Kapoor',  photoInitials: 'DK', avatarColorIndex: 1),
      RosterStudent(id: 'r_10a_3', name: 'Sanjay Mehta',  photoInitials: 'SM', avatarColorIndex: 2),
      RosterStudent(id: 'r_10a_4', name: 'Pooja Verma',   photoInitials: 'PV', avatarColorIndex: 3),
      RosterStudent(id: 'r_10a_5', name: 'Kiran Singh',   photoInitials: 'KS', avatarColorIndex: 4),
    ],
    '7-C': [
      RosterStudent(id: 's005',   name: 'Vikram Tiwari', photoInitials: 'VT', avatarColorIndex: 4),
      RosterStudent(id: 'r_7c_2', name: 'Rashmi Dubey',  photoInitials: 'RD', avatarColorIndex: 5),
      RosterStudent(id: 'r_7c_3', name: 'Aryan Shukla',  photoInitials: 'AS', avatarColorIndex: 6),
      RosterStudent(id: 'r_7c_4', name: 'Meera Jain',    photoInitials: 'MJ', avatarColorIndex: 0),
    ],
    '11-A': [
      RosterStudent(id: 'r_11a_1', name: 'Deepak Rao',     photoInitials: 'DR', avatarColorIndex: 2),
      RosterStudent(id: 'r_11a_2', name: 'Prachi Saxena',  photoInitials: 'PS', avatarColorIndex: 1),
      RosterStudent(id: 'r_11a_3', name: 'Nikhil Gupta',   photoInitials: 'NG', avatarColorIndex: 3),
      RosterStudent(id: 'r_11a_4', name: 'Shruti Tiwari',  photoInitials: 'ST', avatarColorIndex: 5),
      RosterStudent(id: 'r_11a_5', name: 'Varun Mishra',   photoInitials: 'VM', avatarColorIndex: 0),
    ],
  };

  // Which student IDs have submitted each homework item (10-A scope).
  // hw003, hw004, hw007 are already marked isSubmitted=true in homeworkFor().
  // Teacher-marked submission status per student per homework.
  // Mutable so the teacher can toggle submissions in-app.
  static final Map<String, Set<String>> _hwSubmittedIds = {
    // 10-A
    'hw001': {'r_10a_3'},
    'hw002': {'s001', 'r_10a_2'},
    'hw003': {'s001', 'r_10a_2', 'r_10a_3', 'r_10a_4', 'r_10a_5'},
    'hw004': {'s001', 'r_10a_2', 'r_10a_3', 'r_10a_4', 'r_10a_5'},
    'hw005': {},
    'hw006': {'r_10a_4', 'r_10a_5'},
    'hw007': {'s001', 'r_10a_2', 'r_10a_3', 'r_10a_4', 'r_10a_5'},
    'hw008': {'s001', 'r_10a_2', 'r_10a_3'},
    // 11-A CS (Mr. Anil Dubey)
    'hw_11a_cs_01': {'r_11a_1', 'r_11a_3'},
    // 7-C CS (Mr. Anil Dubey)
    'hw_7c_cs_01': {'r_7c_2', 'r_7c_4'},
    'hw_7c_cs_02': {'r_7c_2'},
  };

  static bool isSubmittedBy(String hwId, String studentId) =>
      _hwSubmittedIds[hwId]?.contains(studentId) ?? false;

  static int submittedCountFor(String hwId, String classGrade, String section) {
    final roster = classRosterFor(classGrade, section);
    final submitted = _hwSubmittedIds[hwId] ?? {};
    return roster.where((s) => submitted.contains(s.id)).length;
  }

  static void toggleStudentSubmission(String hwId, String studentId) {
    _hwSubmittedIds.putIfAbsent(hwId, () => {});
    final set = _hwSubmittedIds[hwId]!;
    if (set.contains(studentId)) {
      set.remove(studentId);
    } else {
      set.add(studentId);
    }
  }

  /// Replaces the entire submission set for [hwId] with [submittedIds].
  static void setSubmissions(String hwId, Set<String> submittedIds) {
    _hwSubmittedIds[hwId] = Set.of(submittedIds);
  }

  /// All homework assigned by [teacherName], grouped by class key (e.g. "11-A").
  static Map<String, List<HomeworkItem>> homeworkByClassForTeacher(
      String teacherName) {
    final allClasses = {
      '11-A': _homework11A,
      '10-A': _homework10A,
      '7-C': _homework7C,
    };
    final result = <String, List<HomeworkItem>>{};
    for (final entry in allClasses.entries) {
      final filtered =
          entry.value.where((hw) => hw.teacherName == teacherName).toList();
      if (filtered.isNotEmpty) result[entry.key] = filtered;
    }
    return result;
  }

  static List<RosterStudent> classRosterFor(String classGrade, String section) =>
      _classRosters['$classGrade-$section'] ?? [];

  static const Map<String, List<StudentAttendanceSummary>> _classAttendance = {
    '11-A': [
      StudentAttendanceSummary(name: 'Deepak Rao',    photoInitials: 'DR', avatarColorIndex: 2, presentDays: 108, absentDays: 10, lateDays: 2,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Prachi Saxena', photoInitials: 'PS', avatarColorIndex: 1, presentDays: 112, absentDays:  6, lateDays: 2,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Nikhil Gupta',  photoInitials: 'NG', avatarColorIndex: 3, presentDays: 100, absentDays: 15, lateDays: 5,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Shruti Tiwari', photoInitials: 'ST', avatarColorIndex: 5, presentDays: 108, absentDays: 12, lateDays: 0,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Varun Mishra',  photoInitials: 'VM', avatarColorIndex: 0, presentDays:  72, absentDays: 45, lateDays: 3,  totalWorkingDays: 120),
    ],
    '10-A': [
      StudentAttendanceSummary(name: 'Arjun Sharma',  photoInitials: 'AS', avatarColorIndex: 0, presentDays: 108, absentDays: 10, lateDays: 2,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Divya Kapoor',  photoInitials: 'DK', avatarColorIndex: 1, presentDays: 110, absentDays:  8, lateDays: 2,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Sanjay Mehta',  photoInitials: 'SM', avatarColorIndex: 2, presentDays: 100, absentDays: 18, lateDays: 2,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Pooja Verma',   photoInitials: 'PV', avatarColorIndex: 3, presentDays:  85, absentDays: 30, lateDays: 5,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Kiran Singh',   photoInitials: 'KS', avatarColorIndex: 4, presentDays:  90, absentDays: 28, lateDays: 2,  totalWorkingDays: 120),
    ],
    '7-C': [
      StudentAttendanceSummary(name: 'Vikram Tiwari', photoInitials: 'VT', avatarColorIndex: 4, presentDays: 100, absentDays: 15, lateDays: 5,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Rashmi Dubey',  photoInitials: 'RD', avatarColorIndex: 5, presentDays: 110, absentDays:  8, lateDays: 2,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Aryan Shukla',  photoInitials: 'AS', avatarColorIndex: 6, presentDays:  78, absentDays: 40, lateDays: 2,  totalWorkingDays: 120),
      StudentAttendanceSummary(name: 'Meera Jain',    photoInitials: 'MJ', avatarColorIndex: 0, presentDays: 106, absentDays: 12, lateDays: 2,  totalWorkingDays: 120),
    ],
  };

  static List<StudentAttendanceSummary> classStudentAttendance(
          String classGrade, String section) =>
      List.of(_classAttendance['$classGrade-$section'] ?? [])
        ..sort((a, b) => a.percentage.compareTo(b.percentage));

  static double classAvgAttendancePct(String classGrade, String section) {
    final list = _classAttendance['$classGrade-$section'];
    if (list == null || list.isEmpty) return classAttendancePct(classGrade, section);
    return list.map((s) => s.percentage).reduce((a, b) => a + b) / list.length;
  }

  // ── Per-student subject marks ─────────────────────────────────────────────
  static const Map<String, Map<String, List<StudentSubjectMark>>> _subjectMarks = {
    '10-A': {
      'Computer Science': [
        StudentSubjectMark(name: 'Arjun Sharma',  photoInitials: 'AS', avatarColorIndex: 0, marks: 95, maxMarks: 100),
        StudentSubjectMark(name: 'Divya Kapoor',  photoInitials: 'DK', avatarColorIndex: 1, marks: 90, maxMarks: 100),
        StudentSubjectMark(name: 'Sanjay Mehta',  photoInitials: 'SM', avatarColorIndex: 2, marks: 83, maxMarks: 100),
        StudentSubjectMark(name: 'Kiran Singh',   photoInitials: 'KS', avatarColorIndex: 4, marks: 76, maxMarks: 100),
        StudentSubjectMark(name: 'Pooja Verma',   photoInitials: 'PV', avatarColorIndex: 3, marks: 68, maxMarks: 100),
      ],
    },
    '7-C': {
      'Computer Science': [
        StudentSubjectMark(name: 'Rashmi Dubey',  photoInitials: 'RD', avatarColorIndex: 5, marks: 88, maxMarks: 100),
        StudentSubjectMark(name: 'Meera Jain',    photoInitials: 'MJ', avatarColorIndex: 0, marks: 82, maxMarks: 100),
        StudentSubjectMark(name: 'Vikram Tiwari', photoInitials: 'VT', avatarColorIndex: 4, marks: 76, maxMarks: 100),
        StudentSubjectMark(name: 'Aryan Shukla',  photoInitials: 'AS', avatarColorIndex: 6, marks: 60, maxMarks: 100),
      ],
    },
    '11-A': {
      'Computer Science': [
        StudentSubjectMark(name: 'Deepak Rao',    photoInitials: 'DR', avatarColorIndex: 2, marks: 91, maxMarks: 100),
        StudentSubjectMark(name: 'Shruti Tiwari', photoInitials: 'ST', avatarColorIndex: 5, marks: 85, maxMarks: 100),
        StudentSubjectMark(name: 'Prachi Saxena', photoInitials: 'PS', avatarColorIndex: 1, marks: 79, maxMarks: 100),
        StudentSubjectMark(name: 'Nikhil Gupta',  photoInitials: 'NG', avatarColorIndex: 3, marks: 74, maxMarks: 100),
        StudentSubjectMark(name: 'Varun Mishra',  photoInitials: 'VM', avatarColorIndex: 0, marks: 63, maxMarks: 100),
      ],
    },
  };

  /// Returns students sorted worst → best for the given class + subject.
  /// Returns an empty list if no data exists for that combination.
  static List<StudentSubjectMark> subjectMarksFor(
      String classGrade, String section, String subject) {
    final marks = _subjectMarks['$classGrade-$section']?[subject];
    if (marks == null || marks.isEmpty) return [];
    return List.of(marks)..sort((a, b) => a.marks.compareTo(b.marks));
  }

  /// Returns one [PendingHomeworkEntry] per pending (non-overdue) assignment,
  /// each carrying the list of students who have NOT yet submitted.
  /// Pass [subjectFilter] to restrict to a single subject (for subject teachers).
  static List<PendingHomeworkEntry> pendingSubmissionsFor(
    String classGrade,
    String section, {
    String? subjectFilter,
  }) {
    final roster = classRosterFor(classGrade, section);
    if (roster.isEmpty) return [];

    final pending = homeworkFor(classGrade, section)
        .where((h) => h.dueDate.isBefore(DateTime.now()))
        .where((h) => subjectFilter == null || h.subject == subjectFilter)
        .toList();

    return pending
        .map((hw) {
          final submitted = _hwSubmittedIds[hw.id] ?? const <String>{};
          final notSubmitted =
              roster.where((s) => !submitted.contains(s.id)).toList();
          return PendingHomeworkEntry(
            homework: hw,
            notSubmitted: notSubmitted,
            totalStudents: roster.length,
          );
        })
        .where((e) => e.missingCount > 0)
        .toList();
  }
}

