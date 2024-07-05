import 'package:budgetpro/pages/new_expense/ui/new_expense_page.dart';
import 'package:budgetpro/pages/budget_category_info/ui/transactions_table.dart';
import 'package:budgetpro/pages/expenses/bloc/expenses_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/widgets/month_selector/bloc/month_selector_bloc.dart';
import 'package:budgetpro/widgets/month_selector/ui/month_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Preserve state of the widget

  final _expensesBloc = ExpensesBloc();

  @override
  void initState() {
    _expensesBloc.add(ExpensesInitialEvent());
    super.initState();
  }

  void _goToAddExpensePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddExpensePage(expensesBloc: _expensesBloc)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        child: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(0), // Adjust the border thickness here
            child: BlocListener<MonthSelectorBloc, MonthSelectorState>(
                listener: (context, state) {
                  String month = state.selectedMonth;
                  String year = state.selectedYear;
                  _expensesBloc.add(
                      ExpensesMonthYearChangedEvent(month: month, year: year));
                },
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 14),
                      child: const Row(
                        children: [
                          Text(
                            'Expenses',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor),
                          ),
                          Spacer(),
                          MonthSelectorWidget(),
                        ],
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    )),
                  ],
                )),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 10),
              BlocConsumer(
                  bloc: _expensesBloc,
                  listenWhen: (previous, current) =>
                      current is ExpensesActionState,
                  buildWhen: (previous, current) =>
                      current is ExpensesFetchState,
                  listener: (context, state) {
                    if (state is ExpenesesAddExpenseClickedState) {
                      _goToAddExpensePage(context);
                    }
                  },
                  builder: (context, state) {
                    switch (state) {
                      case ExpensesLoadingState _:
                        return const SizedBox(
                            height: 100,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.accentColor)));
                      case ExpensesLoadingSuccessState state:
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Spacer(),
                                TextButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll<Color>(
                                              Colors.white)),
                                  onPressed: () {
                                    _expensesBloc
                                        .add(ExpensesAddExpenseTappedEvent());
                                  },
                                  child: const Text(
                                    '+ Add New',
                                    style:
                                        TextStyle(color: AppColors.accentColor),
                                  ),
                                ),
                                const SizedBox(width: 20)
                              ]),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TransactionsTable(
                                      transactions: state.expenses)),
                            ]);
                      default:
                        return Container();
                    }
                  })
            ]),
          ),
        ),
      ),
    );
  }
}
