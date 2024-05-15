import 'package:budgetpro/pages/new_expense/ui/new_expense_page.dart';
import 'package:budgetpro/pages/budget_category_info/ui/transactions_table.dart';
import 'package:budgetpro/pages/expenses/bloc/expenses_bloc.dart';
import 'package:budgetpro/pages/home/ui/section_header.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/widgets/year_and_month_selector_widget.dart';
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
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text('Expenses',
              style: TextStyle(fontWeight: FontWeight.bold)),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryColor, // Adjust the text color here
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(1), // Adjust the border thickness here
            child: Container(
              color: Colors.grey.shade300, // Set the color of the border here
              height: 1, // Adjust the height of the border here
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              BlocConsumer(
                  bloc: _expensesBloc,
                  listenWhen: (previous, current) =>
                      current is ExpensesMonthLoadedSuccessState,
                  buildWhen: (previous, current) =>
                      current is ExpensesMonthLoadedSuccessState,
                  builder: (context, state) {
                    switch (state) {
                      case ExpensesMonthLoadedSuccessState state:
                        return YearAndMonthSelectorWidget(
                            yearsList: state.yearsList,
                            monthsList: state.monthsList,
                            onYearChanged: (value) {
                              _expensesBloc
                                  .add(ExpensesYearChangedEvent(year: value));
                            },
                            onMonthChanged: (value) {
                              _expensesBloc
                                  .add(ExpensesMonthChangedEvent(month: value));
                            });
                      default:
                        return Container();
                    }
                  },
                  listener: (context, state) {}),
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
                                const SectionHeader(text: 'Expenses'),
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
