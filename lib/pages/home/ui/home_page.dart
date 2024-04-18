import 'package:budgetpro/pages/budget_category_info/ui/budget_category_info_page.dart';
import 'package:budgetpro/pages/home/bloc/home_bloc.dart';
import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/pages/home/ui/budget_card_widget.dart';
import 'package:budgetpro/pages/home/ui/budget_list_widget.dart';
import 'package:budgetpro/pages/home/ui/section_header.dart';
import 'package:budgetpro/pages/home/ui/year_and_month_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageModel {
  List<String> gridItems = [];
  bool networkError = false;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc();

  void goToDetailsPageForBudgetCategory(BudgetModel budget,
      List<ExpenseModel> transactions, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BudgetCategoryInfoPage(
                budget: budget, transactions: transactions)));
  }

  @override
  void initState() {
    _homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BudgetPro',
            style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 66, 143, 125),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              BlocConsumer(
                  bloc: _homeBloc,
                  listenWhen: (previous, current) =>
                      current is HomeMonthLoadedSuccessState,
                  buildWhen: (previous, current) =>
                      current is HomeMonthLoadedSuccessState,
                  builder: (context, state) {
                    switch (state) {
                      case HomeMonthLoadedSuccessState state:
                        return YearAndMonthSelectorWidget(
                            yearsList: state.yearsList,
                            monthsList: state.monthsList,
                            selectedYear: state.selectedYear,
                            selectedMonth: state.selectedMonth,
                            homeBloc: _homeBloc);
                      default:
                        return const Text('Default View');
                    }
                  },
                  listener: (context, state) {}),
              BlocConsumer(
                  bloc: _homeBloc,
                  listenWhen: (previous, current) =>
                      current is HomeBudgetCategoryItemTappedState,
                  buildWhen: (previous, current) => current is HomeBudgetState,
                  builder: (context, state) {
                    switch (state) {
                      case HomeBudgetLoadingState _:
                        return SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.orange)));
                      case HomeBudgetLoadingSuccessState state:
                        final totalBudget = state.totalBudget;
                        final totalSpent = state.totalSpent;
                        final remaining = state.remaining;
                        final month = state.month;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(text: 'Bugdet for $month'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 10, right: 20, bottom: 20),
                                child: BudgetCardWidget(
                                    totalBudget: totalBudget,
                                    totalSpent: totalSpent,
                                    remaining: remaining),
                              ),
                              const SizedBox(height: 20),
                              const SectionHeader(text: 'Categories'),
                              BudgetListWidget(
                                  budget: state.budget, homeBloc: _homeBloc),
                              const SizedBox(height: 20),
                            ]);
                      default:
                        return const Text('Budget View');
                    }
                  },
                  listener: (context, state) {
                    switch (state) {
                      case HomeBudgetCategoryItemTappedState state:
                        goToDetailsPageForBudgetCategory(
                            state.budget, state.transactions, context);
                        break;
                      default:
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
