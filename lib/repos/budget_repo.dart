import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/constants.dart';
import 'package:budgetpro/services/network_services.dart';
import 'package:budgetpro/utits/utils.dart';

class BudgetRepo {
  static Future<List<CategorizedBudgetModel>> fetchBudgetForMonth(
      String month) async {
    return [];
  }

  static Future<List<BudgetModel>> fetchNewBudgetForMonth(String month) async {
    try {
      final monthDate = Utils.getMonthStartAndEndDate(month);
      final startDate = monthDate['startDate']!;
      final endDate = monthDate['endDate']!;
      final List<dynamic> result = await SupabaseService.fetchByDateRange(
          "budget", "date", startDate, endDate,
          orderBy: "amount", ascending: false);
      final budget = result.map((item) => BudgetModel.fromJson(item)).toList();
      return budget;
    } catch (e) {
      return [];
    }
  }

  static Future<List<MonthlyBudgetModel>> fetchMonthlyBudgets() async {
    const urlString = '$apiEndPoint/budgetpro/totalbudget?limit=13';
    try {
      final List<dynamic> result =
          await NetworkCallService.instance.makeAPICall(urlString);
      final montlyBudget =
          result.map((item) => MonthlyBudgetModel.fromJson(item)).toList();
      return montlyBudget;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveBudget({
    required String month,
    required String year,
    required Map<String, double> categoryBudgets,
    required List<ExpenseCategory> categories,
  }) async {
    final currentMonthDate = Utils.formatDate("$year-$month-01");
    final userId = SupabaseService.client.auth.currentUser?.id;
    final List budgetData = [];

    for (var category in categories) {
      double amount = categoryBudgets[category.name] ?? 0.0;

      final categoryData = {
        'date': currentMonthDate,
        'category': category.name,
        'amount': amount,
        'user_id': userId
      };

      budgetData.add(categoryData);
    }

    await SupabaseService.insertRows('budget', budgetData);
  }

  bool hasAtLeastOneBudget(Map<String, double> categoryBudgets) {
    return categoryBudgets.values.any((amount) => amount > 0);
  }
}
