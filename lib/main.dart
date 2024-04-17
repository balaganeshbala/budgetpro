import 'package:budgetpro/pages/home/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetProApp());
}

class BudgetProApp extends StatelessWidget {
  const BudgetProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}
