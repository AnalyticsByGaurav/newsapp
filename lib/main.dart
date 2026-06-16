import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/settings/settings_event.dart';
import 'presentation/blocs/settings/settings_state.dart';
import 'presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.hiveBoxArticles);
  await Hive.openBox(AppConstants.hiveBoxBookmarks);
  await Hive.openBox(AppConstants.hiveBoxSettings);
  await Hive.openBox(AppConstants.hiveBoxCategories);

  // Firebase - graceful fallback if google-services.json not present
  try {
    // await Firebase.initializeApp();
    // await FirebaseMessaging.instance.requestPermission();
  } catch (_) {}

  // Setup GetIt DI
  await setupLocator();

  runApp(const NamasteramApp());
}

class NamasteramApp extends StatelessWidget {
  const NamasteramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(const LoadSettingsEvent()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
