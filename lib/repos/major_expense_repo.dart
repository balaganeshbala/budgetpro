import 'package:budgetpro/models/major_expense_model.dart';
import 'package:budgetpro/services/supabase_service.dart';

class MajorExpenseRepo {
  static Future<List<MajorExpenseModel>> fetchMajorExpenses() async {
    try {
      final List<dynamic> result = await SupabaseService.client
          .from("major_expenses")
          .select()
          .order("date", ascending: false);
      final majorExpenses =
          result.map((item) => MajorExpenseModel.fromJson(item)).toList();
      return majorExpenses;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addMajorExpense(Map<String, dynamic> data) async {
    try {
      await SupabaseService.insert("major_expenses", data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateMajorExpense(
      int expenseId, Map<String, dynamic> data) async {
    try {
      await SupabaseService.update("major_expenses", "id", expenseId, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteMajorExpense(int expenseId) async {
    try {
      await SupabaseService.delete("major_expenses", "id", expenseId);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<double> getTotalMajorExpenses() async {
    try {
      final List<dynamic> result =
          await SupabaseService.client.from("major_expenses").select("amount");

      double total = 0.0;
      for (var item in result) {
        total += (item['amount'] as num).toDouble();
      }

      return total;
    } catch (e) {
      return 0.0;
    }
  }
}
