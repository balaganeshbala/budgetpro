import 'package:budgetpro/pages/expenses/ui/expenses_page.dart';
import 'package:budgetpro/pages/home/ui/home_page.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

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
      home: Scaffold(
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              HomePage(key: PageStorageKey('Tab1')),
              ExpensesPage(key: PageStorageKey('Tab2')),
            ]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
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
    );
  }
}
