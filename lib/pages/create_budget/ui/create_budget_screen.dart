import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/pages/create_budget/bloc/create_budget_bloc.dart';
import 'package:budgetpro/pages/create_budget/bloc/create_budget_event.dart';
import 'package:budgetpro/pages/create_budget/bloc/create_budget_state.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/utits/utils.dart';

class CreateBudgetScreen extends StatelessWidget {
  const CreateBudgetScreen(
      {super.key, required this.month, required this.year});

  final String month;
  final String year;

  @override
  Widget build(BuildContext context) {
    final List<ExpenseCategory> categories =
        ExpenseCategoryExtension.getAllCategories();

    return BlocProvider(
      create: (context) => CreateBudgetBloc(categories: categories),
      child: CreateBudgetView(month: month, year: year, categories: categories),
    );
  }
}

class CreateBudgetView extends StatefulWidget {
  const CreateBudgetView({
    Key? key,
    required this.month,
    required this.year,
    required this.categories,
  }) : super(key: key);

  final String month;
  final String year;
  final List<ExpenseCategory> categories;

  @override
  State<CreateBudgetView> createState() => _CreateBudgetViewState();
}

class _CreateBudgetViewState extends State<CreateBudgetView> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each category
    for (var category in widget.categories) {
      final controller = TextEditingController();
      controller.addListener(() {
        _onAmountChanged(category.name, controller.text);
      });
      _controllers[category.name] = controller;
    }
  }

  void _onAmountChanged(String category, String value) {
    final amount = double.tryParse(value) ?? 0.0;
    context.read<CreateBudgetBloc>().add(
          BudgetAmountChanged(category: category, amount: amount),
        );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBudgetBloc, CreateBudgetState>(
      listener: (context, state) {
        if (state.status == BudgetStatus.success) {
          UIUtils.showSnackbar(context, 'Budget created successfully!',
              type: SnackbarType.success);
          Navigator.pop(context, true);
        } else if (state.status == BudgetStatus.failure &&
            state.errorMessage != null) {
          UIUtils.showSnackbar(context, state.errorMessage!,
              type: SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Monthly Budget',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora"),
          ),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Set your budget limits for ${widget.month}-${widget.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Sora",
                  ),
                ),
              ),
              // Total Budget Card
              BlocBuilder<CreateBudgetBloc, CreateBudgetState>(
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Budget',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Sora",
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Utils.formatRupees(state.totalBudget),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Sora",
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 24,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: widget.categories.length,
                  itemBuilder: (context, index) {
                    final category = widget.categories[index];
                    return _buildBudgetInputField(category);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AppThemeButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        text: 'Cancel',
                        primary: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BlocBuilder<CreateBudgetBloc, CreateBudgetState>(
                        builder: (context, state) {
                          return AppThemeButton(
                              text: state.status == BudgetStatus.loading
                                  ? 'Saving...'
                                  : 'Save Budget',
                              onPressed: state.status == BudgetStatus.loading
                                  ? null
                                  : () async {
                                      final confirm =
                                          await UIUtils.showConfirmationDialog(
                                              context,
                                              'Confirm Budget',
                                              'Are you sure you want to save this budget?');

                                      if (confirm == true) {
                                        if (context.mounted) {
                                          _saveBudget(context);
                                        }
                                      }
                                    });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetInputField(ExpenseCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                category.icon,
                size: 20,
                color: category.color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Sora",
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                controller: _controllers[category.name],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  isDense: true,
                  prefixText: '₹ ',
                  hintText: '0',
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Sora",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBudget(BuildContext context) {
    context.read<CreateBudgetBloc>().add(
          SaveBudget(month: widget.month, year: widget.year),
        );
  }
}
