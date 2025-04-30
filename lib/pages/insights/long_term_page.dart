import 'dart:math';

import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/models/monthly_summary.dart';
import 'package:budgetpro/repos/historical_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';

class LongTermTrendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Long Term Trend',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora"),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                tabs: const [
                  Tab(text: 'Expenses'),
                  Tab(text: 'Income'),
                  Tab(text: 'Savings'),
                ],
                labelColor: AppColors.primaryColor,
                labelStyle: const TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryColor,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey.shade200,
                child: SafeArea(
                  child: TabBarView(
                    children: [
                      _buildExpenseTrendTab(),
                      _buildIncomeTrendTab(),
                      _buildSavingsTrendTab(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseTrendTab() {
    return FutureBuilder<List<MonthlySummary>>(
      future: HistoricalDataRepo.getExpenseTrend(24), // Last 2 years
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.accentColor,
          ));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No expense history available',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add more expenses to see trends over time',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final data = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(text: 'Expense Trend', paddingLeft: 0),
              const Text("(Last 24 Months)",
                  style: TextStyle(
                      fontFamily: "Sora", fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),

              // Monthly trend chart
              Container(
                height: 300,
                padding: const EdgeInsets.only(right: 20, top: 20, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: _buildTrendChart(data),
              ),

              const SizedBox(height: 24),

              // Statistics section
              _buildStatisticsSection(data),

              const SizedBox(height: 24),

              // Rolling averages section
              _buildRollingAverageSection(data),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIncomeTrendTab() {
    return FutureBuilder<List<MonthlySummary>>(
      future: HistoricalDataRepo.getIncomeTrend(24), // Last 2 years
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.accentColor,
          ));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No income history available',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add more income records to see trends over time',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final data = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(text: 'Income Trend', paddingLeft: 0),
              const Text("(Last 24 Months)",
                  style: TextStyle(
                      fontFamily: "Sora", fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),

              // Monthly trend chart
              Container(
                height: 300,
                padding: const EdgeInsets.only(right: 20, top: 20, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: _buildTrendChart(data, isIncome: true),
              ),

              const SizedBox(height: 24),

              // Statistics section
              _buildStatisticsSection(data, isIncome: true),

              const SizedBox(height: 24),

              // Rolling averages section
              _buildRollingAverageSection(data, isIncome: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSavingsTrendTab() {
    return FutureBuilder<Map<String, List<MonthlySummary>>>(
      future: _fetchSavingsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.accentColor,
          ));
        }

        if (!snapshot.hasData ||
            snapshot.data!['income']!.isEmpty ||
            snapshot.data!['expense']!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Not enough data to calculate savings',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add more income and expense records to see savings trends',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final incomeData = snapshot.data!['income']!;
        final expenseData = snapshot.data!['expense']!;

        // Calculate savings for each month
        final savingsData = _calculateSavings(incomeData, expenseData);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(text: 'Savings Trend', paddingLeft: 0),
              const Text("(Last 24 Months)",
                  style: TextStyle(
                      fontFamily: "Sora", fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),

              // Monthly trend chart
              Container(
                height: 300,
                padding: const EdgeInsets.only(right: 20, top: 20, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: _buildSavingsChart(savingsData),
              ),

              const SizedBox(height: 24),

              // Statistics section
              _buildStatisticsSection(savingsData, isSavings: true),

              const SizedBox(height: 24),

              // Savings rate section
              _buildSavingsRateSection(incomeData, savingsData),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, List<MonthlySummary>>> _fetchSavingsData() async {
    // Fetch income and expense data in parallel
    final incomeData = await HistoricalDataRepo.getIncomeTrend(24);
    final expenseData = await HistoricalDataRepo.getExpenseTrend(24);

    return {
      'income': incomeData,
      'expense': expenseData,
    };
  }

  List<MonthlySummary> _calculateSavings(
      List<MonthlySummary> incomeData, List<MonthlySummary> expenseData) {
    // Create a map of income by month
    final incomeByMonth = <String, double>{};
    for (final income in incomeData) {
      final key = '${income.year}-${income.month}';
      incomeByMonth[key] = income.amount;
    }

    // Create a map of expenses by month
    final expensesByMonth = <String, double>{};
    for (final expense in expenseData) {
      final key = '${expense.year}-${expense.month}';
      expensesByMonth[key] = expense.amount;
    }

    // Calculate savings for each month that appears in both datasets
    final savingsList = <MonthlySummary>[];

    // Use income months as the base since we need income to calculate savings
    for (final income in incomeData) {
      final key = '${income.year}-${income.month}';
      if (expensesByMonth.containsKey(key)) {
        final incomeAmount = incomeByMonth[key] ?? 0.0;
        final expenseAmount = expensesByMonth[key] ?? 0.0;
        final savingsAmount = incomeAmount - expenseAmount;

        savingsList.add(MonthlySummary(
          year: income.year,
          month: income.month,
          amount: savingsAmount,
        ));
      }
    }

    // Sort by date
    savingsList.sort((a, b) => a.date.compareTo(b.date));

    return savingsList;
  }

  Widget _buildTrendChart(List<MonthlySummary> data, {bool isIncome = false}) {
    // Calculate max Y value for the chart
    final maxY =
        data.fold(0.0, (max, item) => item.amount > max ? item.amount : max);

    // Get evenly spaced months for X axis
    final months = _getDisplayMonths(data);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d).withOpacity(0.1),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d).withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: data.length > 12 ? 3 : 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  final index = value.toInt();
                  if (months.contains(index)) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        data[index].monthName,
                        style: const TextStyle(
                          color: Color(0xff68737d),
                          fontFamily: 'Sora',
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value >= 1000
                        ? '${(value / 1000).toStringAsFixed(0)}K'
                        : value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Color(0xff68737d),
                      fontFamily: 'Sora',
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d).withOpacity(0.1)),
        ),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: 0,
        maxY: maxY * 1.1, // Add 10% padding
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) {
              return Colors.grey.shade100;
            },
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final index = touchedSpot.x.toInt();
                if (index >= 0 && index < data.length) {
                  final month = data[index].monthName;
                  final year = data[index].year;
                  final amount = data[index].amount;
                  return LineTooltipItem(
                    '$month $year\n${Utils.formatRupees(amount)}',
                    const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.amount);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: isIncome
                  ? [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.5)
                    ]
                  : [
                      AppColors.accentColor,
                      AppColors.accentColor.withOpacity(0.5)
                    ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color:
                      isIncome ? AppColors.primaryColor : AppColors.accentColor,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: isIncome
                    ? [
                        AppColors.primaryColor.withOpacity(0.3),
                        AppColors.primaryColor.withOpacity(0.0)
                      ]
                    : [
                        AppColors.accentColor.withOpacity(0.3),
                        AppColors.accentColor.withOpacity(0.0)
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsChart(List<MonthlySummary> data) {
    // Find min and max values for the chart
    double minY = 0;
    final minValue =
        data.fold(0.0, (min, item) => item.amount < min ? item.amount : min);
    if (minValue < 0) {
      minY = minValue * 1.1; // Add 10% padding for negative values
    }

    final maxY =
        data.fold(0.0, (max, item) => item.amount > max ? item.amount : max) *
            1.1; // Add 10% padding

    // Get evenly spaced months for X axis
    final months = _getDisplayMonths(data);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (maxY - minY) / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d).withOpacity(0.1),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d).withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: data.length > 12 ? 3 : 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  final index = value.toInt();
                  if (months.contains(index)) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        data[index].monthName,
                        style: const TextStyle(
                          color: Color(0xff68737d),
                          fontFamily: 'Sora',
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY - minY) / 5,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.abs() >= 1000
                        ? '${value >= 0 ? '' : '-'}${(value.abs() / 1000).toStringAsFixed(0)}K'
                        : value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Color(0xff68737d),
                      fontFamily: 'Sora',
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d).withOpacity(0.1)),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) {
              return Colors.grey.shade100;
            },
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final index = touchedSpot.x.toInt();
                if (index >= 0 && index < data.length) {
                  final month = data[index].monthName;
                  final year = data[index].year;
                  final amount = data[index].amount;
                  return LineTooltipItem(
                    '$month $year\n${Utils.formatRupees(amount)}',
                    const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.amount);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final value = spot.y;
                return FlDotCirclePainter(
                  radius: 3,
                  color: value >= 0 ? Colors.green : Colors.red,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              spotsLine: BarAreaSpotsLine(
                show: true,
                flLineStyle: FlLine(
                  color: Colors.blue.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Colors.grey,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ],
        ),
      ),
    );
  }

  List<int> _getDisplayMonths(List<MonthlySummary> data) {
    // For few months, show all
    if (data.length <= 12) {
      return List.generate(data.length, (index) => index);
    }

    // For many months, show approximately quarterly
    final interval = (data.length / 6).ceil();
    return List.generate(
        6, (index) => (index * interval).clamp(0, data.length - 1));
  }

  Widget _buildStatisticsSection(List<MonthlySummary> data,
      {bool isIncome = false, bool isSavings = false}) {
    // Calculate statistics
    final average = data.isEmpty
        ? 0.0
        : data.fold(0.0, (sum, item) => sum + item.amount) / data.length;

    final max = data.isEmpty
        ? 0.0
        : data.fold(0.0, (max, item) => item.amount > max ? item.amount : max);

    final min = data.isEmpty
        ? 0.0
        : data.fold(double.infinity,
            (min, item) => item.amount < min ? item.amount : min);

    // Calculate trend
    String trendText = 'Stable';
    IconData trendIcon = Icons.trending_flat;
    Color trendColor = Colors.orange;
    double trendPercentage = 0.0;

    if (data.length >= 6) {
      final firstHalf = data.sublist(0, data.length ~/ 2);
      final secondHalf = data.sublist(data.length ~/ 2);

      final firstHalfAvg = firstHalf.isEmpty
          ? 0.0
          : firstHalf.fold(0.0, (sum, item) => sum + item.amount) /
              firstHalf.length;

      final secondHalfAvg = secondHalf.isEmpty
          ? 0.0
          : secondHalf.fold(0.0, (sum, item) => sum + item.amount) /
              secondHalf.length;

      if (firstHalfAvg != 0) {
        trendPercentage =
            ((secondHalfAvg - firstHalfAvg) / firstHalfAvg.abs()) * 100;
      }

      if (trendPercentage > 5) {
        trendText = 'Increasing';
        trendIcon = Icons.trending_up;
        trendColor = isSavings || isIncome ? Colors.green : Colors.red;
      } else if (trendPercentage < -5) {
        trendText = 'Decreasing';
        trendIcon = Icons.trending_down;
        trendColor = isSavings || isIncome ? Colors.red : Colors.green;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Statistics',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Average',
                  average,
                  Icons.calculate_outlined,
                  AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Maximum',
                  max,
                  Icons.arrow_upward,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Minimum',
                  min,
                  Icons.arrow_downward,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: trendColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trend',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            trendIcon,
                            color: trendColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              trendText,
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: trendColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${trendPercentage.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 13,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, double value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  Utils.formatRupees(value),
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRollingAverageSection(List<MonthlySummary> data,
      {bool isIncome = false}) {
    // Calculate 3-month rolling average
    final rollingAverages = <double>[];

    for (int i = 0; i < data.length; i++) {
      if (i >= 2) {
        final avg =
            (data[i].amount + data[i - 1].amount + data[i - 2].amount) / 3;
        rollingAverages.add(avg);
      } else if (i == 1) {
        final avg = (data[i].amount + data[i - 1].amount) / 2;
        rollingAverages.add(avg);
      } else {
        rollingAverages.add(data[i].amount);
      }
    }

    // Calculate volatility (standard deviation)
    double average = data.isEmpty
        ? 0
        : data.fold(0.0, (sum, item) => sum + item.amount) / data.length;

    double variance = 0;
    if (data.length > 1) {
      variance =
          data.fold(0.0, (sum, item) => sum + pow(item.amount - average, 2)) /
              (data.length - 1);
    }
    final volatility = sqrt(variance);

    // Calculate coefficient of variation (CV) which measures relative volatility
    final cv = average != 0 ? (volatility / average) * 100 : 0;

    String volatilityText = 'Low';
    Color volatilityColor = Colors.green;

    if (cv > 30) {
      volatilityText = 'High';
      volatilityColor = Colors.red;
    } else if (cv > 15) {
      volatilityText = 'Medium';
      volatilityColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Trend Analysis',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Volatility indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: volatilityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: volatilityColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$volatilityText Volatility',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: volatilityColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isIncome
                            ? 'Your income varies by approximately ${cv.toStringAsFixed(1)}% month to month.'
                            : 'Your spending varies by approximately ${cv.toStringAsFixed(1)}% month to month.',
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Recent months analysis
          if (data.length >= 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Months',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildRecentMonthCard(
                        data[data.length - 3].monthName,
                        data[data.length - 3].amount,
                        isIncome
                            ? AppColors.primaryColor
                            : AppColors.accentColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildRecentMonthCard(
                        data[data.length - 2].monthName,
                        data[data.length - 2].amount,
                        isIncome
                            ? AppColors.primaryColor
                            : AppColors.accentColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildRecentMonthCard(
                        data[data.length - 1].monthName,
                        data[data.length - 1].amount,
                        isIncome
                            ? AppColors.primaryColor
                            : AppColors.accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Analysis',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getRecentMonthsAnalysis(data, isIncome),
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRecentMonthCard(String month, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            month,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Utils.formatRupees(amount),
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getRecentMonthsAnalysis(List<MonthlySummary> data, bool isIncome) {
    if (data.length < 3) return 'Not enough data for analysis.';

    final recent1 = data[data.length - 1].amount;
    final recent2 = data[data.length - 2].amount;
    final recent3 = data[data.length - 3].amount;

    final recentAvg = (recent1 + recent2 + recent3) / 3;

    final lastSixMonths = data.length >= 6
        ? data.sublist(data.length - 6, data.length - 3)
        : data.sublist(0, data.length - 3);

    final previousAvg = lastSixMonths.isEmpty
        ? 0
        : lastSixMonths.fold(0.0, (sum, item) => sum + item.amount) /
            lastSixMonths.length;

    final percentChange =
        previousAvg != 0 ? ((recentAvg - previousAvg) / previousAvg) * 100 : 0;

    final month1 = data[data.length - 1].monthName;
    final month3 = data[data.length - 3].monthName;

    if (isIncome) {
      if (percentChange > 10) {
        return 'Your income has increased by ${percentChange.toStringAsFixed(1)}% from the previous period. Your recent three month average of ${Utils.formatRupees(recentAvg)} shows a positive trend.';
      } else if (percentChange < -10) {
        return 'Your income has decreased by ${percentChange.abs().toStringAsFixed(1)}% from the previous period. Your recent income from $month3 to $month1 is lower than earlier months.';
      } else {
        return 'Your income has been relatively stable with only ${percentChange.abs().toStringAsFixed(1)}% change from previous months. Your three month average is ${Utils.formatRupees(recentAvg)}.';
      }
    } else {
      if (percentChange > 10) {
        return 'Your spending has increased by ${percentChange.toStringAsFixed(1)}% compared to previous months. Recent spending from $month3 to $month1 averages ${Utils.formatRupees(recentAvg)}.';
      } else if (percentChange < -10) {
        return 'Your spending has decreased by ${percentChange.abs().toStringAsFixed(1)}% compared to previous months. This is a positive trend showing better expense control.';
      } else {
        return 'Your spending has remained consistent with only ${percentChange.abs().toStringAsFixed(1)}% change from previous months. The three month average is ${Utils.formatRupees(recentAvg)}.';
      }
    }
  }

  Widget _buildSavingsRateSection(
    List<MonthlySummary> incomeData,
    List<MonthlySummary> savingsData,
  ) {
    // Calculate savings rates for recent months
    final savingsRates = <int, double>{};

    // Create map of income by year-month
    final incomeByMonth = <String, double>{};
    for (final income in incomeData) {
      final key = '${income.year}-${income.month}';
      incomeByMonth[key] = income.amount;
    }

    // Calculate savings rates for months that have both income and savings data
    for (int i = 0; i < savingsData.length; i++) {
      final savings = savingsData[i];
      final key = '${savings.year}-${savings.month}';
      if (incomeByMonth.containsKey(key) && incomeByMonth[key]! > 0) {
        final rate = (savings.amount / incomeByMonth[key]!) * 100;
        savingsRates[i] = rate;
      }
    }

    // Calculate average savings rate
    double avgSavingsRate = 0;
    if (savingsRates.isNotEmpty) {
      avgSavingsRate =
          savingsRates.values.fold(0.0, (sum, rate) => sum + rate) /
              savingsRates.length;
    }

    // Calculate trend
    String trendText = '';
    Color trendColor = Colors.orange;
    IconData trendIcon = Icons.trending_flat;

    // Get most recent 3 months with savings rate data
    final recentIndices = savingsRates.keys.toList()..sort();
    if (recentIndices.length >= 3) {
      final recent = recentIndices.sublist(recentIndices.length - 3);

      final recentRates = recent.map((i) => savingsRates[i]!).toList();
      final avgRecentRate =
          recentRates.fold(0.0, (sum, rate) => sum + rate) / recentRates.length;

      final prevIndices = recentIndices.sublist(0, recentIndices.length - 3);
      if (prevIndices.isNotEmpty) {
        final prevRates = prevIndices.map((i) => savingsRates[i]!).toList();
        final avgPrevRate =
            prevRates.fold(0.0, (sum, rate) => sum + rate) / prevRates.length;

        final rateChange = avgRecentRate - avgPrevRate;

        if (rateChange > 5) {
          trendText = 'Your savings rate is improving';
          trendColor = Colors.green;
          trendIcon = Icons.trending_up;
        } else if (rateChange < -5) {
          trendText = 'Your savings rate is declining';
          trendColor = Colors.red;
          trendIcon = Icons.trending_down;
        } else {
          trendText = 'Your savings rate is stable';
          trendColor = Colors.blue;
          trendIcon = Icons.trending_flat;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.savings_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Savings Rate',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Average savings rate
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getSavingsRateColor(avgSavingsRate).withOpacity(0.1),
                border: Border.all(
                  color: _getSavingsRateColor(avgSavingsRate),
                  width: 4,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${avgSavingsRate.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getSavingsRateColor(avgSavingsRate),
                      ),
                    ),
                    Text(
                      'Average',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Savings rate recommendation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommended savings rate: 20%',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getSavingsRateRecommendation(avgSavingsRate),
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Trend information (if available)
          if (trendText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: trendColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    trendIcon,
                    color: trendColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      trendText,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: trendColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getSavingsRateColor(double rate) {
    if (rate < 0) return Colors.red;
    if (rate < 10) return Colors.orange;
    if (rate < 20) return Colors.blue;
    return Colors.green;
  }

  String _getSavingsRateRecommendation(double rate) {
    if (rate < 0) {
      return 'You\'re currently spending more than you earn. Focus on reducing expenses or increasing income to achieve a positive savings rate.';
    }
    if (rate < 10) {
      return 'Your savings rate is below the recommended level. Consider reviewing your expenses to find opportunities to save more.';
    }
    if (rate < 20) {
      return 'You\'re on the right track! With a few adjustments, you can reach the recommended 20% savings rate for long-term financial health.';
    }
    return 'Excellent! You\'re saving at or above the recommended rate, which puts you in a strong position for financial stability and growth.';
  }
}
