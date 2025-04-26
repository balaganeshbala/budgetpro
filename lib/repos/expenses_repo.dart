import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/utils.dart';

class ExpensesRepo {
  static Future<List<ExpenseModel>> fetchExpensesForMonth(String month) async {
    try {
      final monthDate = Utils.getMonthStartAndEndDate(month);
      final startDate = monthDate['startDate']!;
      final endDate = monthDate['endDate']!;
      final List<dynamic> result = await SupabaseService.fetchByDateRange(
          "expenses", "date", startDate, endDate);
      final expenses =
          result.map((item) => ExpenseModel.fromJson(item)).toList();
      return expenses;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addExpense(Map<String, dynamic> data) async {
    try {
      await SupabaseService.insert("expenses", data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateExpense(
      int expenseId, Map<String, dynamic> data) async {
    try {
      await SupabaseService.update("expenses", "id", expenseId, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteExpense(int expenseId) async {
    try {
      await SupabaseService.delete("expenses", "id", expenseId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
