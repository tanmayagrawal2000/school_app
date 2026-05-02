# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Get dependencies
flutter pub get

# Run the app (connect a device or start an emulator first)
flutter run

# Analyze for lint/type errors
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Build debug APK (for testing)
flutter build apk --debug --no-tree-shake-icons

# Build release APK
flutter build apk --release --no-tree-shake-icons

# Regenerate localization code after editing app_en.arb
flutter gen-l10n
```

> The Android build requires AGP 8.3.2 + Gradle 8.6 + Kotlin 1.9.24 (pinned in `android/settings.gradle.kts` and `android/gradle/wrapper/gradle-wrapper.properties`). Do not upgrade these without testing — the original AGP 8.9.1 / Gradle 8.12 combo caused a Kotlin class-not-found build failure on the dev machine.
>
> `flutter_local_notifications` requires `isCoreLibraryDesugaringEnabled = true` and `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")` in `android/app/build.gradle.kts` — already configured.

## Architecture

All data is currently served from in-memory dummy data — there is no live network layer. The codebase is structured so any repository can be switched to a real API by changing a single line in `app.dart`.

### Caching layer (`AppCache`)

`lib/core/cache/app_cache.dart` is a TTL-based in-memory cache used by the API repository layer.

- **Three TTL tiers:** `shortTtl` (5 min) for homework / attendance / announcements / reminders; `mediumTtl` (10 min) for student profiles, fees, rosters, class stats, teacher profile; `longTtl` (30 min) for timetable and teacher schedules.
- **Cache keys** are static helpers on `AppCache` (e.g. `AppCache.homework(grade, section, studentId)`).
- **Pull-to-refresh bypasses the cache**: every BLoC refresh handler calls `AppCache.clear()` before re-fetching. StatefulWidget screens that call repos directly call `_loadData()` directly via `RefreshIndicator.onRefresh`; their repos will re-fetch because the `RefreshIndicator` doesn't clear cache — but since those screens are teachers-only and the TTL is short, this is acceptable.
- **Dummy repositories ignore the cache** — they always read from `DummyData`.

### Pull-to-refresh pattern

Every screen has a pull-down `RefreshIndicator` wrapping its scrollable content.

**BLoC screens** (home, attendance, homework, results, fees, timetable, announcements, students):
```dart
RefreshIndicator(
  color: AppColors.primaryBrown,
  onRefresh: () async {
    context.read<XBloc>().add(const XRefresh(/* params if needed */));
    await context.read<XBloc>().stream
        .firstWhere((s) => s is XLoaded || s is XError);
  },
  child: ListView(physics: const AlwaysScrollableScrollPhysics(), ...),
)
```
Refresh handlers do NOT emit `XLoading` — current data stays visible while the spinner shows.

**StatefulWidget screens** (class attendance, subject performance, pending HW, teacher HW, tomorrow prep):
```dart
RefreshIndicator(
  color: AppColors.primaryBrown,
  onRefresh: _loadData,  // returns Future<void>; doesn't reset _loading
  child: ListView(physics: const AlwaysScrollableScrollPhysics(), ...),
)
```

### Lazy loading (`StudentListScreen`)

`StudentListScreen` uses client-side windowing to avoid rendering all students at once:
- `_displayCount` starts at 20 and increments by 20 when the `ScrollController` reaches 85% scroll depth.
- Pull-to-refresh resets `_displayCount` back to 20.

### Layer overview

```
lib/
├── main.dart                          # Portrait lock, status bar style, NotificationService.init()
├── app.dart                           # Root widget — wires repositories + BLoCs
│
├── core/
│   ├── cache/
│   │   └── app_cache.dart             # TTL in-memory cache (shortTtl/mediumTtl/longTtl)
│   ├── enums/
│   │   └── user_role.dart             # UserRole enum (student, parent, teacher)
│   ├── error/
│   │   └── app_exception.dart         # Typed exceptions (Network, Server, Auth, Parse, NotFound)
│   ├── network/
│   │   ├── api_client.dart            # HTTP client skeleton (activate by adding Dio)
│   │   └── api_endpoints.dart         # All API path constants + parameterised route methods
│   ├── services/
│   │   ├── auth_storage.dart          # SharedPreferences session persistence
│   │   └── notification_service.dart  # flutter_local_notifications singleton
│   └── theme/
│       ├── app_colors.dart            # Full colour palette (semantic + brand)
│       └── app_theme.dart             # MaterialTheme config (typography, card, appbar)
│
├── data/
│   ├── dummy/
│   │   └── dummy_data.dart            # Single source of all in-memory data + remindersForDay()
│   ├── models/
│   │   ├── announcement_model.dart        # AnnouncementModel, AnnouncementType enum
│   │   ├── attendance_model.dart          # AttendanceRecord, AttendanceStatus enum
│   │   ├── badge_model.dart               # BadgeModel (earned badges)
│   │   ├── badge_type_model.dart          # BadgeType catalog
│   │   ├── bus_model.dart                 # BusRoute, BusStop, LatLng
│   │   ├── class_reminder_model.dart      # ClassReminderModel, ReminderType enum
│   │   ├── class_stats_model.dart         # ClassStats (average marks, rank distribution)
│   │   ├── fee_model.dart                 # FeeInstallment, FeeStatus enum
│   │   ├── homework_model.dart            # HomeworkItem, HomeworkPriority enum
│   │   ├── parent_model.dart              # ParentModel
│   │   ├── pending_homework_entry.dart    # PendingHomeworkEntry (teacher dashboard)
│   │   ├── roster_student.dart            # RosterStudent — lightweight id/name/initials for class lists
│   │   ├── student_attendance_summary.dart # StudentAttendanceSummary
│   │   ├── student_model.dart             # StudentModel (marks, attendance%, fee status)
│   │   ├── student_subject_mark.dart      # StudentSubjectMark — name, marks, maxMarks, grade, percentage
│   │   ├── subject_model.dart             # SubjectModel — single source of truth for color/icon
│   │   ├── teacher_class_summary.dart     # TeacherClassSummary
│   │   ├── teacher_model.dart             # TeacherModel
│   │   └── timetable_model.dart           # TimetableModel, TimetablePeriod
│   └── repositories/
│       ├── announcement_repository.dart   ← abstract interface
│       ├── badge_repository.dart          ← abstract interface
│       ├── bus_repository.dart            ← abstract interface
│       ├── homework_repository.dart       ← abstract interface
│       ├── student_repository.dart        ← abstract interface
│       ├── timetable_repository.dart      ← abstract interface
│       ├── dummy/                         # DummyData-backed implementations (currently active)
│       │   ├── dummy_announcement_repository.dart
│       │   ├── dummy_badge_repository.dart
│       │   ├── dummy_bus_repository.dart
│       │   ├── dummy_homework_repository.dart
│       │   ├── dummy_student_repository.dart
│       │   └── dummy_timetable_repository.dart
│       └── api/                           # ApiClient-backed skeletons (activate when backend ready)
│           ├── api_announcement_repository.dart
│           ├── api_badge_repository.dart
│           ├── api_bus_repository.dart
│           ├── api_homework_repository.dart
│           ├── api_reminder_repository.dart
│           ├── api_student_repository.dart
│           ├── api_teacher_repository.dart
│           └── api_timetable_repository.dart
│
├── features/
│   ├── achievements/
│   │   ├── bloc/                      # BadgeBloc / BadgeEvent / BadgeState
│   │   └── (view lives in home/view/achievements_screen.dart)
│   ├── attendance/
│   │   ├── bloc/                      # AttendanceBloc / AttendanceEvent / AttendanceState
│   │   └── view/attendance_screen.dart
│   ├── bus_tracking/
│   │   ├── bloc/                      # BusBloc / BusEvent / BusState (Timer.periodic simulation)
│   │   └── view/bus_tracking_screen.dart
│   ├── fees/
│   │   ├── bloc/                      # FeesBloc / FeesEvent / FeesState (local scope)
│   │   └── view/fees_screen.dart
│   ├── home/
│   │   ├── bloc/                      # HomeBloc / HomeEvent / HomeState (global scope)
│   │   └── view/
│   │       ├── home_screen.dart               # IndexedStack bottom-nav shell
│   │       ├── achievements_screen.dart       # Badge gallery
│   │       ├── announcement_detail_screen.dart
│   │       ├── announcements_list_screen.dart
│   │       ├── class_grades_screen.dart       # Teacher — per-class grade breakdown
│   │       ├── post_reminder_screen.dart      # Teacher — post a class reminder
│   │       ├── subject_performance_screen.dart # Teacher — per-subject student mark list (worst→best)
│   │       ├── teacher_pending_hw_screen.dart  # Teacher — pending homework dashboard
│   │       └── tomorrow_prep_screen.dart      # Tomorrow's timetable + reminders + due homework
│   ├── homework/
│   │   ├── bloc/                      # HomeworkBloc / HomeworkEvent / HomeworkState (local scope)
│   │   └── view/
│   │       ├── homework_screen.dart           # Student homework list
│   │       ├── post_homework_screen.dart      # Teacher — create/assign homework
│   │       └── teacher_homework_screen.dart   # Teacher — homework list + mark submissions
│   ├── login/
│   │   └── login_screen.dart
│   ├── results/
│   │   ├── bloc/                      # ResultsBloc / ResultsEvent / ResultsState (local scope)
│   │   └── view/results_screen.dart
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── student/
│   │   ├── bloc/                      # StudentBloc / StudentEvent / StudentState (global scope)
│   │   └── view/
│   │       ├── student_list_screen.dart   # Teacher-only tab
│   │       └── student_detail_screen.dart
│   └── timetable/
│       ├── bloc/                      # TimetableBloc / TimetableEvent / TimetableState (global)
│       └── view/timetable_screen.dart
│
└── l10n/
    ├── app_en.arb                     # Source strings — edit this file to add/change strings
    ├── app_localizations.dart         # Generated — do not edit manually
    └── app_localizations_en.dart      # Generated — do not edit manually
```

### Switching from dummy data to a live API

**One repository at a time** — edit `app.dart`:

```dart
// Before (dummy):
RepositoryProvider<StudentRepository>(
  create: (_) => DummyStudentRepository(),
),

// After (live API):
import 'data/repositories/api/api_student_repository.dart';
import 'core/network/api_client.dart';
...
RepositoryProvider<StudentRepository>(
  create: (_) => ApiStudentRepository(ApiClient()),
),
```

**Activating `ApiClient` (Dio):**
1. Add `dio: ^5.7.0` to `pubspec.yaml`
2. In `core/network/api_client.dart`, uncomment the Dio imports and replace the stub `throw UnimplementedError(...)` bodies with the commented-out Dio calls
3. Uncomment `import '../error/app_exception.dart'` and `_mapDioError` in the same file

**Base URL:** Change `ApiEndpoints.baseUrl` in `core/network/api_endpoints.dart`.

**Auth token:** Wire `AuthStorage` in the `_AuthInterceptor` skeleton at the bottom of `api_client.dart`.

### Repository interfaces

| Interface | Dummy impl | API impl | Key methods |
|---|---|---|---|
| `StudentRepository` | `DummyStudentRepository` | `ApiStudentRepository` | `fetchCurrentStudent`, `fetchStudents`, `fetchAttendance`, `fetchClassTeacher`, `fetchSubjectTeachers`, `fetchClassStats`, `fetchFeeInstallments`, `fetchClassAttendanceSummary`, `fetchSubjectMarks` |
| `AnnouncementRepository` | `DummyAnnouncementRepository` | `ApiAnnouncementRepository` | `fetchAnnouncements` |
| `BusRepository` | `DummyBusRepository` | `ApiBusRepository` | `fetchRoutes` |
| `TimetableRepository` | `DummyTimetableRepository` | `ApiTimetableRepository` | `fetchTimetable`, `periodsCountForDay` |
| `HomeworkRepository` | `DummyHomeworkRepository` | `ApiHomeworkRepository` | `fetchHomework`, `saveSubmissions`, `fetchHomeworkByTeacher`, `fetchClassRoster`, `fetchSubmittedCount`, `fetchIsSubmittedBy`, `fetchPendingSubmissions` |
| `TeacherRepository` | `DummyTeacherRepository` | `ApiTeacherRepository` | `fetchCurrentTeacher`, `fetchClassSummaries`, `fetchSchedule` |
| `ReminderRepository` | `DummyReminderRepository` | `ApiReminderRepository` | `fetchRemindersForDay` |

### BLoC wiring

All BLoCs in `app.dart`'s `MultiBlocProvider` are **global** except `ResultsBloc`, `FeesBloc`, and `HomeworkBloc` which are created locally inside their screens.

| BLoC | Scope | Injected repositories |
|---|---|---|
| `HomeBloc` | Global | `StudentRepository`, `TimetableRepository`, `AnnouncementRepository` |
| `StudentBloc` | Global | `StudentRepository` |
| `BusBloc` | Global | `BusRepository` |
| `TimetableBloc` | Global | `TimetableRepository` |
| `AttendanceBloc` | Global | `StudentRepository` |
| `ResultsBloc` | Local | `StudentRepository` |
| `FeesBloc` | Local | `StudentRepository` |
| `HomeworkBloc` | Local | `HomeworkRepository` |

### Features & screens

| Feature | Entry point | Notes |
|---|---|---|
| Home | `HomeScreen` | `IndexedStack` bottom-nav; teacher vs student/parent tabs differ |
| Announcements | `AnnouncementsListScreen` | Filter by type or unread; opened via "View All" or bell icon |
| Announcement detail | `AnnouncementDetailScreen` | Full-screen detail; gold header for pinned, brown for regular |
| Results | `ResultsScreen(student)` | Grouped bar chart (student vs class avg); rank badge; per-subject delta |
| Fees | `FeesScreen(student)` | Quarterly installment cards; progress bar; paid/pending/overdue summary |
| Homework | `HomeworkScreen(student)` | Filter chips; priority badge; due-date colour coding |
| Attendance | `AttendanceScreen(student)` | `table_calendar` with generated attendance records |
| Timetable | `TimetableScreen` | Bottom-nav tab; quick-action uses a `VoidCallback` to switch tabs (not `Navigator.push`) |
| Students | `StudentListScreen` | Teacher-only tab; accepts `teacherClasses` to scope to teacher's classes + chip filter bar |
| Student detail | `StudentDetailScreen` | Profile / results / attendance / fees tabs; `SliverAppBar expandedHeight: 280` |
| Teacher homework | `TeacherHomeworkScreen` | Teacher homework list (all/upcoming/overdue filter) |
| Mark submissions | `TeacherMarkSubmissionsScreen` | Local draft (`_localSubmitted` Set) + single Save → `saveSubmissions` PUT |
| Subject performance | `SubjectPerformanceScreen` | Class avg indicator + student rows sorted worst→best; tapped from Sub Avg card on home |
| Post homework | `PostHomeworkScreen` | Teacher — create/assign homework |
| Class grades | `ClassGradesScreen` | Teacher — per-class grade breakdown |
| Bus | `BusTrackingScreen` | `flutter_map` with live-simulated positions |

### Key design decisions

- **Abstract repository interfaces** — BLoCs only reference the abstract type. `app.dart` decides which implementation to inject. Swapping dummy → API requires changing one line per repository.
- **`fromJson` / `toJson` on all models** — every model supports JSON round-tripping. Enums serialise via `.name` / `.values.byName()`. `LatLng` serialises as `currentLat`/`currentLng` (route) and `lat`/`lng` (stop). `DateTime` uses ISO 8601.
- **`AppException` hierarchy** — `NetworkException`, `ServerException`, `AuthException`, `ParseException`, `NotFoundException`. BLoCs should catch `AppException` and emit an error state.
- **`ApiEndpoints`** — all URL paths are constants in one file. Parameterised routes are static methods (e.g. `ApiEndpoints.studentById(id)`).
- **Dashboard stats** — `HomeBloc` still reads `DummyData.dashboardStats` directly. This is intentional: these aggregate counters (total students, buses on route, etc.) will come from a dedicated stats endpoint when the backend is ready. Mark with `// TODO: DashboardRepository`.
- **No navigation library** — plain `Navigator.push` throughout. Timetable quick-action uses a `VoidCallback` threaded from `_HomeScreenState` → `_DashboardTab` so the tab switches without re-instantiating the BLoC.
- **Color palette** — all colours in `AppColors`. For text on dark gradient backgrounds use the `*Bright` / `*Light` colour variants — the standard semantic colours are too dark to be legible.
- **Overflow prevention** — any `Text` inside a `Row` that could overflow must be wrapped in `Flexible`. Use `Wrap` for chip collections.
- **GridView padding** — always `padding: EdgeInsets.zero` on `GridView` inside `CustomScrollView`/`Column` to suppress Flutter's default `MediaQuery` safe-area leading inset.
- **Announcement read tracking** — `HomeLoaded.readIds: Set<String>` tracks opened announcements in-session. `copyWithRead(id)` uses `{...readIds, id}` for immutable update. Both home screen and `AnnouncementsListScreen` use the same global `HomeBloc`.
- **Notifications** — `NotificationService` singleton (initialised in `main()`). Currently fires a local notification on every announcement tap for testing. Requires `POST_NOTIFICATIONS` permission (Android 13+) — already declared in `AndroidManifest.xml`.
- **CBSE grading** — `StudentModel.grade`: A1 ≥ 91 %, A2 ≥ 81 %, B1 ≥ 71 %, B2 ≥ 61 %, C1 ≥ 51 %, C2 ≥ 41 %, D ≥ 33 %, E otherwise.
- **Bus simulation** — `BusBloc` fires `Timer.periodic(4s)` adding ±0.00025° jitter and decrementing ETA. School anchor: `LatLng(26.4812, 80.2775)` (Indira Nagar, Kanpur).
- **Teacher class filtering** — `StudentListScreen` accepts `List<String>? teacherClasses` (format `"grade-section"`, e.g. `"10-A"`). When provided, the list is scoped to those classes and a chip filter bar appears above the list. Pass via `_HomeScreenState._teacherClassKeys` populated from `HomeLoaded`.
- **BlocBuilder rebuild control** — `StudentBloc` emits `StudentLoading` during both initial load and detail fetch. Use `buildWhen: (prev, curr) => curr is StudentListLoaded || (curr is StudentLoading && prev is StudentInitial)` on the list screen to prevent the list from disappearing when a student detail is viewed.
- **Homework submission — local draft** — `TeacherMarkSubmissionsScreen` keeps all switch state in a local `Set<String> _localSubmitted` (no network calls on toggle). One `saveSubmissions` PUT is made when the teacher taps Save. `DummyData.setSubmissions(hwId, ids)` replaces the entire submission set atomically.
- **Homework submission API** — `PUT /academic/homework/{hwId}/submissions` body: `{ "submittedStudentIds": [...] }`. Endpoint constant: `ApiEndpoints.homeworkSubmissions(hwId)`.
- **Subject performance consistency** — `DummyData._subjectMarks` is the single source of truth. `classStatsFor()` CS averages must match the computed average of `_subjectMarks` entries for that class, otherwise the home card and `SubjectPerformanceScreen` will disagree.
- **`table_calendar` date range** — `firstDay`, `lastDay`, and `focusedDay` must satisfy `firstDay ≤ focusedDay ≤ lastDay`. `focusedDay` defaults to `DateTime.now()` (currently 2026). Set `lastDay: DateTime(2026, 6, 30)` and `firstDay: DateTime(2025, 4, 1)` to avoid assertion errors.
- **`SliverAppBar` overlap** — if content inside `FlexibleSpaceBar` is hidden behind the `TabBar`, increase `expandedHeight`. For `StudentDetailScreen` the correct value is `280`; adding a `SizedBox(height: 60)` at the bottom of the flexible content pushes badges above the tab bar.
- **`bottomNavigationBar` safe area** — use `MediaQuery.of(context).viewPadding.bottom` (not `padding.bottom`) for the bottom inset inside `bottomNavigationBar`. `padding.bottom` can be zeroed out by a parent Scaffold's bottom-nav adjustment; `viewPadding.bottom` is the raw physical inset unaffected by Scaffold.
- **`ElevatedButton` height** — do not wrap `ElevatedButton` in a `SizedBox(height: N)` to control height; tight height constraints clip text descenders. Let the button use its natural theme height, or override via `ButtonStyle.minimumSize`.

### Localization

All UI strings use Flutter's built-in `flutter_localizations` / `intl` pipeline.

- **Template file:** `lib/l10n/app_en.arb` — edit this to add or change strings.
- **Generated files:** `lib/l10n/app_localizations.dart` and `lib/l10n/app_localizations_en.dart` — do not edit manually; regenerate with `flutter gen-l10n`.
- **Config:** `l10n.yaml` — `output-dir: lib/l10n`, `output-class: AppLocalizations`, `synthetic-package: false`.
- **Import:** `import 'package:sgm_school_app/l10n/app_localizations.dart';`
- **Usage in widgets:** `final l10n = AppLocalizations.of(context)!;` then `l10n.someKey`.
- **Parametrized strings** (e.g. `resultsScreenTitle`, `homeworkDue`, `feesAdmissionNo`) are called as methods: `l10n.homeworkDue('15 Jan')`.
- **Scope:** Only UI chrome strings are localized — dummy data content (student names, announcement bodies, subject names, etc.) is intentionally left as-is.
- **`intl` version** must be pinned to `^0.20.2` to match the `flutter_localizations` SDK constraint.

### Adding a new feature

1. Create `lib/features/<name>/bloc/` with event / state / bloc files.
2. Create `lib/features/<name>/view/<name>_screen.dart`.
3. If the BLoC needs global scope, register it in `app.dart`; otherwise create it locally in the screen.
4. Create the repository interface in `data/repositories/<name>_repository.dart`.
5. Add dummy impl in `data/repositories/dummy/dummy_<name>_repository.dart`.
6. Add API skeleton in `data/repositories/api/api_<name>_repository.dart`.
7. Wire the dummy impl in `app.dart`'s `MultiRepositoryProvider`.
8. Add endpoint constants to `ApiEndpoints` and dummy data to `DummyData`.
