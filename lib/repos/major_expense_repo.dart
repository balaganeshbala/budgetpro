import 'package:budgetpro/models/major_expense_model.dart';
import 'package:budgetpro/services/supabase_service.dart';

class MajorExpenseRepo {
  static Future<List<MajorExpenseModel>> fetchMajorExpenses() async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated!');
      }

      final List<dynamic> result = await SupabaseService.client
          .from("major_expenses")
          .select()
          .eq('user_id', user.id)
          .order("date", ascending: false);

      final majorExpenses =
          result.map((item) => MajorExpenseModel.fromJson(item)).toList();
      return majorExpenses;
    } catch (e) {
      print('Error fetching major expenses: $e');
      return [];
    }
  }

  static Future<bool> addMajorExpense(Map<String, dynamic> data) async {
    try {
      await SupabaseService.insert("major_expenses", data);
      return true;
    } catch (e) {
      print('Error adding major expense: $e');
      return false;
    }
  }

  static Future<bool> updateMajorExpense(
      int expenseId, Map<String, dynamic> data) async {
    try {
      await SupabaseService.update("major_expenses", "id", expenseId, data);
      return true;
    } catch (e) {
      print('Error updating major expense: $e');
      return false;
    }
  }

  static Future<bool> deleteMajorExpense(int expenseId) async {
    try {
      await SupabaseService.delete("major_expenses", "id", expenseId);
      return true;
    } catch (e) {
      print('Error deleting major expense: $e');
      return false;
    }
  }

  static Future<double> getTotalMajorExpenses() async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated!');
      }
      final List<dynamic> result = await SupabaseService.client
          .from("major_expenses")
          .select("amount")
          .eq('user_id', user.id);

      double total = 0.0;
      for (var item in result) {
        total += (item['amount'] as num).toDouble();
      }

      return total;
    } catch (e) {
      print('Error calculating total major expenses: $e');
      return 0.0;
    }
  }

  static Future<MajorExpenseModel?> getMajorExpenseById(int expenseId) async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated!');
      }

      final List<dynamic> result = await SupabaseService.client
          .from("major_expenses")
          .select()
          .eq('id', expenseId)
          .eq('user_id', user.id);

      if (result.isNotEmpty) {
        return MajorExpenseModel.fromJson(result.first);
      }
      return null;
    } catch (e) {
      print('Error fetching major expense by ID: $e');
      return null;
    }
  }
}
