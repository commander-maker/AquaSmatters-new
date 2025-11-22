import 'package:flutter/material.dart';
import 'package:aqua_smatters/screens/auth/login_screen.dart';
import 'package:aqua_smatters/screens/auth/signup_screen.dart';
import 'package:aqua_smatters/screens/auth/forgotpassword_screen.dart';
import 'package:aqua_smatters/screens/dashboard/dashboard_screen.dart';
import 'package:aqua_smatters/screens/water-quality/quality_screen.dart';
import 'package:aqua_smatters/screens/usage/usage_screen.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgot = '/forgot';
  static const String dashboard = '/dashboard';
  static const String quality = '/quality';
  static const String usage = '/usage';

  // Route map
  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        signup: (context) => const SignUpScreen(),
        forgot: (context) => const ForgotPasswordScreen(),
        dashboard: (context) => const DashboardScreen(),
        quality: (context) => const QualityScreen(),
        usage: (context) => const UsageScreen(),
      };

  // Initial route
  static String get initialRoute => login;
}
