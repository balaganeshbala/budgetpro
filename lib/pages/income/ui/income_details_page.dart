import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/models/income_category_enum.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/pages/income/bloc/income_details_bloc.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:budgetpro/widgets/date_picker_widget.dart';
import 'package:budgetpro/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeDetailsPage extends StatefulWidget {
  final IncomeModel income;

  const IncomeDetailsPage({super.key, required this.income});

  @override
  State<IncomeDetailsPage> createState() => _IncomeDetailsPageState();
}

class _IncomeDetailsPageState extends State<IncomeDetailsPage> {
  late final IncomeDetailsBloc _incomeDetailsBloc;
  final _sourceTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  bool _shouldRefresh = false;
  bool _isReturning = false;

  @override
  void initState() {
    _incomeDetailsBloc = IncomeDetailsBloc();
    _incomeDetailsBloc.add(IncomeDetailsInitialEvent(income: widget.income));

    // Populate text fields with existing data
    _sourceTextEditingController.text = widget.income.source;
    _amountTextEditingController.text = widget.income.amount.toString();

    super.initState();
  }

  @override
  void dispose() {
    _sourceTextEditingController.dispose();
    _amountTextEditingController.dispose();
    _incomeDetailsBloc.close();
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
            'Income Details',
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
              tooltip: 'Delete Income',
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
              BlocBuilder<IncomeDetailsBloc, IncomeDetailsState>(
                bloc: _incomeDetailsBloc,
                buildWhen: (previous, current) =>
                    current is IncomeDetailsLoadedState,
                builder: (context, state) {
                  return SafeArea(
                    child: BlocListener<IncomeDetailsBloc, IncomeDetailsState>(
                      bloc: _incomeDetailsBloc,
                      listener: (context, state) {
                        if (state is IncomeDetailsUpdatedSuccessState &&
                            !_isReturning) {
                          _shouldRefresh = true;
                          _isReturning = true; // Prevent multiple actions

                          UIUtils.showSnackbar(
                            context,
                            'Income updated successfully!',
                            type: SnackbarType.success,
                          );

                          // Add a short delay before navigating back
                          Future.delayed(const Duration(milliseconds: 800), () {
                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                          });
                        } else if (state is IncomeDetailsDeletedSuccessState) {
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
                                IncomeSourceField(
                                  sourceTextEditingController:
                                      _sourceTextEditingController,
                                  incomeDetailsBloc: _incomeDetailsBloc,
                                ),
                                const SizedBox(height: 20),
                                IncomeAmountField(
                                  amountTextEditingController:
                                      _amountTextEditingController,
                                  incomeDetailsBloc: _incomeDetailsBloc,
                                ),
                                const SizedBox(height: 20),
                                IncomeCategorySelector(
                                  initialCategory: widget.income.category,
                                  categories: state is IncomeDetailsLoadedState
                                      ? state.categories
                                      : IncomeCategoryExtension
                                          .getAllCategories(),
                                  incomeDetailsBloc: _incomeDetailsBloc,
                                ),
                                const SizedBox(height: 20),
                                IncomeDateSelector(
                                  initialDate:
                                      Utils.parseDate(widget.income.date),
                                  incomeDetailsBloc: _incomeDetailsBloc,
                                ),
                                const SizedBox(height: 30),
                                UpdateIncomeButton(
                                  incomeDetailsBloc: _incomeDetailsBloc,
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
              BlocBuilder<IncomeDetailsBloc, IncomeDetailsState>(
                bloc: _incomeDetailsBloc,
                buildWhen: (previous, current) =>
                    current is IncomeDetailsLoadingState ||
                    current is IncomeDetailsErrorState,
                builder: (context, state) {
                  if (state is IncomeDetailsLoadingState) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentColor,
                        ),
                      ),
                    );
                  } else if (state is IncomeDetailsErrorState) {
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
                                  color: AppColors.primaryColor,
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
      'Delete Income',
      'Are you sure you want to delete this income? This action cannot be undone.',
    );

    if (confirm && context.mounted) {
      _incomeDetailsBloc.add(IncomeDetailsDeleteEvent());
    }
  }
}

class UpdateIncomeButton extends StatelessWidget {
  const UpdateIncomeButton({
    super.key,
    required IncomeDetailsBloc incomeDetailsBloc,
  }) : _incomeDetailsBloc = incomeDetailsBloc;

  final IncomeDetailsBloc _incomeDetailsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      buildWhen: (previous, current) =>
          current is IncomeDetailsInputValueChangedState,
      bloc: _incomeDetailsBloc,
      builder: (context, state) {
        bool isInputValid = state is IncomeDetailsInputValueChangedState
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
                        'Update Income',
                        'Are you sure you want to update this income?',
                      );
                      if (confirm) {
                        _incomeDetailsBloc.add(IncomeDetailsUpdateEvent());
                      }
                    }
                  : null,
              text: 'Update Income'),
        );
      },
    );
  }
}

class IncomeDateSelector extends StatelessWidget {
  final DateTime initialDate;

  const IncomeDateSelector({
    super.key,
    required IncomeDetailsBloc incomeDetailsBloc,
    required this.initialDate,
  }) : _incomeDetailsBloc = incomeDetailsBloc;

  final IncomeDetailsBloc _incomeDetailsBloc;

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
                _incomeDetailsBloc.add(IncomeDetailsDateChanged(value: value));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IncomeCategorySelector extends StatelessWidget {
  final IncomeCategory initialCategory;

  const IncomeCategorySelector({
    super.key,
    required this.initialCategory,
    required this.categories,
    required IncomeDetailsBloc incomeDetailsBloc,
  }) : _incomeDetailsBloc = incomeDetailsBloc;

  final List<IncomeCategory> categories;
  final IncomeDetailsBloc _incomeDetailsBloc;

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
                  IncomeCategory selectedCategory = categories.firstWhere(
                    (category) => category.displayName == value,
                    orElse: () => IncomeCategory.other,
                  );
                  _incomeDetailsBloc.add(
                      IncomeDetailsCategoryChanged(value: selectedCategory));
                }
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
    required IncomeDetailsBloc incomeDetailsBloc,
  })  : _amountTextEditingController = amountTextEditingController,
        _incomeDetailsBloc = incomeDetailsBloc;

  final TextEditingController _amountTextEditingController;
  final IncomeDetailsBloc _incomeDetailsBloc;

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
        _incomeDetailsBloc.add(IncomeDetailsAmountChanged(value: value));
      },
    );
  }
}

class IncomeSourceField extends StatelessWidget {
  const IncomeSourceField({
    super.key,
    required TextEditingController sourceTextEditingController,
    required IncomeDetailsBloc incomeDetailsBloc,
  })  : _sourceTextEditingController = sourceTextEditingController,
        _incomeDetailsBloc = incomeDetailsBloc;

  final TextEditingController _sourceTextEditingController;
  final IncomeDetailsBloc _incomeDetailsBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
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
        _incomeDetailsBloc.add(IncomeDetailsSourceChanged(value: value));
      },
    );
  }
}
