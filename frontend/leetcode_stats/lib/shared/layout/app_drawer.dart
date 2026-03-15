import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/core/theme/theme_bloc.dart';
import 'package:leetcode_stats/features/profile_panel/view/profile_detail_screen.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';

class AppDrawer extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const AppDrawer({
    super.key,
    required this.userData,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final profile = userData?["profile"];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 200,
            child: DrawerHeader(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: null,
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profile != null
                          ? NetworkImage(profile["userAvatar"])
                          : null,
                      child: profile == null
                          ? const Icon(Icons.person, size: 40,)
                          : null,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      userData?["username"] ?? "Guest",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: const Text("Profile"),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileDetailsScreen(
                        username: userData?["username"],
                    ),
                ),
              );
            },
          ),

          SwitchListTile(
              title: const Text("Dark Mode"),
              secondary: Icon(Icons.dark_mode),
              value: context.watch<ThemeBloc>().state == ThemeMode.dark,
              onChanged: (value){
                context.read<ThemeBloc>().toggleTheme();
              }
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: (){
              context.read<AuthBloc>().add(LogoutRequest());
            },
          ),
        ],
      ),
    );
  }
}
