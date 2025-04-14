import 'package:budgetpro/pages/profile/settings_list.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';
import 'package:budgetpro/services/supabase_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch the logged-in user's information
    final user = SupabaseService.client.auth.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: "Sora")),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(children: [
                              Icon(Icons.person,
                                  size: 50,
                                  color: AppColors.primaryColor.withAlpha(100)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${user?.userMetadata?['full_name'] ?? 'N/A'}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily:
                                              "Sora", // Apply "Sora" font
                                          fontWeight: FontWeight
                                              .w500, // Optional: Adjust weight
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        user?.email ?? 'N/A',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily:
                                              "Sora", // Apply "Sora" font
                                          fontWeight: FontWeight
                                              .w400, // Optional: Adjust weight
                                        ),
                                      ),
                                    ]),
                              )
                            ]))),
                  ),
                  const SizedBox(height: 10),
                  const SettingsListView(),
                ],
              ),
            )));
  }
}
