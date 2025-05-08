import 'package:budgetpro/models/income_category_enum.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/pages/income/ui/all_incomes_page.dart';
import 'package:budgetpro/pages/income/ui/add_income_page.dart';
import 'package:budgetpro/pages/income/ui/income_details_page.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_bloc.dart';
import 'package:budgetpro/pages/new_home/bloc/new_home_event.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentIncomesView extends StatelessWidget {
  final List<IncomeModel> incomes;
  final String month;
  final String year;

  const RecentIncomesView(
      {super.key,
      required this.incomes,
      required this.month,
      required this.year});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
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
          UIUtils.centeredTextAction(
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
          return UIUtils.transactionListItem(
            context,
            icon: item.category.icon,
            iconBackgroundColor: item.category.color.withOpacity(0.2),
            iconColor: item.category.color,
            title: item.source,
            subtitle: item.date,
            trailingText: Utils.formatRupees(item.amount),
            onTap: () => _navigateToIncomeDetails(context, item),
          );
        } else if (index == incomeCount) {
          return UIUtils.centeredTextAction(
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
        } else {
          return UIUtils.centeredTextAction(
            context,
            text: 'More Details',
            textColor: AppColors.accentColor,
            fontWeight: FontWeight.w600,
            onTap: () {
              // Navigate to AllIncomesPage when "View All" is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllIncomesPage(
                    incomes: incomes,
                    month: month,
                    year: year,
                  ),
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
}
