import 'package:budgetpro/services/supabase_service.dart';
import 'package:flutter/material.dart';

class SettingsListView extends StatelessWidget {
  const SettingsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of setting items to display
    final List<Map<String, dynamic>> settingsItems = [
      {
        'icon': Icons.logout,
        'iconBackgroundColor': Colors.transparent,
        'iconColor': Colors.red.shade600,
        'title': 'Sign Out',
        'showChevron': false,
        'textColor': Colors.red.shade600,
        'onTap': () async {
          // Show confirmation dialog before signing out
          final bool? confirm = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                titleTextStyle: TextStyle(
                    fontFamily: "Sora", fontSize: 22, color: Colors.black),
                contentTextStyle: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 16,
                    color: Colors.grey.shade700),
                title: const Text("Sign Out"),
                content: const Text("Are you sure you want to sign out?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: "Sora", // Add the "Sora" font
                        fontWeight: FontWeight.w500, // Optional: Adjust weight
                        fontSize: 16, // Optional: Adjust size
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(
                        fontFamily: "Sora", // Add the "Sora" font
                        fontWeight: FontWeight.w500, // Optional: Adjust weight
                        fontSize: 16, // Optional: Adjust size
                      ),
                    ),
                  ),
                ],
              );
            },
          );

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
          return _buildSettingsItem(
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

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required String title,
    Color? textColor,
    bool showChevron = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
