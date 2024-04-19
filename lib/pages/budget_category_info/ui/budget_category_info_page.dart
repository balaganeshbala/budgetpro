import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/pages/home/ui/budget_card_widget.dart';
import 'package:budgetpro/pages/home/ui/section_header.dart';
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
        backgroundColor: const Color.fromARGB(255, 66, 143, 125),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionHeader(text: 'Budget for ${budget.category}'),
              Padding(
                padding: const EdgeInsets.all(20.0),
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

class TransactionsTable extends StatelessWidget {
  const TransactionsTable({
    super.key,
    required this.transactions,
  });

  final List<ExpenseModel> transactions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columnSpacing: 0,
        columns: [
          const DataColumn(
              label: SizedBox(
                  width: 100,
                  child: Text('Date',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          DataColumn(
              label: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: const Text('Name',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          const DataColumn(
              numeric: true,
              label: Text('Amount',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: transactions.map((item) {
          return DataRow(cells: [
            DataCell(Text(item.date ?? '')),
            DataCell(Text(item.name)),
            DataCell(
              Container(
                  alignment: Alignment.centerRight,
                  child: Text(UIUtils.formatRupees(item.amount),
                      textAlign: TextAlign.right)),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
