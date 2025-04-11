import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';

enum SortType {
  dateNewest,
  dateOldest,
  amountHighest,
  amountLowest,
}

class NewExpensesPage extends StatefulWidget {
  final List<ExpenseModel> expenses;

  const NewExpensesPage({super.key, required this.expenses});

  @override
  State<NewExpensesPage> createState() => _NewExpensesPageState();
}

class _NewExpensesPageState extends State<NewExpensesPage> {
  late List<ExpenseModel> _sortedExpenses;
  SortType _currentSortType = SortType.dateNewest;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora")),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        actions: [
          PopupMenuButton<SortType>(
            icon: const Icon(Icons.sort),
            onSelected: (SortType result) {
              setState(() {
                _currentSortType = result;
                _sortExpenses();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
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
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sort indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                physics: const AlwaysScrollableScrollPhysics(),
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
                    iconBackgroundColor: item.category.color.withOpacity(0.2),
                    iconColor: item.category.color,
                    title: item.name,
                    subtitle: item.date,
                    trailingText: Utils.formatRupees(item.amount),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
