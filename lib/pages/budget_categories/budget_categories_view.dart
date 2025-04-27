import 'package:budgetpro/models/budget_model.dart';
import 'package:budgetpro/models/expense_category_enum.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';

// Enum to define different sorting options
enum BudgetSortOption { unplanned, overspent, budgetAmount }

Widget _budgetListItem(BuildContext context, CategorizedBudgetModel budget,
    double totalBudget, GestureTapCallback onTap) {
  final percentageSpent = budget.budgetAmount > 0
      ? (budget.spentAmount / budget.budgetAmount)
      : 0.0;
  final isEnabled = budget.budgetAmount > 0 || budget.spentAmount > 0;

  // Calculate percentage of total budget
  final percentOfTotal =
      totalBudget > 0 ? (budget.budgetAmount / totalBudget * 100) : 0.0;

  // Determine status text and color
  final String statusText;
  final Color statusColor;

  if (budget.budgetAmount == 0 && budget.spentAmount > 0) {
    statusText = "Unplanned";
    statusColor = Colors.purple;
  } else if (budget.budgetAmount == 0) {
    statusText = "No Budget";
    statusColor = Colors.grey;
  } else if (percentageSpent > 1) {
    statusText = "Overspent";
    statusColor = AppColors.dangerColor;
  } else {
    statusText = "On Track";
    statusColor = Colors.green;
  }

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: isEnabled ? Colors.grey.shade200 : Colors.transparent,
        width: 1,
      ),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                // Category Icon
                Container(
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? budget.category.color.withAlpha(40)
                        : AppColors.iconColor.withAlpha(10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    budget.category.icon,
                    color: isEnabled
                        ? budget.category.color
                        : AppColors.iconColor.withAlpha(50),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Category Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              budget.category.displayName,
                              style: const TextStyle(
                                fontFamily: "Sora",
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isEnabled
                                  ? budget.category.color.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${percentOfTotal.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Sora",
                                color: isEnabled
                                    ? budget.category.color
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        budget.budgetAmount > 0
                            ? '${Utils.formatRupees(budget.spentAmount)} of ${Utils.formatRupees(budget.budgetAmount.toDouble())}'
                            : 'Spent: ${Utils.formatRupees(budget.spentAmount)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "Sora",
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sora",
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            budget.budgetAmount > 0
                ? LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(4),
                    value: (budget.spentAmount / budget.budgetAmount)
                        .clamp(0.0, 1.0),
                    minHeight: 8.0,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        percentageSpent > 1
                            ? AppColors.dangerColor
                            : AppColors.primaryColor),
                  )
                : budget.spentAmount > 0
                    ? Container(
                        height: 8.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.purple.withOpacity(0.2),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 8.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.shade300,
                        ),
                      ),
          ],
        ),
      ),
    ),
  );
}

class BudgetCategoriesView extends StatefulWidget {
  final List<CategorizedBudgetModel> budget;
  final double totalBudget;
  final Function(CategorizedBudgetModel)? onCategoryTap;

  const BudgetCategoriesView({
    super.key,
    required this.budget,
    required this.totalBudget,
    this.onCategoryTap,
  });

  @override
  State<BudgetCategoriesView> createState() => _BudgetCategoriesViewState();
}

class _BudgetCategoriesViewState extends State<BudgetCategoriesView> {
  BudgetSortOption _currentSortOption = BudgetSortOption.unplanned;

  List<CategorizedBudgetModel> _getSortedBudget() {
    final sortedBudget = List<CategorizedBudgetModel>.from(widget.budget);

    switch (_currentSortOption) {
      case BudgetSortOption.unplanned:
        // Default sorting: Unplanned first, then others
        sortedBudget.sort((a, b) {
          // First prioritize unplanned spending
          if (a.budgetAmount == 0 && a.spentAmount > 0) {
            if (b.budgetAmount == 0 && b.spentAmount > 0) {
              // Both are unplanned, sort by spent amount
              return b.spentAmount.compareTo(a.spentAmount);
            }
            return -1; // a is unplanned, put it first
          }
          if (b.budgetAmount == 0 && b.spentAmount > 0) {
            return 1; // b is unplanned, put it first
          }

          // Next prioritize categories with budgets
          if (b.budgetAmount > 0 && a.budgetAmount == 0) return 1;
          if (a.budgetAmount > 0 && b.budgetAmount == 0) return -1;

          // Then sort by percentage spent for those with budgets
          if (a.budgetAmount > 0 && b.budgetAmount > 0) {
            final aPercentage = a.spentAmount / a.budgetAmount;
            final bPercentage = b.spentAmount / b.budgetAmount;
            return bPercentage.compareTo(aPercentage); // Show most spent first
          }

          // For those without budgets, sort by category name
          return a.category.displayName.compareTo(b.category.displayName);
        });
        break;

      case BudgetSortOption.overspent:
        // Sort by overspent (percentages > 1.0) first
        sortedBudget.sort((a, b) {
          final aPercentage =
              a.budgetAmount > 0 ? a.spentAmount / a.budgetAmount : 0;
          final bPercentage =
              b.budgetAmount > 0 ? b.spentAmount / b.budgetAmount : 0;

          // First check if one is overspent and the other isn't
          final aIsOverspent = aPercentage > 1;
          final bIsOverspent = bPercentage > 1;

          if (aIsOverspent && !bIsOverspent) return -1;
          if (!aIsOverspent && bIsOverspent) return 1;

          // If both are overspent or both are not, sort by percentage
          return bPercentage.compareTo(aPercentage);
        });
        break;

      case BudgetSortOption.budgetAmount:
        // Sort by budget amount (highest first)
        sortedBudget.sort((a, b) {
          // Put items with budget first
          if (a.budgetAmount > 0 && b.budgetAmount == 0) return -1;
          if (a.budgetAmount == 0 && b.budgetAmount > 0) return 1;

          // Sort by budget amount
          return b.budgetAmount.compareTo(a.budgetAmount);
        });
        break;
    }

    return sortedBudget;
  }

  String _getSortOptionLabel() {
    switch (_currentSortOption) {
      case BudgetSortOption.unplanned:
        return 'Default';
      case BudgetSortOption.overspent:
        return 'Overspent';
      case BudgetSortOption.budgetAmount:
        return 'Budget';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedBudget = _getSortedBudget();

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: [
          // Sort options bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            height: 36,
            child: Row(
              children: [
                const Text(
                  'Sort by:',
                  style: TextStyle(
                      fontFamily: "Sora",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                const SizedBox(width: 8),

                // Sort dropdown button
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      _showSortOptions(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          Text(
                            _getSortOptionLabel(),
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Budget list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedBudget.length,
            itemBuilder: (context, index) {
              return _budgetListItem(
                context,
                sortedBudget[index],
                widget.totalBudget,
                () {
                  if (widget.onCategoryTap != null) {
                    widget.onCategoryTap!(sortedBudget[index]);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: const Text(
                  'Sort Categories By',
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Divider(height: 1),
              _sortOption(
                context,
                title: 'Default',
                subtitle: 'Unplanned first, then by spending',
                icon: Icons.sort,
                option: BudgetSortOption.unplanned,
              ),
              _sortOption(
                context,
                title: 'Overspent',
                subtitle: 'Categories exceeding budget first',
                icon: Icons.warning_amber_rounded,
                option: BudgetSortOption.overspent,
              ),
              _sortOption(
                context,
                title: 'Budget Amount',
                subtitle: 'Highest budget first',
                icon: Icons.account_balance_wallet,
                option: BudgetSortOption.budgetAmount,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _sortOption(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required BudgetSortOption option}) {
    final isSelected = _currentSortOption == option;

    return InkWell(
      onTap: () {
        setState(() {
          _currentSortOption = option;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color:
                          isSelected ? AppColors.primaryColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
