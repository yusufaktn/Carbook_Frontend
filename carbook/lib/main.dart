import 'package:carbook/features/screen/home_screen.dart';
import 'package:carbook/features/screen/Auth/login_screen.dart';
import 'package:carbook/core/theme/app_theme.dart';
import 'package:carbook/features/provider/CategoryProvider.dart';
import 'package:carbook/features/provider/Question/question_provider.dart';
import 'package:carbook/features/provider/Answer/answer_provider.dart';
import 'package:carbook/features/provider/User/user_provider.dart';
import 'package:carbook/features/provider/Auth/auth_provider.dart';
import 'package:carbook/features/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => QuestionProvider()),
        ChangeNotifierProvider(create: (context) => AnswerProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider()..initializeAuth(),
        ),
      ],
      child: MaterialApp(
        title: 'CarBook',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        
        // Route yönetimi
        onGenerateRoute: AppRoutes.onGenerateRoute,
        
        // Auth durumuna göre başlangıç sayfası
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Loading durumu
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            // Kullanıcı giriş yapmış mı?
            if (authProvider.isAuthenticated) {
              return const HomeScreen();
            }
            
            // Giriş yapılmamış - Login ekranı göster
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
