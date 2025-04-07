import 'package:budgetpro/pages/home/models/incomes_model.dart';
import 'package:budgetpro/utits/constants.dart';
import 'package:budgetpro/utits/network_services.dart';

class IncomesRepo {
  static Future<List<IncomeModel>> fetchIncomesForMonth(String month) async {
    final urlString = '$apiEndPoint/budgetpro/incomes?month=$month';
    try {
      final List<dynamic> result =
          await NetworkCallService.instance.makeAPICall(urlString);
      final incomes = result.map((item) => IncomeModel.fromJson(item)).toList();
      return incomes;
    } catch (e) {
      return [];
    }
  }
}
