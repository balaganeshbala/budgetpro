import 'package:budgetpro/pages/insights/long_term_page.dart';
import 'package:budgetpro/pages/insights/yearly_comparsion_page.dart';
import 'package:budgetpro/pages/major_expenses/ui/major_expenses_page.dart';
import 'package:budgetpro/services/supabase_service.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:flutter/material.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of setting items to display
    final List<Map<String, dynamic>> settingsItems = [
      {
        'icon': Icons.compare_arrows,
        'iconBackgroundColor': Colors.transparent,
        'iconColor': AppColors.primaryColor,
        'title': 'Yearly Comparison',
        'showChevron': true,
        'textColor': Colors.black87,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const YearlyComparisonScreen()),
          );
        },
      },
      {
        'icon': Icons.bar_chart,
        'iconBackgroundColor': Colors.transparent,
        'iconColor': AppColors.primaryColor,
        'title': 'Long Term Trends',
        'showChevron': true,
        'textColor': Colors.black87,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LongTermTrendScreen()),
          );
        },
      },
      {
        'icon': Icons.attach_money,
        'iconBackgroundColor': Colors.transparent,
        'iconColor': AppColors.primaryColor,
        'title': 'Major Expenses',
        'showChevron': true,
        'textColor': Colors.black87,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MajorExpensesPage()),
          );
        },
      },
      {
        'icon': Icons.info_outline,
        'iconBackgroundColor': Colors.transparent,
        'iconColor': AppColors.primaryColor,
        'title': 'About BudgetPro',
        'showChevron': true,
        'textColor': Colors.black87,
        'onTap': () {
          Navigator.pushNamed(context, '/about');
        },
      },
      {
        'icon': Icons.logout,
        'iconBackgroundColor': Colors.transparent,
        'iconColor': Colors.red.shade600,
        'title': 'Sign Out',
        'showChevron': false,
        'textColor': Colors.red.shade600,
        'onTap': () async {
          // Show confirmation dialog before signing out
          final confirm = await UIUtils.showConfirmationDialog(context,
              'Confirm Sign Out', 'Are you sure you want to sign out?');

          if (confirm == true) {
            // Sign out logic
            await SupabaseService.signOut();
            // Navigate back to the login screen
            Navigator.pushNamedAndRemoveUntil(
                context, '/sign-in', (route) => false);
          }
        },
      },
    ];

    return Container(
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
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: settingsItems.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFEEEEEE),
        ),
        itemBuilder: (context, index) {
          final item = settingsItems[index];
          return UIUtils.buildSettingsItem(
            context,
            icon: item['icon'],
            iconBackgroundColor: item['iconBackgroundColor'],
            iconColor: item['iconColor'],
            title: item['title'],
            textColor: item['textColor'],
            showChevron: item['showChevron'],
            onTap: item['onTap'],
          );
        },
      ),
    );
  }
}
