import 'package:budgetpro/pages/home/models/incomes_model.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';

class IncomesTable extends StatefulWidget {
  const IncomesTable({super.key, required this.incomes});

  final List<IncomeModel> incomes;

  @override
  State<IncomesTable> createState() => _IncomesTableState();
}

class _IncomesTableState extends State<IncomesTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: DataTable(
        columnSpacing: 10,
        sortAscending: _sortAscending,
        sortColumnIndex: _sortColumnIndex,
        columns: [
          DataColumn(
              label: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: const Text('Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "Sora")))),
          DataColumn(
              numeric: true,
              label: const Text('Amount',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "Sora")),
              onSort: (columnIndex, ascending) {
                _sortAscending = ascending;
                _sortColumnIndex = columnIndex;
                setState(() {
                  widget.incomes.sort((a, b) {
                    if (ascending) {
                      return a.amount.compareTo(b.amount);
                    } else {
                      return b.amount.compareTo(a.amount);
                    }
                  });
                });
              }),
        ],
        rows: widget.incomes.map((item) {
          return DataRow(cells: [
            DataCell(
                Text(item.name, style: const TextStyle(fontFamily: "Sora"))),
            DataCell(
              Container(
                  alignment: Alignment.centerRight,
                  child: Text(UIUtils.formatRupees(item.amount),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontFamily: "Sora"))),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
