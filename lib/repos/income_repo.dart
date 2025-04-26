import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/utils.dart';

class IncomeRepo {
  static Future<List<IncomeModel>> fetchIncomesForMonth(String month) async {
    try {
      final monthDate = Utils.getMonthStartAndEndDate(month);
      final startDate = monthDate['startDate']!;
      final endDate = monthDate['endDate']!;
      final List<dynamic> result = await SupabaseService.fetchByDateRange(
          "incomes", "date", startDate, endDate,
          orderBy: "date");
      final incomes = result.map((item) => IncomeModel.fromJson(item)).toList();
      return incomes;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addIncome(Map<String, dynamic> data) async {
    try {
      await SupabaseService.insert("incomes", data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateIncome(
      int incomeId, Map<String, dynamic> data) async {
    try {
      await SupabaseService.update("incomes", "id", incomeId, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteIncome(int incomeId) async {
    try {
      await SupabaseService.delete("incomes", "id", incomeId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
