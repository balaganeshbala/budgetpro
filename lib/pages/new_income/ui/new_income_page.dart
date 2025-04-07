import 'package:budgetpro/pages/incomes/bloc/incomes_bloc.dart';
import 'package:budgetpro/pages/new_income/bloc/new_income_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddIncomePage extends StatefulWidget {
  final IncomesBloc incomesBloc;

  const AddIncomePage({super.key, required this.incomesBloc});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _newIncomeBloc = NewIncomeBloc();
  final _nameTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    _newIncomeBloc.add(NewIncomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Income',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora")),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade200,
            child: Stack(
              children: [
                BlocBuilder<NewIncomeBloc, NewIncomeState>(
                    bloc: _newIncomeBloc,
                    buildWhen: (previous, current) =>
                        current is NewIncomePageLoadedState,
                    builder: (context, state) {
                      return SafeArea(
                        child: BlocListener<NewIncomeBloc, NewIncomeState>(
                            bloc: _newIncomeBloc,
                            listener: (context, state) {
                              if (state.runtimeType ==
                                  NewIncomePageLoadedState) {
                                _nameTextEditingController.clear();
                                _nameFocusNode.requestFocus();
                                _amountTextEditingController.clear();
                                _newIncomeBloc
                                    .add(NewIncomeNameValueChanged(value: ''));
                                _newIncomeBloc.add(
                                    NewIncomeAmountValueChanged(value: ''));
                              }
                            },
                            child: SingleChildScrollView(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  IncomeNameField(
                                      nameTextEditingController:
                                          _nameTextEditingController,
                                      focusNode: _nameFocusNode,
                                      newIncomeBloc: _newIncomeBloc),
                                  const SizedBox(height: 20),
                                  IncomeAmountField(
                                      amountTextEditingController:
                                          _amountTextEditingController,
                                      newIncomeBloc: _newIncomeBloc),
                                  const SizedBox(height: 20),
                                  IncomeDateSelector(
                                      newIncomeBloc: _newIncomeBloc),
                                  const SizedBox(height: 20),
                                  AddIncomeButton(
                                      newIncomeBloc: _newIncomeBloc),
                                  const SizedBox(height: 20),
                                ]))),
                      );
                    }),
                AddIncomeSnackbar(
                    newIncomeBloc: _newIncomeBloc, widget: widget),
                AddIncomeLoader(newIncomeBloc: _newIncomeBloc),
              ],
            )));
  }
}

class AddIncomeSnackbar extends StatelessWidget {
  const AddIncomeSnackbar({
    super.key,
    required NewIncomeBloc newIncomeBloc,
    required this.widget,
  }) : _newIncomeBloc = newIncomeBloc;

  final NewIncomeBloc _newIncomeBloc;
  final AddIncomePage widget;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _newIncomeBloc,
        listener: (context, state) {
          switch (state) {
            case NewIncomeAddIncomeSuccessState _:
              UIUtils.showSnackbar(context, 'Income added successfully!',
                  type: SnackbarType.success);
              widget.incomesBloc.add(IncomesRefreshEvent());
              break;
            case NewIncomeAddIncomeErrorState _:
              UIUtils.showSnackbar(context, 'Error in adding income!',
                  type: SnackbarType.error);
              break;
            default:
              break;
          }
        },
        child: Container());
  }
}

class AddIncomeLoader extends StatelessWidget {
  const AddIncomeLoader({
    super.key,
    required NewIncomeBloc newIncomeBloc,
  }) : _newIncomeBloc = newIncomeBloc;

  final NewIncomeBloc _newIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewIncomeBloc, NewIncomeState>(
        bloc: _newIncomeBloc,
        buildWhen: (previous, current) => current is NewIncomeActionState,
        builder: (context, state) {
          switch (state) {
            case NewIncomeAddIncomeLoadingState _:
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.accentColor),
                ),
              );
            default:
              return Container();
          }
        });
  }
}

class AddIncomeButton extends StatelessWidget {
  const AddIncomeButton({
    super.key,
    required NewIncomeBloc newIncomeBloc,
  }) : _newIncomeBloc = newIncomeBloc;

  final NewIncomeBloc _newIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        buildWhen: (previous, current) =>
            current is NewIncomeInputValueChangedState,
        bloc: _newIncomeBloc,
        builder: (context, state) {
          bool isInputValid = state is NewIncomeInputValueChangedState
              ? state.isInputValid
              : false;
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (isInputValid) {
                  _newIncomeBloc.add(NewIncomeAddIncomeTappedEvent());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isInputValid ? AppColors.accentColor : Colors.grey,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Sora"),
              ),
            ),
          );
        });
  }
}

class IncomeDateSelector extends StatelessWidget {
  const IncomeDateSelector({
    super.key,
    required NewIncomeBloc newIncomeBloc,
  }) : _newIncomeBloc = newIncomeBloc;

  final NewIncomeBloc _newIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Date', style: TextStyle(fontFamily: "Sora")),
        const Spacer(),
        Container(
          margin: const EdgeInsets.only(left: 30),
          width: 150,
          child: DatePickerWidget(
            defaultDate: DateTime.now(),
            onChanged: (value) {
              _newIncomeBloc.add(NewIncomeDateValueChanged(value: value));
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class IncomeAmountField extends StatelessWidget {
  const IncomeAmountField({
    super.key,
    required TextEditingController amountTextEditingController,
    required NewIncomeBloc newIncomeBloc,
  })  : _amountTextEditingController = amountTextEditingController,
        _newIncomeBloc = newIncomeBloc;

  final TextEditingController _amountTextEditingController;
  final NewIncomeBloc _newIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _amountTextEditingController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d{0,2}$'),
        ),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Amount',
        labelStyle: TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w300),
        floatingLabelStyle: TextStyle(fontFamily: "Sora"),
        border: OutlineInputBorder(),
        prefixText: '₹ ', // Always show the rupee sign before input
        prefixStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Sora"),
      ),
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      onChanged: (value) {
        _newIncomeBloc.add(NewIncomeAmountValueChanged(value: value));
      },
    );
  }
}

class IncomeNameField extends StatelessWidget {
  const IncomeNameField({
    super.key,
    required TextEditingController nameTextEditingController,
    required FocusNode focusNode,
    required NewIncomeBloc newIncomeBloc,
  })  : _nameTextEditingController = nameTextEditingController,
        _focusNode = focusNode,
        _newIncomeBloc = newIncomeBloc;

  final TextEditingController _nameTextEditingController;
  final FocusNode _focusNode;
  final NewIncomeBloc _newIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w600),
      focusNode: _focusNode,
      controller: _nameTextEditingController,
      inputFormatters: [LengthLimitingTextInputFormatter(25)],
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
          labelText: 'Income Name',
          labelStyle:
              TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w300),
          border: OutlineInputBorder(),
          floatingLabelStyle: TextStyle(fontFamily: "Sora")),
      onChanged: (value) {
        _newIncomeBloc.add(NewIncomeNameValueChanged(value: value));
      },
    );
  }
}
