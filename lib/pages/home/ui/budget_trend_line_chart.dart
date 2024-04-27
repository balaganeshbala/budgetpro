import 'package:budgetpro/pages/home/models/budget_model.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BudgetTrendLineChart extends StatelessWidget {
  final List<MonthlyBudgetModel> data;

  const BudgetTrendLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 20),
      child: SizedBox(
        height: 200,
        child: _buildLineChart(),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(LineChartData(
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: AppColors.iconColor),
      ),
      backgroundColor: Colors.black12,
      minY: 60000,
      maxY: 160000,
      lineBarsData: [
        LineChartBarData(
          spots: data.map((budget) {
            return FlSpot(data.indexOf(budget).toDouble(),
                budget.budgetAmount.toDouble());
          }).toList(),
          isCurved: false,
          color: AppColors.linkColor,
          barWidth: 2,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
          dotData: const FlDotData(show: true),
          show: true,
        ),
        LineChartBarData(
          spots: data.map((budget) {
            return FlSpot(data.indexOf(budget).toDouble(), budget.spentAmount);
          }).toList(),
          isCurved: false,
          color: AppColors.dangerColor,
          barWidth: 2,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
          dotData: const FlDotData(show: true),
          show: true,
        ),
      ],
      titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Text(data[value.toInt()].month.substring(0, 3));
            },
          )),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false))),
    ));
  }
}
