import 'package:budgetpro/models/budget_model.dart';
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
    // Calculate min and max values
    num minValue = data
        .map((budget) => budget.budgetAmount < budget.spentAmount
            ? budget.budgetAmount
            : budget.spentAmount)
        .reduce((a, b) => a < b ? a : b);

    num maxValue = data
        .map((budget) => budget.budgetAmount > budget.spentAmount
            ? budget.budgetAmount
            : budget.spentAmount)
        .reduce((a, b) => a > b ? a : b);

    num range = maxValue - minValue;
    double padding = range * 0.2;
    double rawMinY = minValue - padding;
    double rawMaxY = maxValue + padding;

    // Round minY and maxY to the nearest significant step (e.g., 10000)
    double roundTo = 10000.0;
    double minY = (rawMinY / roundTo).floor() * roundTo;
    double maxY = (rawMaxY / roundTo).ceil() * roundTo;

    return LineChart(LineChartData(
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: AppColors.iconColor),
      ),
      backgroundColor: Colors.black12,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: data.map((budget) {
            return FlSpot(data.indexOf(budget).toDouble(),
                budget.budgetAmount.toDouble());
          }).toList(),
          isCurved: true,
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
          isCurved: true,
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
            interval: 2,
            getTitlesWidget: (value, meta) {
              if (value.toInt() == data.length - 1) {
                return const SizedBox(); // Hide the last title
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  data[value.toInt()].month.substring(0, 3),
                  style: const TextStyle(
                      fontFamily: "Sora", fontSize: 11, color: Colors.black),
                ),
              );
            },
          )),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            interval: 20000,
            reservedSize: 35,
            getTitlesWidget: (value, meta) {
              String formattedValue = value >= 100000
                  ? "${(value / 100000).toStringAsFixed(1)}L"
                  : "${(value / 1000).toStringAsFixed(0)}K";
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  formattedValue, // Example: Show values in thousands
                  style: const TextStyle(
                    fontFamily: "Sora", // Custom font
                    fontSize: 11, // Adjust size
                    color: Colors.black, // Adjust color
                  ),
                ),
              );
            },
          )),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false))),
    ));
  }
}
