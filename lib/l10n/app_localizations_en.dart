// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SGM International School';

  @override
  String get schoolName => 'SGM International School';

  @override
  String get schoolLocation => 'Indira Nagar, Kanpur';

  @override
  String get schoolAffiliation => 'CBSE Affiliated';

  @override
  String get schoolMotto => 'उत्तिष्ठत जाग्रत प्राप्य वरान्निबोधत';

  @override
  String get loginWelcome => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get loginAdmissionNumber => 'Admission Number';

  @override
  String get loginEmployeeId => 'Employee ID';

  @override
  String get loginParentId => 'Parent ID / Mobile';

  @override
  String get loginAdmissionHint => 'e.g. SGM/2024/001';

  @override
  String get loginEmployeeHint => 'e.g. SGM/T/001';

  @override
  String get loginParentHint => 'e.g. 98765XXXXX';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginDemoHint => 'Demo: Use any ID & password';

  @override
  String get roleStudent => 'Student';

  @override
  String get roleTeacher => 'Teacher';

  @override
  String get roleParent => 'Parent';

  @override
  String get navHome => 'Home';

  @override
  String get navStudents => 'Students';

  @override
  String get navBus => 'Bus';

  @override
  String get navTimetable => 'Timetable';

  @override
  String get homeOverview => 'Overview';

  @override
  String get homeUpcomingEvents => 'Upcoming Events';

  @override
  String get homeNoUpcomingEvents => 'No upcoming events soon';

  @override
  String get homeParentMonitoring => 'Child Monitoring';

  @override
  String get homeParentAlerts => 'Alerts';

  @override
  String get homeParentNoAlerts => 'All clear — no alerts.';

  @override
  String get homeParentGrade => 'Grade';

  @override
  String get homeParentFeeStatus => 'Fee Status';

  @override
  String get homeParentLowAttendance => 'Attendance below 75%';

  @override
  String get homeParentOverdueFees => 'Fee payment pending';

  @override
  String homeParentOverdueHomework(int count) {
    return '$count assignment(s) overdue';
  }

  @override
  String homeParentChildTeachers(String name) {
    return '$name\'s Teachers';
  }

  @override
  String get homeStatTotalStudents => 'Total Students';

  @override
  String get homeStatTeachers => 'Teachers';

  @override
  String get homeStatAttendanceToday => 'Attendance Today';

  @override
  String get homeStatBusesOnRoute => 'Buses On Route';

  @override
  String get homeStatMyAttendance => 'My Attendance';

  @override
  String get homeStatTodayPeriods => 'Today\'s Periods';

  @override
  String get homeStatUpcomingExams => 'Upcoming Exams';

  @override
  String get homeMyTeachers => 'My Teachers';

  @override
  String get homeClassTeacher => 'Class Teacher';

  @override
  String get homeQuickAccess => 'Quick Access';

  @override
  String get quickResults => 'Results';

  @override
  String get quickTimetable => 'Timetable';

  @override
  String get quickAttendance => 'Attendance';

  @override
  String get quickFees => 'Fees';

  @override
  String get quickHomework => 'Homework';

  @override
  String get quickAchievements => 'Achievements';

  @override
  String get homeAnnouncements => 'Announcements';

  @override
  String get homeViewAll => 'View All';

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingAfternoon => 'Good Afternoon';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get announcementPinned => 'PINNED';

  @override
  String get announcementNew => 'NEW';

  @override
  String get announcementTypeExam => 'Exam';

  @override
  String get announcementTypeHoliday => 'Holiday';

  @override
  String get announcementTypeEvent => 'Event';

  @override
  String get announcementTypeFee => 'Fee';

  @override
  String get announcementTypeSports => 'Sports';

  @override
  String get announcementTypeGeneral => 'General';

  @override
  String get announcementsTitle => 'Announcements';

  @override
  String get announcementsAllCaughtUp => 'All caught up!';

  @override
  String get announcementsNone => 'No announcements';

  @override
  String announcementsUnreadCount(int count) {
    return '$count unread';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterUnread => 'Unread';

  @override
  String get studentsTitle => 'Students';

  @override
  String get studentsSearchHint => 'Search by name, class or admission no.';

  @override
  String get studentsNoneFound => 'No students found';

  @override
  String get busTitle => 'Bus Tracking';

  @override
  String get busFetchingLocation => 'Fetching live bus location...';

  @override
  String get busLive => 'LIVE';

  @override
  String get busStatusOnRoute => 'On Route';

  @override
  String get busStatusAtStop => 'At Stop';

  @override
  String get busStatusCompleted => 'Completed';

  @override
  String get busDriver => 'Driver';

  @override
  String get busContact => 'Contact';

  @override
  String get busEta => 'ETA';

  @override
  String get busNextStop => 'Next Stop';

  @override
  String get timetableTitle => 'Timetable';

  @override
  String get attendanceTitle => 'Attendance';

  @override
  String get attendanceOverall => 'Overall';

  @override
  String get attendanceGoodStanding => 'Good Standing';

  @override
  String get attendanceLow => 'Attendance Low';

  @override
  String get attendanceGoodMessage => 'Keep it up! Maintain above 75%.';

  @override
  String get attendanceLowMessage => 'Below 75% — attendance at risk.';

  @override
  String get attendancePresent => 'Present';

  @override
  String get attendanceAbsent => 'Absent';

  @override
  String get attendanceLate => 'Late';

  @override
  String get attendanceWorkingDays => 'Working Days';

  @override
  String get attendanceAbsentDates => 'Absent Dates';

  @override
  String resultsScreenTitle(String firstName) {
    return '$firstName\'s Results';
  }

  @override
  String get resultsTitle => 'Academic Performance';

  @override
  String get resultsSession => 'Session 2024–25';

  @override
  String get resultsGrade => 'Grade';

  @override
  String get resultsScore => 'Score';

  @override
  String get resultsClassRank => 'Class Rank';

  @override
  String resultsClassAvgValue(String value) {
    return 'Class avg: $value';
  }

  @override
  String get resultsYou => 'You';

  @override
  String get resultsClassAvg => 'Class Avg';

  @override
  String get resultsSubjectPerformance => 'Subject-wise Performance';

  @override
  String get resultsDetailedMarks => 'Detailed Marks';

  @override
  String get resultsSubjectHeader => 'Subject';

  @override
  String get resultsMarksHeader => 'Marks';

  @override
  String get resultsGradeHeader => 'Grade';

  @override
  String get homeworkTitle => 'Homework';

  @override
  String get homeworkStatTotal => 'Total';

  @override
  String get homeworkStatPending => 'Pending';

  @override
  String get homeworkStatSubmitted => 'Submitted';

  @override
  String get homeworkStatOverdue => 'Overdue';

  @override
  String get homeworkEmpty => 'No homework';

  @override
  String get homeworkEmptyPending => 'No pending homework';

  @override
  String get homeworkEmptySubmitted => 'No submitted homework';

  @override
  String get homeworkSubmitted => 'Submitted';

  @override
  String get homeworkPriorityHigh => 'High Priority';

  @override
  String get homeworkPriorityMedium => 'Medium';

  @override
  String get homeworkPriorityLow => 'Low';

  @override
  String homeworkOverdue(String date) {
    return 'Overdue · $date';
  }

  @override
  String homeworkDue(String date) {
    return 'Due $date';
  }

  @override
  String get feesTitle => 'Fee Details';

  @override
  String feesAdmissionNo(String admissionNo) {
    return 'Admission No: $admissionNo';
  }

  @override
  String get feesSession => 'Session 2025–26';

  @override
  String get feesInstallmentDetails => 'Installment Details';

  @override
  String get feesStatusPaid => 'Paid';

  @override
  String get feesStatusPending => 'Pending';

  @override
  String get feesStatusOverdue => 'Overdue';

  @override
  String get feesStatusPartial => 'Partial';

  @override
  String get feesTotalFee => 'Total Fee';

  @override
  String get feesPaid => 'Paid';

  @override
  String get feesBalance => 'Balance';

  @override
  String feesDue(String date) {
    return 'Due: $date';
  }

  @override
  String feesPaidDate(String date) {
    return 'Paid: $date';
  }

  @override
  String get achievementsTitle => 'My Achievements';

  @override
  String get teacherMyClass => 'My Class';

  @override
  String get teacherMyClasses => 'My Classes';

  @override
  String get teacherClassIncharge => 'Class Incharge';

  @override
  String get teacherSubjectTeacher => 'Subject Teacher';

  @override
  String get teacherClassHealth => 'Class Health';

  @override
  String get teacherClassAttendance => 'Avg Attendance';

  @override
  String get teacherAvgGrade => 'Avg. Grade';

  @override
  String get teacherSubjectAvg => 'Subject Avg.';

  @override
  String get teacherPendingHW => 'Pending HW';

  @override
  String get teacherSchoolOverview => 'School Overview';

  @override
  String get teacherTakeAttendance => 'Take Attendance';

  @override
  String get teacherMyHomework => 'My HW';

  @override
  String get teacherPostHomework => 'Post HW';

  @override
  String get teacherPostReminder => 'Post Reminder';

  @override
  String get teacherSubmitAttendance => 'Submit Attendance';

  @override
  String get teacherAttendanceSaved => 'Attendance marked successfully!';

  @override
  String get teacherHomeworkPosted => 'Homework posted for the class!';

  @override
  String get teacherReminderPosted => 'Reminder sent to the class!';

  @override
  String get teacherPostHomeworkTitle => 'Post Homework';

  @override
  String get teacherPostReminderTitle => 'Post Reminder';

  @override
  String get teacherSelectSubject => 'Select Subject';

  @override
  String get teacherSelectClass => 'Select Class';

  @override
  String get teacherHomeworkTitleLabel => 'Title';

  @override
  String get teacherHomeworkTitleHint =>
      'e.g. Exercise 4.3 – Quadratic Equations';

  @override
  String get teacherHomeworkDescLabel => 'Description';

  @override
  String get teacherHomeworkDescHint => 'What students should do (optional)';

  @override
  String get teacherDueDateLabel => 'Due Date';

  @override
  String get teacherSelectDueDate => 'Select due date';

  @override
  String get teacherPriorityLabel => 'Priority';

  @override
  String get teacherReminderMessageLabel => 'Message';

  @override
  String get teacherReminderMessageHint => 'Write the reminder here…';

  @override
  String get teacherReminderTypeLabel => 'Reminder Type';
}
