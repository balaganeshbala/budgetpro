import 'package:budgetpro/pages/home/models/expenses_model.dart';
import 'package:budgetpro/utits/network_services.dart';

class ExpensesRepo {
  static Future<List<ExpenseModel>> fetchExpensesForMonth(String month) async {
    final urlString =
        'https://cloudpigeon.cyclic.app/budgetpro/expenses?month=$month';
    try {
      final List<dynamic> result =
          await NetworkCallService.instance.makeAPICall(urlString);
      final expenses =
          result.map((item) => ExpenseModel.fromJson(item)).toList();
      return expenses;
    } catch (e) {
      return [];
    }
  }
}
