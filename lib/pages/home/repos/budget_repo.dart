import 'package:budgetpro/models/budget_model.dart';
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
}
