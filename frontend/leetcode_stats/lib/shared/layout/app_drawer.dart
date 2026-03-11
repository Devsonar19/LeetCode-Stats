import 'package:flutter/material.dart';

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
          DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profile != null
                        ? NetworkImage(profile["userAvatar"])
                        : null,
                    child: profile == null
                        ? const Icon(Icons.person, size: 30,)
                        : null,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    userData?["username"] ?? "Guest",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: const Text("Profile"),
            onTap: (){
              //opens secondary profile page
            },
          ),

          SwitchListTile(
              title: const Text("Dark Mode"),
              secondary: Icon(Icons.dark_mode),
              value: isDarkMode,
              onChanged: (value){
                onToggleTheme();
              }
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.computer),
            title: const Text("About Developer"),
            onTap: (){
              //opens about developer page
            },
          ),
        ],
      ),
    );
  }
}
