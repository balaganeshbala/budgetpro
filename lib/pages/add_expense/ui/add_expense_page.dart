import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/pages/add_expense/bloc/add_expense_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _newExpenseBloc = NewExpenseBloc();
  final _nameTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    _newExpenseBloc.add(NewExpenseInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            BlocBuilder<NewExpenseBloc, NewExpenseState>(
              bloc: _newExpenseBloc,
              buildWhen: (previous, current) =>
                  current is NewExpensePageLoadedState,
              builder: (context, state) {
                return SafeArea(
                  child: BlocListener<NewExpenseBloc, NewExpenseState>(
                    bloc: _newExpenseBloc,
                    listener: (context, state) {
                      if (state.runtimeType == NewExpensePageLoadedState) {
                        _nameTextEditingController.clear();
                        _nameFocusNode.requestFocus();
                        _amountTextEditingController.clear();
                        _newExpenseBloc
                            .add(NewExpenseNameValueChanged(value: ''));
                        _newExpenseBloc
                            .add(NewExpenseAmountValueChanged(value: ''));
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
                                "Expense Details",
                                style: TextStyle(
                                  fontFamily: "Sora",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ExpenseNameField(
                                nameTextEditingController:
                                    _nameTextEditingController,
                                focusNode: _nameFocusNode,
                                newExpenseBloc: _newExpenseBloc,
                              ),
                              const SizedBox(height: 20),
                              ExpenseAmountField(
                                amountTextEditingController:
                                    _amountTextEditingController,
                                newExpenseBloc: _newExpenseBloc,
                              ),
                              const SizedBox(height: 20),
                              ExpenseCategorySelector(
                                categories: state is NewExpensePageLoadedState
                                    ? state.categories
                                    : [],
                                newExpenseBloc: _newExpenseBloc,
                              ),
                              const SizedBox(height: 20),
                              ExpenseDateSelector(
                                newExpenseBloc: _newExpenseBloc,
                              ),
                              const SizedBox(height: 30),
                              AddExpenseButton(
                                newExpenseBloc: _newExpenseBloc,
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
            AddExpenseSnackbar(
              newExpenseBloc: _newExpenseBloc,
              widget: widget,
            ),
            AddExpenseLoader(newExpenseBloc: _newExpenseBloc),
          ],
        ),
      ),
    );
  }
}

class AddExpenseSnackbar extends StatelessWidget {
  const AddExpenseSnackbar({
    super.key,
    required NewExpenseBloc newExpenseBloc,
    required this.widget,
  }) : _newExpenseBloc = newExpenseBloc;

  final NewExpenseBloc _newExpenseBloc;
  final AddExpensePage widget;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _newExpenseBloc,
      listener: (context, state) {
        switch (state) {
          case NewExpenseAddExpenseSuccessState _:
            UIUtils.showSnackbar(
              context,
              'Expense added successfully!',
              type: SnackbarType.success,
            );
            break;
          case NewExpenseAddExpenseErrorState _:
            UIUtils.showSnackbar(
              context,
              'Error in adding expense!',
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
    required NewExpenseBloc newExpenseBloc,
  }) : _newExpenseBloc = newExpenseBloc;

  final NewExpenseBloc _newExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewExpenseBloc, NewExpenseState>(
      bloc: _newExpenseBloc,
      buildWhen: (previous, current) => current is NewExpenseActionState,
      builder: (context, state) {
        switch (state) {
          case NewExpenseAddExpenseLoadingState _:
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
    required NewExpenseBloc newExpenseBloc,
  }) : _newExpenseBloc = newExpenseBloc;

  final NewExpenseBloc _newExpenseBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (previous, current) =>
          current is NewExpenseInputValueChangedState,
      bloc: _newExpenseBloc,
      builder: (context, state) {
        bool isInputValid = state is NewExpenseInputValueChangedState
            ? state.isInputValid
            : false;
        return SizedBox(
          width: double.infinity,
          height: 55,
          child: AppThemeButton(
              onPressed: isInputValid
                  ? () {
                      _newExpenseBloc.add(NewExpenseAddExpenseTappedEvent());
                    }
                  : null,
              text: 'Save Expense'),
        );
      },
    );
  }
}

class ExpenseDateSelector extends StatelessWidget {
  const ExpenseDateSelector({
    super.key,
    required NewExpenseBloc newExpenseBloc,
  }) : _newExpenseBloc = newExpenseBloc;

  final NewExpenseBloc _newExpenseBloc;

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
                _newExpenseBloc.add(NewExpenseDateValueChanged(value: value));
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
    required NewExpenseBloc newExpenseBloc,
  }) : _newExpenseBloc = newExpenseBloc;

  final List<String> categories;
  final NewExpenseBloc _newExpenseBloc;

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
          Container(
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
              items: categories,
              onChanged: (value) {
                if (value != null) {
                  _newExpenseBloc
                      .add(NewExpenseCategoryValueChanged(value: value));
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
    required NewExpenseBloc newExpenseBloc,
  })  : _amountTextEditingController = amountTextEditingController,
        _newExpenseBloc = newExpenseBloc;

  final TextEditingController _amountTextEditingController;
  final NewExpenseBloc _newExpenseBloc;

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
        _newExpenseBloc.add(NewExpenseAmountValueChanged(value: value));
      },
    );
  }
}

class ExpenseNameField extends StatelessWidget {
  const ExpenseNameField({
    super.key,
    required TextEditingController nameTextEditingController,
    required FocusNode focusNode,
    required NewExpenseBloc newExpenseBloc,
  })  : _nameTextEditingController = nameTextEditingController,
        _focusNode = focusNode,
        _newExpenseBloc = newExpenseBloc;

  final TextEditingController _nameTextEditingController;
  final FocusNode _focusNode;
  final NewExpenseBloc _newExpenseBloc;

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
        _newExpenseBloc.add(NewExpenseNameValueChanged(value: value));
      },
    );
  }
}
