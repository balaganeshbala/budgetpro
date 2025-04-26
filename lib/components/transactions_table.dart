import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:intl/intl.dart';

class TransactionsTable extends StatefulWidget {
  final List<ExpenseModel> transactions;

  const TransactionsTable({
    super.key,
    required this.transactions,
  });

  @override
  State<TransactionsTable> createState() => _TransactionsTableState();
}

class _TransactionsTableState extends State<TransactionsTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = false;
  late List<ExpenseModel> _sortedTransactions;

  @override
  void initState() {
    super.initState();
    _sortedTransactions = List.from(widget.transactions);
    _sortData();
  }

  @override
  void didUpdateWidget(TransactionsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transactions != oldWidget.transactions) {
      _sortedTransactions = List.from(widget.transactions);
      _sortData();
    }
  }

  void _sortData() {
    if (_sortColumnIndex == 0) {
      // Sort by date
      _sortedTransactions.sort((a, b) {
        final dateA = Utils.parseDate(a.date);
        final dateB = Utils.parseDate(b.date);
        return _sortAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
      });
    } else if (_sortColumnIndex == 2) {
      // Sort by amount
      _sortedTransactions.sort((a, b) {
        return _sortAscending
            ? a.amount.compareTo(b.amount)
            : b.amount.compareTo(a.amount);
      });
    }
  }

  String _formatDate(String inputDate) {
    try {
      // First parse the date using Utils.parseDate which handles your app's date format
      final DateTime dateTime = Utils.parseDate(inputDate);
      // Then format it to dd/MM
      return DateFormat('dd/MM').format(dateTime);
    } catch (e) {
      // Fallback to original string if parsing fails
      return inputDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: widget.transactions.isEmpty
          ? _buildEmptyState()
          : _buildTransactionList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontFamily: "Sora",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: [
        // Table header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            children: [
              // Date column
              Expanded(
                flex: 2,
                child: _buildHeaderCell(
                  'Date',
                  onTap: () => _onSortColumn(0),
                  isActive: _sortColumnIndex == 0,
                  isAscending: _sortAscending && _sortColumnIndex == 0,
                ),
              ),

              // Name column
              const Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Amount column
              Expanded(
                flex: 2,
                child: _buildHeaderCell(
                  'Amount',
                  onTap: () => _onSortColumn(2),
                  isActive: _sortColumnIndex == 2,
                  isAscending: _sortAscending && _sortColumnIndex == 2,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ),

        // Divider
        const Divider(height: 1, thickness: 1),

        // Table body
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _sortedTransactions.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, thickness: 1),
          itemBuilder: (context, index) {
            final transaction = _sortedTransactions[index];
            return _buildTransactionRow(transaction);
          },
        ),
      ],
    );
  }

  Widget _buildHeaderCell(
    String title, {
    VoidCallback? onTap,
    bool isActive = false,
    bool isAscending = false,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: alignment == Alignment.centerRight
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Sora",
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? AppColors.primaryColor : Colors.black87,
              ),
            ),
            if (onTap != null && isActive)
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(ExpenseModel transaction) {
    return InkWell(
      onTap: () {
        // Optional: Handle transaction row tap if needed
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        color: Colors.white,
        child: Row(
          children: [
            // Date column
            Expanded(
              flex: 2,
              child: Text(
                _formatDate(transaction.date), // Use the formatted date
                style: const TextStyle(
                  fontFamily: "Sora",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),

            // Name column
            Expanded(
              flex: 4,
              child: Text(
                transaction.name,
                style: const TextStyle(
                  fontFamily: "Sora",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Amount column
            Expanded(
              flex: 2,
              child: Text(
                Utils.formatRupees(transaction.amount),
                style: const TextStyle(
                  fontFamily: "Sora",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSortColumn(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        // Reverse the sort direction
        _sortAscending = !_sortAscending;
      } else {
        // Sort by new column in descending order initially
        _sortColumnIndex = columnIndex;
        _sortAscending = false;
      }
      _sortData();
    });
  }
}
