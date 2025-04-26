import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/pages/income/ui/all_incomes_page.dart';
import 'package:budgetpro/pages/income/ui/add_income_page.dart';
import 'package:budgetpro/pages/income/ui/income_details_page.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_bloc.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentIncomesView extends StatelessWidget {
  final List<IncomeModel> incomes;

  const RecentIncomesView({super.key, required this.incomes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
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
        child: incomes.isEmpty
            ? _buildEmptyState(context)
            : _buildIncomesList(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Incomes Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: "Sora",
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start tracking your incomes by adding your first entry',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: "Sora",
            ),
          ),
          const SizedBox(height: 24),
          // Add New centered text action in empty state
          _centeredTextAction(
            context,
            text: '+ Add New',
            textColor: AppColors.accentColor,
            fontWeight: FontWeight.w600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddIncomePage(),
                ),
              ).then((value) {
                // Refresh the page after adding a new income
                if (value != null && value) {
                  if (context.mounted) {
                    context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
                  }
                }
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildIncomesList(BuildContext context) {
    // Calculate total item count: incomes (max 5) + action tiles (2)
    final int incomeCount = incomes.length > 5 ? 5 : incomes.length;
    final int totalItemCount =
        incomeCount + 2; // +2 for "View All" and "Add New" actions

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: totalItemCount,
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFEEEEEE),
        );
      },
      itemBuilder: (context, index) {
        // Display income items
        if (index < incomeCount) {
          final item = incomes[incomes.length - index - 1];
          return _incomeItem(
            context,
            icon: Icons.payments_outlined,
            iconBackgroundColor: Colors.green.withOpacity(0.2),
            iconColor: Colors.green,
            title: item.source,
            subtitle: item.date,
            trailingText: Utils.formatRupees(item.amount),
            onTap: () => _navigateToIncomeDetails(context, item),
          );
        }
        // Display "View All" action with centered text
        else if (index == incomeCount) {
          if (incomes.length <= 5) {
            return const SizedBox
                .shrink(); // No "View All" if less than 5 items
          }
          return _centeredTextAction(
            context,
            text: 'View All',
            textColor: AppColors.accentColor,
            fontWeight: FontWeight.w600,
            onTap: () {
              // Navigate to AllIncomesPage when "View All" is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllIncomesPage(incomes: incomes),
                ),
              ).then((value) {
                // Refresh if incomes were updated
                if (value == true && context.mounted) {
                  context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
                }
              });
            },
          );
        }
        // Display "Add New" action with centered text
        else {
          return _centeredTextAction(
            context,
            text: '+ Add New',
            textColor: AppColors.accentColor,
            fontWeight: FontWeight.w600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddIncomePage(),
                ),
              ).then((value) {
                if (value != null && value) {
                  if (context.mounted) {
                    // Refresh the page after adding a new income
                    context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
                  }
                }
              });
            },
          );
        }
      },
    );
  }

  // Navigate to income details when an income item is tapped
  Future<void> _navigateToIncomeDetails(
      BuildContext context, IncomeModel income) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomeDetailsPage(income: income),
      ),
    );

    // Refresh the home screen if the income was updated or deleted
    if (result == true && context.mounted) {
      context.read<NewHomeBloc>().add(HomeScreenRefreshedEvent());
    }
  }

  // Common method for centered text action items
  Widget _centeredTextAction(
    BuildContext context, {
    required String text,
    required Color textColor,
    required FontWeight fontWeight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Sora",
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _incomeItem(
    BuildContext context, {
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? trailingText,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
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
                    fontSize: 14,
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w500,
                    color: textColor ?? Colors.black,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w400,
                      color: textColor ?? Colors.grey,
                    ),
                  ),
              ],
            )),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black,
                ),
              ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
