import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/pages/budget_category/ui/budget_category_info_page.dart';
import 'package:budgetpro/pages/budget_categories/budget_categories_view.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

class BudgetCategoriesScreen extends StatelessWidget {
  final List<CategorizedBudgetModel> budgetCategories;
  final double totalBudget; // Replace with actual total income
  final String month;
  final String year;

  const BudgetCategoriesScreen({
    Key? key,
    required this.budgetCategories,
    required this.totalBudget,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$month $year',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora"),
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const SectionHeader(text: 'By Category'),
                BudgetCategoriesView(
                  budget: budgetCategories,
                  totalBudget: totalBudget,
                  onCategoryTap: (budget) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BudgetCategoryInfoPage(
                          budget: budget,
                          transactions: budget.expenses,
                          month: month,
                          year: year,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
