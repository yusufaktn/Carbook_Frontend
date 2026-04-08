import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Auth/auth_provider.dart';
import '../../screen/Auth/login_screen.dart';

/// Auth guard widget that redirects to login if not authenticated
class AuthGuard extends StatelessWidget {
  final Widget child;
  final bool requireAuth;

  const AuthGuard({
    super.key,
    required this.child,
    this.requireAuth = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // If authentication is required and user is not authenticated
        if (requireAuth && !authProvider.isAuthenticated) {
          // Redirect to login screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          });
          
          // Show loading while redirecting
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If authentication is not required or user is authenticated
        return child;
      },
    );
  }
}

/// Check authentication guard for routes
class AuthGuardRoute extends StatefulWidget {
  final Widget child;
  final bool requireAuth;

  const AuthGuardRoute({
    super.key,
    required this.child,
    this.requireAuth = true,
  });

  @override
  State<AuthGuardRoute> createState() => _AuthGuardRouteState();
}

class _AuthGuardRouteState extends State<AuthGuardRoute> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = context.read<AuthProvider>();
    
    // Initialize auth if not already done
    if (!authProvider.isAuthenticated && !authProvider.isLoading) {
      await authProvider.initializeAuth();
    }

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final authProvider = context.watch<AuthProvider>();

    // If authentication is required and user is not authenticated
    if (widget.requireAuth && !authProvider.isAuthenticated) {
      return const LoginScreen();
    }

    // If authentication is not required or user is authenticated
    return widget.child;
  }
}
