import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'SGM International School'**
  String get appName;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'SGM International School'**
  String get schoolName;

  /// No description provided for @schoolLocation.
  ///
  /// In en, this message translates to:
  /// **'Indira Nagar, Kanpur'**
  String get schoolLocation;

  /// No description provided for @schoolAffiliation.
  ///
  /// In en, this message translates to:
  /// **'CBSE Affiliated'**
  String get schoolAffiliation;

  /// No description provided for @schoolMotto.
  ///
  /// In en, this message translates to:
  /// **'उत्तिष्ठत जाग्रत प्राप्य वरान्निबोधत'**
  String get schoolMotto;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @loginAdmissionNumber.
  ///
  /// In en, this message translates to:
  /// **'Admission Number'**
  String get loginAdmissionNumber;

  /// No description provided for @loginEmployeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get loginEmployeeId;

  /// No description provided for @loginParentId.
  ///
  /// In en, this message translates to:
  /// **'Parent ID / Mobile'**
  String get loginParentId;

  /// No description provided for @loginAdmissionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SGM/2024/001'**
  String get loginAdmissionHint;

  /// No description provided for @loginEmployeeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SGM/T/001'**
  String get loginEmployeeHint;

  /// No description provided for @loginParentHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 98765XXXXX'**
  String get loginParentHint;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo: Use any ID & password'**
  String get loginDemoHint;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// No description provided for @roleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get roleTeacher;

  /// No description provided for @roleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get roleParent;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get navStudents;

  /// No description provided for @navBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get navBus;

  /// No description provided for @navTimetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get navTimetable;

  /// No description provided for @homeOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get homeOverview;

  /// No description provided for @homeUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get homeUpcomingEvents;

  /// No description provided for @homeNoUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events soon'**
  String get homeNoUpcomingEvents;

  /// No description provided for @homeParentMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Child Monitoring'**
  String get homeParentMonitoring;

  /// No description provided for @homeParentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get homeParentAlerts;

  /// No description provided for @homeParentNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'All clear — no alerts.'**
  String get homeParentNoAlerts;

  /// No description provided for @homeParentGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get homeParentGrade;

  /// No description provided for @homeParentFeeStatus.
  ///
  /// In en, this message translates to:
  /// **'Fee Status'**
  String get homeParentFeeStatus;

  /// No description provided for @homeParentLowAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance below 75%'**
  String get homeParentLowAttendance;

  /// No description provided for @homeParentOverdueFees.
  ///
  /// In en, this message translates to:
  /// **'Fee payment pending'**
  String get homeParentOverdueFees;

  /// No description provided for @homeParentOverdueHomework.
  ///
  /// In en, this message translates to:
  /// **'{count} assignment(s) overdue'**
  String homeParentOverdueHomework(int count);

  /// No description provided for @homeParentChildTeachers.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Teachers'**
  String homeParentChildTeachers(String name);

  /// No description provided for @homeStatTotalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get homeStatTotalStudents;

  /// No description provided for @homeStatTeachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get homeStatTeachers;

  /// No description provided for @homeStatAttendanceToday.
  ///
  /// In en, this message translates to:
  /// **'Attendance Today'**
  String get homeStatAttendanceToday;

  /// No description provided for @homeStatBusesOnRoute.
  ///
  /// In en, this message translates to:
  /// **'Buses On Route'**
  String get homeStatBusesOnRoute;

  /// No description provided for @homeStatMyAttendance.
  ///
  /// In en, this message translates to:
  /// **'My Attendance'**
  String get homeStatMyAttendance;

  /// No description provided for @homeStatTodayPeriods.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Periods'**
  String get homeStatTodayPeriods;

  /// No description provided for @homeStatUpcomingExams.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Exams'**
  String get homeStatUpcomingExams;

  /// No description provided for @homeMyTeachers.
  ///
  /// In en, this message translates to:
  /// **'My Teachers'**
  String get homeMyTeachers;

  /// No description provided for @homeClassTeacher.
  ///
  /// In en, this message translates to:
  /// **'Class Teacher'**
  String get homeClassTeacher;

  /// No description provided for @homeQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get homeQuickAccess;

  /// No description provided for @quickResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get quickResults;

  /// No description provided for @quickTimetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get quickTimetable;

  /// No description provided for @quickAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get quickAttendance;

  /// No description provided for @quickFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get quickFees;

  /// No description provided for @quickHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get quickHomework;

  /// No description provided for @quickAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get quickAchievements;

  /// No description provided for @homeAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get homeAnnouncements;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greetingEvening;

  /// No description provided for @announcementPinned.
  ///
  /// In en, this message translates to:
  /// **'PINNED'**
  String get announcementPinned;

  /// No description provided for @announcementNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get announcementNew;

  /// No description provided for @announcementTypeExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get announcementTypeExam;

  /// No description provided for @announcementTypeHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get announcementTypeHoliday;

  /// No description provided for @announcementTypeEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get announcementTypeEvent;

  /// No description provided for @announcementTypeFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get announcementTypeFee;

  /// No description provided for @announcementTypeSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get announcementTypeSports;

  /// No description provided for @announcementTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get announcementTypeGeneral;

  /// No description provided for @announcementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcementsTitle;

  /// No description provided for @announcementsAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get announcementsAllCaughtUp;

  /// No description provided for @announcementsNone.
  ///
  /// In en, this message translates to:
  /// **'No announcements'**
  String get announcementsNone;

  /// No description provided for @announcementsUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String announcementsUnreadCount(int count);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get filterUnread;

  /// No description provided for @studentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentsTitle;

  /// No description provided for @studentsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, class or admission no.'**
  String get studentsSearchHint;

  /// No description provided for @studentsNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No students found'**
  String get studentsNoneFound;

  /// No description provided for @busTitle.
  ///
  /// In en, this message translates to:
  /// **'Bus Tracking'**
  String get busTitle;

  /// No description provided for @busFetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching live bus location...'**
  String get busFetchingLocation;

  /// No description provided for @busLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get busLive;

  /// No description provided for @busStatusOnRoute.
  ///
  /// In en, this message translates to:
  /// **'On Route'**
  String get busStatusOnRoute;

  /// No description provided for @busStatusAtStop.
  ///
  /// In en, this message translates to:
  /// **'At Stop'**
  String get busStatusAtStop;

  /// No description provided for @busStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get busStatusCompleted;

  /// No description provided for @busDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get busDriver;

  /// No description provided for @busContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get busContact;

  /// No description provided for @busEta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get busEta;

  /// No description provided for @busNextStop.
  ///
  /// In en, this message translates to:
  /// **'Next Stop'**
  String get busNextStop;

  /// No description provided for @timetableTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get timetableTitle;

  /// No description provided for @attendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTitle;

  /// No description provided for @attendanceOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get attendanceOverall;

  /// No description provided for @attendanceGoodStanding.
  ///
  /// In en, this message translates to:
  /// **'Good Standing'**
  String get attendanceGoodStanding;

  /// No description provided for @attendanceLow.
  ///
  /// In en, this message translates to:
  /// **'Attendance Low'**
  String get attendanceLow;

  /// No description provided for @attendanceGoodMessage.
  ///
  /// In en, this message translates to:
  /// **'Keep it up! Maintain above 75%.'**
  String get attendanceGoodMessage;

  /// No description provided for @attendanceLowMessage.
  ///
  /// In en, this message translates to:
  /// **'Below 75% — attendance at risk.'**
  String get attendanceLowMessage;

  /// No description provided for @attendancePresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attendancePresent;

  /// No description provided for @attendanceAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendanceAbsent;

  /// No description provided for @attendanceLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get attendanceLate;

  /// No description provided for @attendanceWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get attendanceWorkingDays;

  /// No description provided for @attendanceAbsentDates.
  ///
  /// In en, this message translates to:
  /// **'Absent Dates'**
  String get attendanceAbsentDates;

  /// No description provided for @resultsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'{firstName}\'s Results'**
  String resultsScreenTitle(String firstName);

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Academic Performance'**
  String get resultsTitle;

  /// No description provided for @resultsSession.
  ///
  /// In en, this message translates to:
  /// **'Session 2024–25'**
  String get resultsSession;

  /// No description provided for @resultsGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get resultsGrade;

  /// No description provided for @resultsScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get resultsScore;

  /// No description provided for @resultsClassRank.
  ///
  /// In en, this message translates to:
  /// **'Class Rank'**
  String get resultsClassRank;

  /// No description provided for @resultsClassAvgValue.
  ///
  /// In en, this message translates to:
  /// **'Class avg: {value}'**
  String resultsClassAvgValue(String value);

  /// No description provided for @resultsYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get resultsYou;

  /// No description provided for @resultsClassAvg.
  ///
  /// In en, this message translates to:
  /// **'Class Avg'**
  String get resultsClassAvg;

  /// No description provided for @resultsSubjectPerformance.
  ///
  /// In en, this message translates to:
  /// **'Subject-wise Performance'**
  String get resultsSubjectPerformance;

  /// No description provided for @resultsDetailedMarks.
  ///
  /// In en, this message translates to:
  /// **'Detailed Marks'**
  String get resultsDetailedMarks;

  /// No description provided for @resultsSubjectHeader.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get resultsSubjectHeader;

  /// No description provided for @resultsMarksHeader.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get resultsMarksHeader;

  /// No description provided for @resultsGradeHeader.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get resultsGradeHeader;

  /// No description provided for @homeworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homeworkTitle;

  /// No description provided for @homeworkStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get homeworkStatTotal;

  /// No description provided for @homeworkStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get homeworkStatPending;

  /// No description provided for @homeworkStatSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get homeworkStatSubmitted;

  /// No description provided for @homeworkStatOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get homeworkStatOverdue;

  /// No description provided for @homeworkEmpty.
  ///
  /// In en, this message translates to:
  /// **'No homework'**
  String get homeworkEmpty;

  /// No description provided for @homeworkEmptyPending.
  ///
  /// In en, this message translates to:
  /// **'No pending homework'**
  String get homeworkEmptyPending;

  /// No description provided for @homeworkEmptySubmitted.
  ///
  /// In en, this message translates to:
  /// **'No submitted homework'**
  String get homeworkEmptySubmitted;

  /// No description provided for @homeworkSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get homeworkSubmitted;

  /// No description provided for @homeworkPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get homeworkPriorityHigh;

  /// No description provided for @homeworkPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get homeworkPriorityMedium;

  /// No description provided for @homeworkPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get homeworkPriorityLow;

  /// No description provided for @homeworkOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue · {date}'**
  String homeworkOverdue(String date);

  /// No description provided for @homeworkDue.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String homeworkDue(String date);

  /// No description provided for @feesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fee Details'**
  String get feesTitle;

  /// No description provided for @feesAdmissionNo.
  ///
  /// In en, this message translates to:
  /// **'Admission No: {admissionNo}'**
  String feesAdmissionNo(String admissionNo);

  /// No description provided for @feesSession.
  ///
  /// In en, this message translates to:
  /// **'Session 2025–26'**
  String get feesSession;

  /// No description provided for @feesInstallmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Installment Details'**
  String get feesInstallmentDetails;

  /// No description provided for @feesStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get feesStatusPaid;

  /// No description provided for @feesStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get feesStatusPending;

  /// No description provided for @feesStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get feesStatusOverdue;

  /// No description provided for @feesStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get feesStatusPartial;

  /// No description provided for @feesTotalFee.
  ///
  /// In en, this message translates to:
  /// **'Total Fee'**
  String get feesTotalFee;

  /// No description provided for @feesPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get feesPaid;

  /// No description provided for @feesBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get feesBalance;

  /// No description provided for @feesDue.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String feesDue(String date);

  /// No description provided for @feesPaidDate.
  ///
  /// In en, this message translates to:
  /// **'Paid: {date}'**
  String feesPaidDate(String date);

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Achievements'**
  String get achievementsTitle;

  /// No description provided for @teacherMyClass.
  ///
  /// In en, this message translates to:
  /// **'My Class'**
  String get teacherMyClass;

  /// No description provided for @teacherClassIncharge.
  ///
  /// In en, this message translates to:
  /// **'Class Incharge'**
  String get teacherClassIncharge;

  /// No description provided for @teacherClassHealth.
  ///
  /// In en, this message translates to:
  /// **'Class Health'**
  String get teacherClassHealth;

  /// No description provided for @teacherClassAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get teacherClassAttendance;

  /// No description provided for @teacherAvgGrade.
  ///
  /// In en, this message translates to:
  /// **'Avg. Grade'**
  String get teacherAvgGrade;

  /// No description provided for @teacherPendingHW.
  ///
  /// In en, this message translates to:
  /// **'Pending HW'**
  String get teacherPendingHW;

  /// No description provided for @teacherSchoolOverview.
  ///
  /// In en, this message translates to:
  /// **'School Overview'**
  String get teacherSchoolOverview;

  /// No description provided for @teacherTakeAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get teacherTakeAttendance;

  /// No description provided for @teacherPostHomework.
  ///
  /// In en, this message translates to:
  /// **'Post HW'**
  String get teacherPostHomework;

  /// No description provided for @teacherPostReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get teacherPostReminder;

  /// No description provided for @teacherSubmitAttendance.
  ///
  /// In en, this message translates to:
  /// **'Submit Attendance'**
  String get teacherSubmitAttendance;

  /// No description provided for @teacherAttendanceSaved.
  ///
  /// In en, this message translates to:
  /// **'Attendance marked successfully!'**
  String get teacherAttendanceSaved;

  /// No description provided for @teacherHomeworkPosted.
  ///
  /// In en, this message translates to:
  /// **'Homework posted for the class!'**
  String get teacherHomeworkPosted;

  /// No description provided for @teacherReminderPosted.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent to the class!'**
  String get teacherReminderPosted;

  /// No description provided for @teacherPostHomeworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Post Homework'**
  String get teacherPostHomeworkTitle;

  /// No description provided for @teacherPostReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Post Reminder'**
  String get teacherPostReminderTitle;

  /// No description provided for @teacherSelectSubject.
  ///
  /// In en, this message translates to:
  /// **'Select Subject'**
  String get teacherSelectSubject;

  /// No description provided for @teacherHomeworkTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get teacherHomeworkTitleLabel;

  /// No description provided for @teacherHomeworkTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Exercise 4.3 – Quadratic Equations'**
  String get teacherHomeworkTitleHint;

  /// No description provided for @teacherHomeworkDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get teacherHomeworkDescLabel;

  /// No description provided for @teacherHomeworkDescHint.
  ///
  /// In en, this message translates to:
  /// **'What students should do (optional)'**
  String get teacherHomeworkDescHint;

  /// No description provided for @teacherDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get teacherDueDateLabel;

  /// No description provided for @teacherSelectDueDate.
  ///
  /// In en, this message translates to:
  /// **'Select due date'**
  String get teacherSelectDueDate;

  /// No description provided for @teacherPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get teacherPriorityLabel;

  /// No description provided for @teacherReminderMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get teacherReminderMessageLabel;

  /// No description provided for @teacherReminderMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write the reminder here…'**
  String get teacherReminderMessageHint;

  /// No description provided for @teacherReminderTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder Type'**
  String get teacherReminderTypeLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
