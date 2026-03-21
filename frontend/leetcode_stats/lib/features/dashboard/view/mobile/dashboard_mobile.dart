import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/features/dashboard/utils/heatmap_image_generator.dart';
import 'package:leetcode_stats/features/dashboard/widgets/badges_card.dart';
import 'package:leetcode_stats/features/dashboard/widgets/stats_card.dart';
import 'package:leetcode_stats/features/dashboard/widgets/submission_heatmap.dart';
import 'package:leetcode_stats/features/widget_sync/widget_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/image_storage_helper.dart';
import '../../../../core/utils/streak_calculator.dart';
import '../../../../services/api_service.dart';
import '../../../../services/widget_service.dart';
import '../../../../shared/layout/app_drawer.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../widgets/widget_heatmap.dart';


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

  Future<void> generateWidget(List<int> data) async {
    print("Generating widget");
    final bytes = await HeatmapImageGenerator.capture();

    if(bytes != null){
      print("Widget generated");
      final path = await ImageStorageHelper.save(bytes);
      print("Widget save path: $path");
      await WidgetService.updateWidget(path);
      print("Widget updated");
    }else{
      print("Widget failed");
    }
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
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        "Wait While we fetch your data...",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
              ),
            );
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

          final calenderRaw = user["submissionCalendar"];

          List<int> heatmapData = [];

          if (calenderRaw != null) {
            final Map<String, dynamic> calenderMap = jsonDecode(calenderRaw);
            final streakData = calculateStreak(calenderMap);

            WidgetSyncService.updateStreak(
              maxStreak: streakData.maxStreak,
              todaySubmissions: streakData.todaySubmissions,
            );
            final sortedKeys = calenderMap.keys.toList()
              ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

            heatmapData = sortedKeys.map((k) => calenderMap[k] as int).toList();
            bool widgetGenerated = false;
            if (heatmapData.isNotEmpty && !widgetGenerated) {
              widgetGenerated = true;

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await Future.delayed(const Duration(milliseconds: 700));
                await generateWidget(heatmapData);
              });
            }

            if (heatmapData.length > 84) {
              heatmapData = heatmapData.sublist(heatmapData.length - 84);
            }

          }

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
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.10),
                            blurRadius: 12,
                            offset: const Offset(0,4),
                          )
                        ]
                      ),
                      child: Text(
                        "Hello, ${profile["realName"] ?? "Coder"}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
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

                    const SizedBox(height: 5),

                    SubmissionHeatmap(
                      username: user["username"] ?? "",
                      submissionCalender: user["submissionCalendar"] ?? "{}",
                    ),

                    const SizedBox(height: 5),

                    BadgesCard(
                      badges: (user["badges"] ?? []) as List,
                    ),

                    const SizedBox(height: 5),

                    //For Testing Widget Purpose
                    // RepaintBoundary(
                    //   key: HeatmapImageGenerator.repaintKey,
                    //   child: WidgetHeatmap(data: heatmapData),
                    // )

                  ]
              ),
            ),
          );
        }
    );
  }
}
