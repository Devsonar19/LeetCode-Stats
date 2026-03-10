

import 'package:flutter/material.dart';

import '../../../../services/api_service.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {

  late Future<Map<String,dynamic>>? profileData;

  @override
  void initState() {
    super.initState();
    profileData = ApiService.fetchProfile("Dev_Sonar19");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LeetCode Stats"),
        centerTitle: true,
      ),

      body: FutureBuilder<Map<String, dynamic>>(
          future: profileData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text("No data"));
            }

            final data = snapshot.data!;
            final user = data["profile"];
            final profile = user["profile"];

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  "Hello, ${profile["realName"]}",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Image.network(profile["userAvatar"], height: 100),

                const SizedBox(height: 20),

                Text(
                  "Rank: ${profile["ranking"]}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Daily Question \n${data["activeDailyCodingChallengeQuestion"]["question"]["title"]}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ]
            );
          }
      ),
    );
  }
}
