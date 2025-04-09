import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/pages/budget_category_info/ui/transactions_table.dart';
import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/pages/new_home/ui/budget_card_widget.dart';
import 'package:budgetpro/pages/new_home/ui/section_header.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';

class BudgetCategoryInfoPage extends StatelessWidget {
  final CategorizedBudgetModel budget;
  final List<ExpenseModel> transactions;
  final String month;

  const BudgetCategoryInfoPage(
      {super.key,
      required this.budget,
      required this.transactions,
      required this.month});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(month,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "Sora")),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      const SectionHeader(text: 'Budget'),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 20),
                        child: BudgetCardWidget(
                            totalBudget: budget.budgetAmount.toDouble(),
                            totalSpent: budget.spentAmount,
                            remaining:
                                budget.budgetAmount - budget.spentAmount),
                      ),
                      const SizedBox(height: 10),
                      const SectionHeader(text: 'Transactions'),
                      const SizedBox(height: 10),
                      transactions.isEmpty
                          ? Container(
                              padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: const Text('No transactions yet.'))
                          : TransactionsTable(transactions: transactions)
                    ]),
              ),
              CategoryHeader(category: budget.category),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({super.key, required this.category});

  final ExpenseCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 4, // Blur radius
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: category.color.withAlpha(40),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            padding: const EdgeInsets.all(5),
            child: Icon(category.icon, color: category.color),
          ),
          const SizedBox(width: 15),
          Text(
            category.displayName,
            style: const TextStyle(
              fontFamily: "Sora",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
