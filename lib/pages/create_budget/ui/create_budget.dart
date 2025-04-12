import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/utits/utils.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({Key? key, required this.month, required this.year})
      : super(key: key);

  final String month;
  final String year;

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  final Map<String, TextEditingController> _controllers = {};
  double _totalBudget = 0.0;
  final List<ExpenseCategory> categories =
      ExpenseCategoryExtension.getAllCategories();

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each category
    for (var category in categories) {
      final controller = TextEditingController();
      controller.addListener(_updateTotal);
      _controllers[category.name] = controller;
    }
  }

  void _updateTotal() {
    double total = 0.0;
    for (var controller in _controllers.values) {
      if (controller.text.isNotEmpty) {
        total += double.tryParse(controller.text) ?? 0.0;
      }
    }
    setState(() {
      _totalBudget = total;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Monthly Budget',
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
                'Set your budget limits for ${widget.month}-${widget.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Sora",
                ),
              ),
            ),
            // Total Budget Card
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        Utils.formatRupees(_totalBudget),
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
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildBudgetInputField(category);
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryColor,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: AppColors.primaryColor),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sora",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveBudget,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Save Budget',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Sora",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  void _saveBudget() async {
    final currentMonthDate =
        Utils.formatDate("${widget.year}-${widget.month}-01");
    final userId = SupabaseService.client.auth.currentUser?.id;
    final List budgetData = [];
    bool hasAtLeastOneBudget = false;

    for (var category in categories) {
      double amount =
          double.tryParse(_controllers[category.name]?.text ?? '0.0') ?? 0.0;

      if (amount > 0) {
        hasAtLeastOneBudget = true;
      }

      final categoryData = {
        'date': currentMonthDate,
        'category': category.name,
        'amount': amount,
        'user_id': userId
      };

      budgetData.add(categoryData);
    }

    if (!hasAtLeastOneBudget) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set at least one budget category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await SupabaseService.insertRows('budget', budgetData);

      if (!mounted) return;

      UIUtils.showSnackbar(context, 'Budget created successfully!',
          type: SnackbarType.success);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      UIUtils.showSnackbar(context, 'Error creating budget!',
          type: SnackbarType.error);
    }
  }
}
