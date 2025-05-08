import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/pages/all_expenses/ui/all_expenses_page.dart';
import 'package:budgetpro/pages/add_expense/ui/add_expense_page.dart';
import 'package:budgetpro/pages/expense_details/ui/expense_details_page.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_bloc.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentExpensesView extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final String month;
  final String year;

  const RecentExpensesView(
      {super.key,
      required this.expenses,
      required this.month,
      required this.year});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Container(
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
        child: expenses.isEmpty
            ? _buildEmptyState(context)
            : _buildExpensesList(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Expenses Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "Sora",
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start tracking your expenses by adding your first entry',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: "Sora",
            ),
          ),
          const SizedBox(height: 24),
          // Add New centered text action in empty state
          UIUtils.centeredTextAction(
            context,
            text: '+ Add New',
            textColor: AppColors.accentColor,
            fontWeight: FontWeight.w600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpensePage(),
                ),
              ).then((value) {
                // Refresh the page after adding a new expense
                if (value != null && value) {
                  if (context.mounted) {
                    context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
                  }
                }
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExpensesList(BuildContext context) {
    // Calculate total item count: expenses (max 5) + action tiles (2)
    final int expenseCount = expenses.length > 5 ? 5 : expenses.length;
    final int totalItemCount =
        expenseCount + 2; // +2 for "View All" and "Add New" actions

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: totalItemCount,
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFEEEEEE),
        );
      },
      itemBuilder: (context, index) {
        // Display expense items
        if (index < expenseCount) {
          final item = expenses[expenses.length - index - 1];
          return UIUtils.transactionListItem(
            context,
            icon: item.category.icon,
            iconBackgroundColor: item.category.color.withOpacity(0.2),
            iconColor: item.category.color,
            title: item.name,
            subtitle: item.date,
            trailingText: Utils.formatRupees(item.amount),
            onTap: () => _navigateToExpenseDetails(context, item),
          );
        }
        // Display "Add New" action with centered text
        else if (index == expenseCount) {
          return UIUtils.centeredTextAction(
            context,
            text: '+ Add New',
            textColor: AppColors.accentColor,
            fontWeight: FontWeight.w600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpensePage(),
                ),
              ).then((value) {
                if (value != null && value) {
                  if (context.mounted) {
                    // Refresh the page after adding a new expense
                    context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
                  }
                }
              });
            },
          );
        }
        // Display "More Details" action with centered text
        else {
          return UIUtils.centeredTextAction(
            context,
            text: 'More Details',
            textColor: AppColors.accentColor,
            fontWeight: FontWeight.w600,
            onTap: () {
              // Navigate to AllExpensesPage when "View All" is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllExpensesPage(
                      expenses: expenses, month: month, year: year),
                ),
              ).then((value) {
                // Refresh if expenses were updated
                if (value == true && context.mounted) {
                  context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
                }
              });
            },
          );
        }
      },
    );
  }

  // Navigate to expense details when an expense item is tapped
  Future<void> _navigateToExpenseDetails(
      BuildContext context, ExpenseModel expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailsPage(expense: expense),
      ),
    );

    // Refresh the home screen if the expense was updated or deleted
    if (result == true && context.mounted) {
      context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
    }
  }
}
