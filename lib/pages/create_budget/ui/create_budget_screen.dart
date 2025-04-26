import 'package:budgetpro/components/budget_form_component.dart';
import 'package:budgetpro/pages/create_budget/bloc/create_budget_bloc.dart';
import 'package:budgetpro/pages/create_budget/bloc/create_budget_event.dart';
import 'package:budgetpro/pages/create_budget/bloc/create_budget_state.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/models/expense_category_enum.dart';

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
                  return BudgetTotalCard(totalBudget: state.totalBudget);
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: widget.categories.length,
                  itemBuilder: (context, index) {
                    final category = widget.categories[index];
                    return BudgetInputField(
                      category: category,
                      controller: _controllers[category.name]!,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<CreateBudgetBloc, CreateBudgetState>(
                builder: (context, state) {
                  return BudgetFormButtons(
                    onCancel: () => Navigator.pop(context, false),
                    onSubmit: () => _handleSubmit(state),
                    isLoading: state.status == BudgetStatus.loading,
                    submitText: 'Save',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(CreateBudgetState state) async {
    if (state.totalBudget == 0) {
      UIUtils.showSnackbar(context, 'Please add at least one budget amount',
          type: SnackbarType.error);
      return;
    }

    final confirm = await showBudgetConfirmationDialog(context,
        'Confirm Budget', 'Are you sure you want to save this budget?');

    if (confirm && context.mounted) {
      context.read<CreateBudgetBloc>().add(
            SaveBudget(month: widget.month, year: widget.year),
          );
    }
  }
}
