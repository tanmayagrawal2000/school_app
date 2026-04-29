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

### Layer overview

```
lib/
├── main.dart                          # Portrait lock, status bar style, NotificationService.init()
├── app.dart                           # Root widget — wires repositories + BLoCs
├── core/
│   ├── error/app_exception.dart       # Typed exceptions (Network, Server, Auth, …)
│   ├── network/
│   │   ├── api_client.dart            # HTTP client skeleton (activate by adding Dio)
│   │   └── api_endpoints.dart         # All API path constants
│   ├── enums/user_role.dart
│   └── services/notification_service.dart
└── data/
    ├── models/                        # Equatable data classes with fromJson / toJson
    ├── dummy/dummy_data.dart          # Single source of all in-memory data
    └── repositories/
        ├── student_repository.dart         ← abstract interface
        ├── bus_repository.dart             ← abstract interface
        ├── timetable_repository.dart       ← abstract interface
        ├── homework_repository.dart        ← abstract interface
        ├── announcement_repository.dart    ← abstract interface
        ├── dummy/   ← DummyData-backed implementations (currently active)
        └── api/     ← ApiClient-backed implementations (activate when backend is ready)
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
| `StudentRepository` | `DummyStudentRepository` | `ApiStudentRepository` | `fetchCurrentStudent`, `fetchStudents`, `fetchAttendance`, `fetchClassTeacher`, `fetchSubjectTeachers`, `fetchClassStats`, `fetchFeeInstallments` |
| `AnnouncementRepository` | `DummyAnnouncementRepository` | `ApiAnnouncementRepository` | `fetchAnnouncements` |
| `BusRepository` | `DummyBusRepository` | `ApiBusRepository` | `fetchRoutes` |
| `TimetableRepository` | `DummyTimetableRepository` | `ApiTimetableRepository` | `fetchTimetable`, `periodsCountForDay` |
| `HomeworkRepository` | `DummyHomeworkRepository` | `ApiHomeworkRepository` | `fetchHomework` |

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
| Students | `StudentListScreen` | Teacher-only tab |
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
