import 'package:budgetpro/components/budget_form_component.dart';
import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_bloc.dart';
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_event.dart';
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_state.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetpro/utits/colors.dart';

class EditBudgetScreen extends StatelessWidget {
  const EditBudgetScreen(
      {super.key,
      required this.month,
      required this.year,
      required this.currentBudget});

  final String month;
  final String year;
  final List<BudgetModel> currentBudget;

  @override
  Widget build(BuildContext context) {
    Map<String, BudgetModel> currentBudgetMap = {};
    for (var budget in currentBudget) {
      currentBudgetMap[budget.category.name] = budget;
    }

    return BlocProvider(
      create: (context) => EditBudgetBloc(),
      child: EditBudgetView(
          month: month, year: year, currentBudget: currentBudgetMap),
    );
  }
}

class EditBudgetView extends StatefulWidget {
  const EditBudgetView({
    Key? key,
    required this.month,
    required this.year,
    required this.currentBudget,
  }) : super(key: key);

  final String month;
  final String year;
  final Map<String, BudgetModel> currentBudget;

  @override
  State<EditBudgetView> createState() => _EditBudgetViewState();
}

class _EditBudgetViewState extends State<EditBudgetView> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    context.read<EditBudgetBloc>().add(
          EditBudgetInitialEvent(budgetItems: widget.currentBudget),
        );

    // Initialize controllers for each category with existing values
    widget.currentBudget.forEach((category, budget) {
      final existingAmount = budget.amount;
      // Initialize the controller with the existing amount
      final controller = TextEditingController(
          text: existingAmount > 0 ? existingAmount.toStringAsFixed(0) : '');

      controller.addListener(() {
        // Update the budget amount in the bloc when the text changes
        context.read<EditBudgetBloc>().add(
              EditBudgetAmountChanged(
                category: category,
                amount: double.tryParse(controller.text) ?? 0.0,
              ),
            );
      });
      _controllers[category] = controller;
    });
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
    return BlocListener<EditBudgetBloc, EditBudgetState>(
      listener: (context, state) {
        if (state.status == EditBudgetStatus.success) {
          UIUtils.showSnackbar(context, 'Budget updated successfully!',
              type: SnackbarType.success);
          Navigator.pop(context, true);
        } else if (state.status == EditBudgetStatus.failure &&
            state.errorMessage != null) {
          UIUtils.showSnackbar(context, state.errorMessage!,
              type: SnackbarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Budget',
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
                  'Update your budget limits for ${widget.month}-${widget.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Sora",
                  ),
                ),
              ),
              // Total Budget Card
              BlocBuilder<EditBudgetBloc, EditBudgetState>(
                builder: (context, state) {
                  return BudgetTotalCard(totalBudget: state.totalBudget);
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: widget.currentBudget.length,
                  itemBuilder: (context, index) {
                    final category = widget.currentBudget.keys.elementAt(index);
                    final budget = widget.currentBudget[category]!;
                    return BudgetInputField(
                      category: budget.category,
                      controller: _controllers[category]!,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<EditBudgetBloc, EditBudgetState>(
                builder: (context, state) {
                  return BudgetFormButtons(
                    onCancel: () => Navigator.pop(context, false),
                    onSubmit: () => _handleSubmit(state),
                    isLoading: state.status == EditBudgetStatus.loading,
                    submitText: 'Update',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(EditBudgetState state) async {
    if (state.totalBudget == 0) {
      UIUtils.showSnackbar(context, 'Budget can\'t be zero',
          type: SnackbarType.error);
      return;
    }

    final updatedBudget = _getUpdatedBudget();
    if (updatedBudget.isEmpty) {
      UIUtils.showSnackbar(context, 'No changes made to the budget',
          type: SnackbarType.error);
      return;
    }

    final confirm = await showBudgetConfirmationDialog(
        context,
        'Confirm Budget Update',
        'Are you sure you want to update this budget?');

    if (confirm && context.mounted) {
      context.read<EditBudgetBloc>().add(
            UpdateBudget(newBudgetItems: updatedBudget),
          );
    }
  }

  List<BudgetModel> _getUpdatedBudget() {
    List<BudgetModel> updatedBudget = [];
    for (var entry in _controllers.entries) {
      final category = entry.key;
      final controller = entry.value;
      final amount = double.tryParse(controller.text) ?? 0.0;
      final budget = widget.currentBudget[category];
      if (budget != null && budget.amount != amount) {
        updatedBudget.add(
          budget.copyWith(
            amount: amount,
          ),
        );
      }
    }

    return updatedBudget;
  }
}
