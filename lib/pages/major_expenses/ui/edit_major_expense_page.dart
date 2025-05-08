import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/models/major_expense_category_enum.dart';
import 'package:budgetpro/models/major_expense_model.dart';
import 'package:budgetpro/pages/major_expenses/bloc/edit_major_expense_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditMajorExpensePage extends StatefulWidget {
  final MajorExpenseModel expense;

  const EditMajorExpensePage({super.key, required this.expense});

  @override
  State<EditMajorExpensePage> createState() => _EditMajorExpensePageState();
}

class _EditMajorExpensePageState extends State<EditMajorExpensePage> {
  late EditMajorExpenseBloc _editMajorExpenseBloc;
  final _nameTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  final _notesTextEditingController = TextEditingController();

  bool _shouldRefresh = false;

  @override
  void initState() {
    super.initState();
    _editMajorExpenseBloc = EditMajorExpenseBloc();
    _editMajorExpenseBloc
        .add(EditMajorExpenseInitialEvent(expense: widget.expense));

    // Populate text fields with existing data
    _nameTextEditingController.text = widget.expense.name;
    _amountTextEditingController.text = widget.expense.amount.toString();
    _notesTextEditingController.text = widget.expense.notes ?? '';
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _amountTextEditingController.dispose();
    _notesTextEditingController.dispose();
    _editMajorExpenseBloc.close();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await UIUtils.showConfirmationDialog(
      context,
      'Delete Expense',
      'Are you sure you want to delete this expense? This action cannot be undone.',
    );

    if (confirm && context.mounted) {
      _editMajorExpenseBloc.add(EditMajorExpenseDeleteEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_shouldRefresh,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_shouldRefresh);
      },
      child: BlocProvider(
        create: (context) => _editMajorExpenseBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Expense',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Sora",
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context),
                tooltip: 'Delete Expense',
              ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Stack(
              children: [
                // Background Design Element
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<EditMajorExpenseBloc, EditMajorExpenseState>(
                  buildWhen: (previous, current) =>
                      current is EditMajorExpenseLoadedState,
                  builder: (context, state) {
                    return SafeArea(
                      child: BlocListener<EditMajorExpenseBloc,
                          EditMajorExpenseState>(
                        listener: (context, state) {
                          if (state is EditMajorExpenseSuccessState) {
                            setState(() {
                              _shouldRefresh = true;
                            });

                            UIUtils.showSnackbar(
                              context,
                              'Expense updated successfully!',
                              type: SnackbarType.success,
                            );

                            // Add a short delay before navigating back
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            });
                          } else if (state is EditMajorExpenseErrorState) {
                            UIUtils.showSnackbar(
                              context,
                              state.error,
                              type: SnackbarType.error,
                            );
                          } else if (state is EditMajorExpenseDeletedState) {
                            setState(() {
                              _shouldRefresh = true;
                            });

                            UIUtils.showSnackbar(
                              context,
                              'Expense deleted successfully!',
                              type: SnackbarType.success,
                            );

                            // Add a short delay before navigating back
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            });
                          }
                        },
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),

                                  // Name Field
                                  ExpenseNameField(
                                    nameTextEditingController:
                                        _nameTextEditingController,
                                    editMajorExpenseBloc: _editMajorExpenseBloc,
                                  ),
                                  const SizedBox(height: 20),

                                  // Amount Field
                                  ExpenseAmountField(
                                    amountTextEditingController:
                                        _amountTextEditingController,
                                    editMajorExpenseBloc: _editMajorExpenseBloc,
                                  ),
                                  const SizedBox(height: 20),

                                  // Category Selector
                                  ExpenseCategorySelector(
                                    initialCategory: widget.expense.category,
                                    categories:
                                        state is EditMajorExpenseLoadedState
                                            ? state.categories
                                            : MajorExpenseCategoryExtension
                                                .getAllCategories(),
                                    editMajorExpenseBloc: _editMajorExpenseBloc,
                                  ),
                                  const SizedBox(height: 20),

                                  // Date Selector
                                  ExpenseDateSelector(
                                    initialDate:
                                        Utils.parseDate(widget.expense.date),
                                    editMajorExpenseBloc: _editMajorExpenseBloc,
                                  ),
                                  const SizedBox(height: 20),

                                  // Notes Field
                                  NotesField(
                                    notesTextEditingController:
                                        _notesTextEditingController,
                                    editMajorExpenseBloc: _editMajorExpenseBloc,
                                  ),
                                  const SizedBox(height: 30),

                                  // Update Button
                                  UpdateExpenseButton(
                                    editMajorExpenseBloc: _editMajorExpenseBloc,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Status overlay
                BlocBuilder<EditMajorExpenseBloc, EditMajorExpenseState>(
                  buildWhen: (previous, current) =>
                      current is EditMajorExpenseLoadingState,
                  builder: (context, state) {
                    if (state is EditMajorExpenseLoadingState) {
                      return Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentColor,
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateExpenseButton extends StatelessWidget {
  const UpdateExpenseButton({
    super.key,
    required EditMajorExpenseBloc editMajorExpenseBloc,
  }) : _editMajorExpenseBloc = editMajorExpenseBloc;

  final EditMajorExpenseBloc _editMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditMajorExpenseBloc, EditMajorExpenseState>(
      buildWhen: (previous, current) =>
          current is EditMajorExpenseInputValueChangedState,
      builder: (context, state) {
        bool isInputValid = state is EditMajorExpenseInputValueChangedState
            ? state.isInputValid
            : true; // Default to true since we're editing existing data
        return SizedBox(
          width: double.infinity,
          height: 55,
          child: AppThemeButton(
            onPressed: isInputValid
                ? () async {
                    final confirm = await UIUtils.showConfirmationDialog(
                      context,
                      'Update Expense',
                      'Are you sure you want to update this expense?',
                    );

                    if (confirm) {
                      _editMajorExpenseBloc.add(EditMajorExpenseUpdateEvent());
                    }
                  }
                : null,
            text: 'Update Expense',
          ),
        );
      },
    );
  }
}

class ExpenseDateSelector extends StatelessWidget {
  final DateTime initialDate;

  const ExpenseDateSelector({
    super.key,
    required EditMajorExpenseBloc editMajorExpenseBloc,
    required this.initialDate,
  }) : _editMajorExpenseBloc = editMajorExpenseBloc;

  final EditMajorExpenseBloc _editMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.black54,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            'Date',
            style: TextStyle(
              fontFamily: "Sora",
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Container(
            width: 150,
            margin: const EdgeInsets.only(left: 8),
            child: DatePickerWidget(
              defaultDate: initialDate,
              onChanged: (value) {
                _editMajorExpenseBloc
                    .add(EditMajorExpenseDateValueChanged(value: value));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategorySelector extends StatelessWidget {
  final MajorExpenseCategory initialCategory;

  const ExpenseCategorySelector({
    super.key,
    required this.initialCategory,
    required this.categories,
    required EditMajorExpenseBloc editMajorExpenseBloc,
  }) : _editMajorExpenseBloc = editMajorExpenseBloc;

  final List<MajorExpenseCategory> categories;
  final EditMajorExpenseBloc _editMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Fixed width section with icon and label
          const SizedBox(
            width: 100, // Adjust based on your text size
            child: Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Category',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // Expanded section for dropdown
          const SizedBox(width: 12),
          Expanded(
            child: DropdownWidget(
              items: categories.map((item) => item.displayName).toList(),
              initialValue: initialCategory.displayName,
              onChanged: (value) {
                if (value != null) {
                  MajorExpenseCategory selectedCategory = categories.firstWhere(
                    (category) => category.displayName == value,
                    orElse: () => MajorExpenseCategory.other,
                  );
                  _editMajorExpenseBloc.add(
                      EditMajorExpenseCategoryChanged(value: selectedCategory));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseAmountField extends StatelessWidget {
  const ExpenseAmountField({
    super.key,
    required TextEditingController amountTextEditingController,
    required EditMajorExpenseBloc editMajorExpenseBloc,
  })  : _amountTextEditingController = amountTextEditingController,
        _editMajorExpenseBloc = editMajorExpenseBloc;

  final TextEditingController _amountTextEditingController;
  final EditMajorExpenseBloc _editMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _amountTextEditingController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d{0,2}$'),
        ),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Amount',
        hintText: '0.00',
        prefixIcon: const Icon(Icons.currency_rupee, color: Colors.black54),
        labelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        hintStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w300,
          color: Colors.black38,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      onChanged: (value) {
        _editMajorExpenseBloc.add(EditMajorExpenseAmountChanged(value: value));
      },
    );
  }
}

class ExpenseNameField extends StatelessWidget {
  const ExpenseNameField({
    super.key,
    required TextEditingController nameTextEditingController,
    required EditMajorExpenseBloc editMajorExpenseBloc,
  })  : _nameTextEditingController = nameTextEditingController,
        _editMajorExpenseBloc = editMajorExpenseBloc;

  final TextEditingController _nameTextEditingController;
  final EditMajorExpenseBloc _editMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      controller: _nameTextEditingController,
      inputFormatters: [LengthLimitingTextInputFormatter(25)],
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Expense Name',
        hintText: 'What did you spend on?',
        prefixIcon:
            const Icon(Icons.shopping_bag_outlined, color: Colors.black54),
        labelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        hintStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w300,
          color: Colors.black38,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onChanged: (value) {
        _editMajorExpenseBloc.add(EditMajorExpenseNameChanged(value: value));
      },
    );
  }
}

class NotesField extends StatelessWidget {
  const NotesField({
    super.key,
    required TextEditingController notesTextEditingController,
    required EditMajorExpenseBloc editMajorExpenseBloc,
  })  : _notesTextEditingController = notesTextEditingController,
        _editMajorExpenseBloc = editMajorExpenseBloc;

  final TextEditingController _notesTextEditingController;
  final EditMajorExpenseBloc _editMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      controller: _notesTextEditingController,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Notes (Optional)',
        hintText: 'Add additional details about this expense',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 48.0),
          child: Icon(Icons.note, color: Colors.black54),
        ),
        alignLabelWithHint: true,
        labelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        hintStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w300,
          color: Colors.black38,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onChanged: (value) {
        _editMajorExpenseBloc.add(EditMajorExpenseNotesChanged(value: value));
      },
    );
  }
}
