import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/pages/expense_details/bloc/expense_details_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseDetailsPage extends StatefulWidget {
  final ExpenseModel expense;

  const ExpenseDetailsPage({super.key, required this.expense});

  @override
  State<ExpenseDetailsPage> createState() => _ExpenseDetailsPageState();
}

class _ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  late final ExpenseDetailsBloc _expenseDetailsBloc;
  final _nameTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  bool _shouldRefresh = false;
  bool _isReturning = false;

  @override
  void initState() {
    _expenseDetailsBloc = ExpenseDetailsBloc();
    _expenseDetailsBloc
        .add(ExpenseDetailsInitialEvent(expense: widget.expense));

    // Populate text fields with existing data
    _nameTextEditingController.text = widget.expense.name;
    _amountTextEditingController.text = widget.expense.amount.toString();

    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _amountTextEditingController.dispose();
    _expenseDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_shouldRefresh,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(_shouldRefresh);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Expense Details',
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
              BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
                bloc: _expenseDetailsBloc,
                buildWhen: (previous, current) =>
                    current is ExpenseDetailsLoadedState,
                builder: (context, state) {
                  return SafeArea(
                    child:
                        BlocListener<ExpenseDetailsBloc, ExpenseDetailsState>(
                      bloc: _expenseDetailsBloc,
                      listener: (context, state) {
                        if (state is ExpenseDetailsUpdatedSuccessState &&
                            !_isReturning) {
                          _shouldRefresh = true;
                          _isReturning = true; // Prevent multiple actions

                          UIUtils.showSnackbar(
                            context,
                            'Expense updated successfully!',
                            type: SnackbarType.success,
                          );

                          // Add a short delay before navigating back
                          Future.delayed(const Duration(milliseconds: 800), () {
                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                          });
                        } else if (state is ExpenseDetailsDeletedSuccessState) {
                          _shouldRefresh = true;
                          Navigator.pop(context, true);
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
                                ExpenseNameField(
                                  nameTextEditingController:
                                      _nameTextEditingController,
                                  expenseDetailsBloc: _expenseDetailsBloc,
                                ),
                                const SizedBox(height: 20),
                                ExpenseAmountField(
                                  amountTextEditingController:
                                      _amountTextEditingController,
                                  expenseDetailsBloc: _expenseDetailsBloc,
                                ),
                                const SizedBox(height: 20),
                                ExpenseCategorySelector(
                                  initialCategory: widget.expense.category,
                                  categories: state is ExpenseDetailsLoadedState
                                      ? state.categories
                                      : ExpenseCategoryExtension
                                          .getAllCategories(),
                                  expenseDetailsBloc: _expenseDetailsBloc,
                                ),
                                const SizedBox(height: 20),
                                ExpenseDateSelector(
                                  initialDate:
                                      Utils.parseDate(widget.expense.date),
                                  expenseDetailsBloc: _expenseDetailsBloc,
                                ),
                                const SizedBox(height: 30),
                                UpdateExpenseButton(
                                  expenseDetailsBloc: _expenseDetailsBloc,
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
              // Status overlay (loading, success, error)
              BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
                bloc: _expenseDetailsBloc,
                buildWhen: (previous, current) =>
                    current is ExpenseDetailsLoadingState ||
                    current is ExpenseDetailsErrorState,
                builder: (context, state) {
                  if (state is ExpenseDetailsLoadingState) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentColor,
                        ),
                      ),
                    );
                  } else if (state is ExpenseDetailsErrorState) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.error,
                              style: const TextStyle(
                                fontFamily: "Sora",
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Go Back',
                                style: TextStyle(
                                  fontFamily: "Sora",
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await UIUtils.showConfirmationDialog(
      context,
      'Delete Expense',
      'Are you sure you want to delete this expense? This action cannot be undone.',
    );

    if (confirm && context.mounted) {
      _expenseDetailsBloc.add(ExpenseDetailsDeleteEvent());
    }
  }
}

class UpdateExpenseButton extends StatelessWidget {
  const UpdateExpenseButton({
    super.key,
    required ExpenseDetailsBloc expenseDetailsBloc,
  }) : _expenseDetailsBloc = expenseDetailsBloc;

  final ExpenseDetailsBloc _expenseDetailsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (previous, current) =>
          current is ExpenseDetailsInputValueChangedState,
      bloc: _expenseDetailsBloc,
      builder: (context, state) {
        bool isInputValid = state is ExpenseDetailsInputValueChangedState
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
                        _expenseDetailsBloc.add(ExpenseDetailsUpdateEvent());
                      }
                    }
                  : null,
              text: 'Update Expense'),
        );
      },
    );
  }
}

class ExpenseDateSelector extends StatelessWidget {
  final DateTime initialDate;

  const ExpenseDateSelector({
    super.key,
    required ExpenseDetailsBloc expenseDetailsBloc,
    required this.initialDate,
  }) : _expenseDetailsBloc = expenseDetailsBloc;

  final ExpenseDetailsBloc _expenseDetailsBloc;

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
                _expenseDetailsBloc
                    .add(ExpenseDetailsDateChanged(value: value));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategorySelector extends StatelessWidget {
  final ExpenseCategory initialCategory;

  const ExpenseCategorySelector({
    super.key,
    required this.initialCategory,
    required this.categories,
    required ExpenseDetailsBloc expenseDetailsBloc,
  }) : _expenseDetailsBloc = expenseDetailsBloc;

  final List<ExpenseCategory> categories;
  final ExpenseDetailsBloc _expenseDetailsBloc;

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
          SizedBox(
            width: 100, // Adjust based on your text size
            child: const Row(
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
                  ExpenseCategory selectedCategory = categories.firstWhere(
                    (category) => category.displayName == value,
                    orElse: () => ExpenseCategory.unknown,
                  );
                  _expenseDetailsBloc.add(
                      ExpenseDetailsCategoryChanged(value: selectedCategory));
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
    required ExpenseDetailsBloc expenseDetailsBloc,
  })  : _amountTextEditingController = amountTextEditingController,
        _expenseDetailsBloc = expenseDetailsBloc;

  final TextEditingController _amountTextEditingController;
  final ExpenseDetailsBloc _expenseDetailsBloc;

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
        _expenseDetailsBloc.add(ExpenseDetailsAmountChanged(value: value));
      },
    );
  }
}

class ExpenseNameField extends StatelessWidget {
  const ExpenseNameField({
    super.key,
    required TextEditingController nameTextEditingController,
    required ExpenseDetailsBloc expenseDetailsBloc,
  })  : _nameTextEditingController = nameTextEditingController,
        _expenseDetailsBloc = expenseDetailsBloc;

  final TextEditingController _nameTextEditingController;
  final ExpenseDetailsBloc _expenseDetailsBloc;

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
        _expenseDetailsBloc.add(ExpenseDetailsNameChanged(value: value));
      },
    );
  }
}
