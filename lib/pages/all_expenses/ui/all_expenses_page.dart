import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/pages/expense_details/ui/expense_details_page.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';

enum SortType {
  dateNewest,
  dateOldest,
  amountHighest,
  amountLowest,
}

class AllExpensesPage extends StatefulWidget {
  final List<ExpenseModel> expenses;
  final String month;
  final String year;

  const AllExpensesPage(
      {super.key,
      required this.expenses,
      required this.month,
      required this.year});

  @override
  State<AllExpensesPage> createState() => _AllExpensesPageState();
}

class _AllExpensesPageState extends State<AllExpensesPage> {
  late List<ExpenseModel> _sortedExpenses;
  SortType _currentSortType = SortType.dateNewest;
  bool _shouldRefresh = false;

  @override
  void initState() {
    super.initState();
    _sortedExpenses = List.from(widget.expenses);
    _sortExpenses();
  }

  void _sortExpenses() {
    switch (_currentSortType) {
      case SortType.dateNewest:
        _sortedExpenses.sort((a, b) =>
            Utils.parseDate(b.date).compareTo(Utils.parseDate(a.date)));
        break;
      case SortType.dateOldest:
        _sortedExpenses.sort((a, b) =>
            Utils.parseDate(a.date).compareTo(Utils.parseDate(b.date)));
        break;
      case SortType.amountHighest:
        _sortedExpenses.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortType.amountLowest:
        _sortedExpenses.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow normal back button behavior
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // When back button pressed, pass the refresh flag to previous screen
        Navigator.of(context).pop(_shouldRefresh);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.month} ${widget.year}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: "Sora")),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
        ),
        body: Container(
          color: Colors.grey.shade200,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const SectionHeader(text: 'Expense Summary'),
                  // Expense Summary Widget
                  ExpenseSummaryWidget(expenses: widget.expenses),

                  const SizedBox(height: 16),
                  // Sort indicator
                  Row(children: [
                    const SectionHeader(text: 'All Expenses'),
                    const Spacer(),
                    PopupMenuButton<SortType>(
                      icon: const Icon(Icons.sort),
                      onSelected: (SortType result) {
                        setState(() {
                          _currentSortType = result;
                          _sortExpenses();
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SortType>>[
                        const PopupMenuItem<SortType>(
                          value: SortType.dateNewest,
                          child: Text('Date (Newest First)'),
                        ),
                        const PopupMenuItem<SortType>(
                          value: SortType.dateOldest,
                          child: Text('Date (Oldest First)'),
                        ),
                        const PopupMenuItem<SortType>(
                          value: SortType.amountHighest,
                          child: Text('Amount (Highest First)'),
                        ),
                        const PopupMenuItem<SortType>(
                          value: SortType.amountLowest,
                          child: Text('Amount (Lowest First)'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                  ]),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Sorted by: ',
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _getSortTypeText(),
                          style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expenses list
                  Container(
                    color: Colors.white,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _sortedExpenses.length,
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
                        final item = _sortedExpenses[index];
                        return _expenseItem(
                          context,
                          icon: item.category.icon,
                          iconBackgroundColor:
                              item.category.color.withOpacity(0.2),
                          iconColor: item.category.color,
                          title: item.name,
                          subtitle: item.date,
                          trailingText: Utils.formatRupees(item.amount),
                          onTap: () => _navigateToExpenseDetails(item),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToExpenseDetails(ExpenseModel expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailsPage(expense: expense),
      ),
    );

    // If there was a change (update or delete), set the flag to refresh parent
    if (result == true && mounted) {
      setState(() {
        _shouldRefresh = true;
      });

      Navigator.pop(context, true);
    }
  }

  String _getSortTypeText() {
    switch (_currentSortType) {
      case SortType.dateNewest:
        return 'Date (Newest First)';
      case SortType.dateOldest:
        return 'Date (Oldest First)';
      case SortType.amountHighest:
        return 'Amount (Highest First)';
      case SortType.amountLowest:
        return 'Amount (Lowest First)';
    }
  }

  Widget _expenseItem(
    BuildContext context, {
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? trailingText,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w400,
                        color: textColor ?? Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseSummaryWidget extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ExpenseSummaryWidget({Key? key, required this.expenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total expenses
    double totalExpense =
        expenses.fold(0, (sum, expense) => sum + expense.amount);

    // Process expenses by category
    Map<ExpenseCategory, double> categoryTotals = {};
    for (var expense in expenses) {
      if (categoryTotals.containsKey(expense.category)) {
        categoryTotals[expense.category] =
            categoryTotals[expense.category]! + expense.amount;
      } else {
        categoryTotals[expense.category] = expense.amount;
      }
    }

    // Sort categories by amount (descending)
    List<MapEntry<ExpenseCategory, double>> sortedCategories =
        categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total expense section
          Text(
            'Total Expenses',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Sora",
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Utils.formatRupees(totalExpense),
            style: const TextStyle(
              fontSize: 24,
              fontFamily: "Sora",
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor,
            ),
          ),
          const SizedBox(height: 24),

          // Category breakdown header
          Text(
            'Expenses by Category',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Sora",
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),

          // Category breakdown list
          if (expenses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'No expense data to display',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Sora",
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sortedCategories.length,
              itemBuilder: (context, index) {
                final category = sortedCategories[index].key;
                final amount = sortedCategories[index].value;
                final percent = (amount / totalExpense) * 100;

                return _buildCategoryItem(
                  category: category,
                  amount: amount,
                  percent: percent,
                );
              },
            )
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required ExpenseCategory category,
    required double amount,
    required double percent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon,
              size: 18,
              color: category.color,
            ),
          ),
          const SizedBox(width: 12),

          // Category name
          Expanded(
            flex: 3,
            child: Text(
              category.displayName,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Sora",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Amount
          Expanded(
            flex: 3,
            child: Text(
              Utils.formatRupees(amount),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Sora",
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          // Percentage
          Expanded(
            flex: 2,
            child: Text(
              '${percent.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Sora",
                fontWeight: FontWeight.w500,
                color: AppColors.accentColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
