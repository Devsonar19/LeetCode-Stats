import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>>? profileData;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final username = ModalRoute
          .of(context)!
          .settings
          .arguments as String;
      profileData = ApiService.fetchProfileForApp(username);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: profileData,
      builder: (context, asyncSnapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                "LeetCode Stats",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.brunoAceSc().fontFamily,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.account_circle_rounded)
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    child: Icon(Icons.person, size: 50),
                ),
                ListTile(
                  trailing: Icon(Icons.login_rounded),
                  title: Text("Logout"),
                  onTap: () {},
                ),
              ]
            ),
          ),
          body: FutureBuilder(
            future: profileData,
            builder: (context, snapshot) {
        
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
        
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }


              final data = snapshot.data!;
              final profile = data["profile"]["profile"];
              final badges = data["profile"]["badges"];

              if (data["profile"] == null) {
                return const Center(child: Text("User not found"));
              }

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hello, ",
                          style: const TextStyle(
                              fontSize: 30
                          ),
                        ),
                        Text(
                          "${profile["realName"]}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Image.network(profile["userAvatar"], height: 100),
        
                    const SizedBox(height: 20),
        
                    Row(
                      children: [
                        Text(
                          "Username: ",
                          style: const TextStyle(
                              fontSize: 18
                          ),
                        ),
                        Text(
                          "${data["profile"]["username"]}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                          ),
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 10),
        
                    Row(
                      children: [
                        Text(
                          "Global Rank: ",
                          style: const TextStyle(
                              fontSize: 18
                          ),
                        ),
                        Text(
                          "${profile["ranking"]}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Badges",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    if (badges != null && badges.isNotEmpty)
                      Row(
                        children: [
                          Image.network(
                            badges[0]["icon"],
                            height: 80,
                          ),
                          const SizedBox(width: 5),
                          Image.network(
                            badges[1]["icon"].startsWith("/")
                                ? "https://leetcode.com${badges[1]["icon"]}"
                                : badges[1]["icon"],
                            height: 80,
                          ),
                        ]
                      )
                    else
                      const Text("No badge yet"),

                    const SizedBox(height: 20),

                    Text(
                      "Active Badges",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      children: [
                        Image.network(
                          data["profile"]["activeBadge"]["icon"],
                          height: 80,
                        ),
                      ],
                    ),
        
        
                    const SizedBox(height: 20),
        
                    const Text(
                      "Daily Question",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
        
                    const SizedBox(height: 10),
        
                    Text(
                      data["activeDailyCodingChallengeQuestion"]["question"]["title"],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    );
  }
}