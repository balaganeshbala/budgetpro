import 'package:flutter/material.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/utits/network_services.dart';

class ExpensesListPage extends StatefulWidget {
  const ExpensesListPage({super.key, required this.month});

  final String month;

  @override
  State<ExpensesListPage> createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  List<DayWiseExpensesModel> _allExpenses = <DayWiseExpensesModel>[];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future fetchExpenses() async {
    final urlString =
        'https://cloudpigeon.cyclic.app/budgetpro/expenses?month=${widget.month}';
    List<dynamic> result =
        await NetworkCallService.instance.makeAPICall(urlString);
    final allExpenses =
        result.map((item) => DayWiseExpensesModel.fromJson(item)).toList();
    setState(() {
      _allExpenses = allExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.month)),
        body: ListView.builder(
            itemCount: _allExpenses.length,
            itemBuilder: (context, index) {
              final dayWiseExpenses = _allExpenses[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dayWiseExpenses.date,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dayWiseExpenses.expenses.length,
                    itemBuilder: (context, innerIndex) {
                      final expense = dayWiseExpenses.expenses[innerIndex];
                      return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(expense.name),
                              const Spacer(),
                              Text('₹ ${expense.amount.toStringAsFixed(2)}')
                            ],
                          ));
                    },
                  ),
                ],
              );
            }));
  }
}
