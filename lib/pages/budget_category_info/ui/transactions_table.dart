import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';

class TransactionsTable extends StatefulWidget {
  TransactionsTable({super.key, required this.transactions});

  List<ExpenseModel> transactions;

  @override
  State<TransactionsTable> createState() => _TransactionsTableState();
}

class _TransactionsTableState extends State<TransactionsTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columnSpacing: 10,
        sortAscending: _sortAscending,
        sortColumnIndex: _sortColumnIndex,
        columns: [
          DataColumn(
            label: const SizedBox(
                child: Text('Date',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            onSort: (columnIndex, ascending) {
              _sortAscending = ascending;
              _sortColumnIndex = columnIndex;
              setState(() {
                widget.transactions.sort((a, b) {
                  if (ascending) {
                    return a.id.compareTo(b.id);
                  } else {
                    return b.id.compareTo(a.id);
                  }
                });
              });
            },
          ),
          DataColumn(
              label: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: const Text('Name',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
          DataColumn(
              numeric: true,
              label: const Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, ascending) {
                _sortAscending = ascending;
                _sortColumnIndex = columnIndex;
                setState(() {
                  widget.transactions.sort((a, b) {
                    if (ascending) {
                      return a.amount.compareTo(b.amount);
                    } else {
                      return b.amount.compareTo(a.amount);
                    }
                  });
                });
              }),
        ],
        rows: widget.transactions.map((item) {
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
