import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

// ── Repository interfaces ─────────────────────────────────────────────────────
import 'data/repositories/announcement_repository.dart';
import 'data/repositories/badge_repository.dart';
import 'data/repositories/bus_repository.dart';
import 'data/repositories/homework_repository.dart';
import 'data/repositories/student_repository.dart';
import 'data/repositories/timetable_repository.dart';

// ── Active implementations ────────────────────────────────────────────────────
// To switch a repository to the live API, replace the Dummy* import below with
// the corresponding Api* import and pass ApiClient() to its constructor.
//
// Example — switching students to live API:
//   import 'data/repositories/api/api_student_repository.dart';
//   import 'core/network/api_client.dart';
//   ...
//   RepositoryProvider<StudentRepository>(
//     create: (_) => ApiStudentRepository(ApiClient()),
//   ),
// ─────────────────────────────────────────────────────────────────────────────
import 'data/repositories/dummy/dummy_announcement_repository.dart';
import 'data/repositories/dummy/dummy_badge_repository.dart';
import 'data/repositories/dummy/dummy_bus_repository.dart';
import 'data/repositories/dummy/dummy_homework_repository.dart';
import 'data/repositories/dummy/dummy_student_repository.dart';
import 'data/repositories/dummy/dummy_timetable_repository.dart';

// ── BLoCs ─────────────────────────────────────────────────────────────────────
import 'features/home/bloc/home_bloc.dart';
import 'features/student/bloc/student_bloc.dart';
import 'features/bus_tracking/bloc/bus_bloc.dart';
import 'features/timetable/bloc/timetable_bloc.dart';
import 'features/attendance/bloc/attendance_bloc.dart';
import 'features/splash/splash_screen.dart';

class SGMSchoolApp extends StatelessWidget {
  const SGMSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StudentRepository>(
          create: (_) => DummyStudentRepository(),
        ),
        RepositoryProvider<BusRepository>(
          create: (_) => DummyBusRepository(),
        ),
        RepositoryProvider<TimetableRepository>(
          create: (_) => DummyTimetableRepository(),
        ),
        RepositoryProvider<HomeworkRepository>(
          create: (_) => DummyHomeworkRepository(),
        ),
        RepositoryProvider<AnnouncementRepository>(
          create: (_) => DummyAnnouncementRepository(),
        ),
        RepositoryProvider<BadgeRepository>(
          create: (_) => DummyBadgeRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => HomeBloc(
              ctx.read<StudentRepository>(),
              ctx.read<TimetableRepository>(),
              ctx.read<AnnouncementRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => StudentBloc(ctx.read<StudentRepository>()),
          ),
          BlocProvider(
            create: (ctx) => BusBloc(ctx.read<BusRepository>()),
          ),
          BlocProvider(
            create: (ctx) => TimetableBloc(ctx.read<TimetableRepository>()),
          ),
          BlocProvider(
            create: (ctx) => AttendanceBloc(ctx.read<StudentRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'SGM International School',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
