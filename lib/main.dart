import 'package:budgetpro/pages/new_home/ui/new_home_page.dart';
import 'package:budgetpro/pages/profile/profile_page.dart';
import 'package:budgetpro/pages/registration/ui/registration_screen.dart';
import 'package:budgetpro/pages/sign_in/ui/sign_in_screen.dart';
import 'package:budgetpro/pages/navigator/splash_screen.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const BudgetProApp());
}

class BudgetProApp extends StatefulWidget {
  const BudgetProApp({super.key});

  @override
  _BudgetProAppState createState() => _BudgetProAppState();
}

class _BudgetProAppState extends State<BudgetProApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: const MaterialColor(0xFF428F7D, {
              50: Color(0xFFE4F6F3),
              100: Color(0xFFB5E0CD),
              200: Color(0xFF85CCAA),
              300: Color(0xFF55B987),
              400: Color(0xFF39A874),
              500: Color(0xFF1D9A61),
              600: Color(0xFF1A8B57),
              700: Color(0xFF167B4D),
              800: Color(0xFF126C43),
              900: Color(0xFF0E5D39),
            }),
            accentColor: AppColors.accentColor,
          ),
          dividerTheme: DividerThemeData(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          inputDecorationTheme: InputDecorationTheme(
              floatingLabelStyle:
                  const TextStyle(color: AppColors.primaryColor),
              labelStyle: TextStyle(color: AppColors.iconColor),
              hintStyle: TextStyle(color: AppColors.iconColor),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.iconColor)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)))),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const NewHomePage(),
        '/sign-in': (context) => SignInScreen(),
        '/register': (context) => RegistrationScreen(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
