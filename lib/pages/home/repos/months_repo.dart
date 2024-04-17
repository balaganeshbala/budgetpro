import 'package:budgetpro/utits/network_services.dart';

class MonthsRepo {
  static Future<List<String>> fetchMonths() async {
    const urlString = "https://cloudpigeon.cyclic.app/budgetpro/months";
    try {
      final List<dynamic> result =
          await NetworkCallService.instance.makeAPICall(urlString);
      final months = result.map((item) => item.toString()).toList();
      return months;
    } catch (e) {
      return [];
    }
  }
}
