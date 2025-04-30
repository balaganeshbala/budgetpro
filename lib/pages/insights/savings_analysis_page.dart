import 'dart:math';

import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expenses_model.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';

class SavingsAnalysisScreen extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final List<IncomeModel> incomes;
  final List<CategorizedBudgetModel> budgetCategories;
  final double totalBudget;
  final String month;
  final String year;

  const SavingsAnalysisScreen({
    super.key,
    required this.expenses,
    required this.incomes,
    required this.budgetCategories,
    required this.totalBudget,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total income
    double totalIncome = incomes.fold(0, (sum, income) => sum + income.amount);

    // Calculate total expenses (actual spent)
    double totalExpenses =
        expenses.fold(0, (sum, expense) => sum + expense.amount);

    // Use the higher of budget or spent amount for analysis
    double effectiveExpenses = getEffectiveExpenses(
        totalExpenses, totalBudget, Utils.isCurrentMonth(month, year));

    // Calculate savings
    double savings = totalIncome - effectiveExpenses;

    // Calculate savings rate (as percentage of income)
    double savingsRate = totalIncome > 0 ? (savings / totalIncome) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$month $year',
          style:
              const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora"),
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: incomes.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Income Data Unavailable',
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add income data to view savings analysis and recommendations.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                          text: 'Savings Analysis', paddingLeft: 0),
                      const SizedBox(height: 16),
                      _buildSavingsSummaryCard(
                          totalIncome, effectiveExpenses, savings, savingsRate),
                      const SizedBox(height: 24),
                      _buildSavingsRateIndicator(savingsRate, context),
                      const SizedBox(height: 24),
                      _buildSavingsRecommendations(
                          savingsRate, totalExpenses, totalBudget),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsSummaryCard(double totalIncome, double effectiveExpenses,
      double savings, double savingsRate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total Income',
                  Utils.formatRupees(totalIncome),
                  const Color(0xFF428F7D),
                  Icons.arrow_upward,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Effective Expenses',
                  Utils.formatRupees(effectiveExpenses),
                  const Color(0xFFFF6B6B),
                  Icons.arrow_downward,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Balance',
                  Utils.formatRupees(savings.abs()),
                  savings >= 0 ? AppColors.primaryColor : Colors.red,
                  savings >= 0 ? Icons.trending_up : Icons.trending_down,
                  prefix: savings >= 0 ? '+' : '-',
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Savings Rate',
                  '${savingsRate.toStringAsFixed(1)}%',
                  _getSavingsRateColor(savingsRate),
                  _getSavingsRateIcon(savingsRate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String title, String value, Color color, IconData icon,
      {String prefix = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Sora",
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          prefix + value,
          style: TextStyle(
            fontFamily: "Sora",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsRateIndicator(double savingsRate, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Savings Rate',
            style: TextStyle(
              fontFamily: "Sora",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Financial experts recommend saving at least 20% of your income.',
            style: TextStyle(
              fontFamily: "Sora",
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                height: 24,
                width: max(
                    savingsRate >= 40
                        ? (MediaQuery.of(context).size.width - 64)
                        : (MediaQuery.of(context).size.width - 64) *
                            (savingsRate / 40),
                    0),
                decoration: BoxDecoration(
                  color: _getSavingsRateColor(savingsRate),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 1), // Spacer
                    _buildMarker(10, savingsRate),
                    _buildMarker(20, savingsRate),
                    _buildMarker(30, savingsRate),
                    Container(width: 1), // Spacer
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%',
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                '20%',
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                '40%',
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getSavingsRateColor(savingsRate).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getSavingsRateIcon(savingsRate),
                  color: _getSavingsRateColor(savingsRate),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getSavingsRateMessage(savingsRate),
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontSize: 14,
                      color: _getSavingsRateColor(savingsRate),
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

  Widget _buildMarker(double value, double savingsRate) {
    bool isPassed = savingsRate >= value;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isPassed ? Colors.white : Colors.grey.shade300,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          value.toStringAsFixed(0),
          style: TextStyle(
            fontFamily: "Sora",
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isPassed ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsRecommendations(
      double savingsRate, double totalExpenses, double totalBudget) {
    List<Map<String, dynamic>> recommendations = [];

    // Generate recommendations based on savings rate and budget adherence
    if (savingsRate < 0) {
      recommendations = [
        {
          'title': 'Spending exceeds income',
          'description':
              'Your expenses are higher than your income. This is not sustainable long-term. Consider reducing expenses or finding additional income sources.',
          'icon': Icons.warning_amber_rounded,
          'color': Colors.red,
        },
      ];
    } else if (savingsRate < 10) {
      recommendations = [
        {
          'title': 'Increase your savings rate',
          'description':
              'Try to save at least 10-15% of your income. Review discretionary expenses like entertainment and shopping.',
          'icon': Icons.arrow_upward,
          'color': Colors.orange,
        },
      ];
    } else if (savingsRate < 20) {
      recommendations = [
        {
          'title': 'You\'re on the right track',
          'description':
              'You\'re doing well, but try to increase your savings rate to 20% by reducing expenses in top spending categories.',
          'icon': Icons.trending_up,
          'color': AppColors.primaryColor,
        },
      ];
    } else {
      recommendations = [
        {
          'title': 'Excellent saving habits',
          'description':
              'You\'re saving more than 20% of your income, which is excellent! Consider investing your savings for better growth.',
          'icon': Icons.stars,
          'color': Colors.amber,
        },
      ];
    }

    // Add recommendation about budget adherence
    if (totalExpenses > totalBudget) {
      double overBudgetAmount = totalExpenses - totalBudget;
      double overBudgetPercentage = (overBudgetAmount / totalBudget) * 100;

      recommendations.add({
        'title': 'Over budget alert',
        'description':
            'You\'ve exceeded your budget by ${overBudgetPercentage.toStringAsFixed(1)}%. Review your spending in categories where you\'ve gone over budget.',
        'icon': Icons.account_balance_wallet,
        'color': Colors.red,
      });
    } else if (totalBudget > 0) {
      double budgetUtilization = (totalExpenses / totalBudget) * 100;

      if (budgetUtilization < 80) {
        recommendations.add({
          'title': 'Budget underutilization',
          'description':
              'You\'ve only used ${budgetUtilization.toStringAsFixed(1)}% of your budget. Consider reallocating funds to savings or investments.',
          'icon': Icons.account_balance_wallet,
          'color': Colors.blue,
        });
      } else {
        recommendations.add({
          'title': 'Good budget management',
          'description':
              'You\'re staying within your budget while using it effectively (${budgetUtilization.toStringAsFixed(1)}% utilization).',
          'icon': Icons.account_balance_wallet,
          'color': Colors.green,
        });
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommendations',
            style: TextStyle(
              fontFamily: "Sora",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...recommendations.map((recommendation) {
            return _buildRecommendationItem(
              title: recommendation['title'],
              description: recommendation['description'],
              icon: recommendation['icon'],
              color: recommendation['color'],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Sora",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: "Sora",
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSavingsRateColor(double savingsRate) {
    if (savingsRate < 0) return Colors.red;
    if (savingsRate < 10) return Colors.red.shade400;
    if (savingsRate < 20) return Colors.orange;
    return AppColors.primaryColor;
  }

  IconData _getSavingsRateIcon(double savingsRate) {
    if (savingsRate < 0) return Icons.warning_rounded;
    if (savingsRate < 10) return Icons.trending_down_rounded;
    if (savingsRate < 20) return Icons.trending_flat_rounded;
    return Icons.trending_up_rounded;
  }

  String _getSavingsRateMessage(double savingsRate) {
    if (savingsRate < 0) {
      return 'Warning: You\'re spending more than you earn.';
    }
    if (savingsRate < 10) {
      return 'Your savings rate is low. Try to increase it to at least 10-15%.';
    }
    if (savingsRate < 20) {
      return 'Good progress! Try to reach the recommended 20% savings rate.';
    }
    return 'Excellent! You\'re meeting or exceeding the recommended savings rate.';
  }

  // Calculate effective expenses based on month status
  double getEffectiveExpenses(
      double totalExpenses, double totalBudget, bool isCurrentMonth) {
    if (isCurrentMonth) {
      // For current month, use the higher of budget or spent amount
      return totalExpenses > totalBudget ? totalExpenses : totalBudget;
    } else {
      // For past months, use the actual spent amount
      return totalExpenses;
    }
  }
}
