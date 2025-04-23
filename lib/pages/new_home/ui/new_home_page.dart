import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/pages/create_budget/ui/create_budget_screen.dart';
import 'package:budgetpro/pages/budget_category/ui/budget_category_info_page.dart';
import 'package:budgetpro/components/budget_card_widget.dart';
import 'package:budgetpro/pages/edit_budget/ui/edit_budget_page.dart';
import 'package:budgetpro/pages/new_home/ui/budget_categories_view.dart';
import 'package:budgetpro/pages/new_home/ui/recent_expenses.dart';
import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_bloc.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_state.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:budgetpro/widgets/month_selector/bloc/month_selector_bloc.dart';
import 'package:budgetpro/widgets/month_selector/ui/month_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  final String initialMonth = Utils.getMonthAsShortText(DateTime.now());
  final String initialYear = '${DateTime.now().year}';

  // Track current selected month/year
  String _selectedMonth = '';
  String _selectedYear = '';

  @override
  void initState() {
    context.read<NewHomeBloc>().add(HomeInitialEvent());
    _selectedMonth = initialMonth;
    _selectedYear = initialYear;
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

  bool _isCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime selectedDate =
        Utils.parseDate("${now.day} $_selectedMonth $_selectedYear");
    // check if two dates are in the same month and year
    if (selectedDate.year == now.year && selectedDate.month == now.month) {
      return true;
    }
    return false;
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
                    preferredSize: const Size.fromHeight(0),
                    child: BlocProvider(
                        create: (context) => MonthSelectorBloc(
                            initialMonth, initialYear, DateTime.now()),
                        child:
                            BlocListener<MonthSelectorBloc, MonthSelectorState>(
                                listener: (context, state) {
                                  _selectedMonth = state.selectedMonth;
                                  _selectedYear = state.selectedYear;
                                  context.read<NewHomeBloc>().add(
                                      HomeMonthYearChangedEvent(
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
                                          Navigator.pushNamed(
                                              context, '/profile');
                                        },
                                        child: const Icon(
                                          Icons.account_circle,
                                          size: 50,
                                          color: AppColors.accentColor,
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
              color: AppColors.accentColor,
              onRefresh: () async {
                context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
              },
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    BlocConsumer(
                        bloc: context.read<NewHomeBloc>(),
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
                            case HomeBudgetPendingState _:
                              if (_isCurrentMonth()) {
                                return _buildEmptyBudgetState(
                                    context, _selectedMonth, _selectedYear);
                              } else {
                                return _buildPastMonthNoBudgetState();
                              }
                            case HomeLoadingSuccessState state:
                              final totalBudget = state.totalBudget;
                              final totalSpent = state.totalSpent;
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
                                          bottom: 0),
                                      child: Column(
                                        children: [
                                          BudgetCardWidget(
                                              totalBudget: totalBudget,
                                              totalSpent: totalSpent,
                                              showEditButton: _isCurrentMonth(),
                                              onEditTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditBudgetScreen(
                                                              month:
                                                                  _selectedMonth,
                                                              year:
                                                                  _selectedYear,
                                                              currentBudget:
                                                                  state
                                                                      .budget)),
                                                ).then((value) {
                                                  if (value != null && value) {
                                                    if (context.mounted) {
                                                      // Refresh the screen when returning from create budget
                                                      context
                                                          .read<NewHomeBloc>()
                                                          .add(
                                                              HomeScreenRefreshedEvent());
                                                    }
                                                  }
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const SectionHeader(text: 'Expenses'),
                                    RecentExpensesView(expenses: expenses),
                                    const SizedBox(height: 20),
                                    const SectionHeader(text: 'Categories'),
                                    BudgetCategoriesView(
                                        budget: state.budgetCategories),
                                    const SizedBox(height: 20),
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

  Widget _buildEmptyBudgetState(
      BuildContext context, String month, String year) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Budget Set For This Month',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Sora",
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a monthly budget to track your spending and save more effectively',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: "Sora",
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateBudgetScreen(month: month, year: year)),
                ).then((value) {
                  if (value != null && value) {
                    if (context.mounted) {
                      // Refresh the screen when returning from create budget
                      context
                          .read<NewHomeBloc>()
                          .add(HomeScreenRefreshedEvent());
                    }
                  }
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                child: Center(
                  child: Text(
                    '+ Create Budget',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  // New widget for past months without budget
  Widget _buildPastMonthNoBudgetState() {
    return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No Budget Data Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Sora",
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Budget data for past months cannot be created. Please select the current month to set a budget.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: "Sora",
              ),
            ),
            SizedBox(height: 16),
          ],
        ));
  }
}
