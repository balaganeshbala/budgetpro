import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/models/major_expense_category_enum.dart';
import 'package:budgetpro/pages/major_expenses/bloc/add_major_expense_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMajorExpensePage extends StatefulWidget {
  const AddMajorExpensePage({super.key});

  @override
  State<AddMajorExpensePage> createState() => _AddMajorExpensePageState();
}

class _AddMajorExpensePageState extends State<AddMajorExpensePage> {
  final _addMajorExpenseBloc = AddMajorExpenseBloc();
  final _nameTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  final _notesTextEditingController = TextEditingController();
  final _nameFocusNode = FocusNode();

  bool _shouldRefresh = false;

  @override
  void initState() {
    _addMajorExpenseBloc.add(AddMajorExpenseInitialEvent());
    super.initState();
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
            'Add Expense',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Sora",
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
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
              BlocBuilder<AddMajorExpenseBloc, AddMajorExpenseState>(
                bloc: _addMajorExpenseBloc,
                buildWhen: (previous, current) =>
                    current is AddMajorExpensePageLoadedState,
                builder: (context, state) {
                  return SafeArea(
                    child:
                        BlocListener<AddMajorExpenseBloc, AddMajorExpenseState>(
                      bloc: _addMajorExpenseBloc,
                      listener: (context, state) {
                        if (state.runtimeType ==
                            AddMajorExpensePageLoadedState) {
                          _nameTextEditingController.clear();
                          _nameFocusNode.requestFocus();
                          _amountTextEditingController.clear();
                          _notesTextEditingController.clear();
                          _addMajorExpenseBloc
                              .add(AddMajorExpenseNameValueChanged(value: ''));
                          _addMajorExpenseBloc.add(
                              AddMajorExpenseAmountValueChanged(value: ''));
                          _addMajorExpenseBloc
                              .add(AddMajorExpenseNotesValueChanged(value: ''));
                        } else if (state
                            is AddMajorExpenseAddExpenseSuccessState) {
                          setState(() {
                            _shouldRefresh = true;
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
                                const Text(
                                  "Major Expense Details",
                                  style: TextStyle(
                                    fontFamily: "Sora",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Name Field
                                ExpenseNameField(
                                  nameTextEditingController:
                                      _nameTextEditingController,
                                  focusNode: _nameFocusNode,
                                  addMajorExpenseBloc: _addMajorExpenseBloc,
                                ),
                                const SizedBox(height: 20),
                                // Amount Field
                                ExpenseAmountField(
                                  amountTextEditingController:
                                      _amountTextEditingController,
                                  addMajorExpenseBloc: _addMajorExpenseBloc,
                                ),
                                const SizedBox(height: 20),
                                // Category Selector
                                ExpenseCategorySelector(
                                  categories:
                                      state is AddMajorExpensePageLoadedState
                                          ? state.categories
                                          : [],
                                  addMajorExpenseBloc: _addMajorExpenseBloc,
                                ),
                                const SizedBox(height: 20),
                                // Date Selector
                                ExpenseDateSelector(
                                  addMajorExpenseBloc: _addMajorExpenseBloc,
                                ),
                                const SizedBox(height: 20),
                                // Notes Field
                                NotesField(
                                  notesTextEditingController:
                                      _notesTextEditingController,
                                  addMajorExpenseBloc: _addMajorExpenseBloc,
                                ),
                                const SizedBox(height: 30),
                                // Add Button
                                AddExpenseButton(
                                  addMajorExpenseBloc: _addMajorExpenseBloc,
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
              // Status Feedback
              AddExpenseSnackbar(
                addMajorExpenseBloc: _addMajorExpenseBloc,
                widget: widget,
              ),
              AddExpenseLoader(addMajorExpenseBloc: _addMajorExpenseBloc),
            ],
          ),
        ),
      ),
    );
  }
}

class AddExpenseSnackbar extends StatelessWidget {
  const AddExpenseSnackbar({
    super.key,
    required AddMajorExpenseBloc addMajorExpenseBloc,
    required this.widget,
  }) : _addMajorExpenseBloc = addMajorExpenseBloc;

  final AddMajorExpenseBloc _addMajorExpenseBloc;
  final AddMajorExpensePage widget;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _addMajorExpenseBloc,
      listener: (context, state) {
        switch (state) {
          case AddMajorExpenseAddExpenseSuccessState _:
            UIUtils.showSnackbar(
              context,
              'Major expense added successfully!',
              type: SnackbarType.success,
            );
            break;
          case AddMajorExpenseAddExpenseErrorState _:
            UIUtils.showSnackbar(
              context,
              'Error in adding major expense!',
              type: SnackbarType.error,
            );
            break;
          default:
            break;
        }
      },
      child: Container(),
    );
  }
}

class AddExpenseLoader extends StatelessWidget {
  const AddExpenseLoader({
    super.key,
    required AddMajorExpenseBloc addMajorExpenseBloc,
  }) : _addMajorExpenseBloc = addMajorExpenseBloc;

  final AddMajorExpenseBloc _addMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMajorExpenseBloc, AddMajorExpenseState>(
      bloc: _addMajorExpenseBloc,
      buildWhen: (previous, current) => current is AddMajorExpenseActionState,
      builder: (context, state) {
        switch (state) {
          case AddMajorExpenseAddExpenseLoadingState _:
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              ),
            );
          default:
            return Container();
        }
      },
    );
  }
}

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({
    super.key,
    required AddMajorExpenseBloc addMajorExpenseBloc,
  }) : _addMajorExpenseBloc = addMajorExpenseBloc;

  final AddMajorExpenseBloc _addMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (previous, current) =>
          current is AddMajorExpenseInputValueChangedState,
      bloc: _addMajorExpenseBloc,
      builder: (context, state) {
        bool isInputValid = state is AddMajorExpenseInputValueChangedState
            ? state.isInputValid
            : false;
        return SizedBox(
          width: double.infinity,
          height: 55,
          child: AppThemeButton(
            onPressed: isInputValid
                ? () {
                    _addMajorExpenseBloc
                        .add(AddMajorExpenseAddExpenseTappedEvent());
                  }
                : null,
            text: 'Save',
          ),
        );
      },
    );
  }
}

class ExpenseDateSelector extends StatelessWidget {
  const ExpenseDateSelector({
    super.key,
    required AddMajorExpenseBloc addMajorExpenseBloc,
  }) : _addMajorExpenseBloc = addMajorExpenseBloc;

  final AddMajorExpenseBloc _addMajorExpenseBloc;

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
              defaultDate: DateTime.now(),
              onChanged: (value) {
                _addMajorExpenseBloc
                    .add(AddMajorExpenseDateValueChanged(value: value));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategorySelector extends StatelessWidget {
  const ExpenseCategorySelector({
    super.key,
    required this.categories,
    required AddMajorExpenseBloc addMajorExpenseBloc,
  }) : _addMajorExpenseBloc = addMajorExpenseBloc;

  final List<MajorExpenseCategory> categories;
  final AddMajorExpenseBloc _addMajorExpenseBloc;

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
              onChanged: (value) {
                if (value != null) {
                  MajorExpenseCategory selectedCategory = categories.firstWhere(
                    (category) => category.displayName == value,
                    orElse: () => MajorExpenseCategory.other,
                  );
                  _addMajorExpenseBloc.add(AddMajorExpenseCategoryValueChanged(
                      value: selectedCategory));
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
    required AddMajorExpenseBloc addMajorExpenseBloc,
  })  : _amountTextEditingController = amountTextEditingController,
        _addMajorExpenseBloc = addMajorExpenseBloc;

  final TextEditingController _amountTextEditingController;
  final AddMajorExpenseBloc _addMajorExpenseBloc;

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
        _addMajorExpenseBloc
            .add(AddMajorExpenseAmountValueChanged(value: value));
      },
    );
  }
}

class ExpenseNameField extends StatelessWidget {
  const ExpenseNameField({
    super.key,
    required TextEditingController nameTextEditingController,
    required FocusNode focusNode,
    required AddMajorExpenseBloc addMajorExpenseBloc,
  })  : _nameTextEditingController = nameTextEditingController,
        _focusNode = focusNode,
        _addMajorExpenseBloc = addMajorExpenseBloc;

  final TextEditingController _nameTextEditingController;
  final FocusNode _focusNode;
  final AddMajorExpenseBloc _addMajorExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      focusNode: _focusNode,
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
        _addMajorExpenseBloc.add(AddMajorExpenseNameValueChanged(value: value));
      },
    );
  }
}

class NotesField extends StatelessWidget {
  const NotesField({
    super.key,
    required TextEditingController notesTextEditingController,
    required AddMajorExpenseBloc addMajorExpenseBloc,
  })  : _notesTextEditingController = notesTextEditingController,
        _addMajorExpenseBloc = addMajorExpenseBloc;

  final TextEditingController _notesTextEditingController;
  final AddMajorExpenseBloc _addMajorExpenseBloc;

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
        _addMajorExpenseBloc
            .add(AddMajorExpenseNotesValueChanged(value: value));
      },
    );
  }
}
