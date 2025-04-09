import 'package:budgetpro/services/supabase_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay the session check until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    // await SupabaseService.signOut();
    final session = SupabaseService.client.auth.currentSession;

    if (session != null) {
      // User is logged in, navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not logged in, navigate to the login screen
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
