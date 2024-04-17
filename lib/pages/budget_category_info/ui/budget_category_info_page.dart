import 'package:flutter/material.dart';

class BudgetCategoryInfoPage extends StatelessWidget {
  const BudgetCategoryInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Info',
            style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 143, 125),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: []),
          ),
        ),
      ),
    );
  }
}
