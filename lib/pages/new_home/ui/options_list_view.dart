import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/pages/new_home/ui/savings_analysis_page.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';

class OptionsListView extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final List<IncomeModel> incomes;
  final List<CategorizedBudgetModel> budgetCategories;
  final double totalBudget;
  final String month;
  final String year;

  const OptionsListView(
      {Key? key,
      required this.expenses,
      required this.incomes,
      required this.budgetCategories,
      required this.totalBudget,
      required this.month,
      required this.year})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of setting items to display
    final List<Map<String, dynamic>> settingsItems = [
      {
        'icon': Icons.analytics,
        'iconBackgroundColor': Colors.blue.withOpacity(0.1),
        'iconColor': Colors.blue.shade600,
        'title': 'Savings Analysis',
        'showChevron': true,
        'textColor': Colors.black87,
        'onTap': () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SavingsAnalysisScreen(
                  month: month,
                  year: year,
                  budgetCategories: budgetCategories,
                  totalBudget: totalBudget,
                  expenses: expenses,
                  incomes: incomes,
                ),
              ));
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: settingsItems.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFEEEEEE),
        ),
        itemBuilder: (context, index) {
          final item = settingsItems[index];
          return UIUtils.buildSettingsItem(
            context,
            icon: item['icon'],
            iconBackgroundColor: item['iconBackgroundColor'],
            iconColor: item['iconColor'],
            title: item['title'],
            textColor: item['textColor'],
            showChevron: item['showChevron'],
            onTap: item['onTap'],
          );
        },
      ),
    );
  }
}
