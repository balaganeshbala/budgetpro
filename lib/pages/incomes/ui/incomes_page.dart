import 'package:budgetpro/pages/budget_category_info/ui/incomes_table.dart';
import 'package:budgetpro/pages/new_income/ui/new_income_page.dart';
import 'package:budgetpro/pages/incomes/bloc/incomes_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/widgets/month_selector/bloc/month_selector_bloc.dart';
import 'package:budgetpro/widgets/month_selector/ui/month_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({super.key});

  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Preserve state of the widget

  final _incomesBloc = IncomesBloc();

  @override
  void initState() {
    _incomesBloc.add(IncomesInitialEvent());
    super.initState();
  }

  void _goToAddIncomePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddIncomePage(incomesBloc: _incomesBloc)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  _incomesBloc.add(
                      IncomesMonthYearChangedEvent(month: month, year: year));
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
                            'Incomes',
                            style: TextStyle(
                                fontFamily: "Sora",
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
                  bloc: _incomesBloc,
                  listenWhen: (previous, current) =>
                      current is IncomesActionState,
                  buildWhen: (previous, current) =>
                      current is IncomesFetchState,
                  listener: (context, state) {
                    if (state is IncomesAddIncomeClickedState) {
                      _goToAddIncomePage(context);
                    }
                  },
                  builder: (context, state) {
                    switch (state) {
                      case IncomesLoadingState _:
                        return const SizedBox(
                            height: 100,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.accentColor)));
                      case IncomesLoadingSuccessState state:
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
                                    _incomesBloc
                                        .add(IncomesAddIncomeTappedEvent());
                                  },
                                  child: const Text(
                                    '+ Add New',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accentColor,
                                        fontFamily: "Sora"),
                                  ),
                                ),
                                const SizedBox(width: 20)
                              ]),
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: IncomesTable(incomes: state.incomes)),
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
