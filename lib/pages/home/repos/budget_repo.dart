import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/utits/constants.dart';
import 'package:budgetpro/utits/network_services.dart';

class BudgetRepo {
  static Future<List<BudgetModel>> fetchBudgetForMonth(String month) async {
    final urlString = '$API_END_POINT/budgetpro/budget?month=$month';
    try {
      final List<dynamic> result =
          await NetworkCallService.instance.makeAPICall(urlString);
      final budget = result.map((item) => BudgetModel.fromJson(item)).toList();
      return budget;
    } catch (e) {
      return [];
    }
  }

  static Future<List<MonthlyBudgetModel>> fetchMonthlyBudgets() async {
    const urlString = '$API_END_POINT/budgetpro/totalbudget?limit=8';
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
