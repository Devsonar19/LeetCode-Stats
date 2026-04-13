import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/core/theme/theme_bloc.dart';
import 'package:leetcode_stats/features/profile_panel/view/profile_detail_screen.dart';

import '../../core/theme/theme_event.dart';
import '../../features/about/about_dev_screen.dart';
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
    final themeMode = context.watch<ThemeBloc>().state.themeMode;
    final isDark = themeMode == ThemeMode.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 300,
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
                      radius: 70,
                      backgroundImage: profile != null
                          ? CachedNetworkImageProvider(profile["userAvatar"])
                          : null,
                      child: profile == null
                          ? const Icon(Icons.person, size: 40,)
                          : null,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      userData?["username"] ?? "Guest",
                      style: const TextStyle(
                        fontSize: 20,
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

          ListTile(
            leading: Icon(
              themeMode == ThemeMode.light
                  ? Icons.sunny
                  : themeMode == ThemeMode.dark
                    ? Icons.nightlight_round
                    : Icons.brightness_auto,
            ),
            title: const Text("Theme"),
            trailing: DropdownButton<ThemeMode>(
                value: themeMode,
                underline: const SizedBox(),
                items: const[
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text("Light"),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text("Dark"),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text("System"),
                  ),
                ],
                onChanged: (ThemeMode? newTheme){
                  if(newTheme != null){
                    context.read<ThemeBloc>().add(ChangeThemeEvent(newTheme));
                  }
                }
            ),
          ),

          ListTile(
            leading: Icon(Icons.code),
            title: const Text("About Developer"),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutDevScreen(),
                  ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<AuthBloc>().add(LogoutRequest());
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
