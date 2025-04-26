import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/pages/income/bloc/add_income_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _addIncomeBloc = AddIncomeBloc();
  final _sourceTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  final _sourceFocusNode = FocusNode();

  bool _shouldRefresh = false;

  @override
  void initState() {
    _addIncomeBloc.add(AddIncomeInitialEvent());
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
              'Add Income',
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
                BlocBuilder<AddIncomeBloc, AddIncomeState>(
                  bloc: _addIncomeBloc,
                  buildWhen: (previous, current) =>
                      current is AddIncomePageLoadedState,
                  builder: (context, state) {
                    return SafeArea(
                      child: BlocListener<AddIncomeBloc, AddIncomeState>(
                        bloc: _addIncomeBloc,
                        listener: (context, state) {
                          if (state.runtimeType == AddIncomePageLoadedState) {
                            _sourceTextEditingController.clear();
                            _sourceFocusNode.requestFocus();
                            _amountTextEditingController.clear();
                            _addIncomeBloc
                                .add(AddIncomeSourceValueChanged(value: ''));
                            _addIncomeBloc
                                .add(AddIncomeAmountValueChanged(value: ''));
                          } else if (state is AddIncomeAddIncomeSuccessState) {
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
                                    "Income Details",
                                    style: TextStyle(
                                      fontFamily: "Sora",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  IncomeSourceField(
                                    sourceTextEditingController:
                                        _sourceTextEditingController,
                                    focusNode: _sourceFocusNode,
                                    addIncomeBloc: _addIncomeBloc,
                                  ),
                                  const SizedBox(height: 20),
                                  IncomeAmountField(
                                    amountTextEditingController:
                                        _amountTextEditingController,
                                    addIncomeBloc: _addIncomeBloc,
                                  ),
                                  const SizedBox(height: 20),
                                  IncomeDateSelector(
                                    addIncomeBloc: _addIncomeBloc,
                                  ),
                                  const SizedBox(height: 30),
                                  AddIncomeButton(
                                    addIncomeBloc: _addIncomeBloc,
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
                AddIncomeSnackbar(
                  addIncomeBloc: _addIncomeBloc,
                  widget: widget,
                ),
                AddIncomeLoader(addIncomeBloc: _addIncomeBloc),
              ],
            ),
          ),
        ));
  }
}

class AddIncomeSnackbar extends StatelessWidget {
  const AddIncomeSnackbar({
    super.key,
    required AddIncomeBloc addIncomeBloc,
    required this.widget,
  }) : _addIncomeBloc = addIncomeBloc;

  final AddIncomeBloc _addIncomeBloc;
  final AddIncomePage widget;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _addIncomeBloc,
      listener: (context, state) {
        switch (state) {
          case AddIncomeAddIncomeSuccessState _:
            UIUtils.showSnackbar(
              context,
              'Income added successfully!',
              type: SnackbarType.success,
            );
            break;
          case AddIncomeAddIncomeErrorState _:
            UIUtils.showSnackbar(
              context,
              'Error in adding income!',
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

class AddIncomeLoader extends StatelessWidget {
  const AddIncomeLoader({
    super.key,
    required AddIncomeBloc addIncomeBloc,
  }) : _addIncomeBloc = addIncomeBloc;

  final AddIncomeBloc _addIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncomeBloc, AddIncomeState>(
      bloc: _addIncomeBloc,
      buildWhen: (previous, current) => current is AddIncomeActionState,
      builder: (context, state) {
        switch (state) {
          case AddIncomeAddIncomeLoadingState _:
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

class AddIncomeButton extends StatelessWidget {
  const AddIncomeButton({
    super.key,
    required AddIncomeBloc addIncomeBloc,
  }) : _addIncomeBloc = addIncomeBloc;

  final AddIncomeBloc _addIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (previous, current) =>
          current is AddIncomeInputValueChangedState,
      bloc: _addIncomeBloc,
      builder: (context, state) {
        bool isInputValid = state is AddIncomeInputValueChangedState
            ? state.isInputValid
            : false;
        return SizedBox(
          width: double.infinity,
          height: 55,
          child: AppThemeButton(
              onPressed: isInputValid
                  ? () {
                      _addIncomeBloc.add(AddIncomeAddIncomeTappedEvent());
                    }
                  : null,
              text: 'Save Income'),
        );
      },
    );
  }
}

class IncomeDateSelector extends StatelessWidget {
  const IncomeDateSelector({
    super.key,
    required AddIncomeBloc addIncomeBloc,
  }) : _addIncomeBloc = addIncomeBloc;

  final AddIncomeBloc _addIncomeBloc;

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
                _addIncomeBloc.add(AddIncomeDateValueChanged(value: value));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IncomeAmountField extends StatelessWidget {
  const IncomeAmountField({
    super.key,
    required TextEditingController amountTextEditingController,
    required AddIncomeBloc addIncomeBloc,
  })  : _amountTextEditingController = amountTextEditingController,
        _addIncomeBloc = addIncomeBloc;

  final TextEditingController _amountTextEditingController;
  final AddIncomeBloc _addIncomeBloc;

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
        _addIncomeBloc.add(AddIncomeAmountValueChanged(value: value));
      },
    );
  }
}

class IncomeSourceField extends StatelessWidget {
  const IncomeSourceField({
    super.key,
    required TextEditingController sourceTextEditingController,
    required FocusNode focusNode,
    required AddIncomeBloc addIncomeBloc,
  })  : _sourceTextEditingController = sourceTextEditingController,
        _focusNode = focusNode,
        _addIncomeBloc = addIncomeBloc;

  final TextEditingController _sourceTextEditingController;
  final FocusNode _focusNode;
  final AddIncomeBloc _addIncomeBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      focusNode: _focusNode,
      controller: _sourceTextEditingController,
      inputFormatters: [LengthLimitingTextInputFormatter(25)],
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Income Source',
        hintText: 'Where did the income come from?',
        prefixIcon: const Icon(Icons.account_balance_wallet_outlined,
            color: Colors.black54),
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
      onChanged: (value) {
        _addIncomeBloc.add(AddIncomeSourceValueChanged(value: value));
      },
    );
  }
}
