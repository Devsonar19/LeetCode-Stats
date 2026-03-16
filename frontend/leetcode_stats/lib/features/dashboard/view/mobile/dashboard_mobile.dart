import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/features/dashboard/widgets/badges_card.dart';
import 'package:leetcode_stats/features/dashboard/widgets/stats_card.dart';
import 'package:leetcode_stats/features/dashboard/widgets/submission_heatmap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/api_service.dart';
import '../../../../shared/layout/app_drawer.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {

  Future<Map<String, dynamic>>? profileData;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final store = await SharedPreferences.getInstance();
    final username = store.getString("username");

    if(!mounted) return;

    if (username == null) {
      Navigator.pushReplacementNamed(
          context, "/login",
      );
      return;
    }
    setState(() {
      profileData = ApiService.fetchProfileForApp(username);
    });
  }

  @override
  Widget build(BuildContext context) {

    if(profileData == null){
      return Scaffold(
          body: Center(child: CircularProgressIndicator())
      );
    }

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
          final user = data["profile"] ?? {};
          final profile = user["profile"] ?? {};

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

          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Loggout) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text("LeetCode Stats"),
                centerTitle: true,
              ),
              drawer: AppDrawer(
                userData: data["profile"],
                isDarkMode: false,
                onToggleTheme: () {},
              ),
              body: ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    Text(
                      "Hello, ${profile["realName"] ?? "Coder"}",
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
                      username: user["username"] ?? "",
                      submissionCalender: user["submissionCalendar"] ?? {},
                    ),

                    const SizedBox(height: 10),

                    BadgesCard(
                      badges: (user["badges"] ?? []) as List,
                    ),

                  ]
              ),
            ),
          );
        }
    );
  }
}
