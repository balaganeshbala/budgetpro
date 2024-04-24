import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';

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
            DataCell(Text(item.date)),
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
