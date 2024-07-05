import 'package:budgetpro/pages/budget_category_info/ui/budget_category_info_page.dart';
import 'package:budgetpro/pages/home/bloc/home_bloc.dart';
import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/pages/home/ui/budget_card_widget.dart';
import 'package:budgetpro/pages/home/ui/budget_list_widget.dart';
import 'package:budgetpro/pages/home/ui/budget_trend_line_chart.dart';
import 'package:budgetpro/pages/home/ui/section_header.dart';
import 'package:budgetpro/widgets/month_selector/bloc/month_selector_bloc.dart';
import 'package:budgetpro/widgets/month_selector/ui/month_selector_widget.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Preserve state of the widget

  final _homeBloc = HomeBloc();

  void goToDetailsPageForBudgetCategory(BudgetModel budget,
      List<ExpenseModel> transactions, String month, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BudgetCategoryInfoPage(
                budget: budget, transactions: transactions, month: month)));
  }

  @override
  void initState() {
    _homeBloc.add(HomeInitialEvent());
    super.initState();
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
                  _homeBloc.add(HomeMonthYearChangedEvent(
                      month: state.selectedMonth, year: state.selectedYear));
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
                            'Budget',
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
              BlocConsumer(
                  bloc: _homeBloc,
                  listenWhen: (previous, current) =>
                      current is HomeBudgetCategoryItemTappedState,
                  buildWhen: (previous, current) => current is HomeBudgetState,
                  builder: (context, state) {
                    switch (state) {
                      case HomeBudgetLoadingState _:
                        return const SizedBox(
                            height: 100,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.accentColor)));
                      case HomeBudgetLoadingSuccessState state:
                        final totalBudget = state.totalBudget;
                        final totalSpent = state.totalSpent;
                        final remaining = state.remaining;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 20, right: 20, bottom: 20),
                                child: BudgetCardWidget(
                                    totalBudget: totalBudget,
                                    totalSpent: totalSpent,
                                    remaining: remaining),
                              ),
                              const SizedBox(height: 10),
                              const SectionHeader(text: 'Categories'),
                              BudgetListWidget(
                                  budget: state.budget, homeBloc: _homeBloc),
                              const SizedBox(height: 20),
                            ]);
                      default:
                        return Container();
                    }
                  },
                  listener: (context, state) {
                    switch (state) {
                      case HomeBudgetCategoryItemTappedState state:
                        goToDetailsPageForBudgetCategory(state.budget,
                            state.transactions, state.month, context);
                        break;
                      default:
                    }
                  }),
              BlocBuilder(
                  bloc: _homeBloc,
                  buildWhen: (previous, current) =>
                      current is HomeBudgetTrendState,
                  builder: (context, state) {
                    switch (state) {
                      case HomeBudgetTrendLoadingState _:
                        return const SizedBox(
                            height: 100,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.accentColor)));
                      case HomeBudgetTrendSuccessState state:
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.monthlyBudget.isNotEmpty
                                ? [
                                    const SizedBox(height: 10),
                                    const SectionHeader(text: 'Bugdet Trend'),
                                    const SizedBox(height: 10),
                                    BudgetTrendLineChart(
                                      data:
                                          state.monthlyBudget.reversed.toList(),
                                    ),
                                    const SizedBox(height: 20),
                                  ]
                                : []);
                      default:
                        return Container();
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
