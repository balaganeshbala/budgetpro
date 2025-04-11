import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/pages/budget_category_info/ui/budget_category_info_page.dart';
import 'package:budgetpro/pages/new_home/ui/budget_card_widget.dart';
import 'package:budgetpro/pages/new_home/ui/budget_list_widget.dart';
import 'package:budgetpro/pages/new_home/ui/recent_expenses.dart';
import 'package:budgetpro/pages/new_home/ui/section_header.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_bloc.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_state.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:budgetpro/widgets/month_selector/bloc/month_selector_bloc.dart';
import 'package:budgetpro/widgets/month_selector/ui/month_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  final _homeBloc = NewHomeBloc();
  final String initialMonth = Utils.getMonthAsShortText(DateTime.now());
  final String initialYear = '${DateTime.now().year}';

  @override
  void initState() {
    _homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  void goToDetailsPageForBudgetCategory(
      CategorizedBudgetModel budget, String month, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BudgetCategoryInfoPage(
                budget: budget, transactions: budget.expenses, month: month)));
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
                    preferredSize: const Size.fromHeight(
                        0), // Adjust the border thickness here
                    child: BlocProvider(
                        create: (context) => MonthSelectorBloc(
                            initialMonth, initialYear, DateTime.now()),
                        child:
                            BlocListener<MonthSelectorBloc, MonthSelectorState>(
                                listener: (context, state) {
                                  _homeBloc.add(HomeMonthYearChangedEvent(
                                      month: state.selectedMonth,
                                      year: state.selectedYear));
                                },
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 14),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/profile'); // Navigate to the profile screen
                                        },
                                        child: const Icon(
                                          Icons.account_circle,
                                          size: 50,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      const MonthSelectorWidget(),
                                    ],
                                  ),
                                )))))),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.shade200,
          child: SafeArea(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: () async {
                _homeBloc.add(HomeScreenRefreshedEvent());
              },
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    BlocConsumer(
                        bloc: _homeBloc,
                        listenWhen: (previous, current) =>
                            current is HomeBudgetCategoryItemTappedState,
                        buildWhen: (previous, current) =>
                            current is HomeContentState,
                        builder: (context, state) {
                          switch (state) {
                            case HomeLoadingState _:
                              return const SizedBox(
                                  height: 100,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.accentColor)));
                            case HomeLoadingSuccessState state:
                              final totalBudget = state.totalBudget;
                              final totalSpent = state.totalSpent;
                              final remaining = state.remaining;
                              final expenses = state.expenses;
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    const SectionHeader(text: 'Budget'),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                          right: 20,
                                          bottom: 20),
                                      child: BudgetCardWidget(
                                          totalBudget: totalBudget,
                                          totalSpent: totalSpent,
                                          remaining: remaining),
                                    ),
                                    const SizedBox(height: 10),
                                    const SectionHeader(text: 'Categories'),
                                    BudgetListWidget(
                                        budget: state.budgetCategories,
                                        homeBloc: _homeBloc),
                                    const SizedBox(height: 30),
                                    const SectionHeader(text: 'Expenses'),
                                    RecentExpensesView(
                                        expenses: expenses, homeBloc: _homeBloc)
                                  ]);
                            default:
                              return Container();
                          }
                        },
                        listener: (context, state) {
                          switch (state) {
                            case HomeBudgetCategoryItemTappedState state:
                              goToDetailsPageForBudgetCategory(
                                  state.budget, state.month, context);
                              break;
                            default:
                          }
                        }),
                  ])),
            ),
          ),
        ));
  }
}
