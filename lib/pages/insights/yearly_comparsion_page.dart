import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/models/monthly_summary.dart';
import 'package:budgetpro/repos/historical_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:intl/intl.dart';

class YearlyComparisonScreen extends StatefulWidget {
  const YearlyComparisonScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _YearlyComparisonScreenState();
  }
}

class _YearlyComparisonScreenState extends State<YearlyComparisonScreen> {
  late int currentYear;
  late int previousYear;

  @override
  void initState() {
    super.initState();
    currentYear = DateTime.now().year;
    previousYear = currentYear - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yearly Comparison',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora"),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: previousYear.toString(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: AppColors.primaryColor),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      underline: Container(),
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: "Sora",
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            previousYear = int.parse(newValue);
                          });
                        }
                      },
                      items: Utils.getYearsList()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.compare_arrows, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: currentYear.toString(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: AppColors.primaryColor),
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      underline: Container(),
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: "Sora",
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            currentYear = int.parse(newValue);
                          });
                        }
                      },
                      items: Utils.getYearsList()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Expenses'),
                  Tab(text: 'Income'),
                  Tab(text: 'Budget'),
                ],
                labelColor: AppColors.primaryColor,
                labelStyle: TextStyle(
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
                      _buildYearComparisonTab(
                          context, 'expense', previousYear, currentYear),
                      _buildYearComparisonTab(
                          context, 'income', previousYear, currentYear),
                      _buildYearComparisonTab(
                          context, 'budget', previousYear, currentYear),
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

  Widget _buildYearComparisonTab(
      BuildContext context, String type, int prevYear, int currYear) {
    return FutureBuilder<Map<String, List<MonthlySummary>>>(
      future: HistoricalDataRepo.getYearlyComparison(type, prevYear, currYear),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.accentColor,
          ));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final prevYearData = snapshot.data!['year1'] ?? [];
        final currYearData = snapshot.data!['year2'] ?? [];

        if (prevYearData.isEmpty && currYearData.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.compare_arrows,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No $type data available for comparison',
                    style: const TextStyle(
                      fontFamily: "Sora",
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add $type records for multiple years to compare',
                    style: const TextStyle(
                      fontFamily: "Sora",
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Calculate yearly totals
        final prevYearTotal =
            prevYearData.fold(0.0, (sum, item) => sum + item.amount);
        final currYearTotal =
            currYearData.fold(0.0, (sum, item) => sum + item.amount);

        // Calculate percentage change
        final percentChange = prevYearTotal > 0
            ? ((currYearTotal - prevYearTotal) / prevYearTotal) * 100
            : 0.0;

        // Determine if increase is good or bad based on type
        final isIncreasePositive = type == 'income';
        final changeColor = percentChange >= 0
            ? (isIncreasePositive ? Colors.green : Colors.red)
            : (isIncreasePositive ? Colors.red : Colors.green);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year summary card
                Container(
                  padding: const EdgeInsets.all(16.0),
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
                    children: [
                      Text(
                        'Total ${type.capitalize()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildYearTotal(prevYear.toString(), prevYearTotal),
                          _buildYearTotal(currYear.toString(), currYearTotal),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            percentChange >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: changeColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${percentChange.abs().toStringAsFixed(1)}% ${percentChange >= 0 ? 'increase' : 'decrease'}',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.bold,
                              color: changeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getYearComparisonAnalysis(
                            type, percentChange, isIncreasePositive),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Monthly comparison chart
                Container(
                  height: 350,
                  padding:
                      const EdgeInsets.only(right: 16, bottom: 16, top: 16),
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
                    children: [
                      const Text(
                        'Monthly Comparison',
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildMonthlyComparisonChart(
                          prevYearData,
                          currYearData,
                          prevYear,
                          currYear,
                          type,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(
                            prevYear.toString(),
                            Colors.blue,
                          ),
                          const SizedBox(width: 24),
                          _buildLegendItem(
                            currYear.toString(),
                            Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Monthly details table
                _buildMonthlyDetailsTable(
                  context,
                  prevYearData,
                  currYearData,
                  prevYear,
                  currYear,
                  type,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearTotal(String year, double total) {
    return Column(
      children: [
        Text(
          year,
          style: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          Utils.formatRupees(total),
          style: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Sora',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyComparisonChart(
    List<MonthlySummary> prevYearData,
    List<MonthlySummary> currYearData,
    int prevYear,
    int currYear,
    String type,
  ) {
    // Group data by month for both years
    final Map<int, double> prevYearByMonth = {};
    final Map<int, double> currYearByMonth = {};

    for (var item in prevYearData) {
      prevYearByMonth[item.month] = item.amount;
    }

    for (var item in currYearData) {
      currYearByMonth[item.month] = item.amount;
    }

    // Find max value for Y axis scaling
    double maxY = 0;
    for (int month = 1; month <= 12; month++) {
      final prevAmount = prevYearByMonth[month] ?? 0;
      final currAmount = currYearByMonth[month] ?? 0;
      maxY = [maxY, prevAmount, currAmount]
          .reduce((max, value) => value > max ? value : max);
    }

    maxY = maxY * 1.1; // Add 10% padding

    // Month names for X axis
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) {
              return Colors.blueGrey;
            },
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final month = monthNames[group.x.toInt() - 1];
              final year = rodIndex == 0 ? prevYear : currYear;
              final amount = rod.toY;
              return BarTooltipItem(
                '$month $year\n${Utils.formatRupees(amount)}',
                const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value < 1 || value > 12) return const SizedBox.shrink();
                final month = monthNames[value.toInt() - 1];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    month,
                    style: const TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7589a2),
                    ),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value >= 1000
                        ? '${(value / 1000).toStringAsFixed(0)}K'
                        : value.toStringAsFixed(0),
                    style: const TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 10,
                      color: Color(0xff7589a2),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(12, (index) {
          final month = index + 1;
          final prevYearValue = prevYearByMonth[month] ?? 0;
          final currYearValue = currYearByMonth[month] ?? 0;

          return BarChartGroupData(
            x: month,
            barRods: [
              BarChartRodData(
                toY: prevYearValue,
                color: Colors.blue,
                width: 10,
                borderRadius: BorderRadius.zero,
              ),
              BarChartRodData(
                toY: currYearValue,
                color: Colors.orange,
                width: 10,
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Color(0xffe7e8ec),
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyDetailsTable(
    BuildContext context,
    List<MonthlySummary> prevYearData,
    List<MonthlySummary> currYearData,
    int prevYear,
    int currYear,
    String type,
  ) {
    // Create maps for easy lookup
    final Map<int, double> prevYearByMonth = {};
    for (var item in prevYearData) {
      prevYearByMonth[item.month] = item.amount;
    }

    final Map<int, double> currYearByMonth = {};
    for (var item in currYearData) {
      currYearByMonth[item.month] = item.amount;
    }

    // Month names
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // Check current date to avoid showing future months
    final currentMonth = DateTime.now().month;
    final isCurrentYear = currYear == DateTime.now().year;
    final monthsToShow = isCurrentYear ? currentMonth : 12;

    // Determine if increase is good based on the type
    final isIncreasePositive = type == 'income';

    return Container(
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Monthly Details',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Table header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Month',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    prevYear.toString(),
                    style: const TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    currYear.toString(),
                    style: const TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Change',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Table content
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: monthsToShow,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final month = index + 1;
              final monthName = monthNames[index];
              final prevAmount = prevYearByMonth[month] ?? 0;
              final currAmount = currYearByMonth[month] ?? 0;

              double percentChange = 0;
              if (prevAmount > 0) {
                percentChange = ((currAmount - prevAmount) / prevAmount) * 100;
              } else if (currAmount > 0) {
                percentChange = 100; // If previous was 0, new is 100% increase
              }

              final changeColor = percentChange >= 0
                  ? (isIncreasePositive ? Colors.green : Colors.red)
                  : (isIncreasePositive ? Colors.red : Colors.green);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        monthName,
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        Utils.formatRupees(prevAmount),
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        Utils.formatRupees(currAmount),
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            percentChange > 0
                                ? Icons.arrow_upward
                                : percentChange < 0
                                    ? Icons.arrow_downward
                                    : Icons.remove,
                            color:
                                percentChange == 0 ? Colors.grey : changeColor,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${percentChange.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 12,
                              color: percentChange == 0
                                  ? Colors.grey
                                  : changeColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getYearComparisonAnalysis(
      String type, double percentChange, bool isIncreasePositive) {
    String direction = percentChange >= 0 ? 'increased' : 'decreased';
    String sentiment = '';

    if (isIncreasePositive) {
      // For income, increase is good
      sentiment = percentChange >= 0 ? 'positive' : 'concerning';
    } else {
      // For expenses and budget, decrease is good
      sentiment = percentChange >= 0 ? 'concerning' : 'positive';
    }

    if (type == 'income') {
      return 'Your income has $direction by ${percentChange.abs().toStringAsFixed(1)}% compared to past year. This is a $sentiment trend.';
    } else if (type == 'expense') {
      return 'Your expenses have $direction by ${percentChange.abs().toStringAsFixed(1)}% compared to past year. This is a $sentiment trend.';
    } else {
      return 'Your budget has $direction by ${percentChange.abs().toStringAsFixed(1)}% compared to past year.';
    }
  }
}

// Extension method to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}
