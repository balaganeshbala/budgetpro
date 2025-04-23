import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/utits/utils.dart';

// Create a new bloc for edit budget functionality
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_bloc.dart';
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_event.dart';
import 'package:budgetpro/pages/edit_budget/bloc/edit_budget_state.dart';

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
            'Edit Monthly Budget',
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
                  itemCount: widget.currentBudget.length,
                  itemBuilder: (context, index) {
                    final budget = widget.currentBudget[
                        widget.currentBudget.keys.elementAt(index)]!;
                    return _buildBudgetInputField(budget.category);
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
                      child: BlocBuilder<EditBudgetBloc, EditBudgetState>(
                        builder: (context, state) {
                          return AppThemeButton(
                              text: state.status == EditBudgetStatus.loading
                                  ? 'Updating...'
                                  : 'Update',
                              onPressed: state.status ==
                                      EditBudgetStatus.loading
                                  ? null
                                  : () async {
                                      if (state.totalBudget == 0) {
                                        UIUtils.showSnackbar(
                                            context, 'Budget can\'t be zero',
                                            type: SnackbarType.error);
                                        return;
                                      }

                                      final updatedBudget = _getUpdatedBudget();
                                      if (updatedBudget.isEmpty) {
                                        UIUtils.showSnackbar(context,
                                            'No changes made to the budget',
                                            type: SnackbarType.error);
                                        return;
                                      }

                                      final confirm =
                                          await UIUtils.showConfirmationDialog(
                                              context,
                                              'Confirm Budget Update',
                                              'Are you sure you want to update this budget?');

                                      if (confirm == true) {
                                        if (context.mounted) {
                                          context.read<EditBudgetBloc>().add(
                                                UpdateBudget(
                                                    newBudgetItems:
                                                        updatedBudget),
                                              );
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
