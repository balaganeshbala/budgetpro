import 'package:budgetpro/models/monthly_summary.dart';
import 'package:budgetpro/services/supabase_service.dart';

class HistoricalDataRepo {
  // Get expense trends for a specific period
  static Future<List<MonthlySummary>> getExpenseTrend(int months) async {
    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - months + 1, 1);

      final result = await SupabaseService.client
          .from('monthly_expense_summaries')
          .select()
          .gte('year', startDate.year)
          .lte('year', now.year)
          .order('year', ascending: true)
          .order('month', ascending: true);

      // Filter to make sure we only get the last N months
      final filteredResults = (result as List<dynamic>).where((item) {
        final itemDate = DateTime(item['year'], item['month'], 1);
        return !itemDate.isBefore(startDate);
      }).toList();

      return filteredResults
          .map((item) => MonthlySummary.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching expense trend: $e');
      return [];
    }
  }

  // Get income trends
  static Future<List<MonthlySummary>> getIncomeTrend(int months) async {
    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - months + 1, 1);

      final result = await SupabaseService.client
          .from('monthly_income_summaries')
          .select()
          .gte('year', startDate.year)
          .lte('year', now.year)
          .order('year', ascending: true)
          .order('month', ascending: true);

      // Filter to make sure we only get the last N months
      final filteredResults = (result as List<dynamic>).where((item) {
        final itemDate = DateTime(item['year'], item['month'], 1);
        return !itemDate.isBefore(startDate);
      }).toList();

      return filteredResults
          .map((item) => MonthlySummary.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching income trend: $e');
      return [];
    }
  }

  // Get category breakdown for a specific period
  static Future<Map<String, double>> getCategoryBreakdown(
      String type, // 'expense', 'income', or 'budget'
      DateTime startDate,
      DateTime endDate) async {
    try {
      final result = await SupabaseService.client
          .from('category_monthly_summaries')
          .select()
          .eq('category_type', type)
          .gte('year', startDate.year)
          .lte('year', endDate.year)
          .order('total_amount', ascending: false);

      // Filter to ensure we're in the right date range
      final filteredResults = (result as List<dynamic>).where((item) {
        final itemDate = DateTime(item['year'], item['month'], 1);
        return !itemDate.isBefore(startDate) &&
            !itemDate.isAfter(DateTime(endDate.year, endDate.month + 1, 0));
      }).toList();

      // Aggregate by category
      Map<String, double> categoryTotals = {};
      for (var item in filteredResults) {
        final category = item['category_name'];
        final amount = item['total_amount'].toDouble();
        categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
      }

      return categoryTotals;
    } catch (e) {
      print('Error fetching category breakdown: $e');
      return {};
    }
  }

  // Get year-over-year comparison
  static Future<Map<String, List<MonthlySummary>>> getYearlyComparison(
      String type, // 'expense', 'income', or 'budget'
      int year1,
      int year2) async {
    try {
      final result = await SupabaseService.client
          .from(type == 'expense'
              ? 'monthly_expense_summaries'
              : type == 'income'
                  ? 'monthly_income_summaries'
                  : 'monthly_budget_summaries')
          .select()
          .or('year.eq.$year1,year.eq.$year2')
          .order('month');

      // Split results by year
      final year1Data = (result as List<dynamic>)
          .where((item) => item['year'] == year1)
          .map((item) => MonthlySummary.fromJson(item))
          .toList();

      final year2Data = result
          .where((item) => item['year'] == year2)
          .map((item) => MonthlySummary.fromJson(item))
          .toList();

      return {
        'year1': year1Data,
        'year2': year2Data,
      };
    } catch (e) {
      print('Error fetching yearly comparison: $e');
      return {
        'year1': [],
        'year2': [],
      };
    }
  }
}
