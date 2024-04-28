import 'package:budgetpro/pages/expenses/bloc/expenses_bloc.dart';
import 'package:budgetpro/pages/new_expense/bloc/new_expense_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/network_services.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseCategory {
  final String rawValue;

  const ExpenseCategory._(this.rawValue);

  static const ExpenseCategory unselected = ExpenseCategory._("");
  static const ExpenseCategory loan = ExpenseCategory._("Loan");
  static const ExpenseCategory food = ExpenseCategory._("Food");
  static const ExpenseCategory trip = ExpenseCategory._("Holiday/Trip");
  static const ExpenseCategory housing = ExpenseCategory._("Housing");
  static const ExpenseCategory shopping = ExpenseCategory._("Shopping");
  static const ExpenseCategory travel = ExpenseCategory._("Travel");
  static const ExpenseCategory home = ExpenseCategory._("Home");
  static const ExpenseCategory charges = ExpenseCategory._("Charges/Fees");
  static const ExpenseCategory groceries = ExpenseCategory._("Groceries");
  static const ExpenseCategory life = ExpenseCategory._("Health/Beauty");
  static const ExpenseCategory entertainment =
      ExpenseCategory._("Entertainment");
  static const ExpenseCategory gift = ExpenseCategory._("Charity/Gift");
  static const ExpenseCategory education = ExpenseCategory._("Education");
  static const ExpenseCategory vehicle = ExpenseCategory._("Vehicle");

  @override
  String toString() => rawValue;
}

class AddExpensePage extends StatefulWidget {
  final ExpensesBloc expensesBloc;

  const AddExpensePage({super.key, required this.expensesBloc});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _newExpenseBloc = NewExpenseBloc();
  final _nameTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _newExpenseBloc.add(NewExpenseInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Expense',
              style: TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade200,
            child: Stack(
              children: [
                BlocBuilder<NewExpenseBloc, NewExpenseState>(
                    bloc: _newExpenseBloc,
                    buildWhen: (previous, current) =>
                        current is NewExpensePageLoadedState,
                    builder: (context, state) {
                      return SafeArea(
                        child: BlocListener<NewExpenseBloc, NewExpenseState>(
                            bloc: _newExpenseBloc,
                            listener: (context, state) {
                              if (state.runtimeType ==
                                  NewExpensePageLoadedState) {
                                _nameTextEditingController.clear();
                                _amountTextEditingController.clear();
                                _newExpenseBloc
                                    .add(NewExpenseNameValueChanged(value: ''));
                                _newExpenseBloc.add(
                                    NewExpenseAmountValueChanged(value: ''));
                              }
                            },
                            child: SingleChildScrollView(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  TextField(
                                    controller: _nameTextEditingController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(25)
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'Expense Name',
                                      hintText: 'Enter expense name',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      _newExpenseBloc.add(
                                          NewExpenseNameValueChanged(
                                              value: value));
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _amountTextEditingController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}$'),
                                      ),
                                    ],
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: const InputDecoration(
                                      labelText: 'Amount',
                                      hintText: 'Enter amount',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      _newExpenseBloc.add(
                                          NewExpenseAmountValueChanged(
                                              value: value));
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Text('Category'),
                                      const Spacer(),
                                      DropdownWidget(
                                        items:
                                            state is NewExpensePageLoadedState
                                                ? state.categories
                                                : [],
                                        onChanged: (value) {
                                          if (value != null) {
                                            _newExpenseBloc.add(
                                                NewExpenseCategoryValueChanged(
                                                    value: value));
                                          }
                                        },
                                      ),
                                      const Spacer()
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Text('Date'),
                                      const Spacer(),
                                      Container(
                                        margin: const EdgeInsets.only(left: 30),
                                        width: 150,
                                        child: DatePickerWidget(
                                          defaultDate: DateTime.now(),
                                          onChanged: (value) {
                                            _newExpenseBloc.add(
                                                NewExpenseDateValueChanged(
                                                    value: value));
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  BlocBuilder(
                                      buildWhen: (previous, current) => current
                                          is NewExpenseInputValueChangedState,
                                      bloc: _newExpenseBloc,
                                      builder: (context, state) {
                                        bool isInputValid = state
                                                is NewExpenseInputValueChangedState
                                            ? state.isInputValid
                                            : false;
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (isInputValid) {
                                                _newExpenseBloc.add(
                                                    NewExpenseAddExpenseTappedEvent());
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isInputValid
                                                  ? AppColors.accentColor
                                                  : Colors.grey,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 20),
                                            ),
                                            child: const Text(
                                              'Add',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }),
                                  const SizedBox(height: 20),
                                ]))),
                      );
                    }),
                BlocConsumer(
                    bloc: _newExpenseBloc,
                    listener: (context, state) {
                      switch (state) {
                        case NewExpenseAddExpenseSuccessState _:
                          UIUtils.showSnackbar(
                              context, 'Expense added successfully!',
                              type: SnackbarType.SUCCESS);
                          break;
                        case NewExpenseAddExpenseErrorState _:
                          UIUtils.showSnackbar(
                              context, 'Error in adding expense!',
                              type: SnackbarType.ERROR);
                          break;
                        default:
                          break;
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is NewExpenseActionState,
                    builder: (context, state) {
                      switch (state) {
                        case NewExpenseAddExpenseLoadingState _:
                          return Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.accentColor),
                            ),
                          );
                        default:
                          return Container();
                      }
                    }),
              ],
            )));
  }
}
