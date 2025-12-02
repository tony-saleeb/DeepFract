import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'utils/theme_provider.dart';
import 'utils/routes.dart';
import 'widgets/theme_switcher.dart';

import 'package:flutter/services.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Make system bars transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const ThemeSwitcher(child: DeepFractApp()),
    ),
  );
}

class DeepFractApp extends StatelessWidget {
  const DeepFractApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'DeepFract',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          // Disable default transition as we handle it manually
          themeAnimationDuration: Duration.zero,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
