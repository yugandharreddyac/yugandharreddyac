import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/admin/admin_login_screen.dart';

class AdminAuthGuard extends StatelessWidget {
  final Widget child;

  const AdminAuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // If loading auth state, show centered loader
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If authenticated AND is admin, grant access to child Admin page
    if (authProvider.isAuthenticated && authProvider.isAdmin) {
      return child;
    }

    // Otherwise, present secure Admin Login Screen
    return const AdminLoginScreen();
  }
}
