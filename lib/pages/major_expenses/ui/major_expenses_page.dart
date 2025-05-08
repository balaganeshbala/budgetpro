import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/models/major_expense_category_enum.dart';
import 'package:budgetpro/models/major_expense_model.dart';
import 'package:budgetpro/pages/major_expenses/bloc/major_expenses_bloc.dart';
import 'package:budgetpro/pages/major_expenses/ui/add_major_expense_page.dart';
import 'package:budgetpro/pages/major_expenses/ui/edit_major_expense_page.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MajorExpensesPage extends StatefulWidget {
  const MajorExpensesPage({Key? key}) : super(key: key);

  @override
  State<MajorExpensesPage> createState() => _MajorExpensesPageState();
}

class _MajorExpensesPageState extends State<MajorExpensesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MajorExpensesBloc>().add(MajorExpensesInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Major Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Sora",
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        focusElevation: 2,
        highlightElevation: 2,
        elevation: 2,
        onPressed: () => _navigateToAddExpense(context),
        backgroundColor: AppColors.accentColor,
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<MajorExpensesBloc, MajorExpensesState>(
        listener: (context, state) {
          if (state is MajorExpensesActionState) {
            if (state is MajorExpenseDetailsClickedState) {
              _navigateToExpenseDetails(context, state.expense);
            }
          }
        },
        builder: (context, state) {
          if (state is MajorExpensesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentColor),
            );
          } else if (state is MajorExpensesLoadedState) {
            final expenses = state.expenses;
            final totalAmount = state.totalAmount;
            return _buildContent(context, expenses, totalAmount);
          } else {
            return const Center(
              child: Text('Something went wrong',
                  style: TextStyle(fontFamily: "Sora")),
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<MajorExpenseModel> expenses,
      double totalAmount) {
    return Container(
      color: Colors.grey.shade200,
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<MajorExpensesBloc>().add(MajorExpensesRefreshEvent());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              const SizedBox(height: 16),
              const SectionHeader(text: 'Summary'),
              _buildSummaryCard(totalAmount),

              // Expenses List Section
              const SizedBox(height: 10),
              const SectionHeader(text: 'All Expenses'),
              const SizedBox(height: 10),
              expenses.isEmpty
                  ? _buildEmptyState(context)
                  : _buildExpensesList(context, expenses),
              const SizedBox(height: 80), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double totalAmount) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Major Expenses',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              Utils.formatRupees(totalAmount),
              style: const TextStyle(
                fontFamily: "Sora",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList(
      BuildContext context, List<MajorExpenseModel> expenses) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: expenses.length,
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
          final item = expenses[index];
          return UIUtils.transactionListItem(
            context,
            icon: item.category.icon,
            iconBackgroundColor: item.category.color.withAlpha(50),
            iconColor: item.category.color,
            title: item.name,
            subtitle: item.date,
            trailingText: Utils.formatRupees(item.amount),
            onTap: () {
              context.read<MajorExpensesBloc>().add(
                    MajorExpenseDetailsClickedEvent(expense: item),
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Major Expenses Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Sora",
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your significant expenses like vehicle purchases, medical procedures, etc.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: "Sora",
              ),
            ),
            const SizedBox(height: 24),
            UIUtils.centeredTextAction(context,
                text: '+ Add New',
                textColor: AppColors.accentColor,
                fontWeight: FontWeight.w600, onTap: () {
              _navigateToAddExpense(context);
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToAddExpense(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMajorExpensePage(),
      ),
    );

    if (result == true && context.mounted) {
      context.read<MajorExpensesBloc>().add(MajorExpensesRefreshEvent());
    }
  }

  Future<void> _navigateToExpenseDetails(
      BuildContext context, MajorExpenseModel expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMajorExpensePage(expense: expense),
      ),
    );

    if (result == true && context.mounted) {
      context.read<MajorExpensesBloc>().add(MajorExpensesRefreshEvent());
    }
  }
}
