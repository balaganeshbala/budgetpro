import 'package:budgetpro/utits/network_services.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
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
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _nameErrorText;
  String? _amountErrorText;
  final List<String> expenseCategories = [
    'Loan',
    'Food',
    'Holiday/Trip',
    'Housing',
    'Shopping',
    'Travel',
    'Home',
    'Charges/Fees',
    'Groceries',
    'Health/Beauty',
    'Entertainment',
    'Charity/Gift',
    'Education',
    'Vehicle',
  ];

  String? _selectedCategory;
  String? _selectedDate;

  bool _isInputValid() {
    return _nameErrorText == null &&
        _amountErrorText == null &&
        _selectedCategory != null &&
        _selectedDate != null;
  }

  Future addExpense(
      String name, String amount, String category, String date) async {
    const urlString = 'https://cloudpigeon.cyclic.app/budgetpro/expense/add';

    final postData = {
      'name': name,
      'amount': amount,
      'category': category,
      'date': date
    };
    final result =
        await NetworkCallService.instance.makePostAPICall(urlString, postData);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Expense',
              style: TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 36, 76, 60),
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              TextField(
                controller: _nameController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Expense Name',
                  hintText: 'Enter expense name',
                  errorText: _nameErrorText,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      _nameErrorText = 'Enter a valid name';
                    });
                  } else {
                    setState(() {
                      _nameErrorText = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount',
                  errorText: _amountErrorText,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isEmpty || double.tryParse(value) == null) {
                    setState(() {
                      _amountErrorText = 'Enter a valid amount';
                    });
                  } else {
                    setState(() {
                      _amountErrorText = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text('Category'),
                  Spacer(),
                  // DropdownWidget(
                  //   items: expenseCategories,
                  //   hintText: 'Select Category',
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _selectedCategory = value;
                  //     });
                  //   },
                  // ),
                  Spacer()
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Date'),
                  const Spacer(),
                  DatePickerWidget(
                    onChanged: (value) {
                      String formattedDate =
                          DateFormat('MM/dd/yyyy').format(value);
                      setState(() {
                        _selectedDate = formattedDate;
                      });
                    },
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isInputValid()
                        ? () {
                            final String name = _nameController.text;
                            final String amount = _amountController.text;
                            final String category = _selectedCategory!;
                            final String date = _selectedDate!;

                            print(name);
                            print(amount);
                            print(category);
                            print(date);

                            _nameController.clear();
                            _amountController.clear();
                            setState() {
                              _selectedCategory = null;
                              _selectedDate = null;
                            }

                            addExpense(name, amount, category, date);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isInputValid() ? Colors.orange : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ])));
  }
}
