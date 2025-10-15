import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/providers/theme_provider.dart';
import 'core/services/cache_service.dart';
import 'core/services/environment_service.dart';
import 'screens/splash/splash_screen.dart';
import 'core/themes/app_theme.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await EnvironmentService.initialize();

  // Initialize Hive for caching
  await Hive.initFlutter();
  await CacheService.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app with MultiProvider for state management
    return MultiProvider(
      providers: [
        // Theme Provider for theme switching
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            // Design size based on 375px width (iPhone SE/8)
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Flutter Photo App',
                debugShowCheckedModeBanner: false,

                // Theme configuration
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,

                // Initial route
                home: const SplashScreen(),

                // Global builder for handling safe area and orientation
                builder: (context, widget) {
                  // Set orientation based on device type
                  final mediaQuery = MediaQuery.of(context);
                  final isTablet = mediaQuery.size.shortestSide >= 600;

                  // Lock orientation for mobile devices only
                  if (!isTablet) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  } else {
                    // Allow all orientations for tablets
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                    ]);
                  }

                  return MediaQuery(
                    // Ensure text scale factor doesn't exceed 1.5
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(
                        MediaQuery.of(context)
                            .textScaler
                            .scale(1.0)
                            .clamp(0.8, 1.5),
                      ),
                    ),
                    child: widget!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
