import 'package:budgetpro/pages/budget_category_info/ui/transactions_table.dart';
import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/pages/home/ui/budget_card_widget.dart';
import 'package:budgetpro/pages/home/ui/section_header.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';

class BudgetCategoryInfoPage extends StatelessWidget {
  final BudgetModel budget;
  final List<ExpenseModel> transactions;

  const BudgetCategoryInfoPage(
      {super.key, required this.budget, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Info',
            style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(UIUtils.iconForCategory(budget.category),
                          size: 40, color: AppColors.iconColor),
                      const SizedBox(width: 10),
                      Text(
                        budget.category,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SectionHeader(text: 'Budget'),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 10, right: 20, bottom: 20),
                child: BudgetCardWidget(
                    totalBudget: budget.budgetAmount.toDouble(),
                    totalSpent: budget.spentAmount,
                    remaining: budget.budgetAmount - budget.spentAmount),
              ),
              const SectionHeader(text: 'Transactions'),
              TransactionsTable(transactions: transactions)
            ]),
          ),
        ),
      ),
    );
  }
}
