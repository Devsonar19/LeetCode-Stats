import 'package:flutter/material.dart';

import '../../../../services/api_service.dart';
import '../../../../shared/layout/app_drawer.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/submission_heatmap.dart';

class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key});

  @override
  State<DashboardDesktop> createState() => _DashboardTabletState();
}

class _DashboardTabletState extends State<DashboardDesktop> {
  late Future<Map<String,dynamic>>? profileData;

  @override
  void initState() {
    profileData = ApiService.fetchProfileForWeb("Dev_Sonar19");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
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

          final submitStats = user["submitStatsGlobal"];
          final solvedStats = submitStats?["acSubmissionNum"];
          final totalStats = data["allQuestionsCount"];

          if (solvedStats == null) {
            return const Center(child: Text("Stats unavailable"));
          }

          final totalSolved = solvedStats[0]["count"];
          final easySolved = solvedStats[1]["count"];
          final mediumSolved = solvedStats[2]["count"];
          final hardSolved = solvedStats[3]["count"];

          final totalQuestions = totalStats[0]["count"];
          final totalEasy = totalStats[1]["count"];
          final totalMedium = totalStats[2]["count"];
          final totalHard = totalStats[3]["count"];

          final rank = profile["ranking"];

          return Scaffold(
            appBar: AppBar(
              title: const Text("LeetCode Stats"),
              centerTitle: true,
            ),
            drawer: AppDrawer(
              userData: data["profile"],
              isDarkMode: false,
              onToggleTheme: (){},
            ),
            body: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Text(
                    "Hello, ${profile["realName"]}",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  StatsCard(
                    stats: {
                      "totalSolved": totalSolved,
                      "totalQuestions": totalQuestions,

                      "easySolved": easySolved,
                      "totalEasy": totalEasy,

                      "mediumSolved": mediumSolved,
                      "totalMedium": totalMedium,

                      "hardSolved": hardSolved,
                      "totalHard": totalHard,

                      "ranking": rank,
                    },
                  ),

                  const SizedBox(height: 10),

                  SubmissionHeatmap(
                    username: user["username"],
                    submissionCalender: user["submissionCalendar"],
                  ),

                ]
            ),
          );
        }
    );
  }
}
