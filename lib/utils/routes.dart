import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/about_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String profile = '/profile';
  static const String about = '/about';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
