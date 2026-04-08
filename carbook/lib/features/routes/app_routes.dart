import 'package:flutter/material.dart';
import '../screen/Auth/login_screen.dart';
import '../screen/Auth/register_screen.dart';
import '../screen/home_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/questions_list_screen.dart';
import '../screen/question_detail_screen.dart';

/// App routes configuration
class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String questionsList = '/questions';
  static const String questionDetail = '/question-detail';

  /// Generate routes
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case profile:
        // Get user ID from arguments, default to current user
        final args = settings.arguments as Map<String, dynamic>?;
        final userId = args?['userId'] as int? ?? 1; // TODO: Get from AuthProvider
        
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(userId: userId),
          settings: settings,
        );

      case questionsList:
        return MaterialPageRoute(
          builder: (_) => const QuestionsListScreen(),
          settings: settings,
        );

      case questionDetail:
        // Get question object from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final question = args?['question'];
        
        if (question == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Geçersiz soru'),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => QuestionDetailScreen(question: question),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Sayfa bulunamadı'),
            ),
          ),
        );
    }
  }

  /// Navigate to route
  static Future<T?> navigateTo<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Navigate and replace current route
  static Future<dynamic> navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and remove all previous routes
  static Future<dynamic> navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  static void goBack(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }
}
