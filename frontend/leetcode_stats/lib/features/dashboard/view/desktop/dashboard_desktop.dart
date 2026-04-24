import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/theme_bloc.dart';
import '../../../../core/theme/theme_event.dart';
import '../../../../core/theme/theme_state.dart';
import '../../../../core/utils/image_storage_helper.dart';
import '../../../../core/utils/streak_calculator.dart';
import '../../../../models/contest/contest.dart';
import '../../../../repositories/profile_repository.dart';
import '../../../../services/widget_service.dart';
import '../../../about/about_dev_screen.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_event.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../../contests/views/contest_card.dart';
import '../../../profile_panel/bloc/profile_details_bloc.dart';
import '../../../profile_panel/bloc/profile_details_event.dart';
import '../../../profile_panel/bloc/profile_details_state.dart';
import '../../../profile_panel/widgets/recent_solved_card.dart';
import '../../../widget_sync/widget_sync_service.dart';
import '../../utils/heatmap_image_generator.dart';
import '../../widgets/badges_card.dart';
import '../../widgets/daily_question_card.dart';
import '../../widgets/sec_profile_details.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/submission_heatmap.dart';

class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key});

  @override
  State<DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DashboardDesktop> {
  Future<Map<String, dynamic>>? profileData;
  final _repository = ProfileRepository();
  String? _username;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final store = await SharedPreferences.getInstance();
    final username = store.getString("username");

    if (!mounted) return;

    if (username == null) {
      Navigator.pushReplacementNamed(
        context,
        "/login",
      );
      return;
    }

    setState(() {
      _username = username;
      profileData = _repository.getProfile(username);
    });
  }

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('SocketException') ||
        errorStr.contains('Failed host lookup')) {
      return "Unable to connect to the server. Please check your internet connection.";
    } else if (errorStr.contains('TimeoutException')) {
      return "The connection timed out. Please try again.";
    }
    return "Something went wrong. Please try again later.";
  }

  Future<void> generateWidget(List<int> data) async {
    print("Generating widget");
    final bytes = await HeatmapImageGenerator.capture();

    if (bytes != null) {
      print("Widget generated");
      final path = await ImageStorageHelper.save(bytes);
      print("Widget save path: $path");
      await WidgetService.updateWidget(path);
      print("Widget updated");
    } else {
      print("Widget failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null || _username == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileDetailsBloc(_repository)
            ..add(LoadRecentSolved(_username!)),
        ),
      ],
      child: FutureBuilder<Map<String, dynamic>>(
          future: profileData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
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
              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _getErrorMessage(snapshot.error),
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            loadProfile();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Try Again"),
                        )
                      ],
                    ),
                  ),
                ),
              );
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

            //Contest Calculations
            final contestsRaw = data["allContests"] ?? [];
            final contests = (contestsRaw as List)
                .map((e) => Contest.fromJson(e))
                .toList();
            final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
            Contest? selectedContest;

            for (var contest in contests) {
              if (contest.startTime > now) {
                selectedContest = contest;
                break;
              }
            }
            selectedContest ??= contests.isNotEmpty ? contests.first : null;

            final contestRanking = data["userContestRanking"];

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

              heatmapData =
                  sortedKeys.map((k) => calenderMap[k] as int).toList();
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
            final cachedBadges = _repository.getCacheBadges(user["username"]);

            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Loggout) {
                  setState(() {
                    profileData = null;
                  });
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      const Text(
                        "LeetCode Stats Web",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 32),


                      TextButton.icon(
                        icon: const Icon(Icons.code, size: 18),
                        label: Text("About Developer"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutDevScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  actions: [
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, themeState) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<ThemeMode>(
                            value: themeState.themeMode,
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.palette_outlined, size: 20),
                            ),
                            items: const [
                              DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
                              DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
                              DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
                            ],
                            onChanged: (ThemeMode? newTheme) {
                              if (newTheme != null) {
                                context.read<ThemeBloc>().add(ChangeThemeEvent(newTheme));
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 24),

                    if (profile["userAvatar"] != null)
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: CachedNetworkImageProvider(profile["userAvatar"]),
                      )
                    else
                      const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 16),
                      ),
                    const SizedBox(width: 16),

                    IconButton(
                      tooltip: "Refresh Data",
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        final store = await SharedPreferences.getInstance();
                        final username = store.getString("username");
                        if (username == null) return;

                        setState(() {
                          profileData = _repository.getProfile(
                            username,
                            forceRefresh: true,
                          );
                        });
                      },
                    ),

                    IconButton(
                      tooltip: "Logout",
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Logout"),
                              content: const Text("Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
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
                    const SizedBox(width: 16),
                  ],
                ),
                body: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1300),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
                        builder: (context, detailsState) {

                          Widget recentCard = const Center(child: CircularProgressIndicator());
                          Widget dailyCard = const SizedBox();
                          Widget secProfileCard = const SizedBox();

                          if (detailsState is ProfileDetailsLoaded) {
                            recentCard = RecentSolvedCard(ques: detailsState.recentSolved);
                            dailyCard = DailyQuestionCard(question: detailsState.dailyQues);
                            secProfileCard = SecProfileDetails(profile: detailsState.user);
                          } else if (detailsState is ProfileDetailsError) {
                            recentCard = Center(child: Text("Error: ${detailsState.error}"));
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: StatsCard(
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
                                                "topPercentage": data["userContestRanking"]?["topPercentage"],
                                              },
                                            ),
                                          ),
                                          if (selectedContest != null) ...[
                                            const SizedBox(height: 8),
                                            Expanded(
                                              flex: 1,
                                              child: ContestCard(
                                                contest: selectedContest,
                                                ranking: contestRanking ?? {},
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SubmissionHeatmap(
                                              username: user["username"] ?? "",
                                              submissionCalender: user["submissionCalendar"] ?? "{}",
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            flex: 1,
                                            child: BadgesCard(
                                              badges: cachedBadges.isNotEmpty
                                                  ? cachedBadges
                                                  : (user["badges"] ?? []) as List,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: dailyCard,
                                          ),
                                          const SizedBox(height: 5),
                                          Expanded(
                                            flex: 1,
                                            child: recentCard,
                                          ),
                                          const SizedBox(height: 5),
                                          Expanded(
                                            flex: 6,
                                            child: secProfileCard,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
