import 'package:budgetpro/pages/expenses/ui/expenses_page.dart';
import 'package:budgetpro/pages/home/ui/home_page.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:budgetpro/widgets/month_selector/bloc/month_selector_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const BudgetProApp());
}

class BudgetProApp extends StatefulWidget {
  const BudgetProApp({super.key});

  @override
  _BudgetProAppState createState() => _BudgetProAppState();
}

class _BudgetProAppState extends State<BudgetProApp> {
  int _currentIndex = 0;
  late PageController _pageController;

  String initialMonth = Utils.getMonthAsShortText(DateTime.now());
  String initialYear = '${DateTime.now().year}';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
      home: BlocProvider(
        create: (context) =>
            MonthSelectorBloc(initialMonth, initialYear, DateTime.now()),
        child: Scaffold(
          body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: const [
                HomePage(key: PageStorageKey('Tab1')),
                ExpensesPage(key: PageStorageKey('Tab2')),
              ]),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              unselectedLabelStyle: const TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.w600),
              selectedLabelStyle: const TextStyle(
                  fontFamily: "Quicksand", fontWeight: FontWeight.bold),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.calculate),
                  label: 'Budget',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: 'Expenses',
                ),
              ],
              currentIndex: _currentIndex,
              selectedItemColor: AppColors.linkColor, // Selected tab color
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
