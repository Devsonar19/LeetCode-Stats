import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/features/dashboard/widgets/daily_question_card.dart';
import 'package:leetcode_stats/repositories/profile_repository.dart';
import '../../dashboard/widgets/sec_profile_details.dart';
import '../bloc/profile_details_bloc.dart';
import '../bloc/profile_details_event.dart';
import '../bloc/profile_details_state.dart';
import '../widgets/recent_solved_card.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final String username;
  const ProfileDetailsScreen({super.key, required this.username});

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('SocketException') || errorStr.contains('Failed host lookup')) {
      return "Unable to connect to the server. Please check your internet connection.";
    } else if (errorStr.contains('TimeoutException')) {
      return "The connection timed out. Please try again.";
    } else if(errorStr.contains("User not Found") || errorStr.contains("404") || errorStr.contains("invalid user")){
      return "Invalid Username";
    }
    return errorStr.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ProfileDetailsBloc(ProfileRepository())..add(LoadRecentSolved(username)),

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail Info"),
          centerTitle: true,
        ),

        body: BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
            builder: (context, state){
              if(state is ProfileDetailsLoading){
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
              if(state is ProfileDetailsError){
                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            _getErrorMessage(state.error),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if(state is ProfileDetailsLoaded){
                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    RecentSolvedCard(
                      ques: state.recentSolved,
                    ),

                    const SizedBox(height: 10),

                    DailyQuestionCard(
                      question: state.dailyQues ?? {},
                    ),

                    const SizedBox(height: 10),

                    SecProfileDetails(
                      profile: state.user ?? {},
                    )
                  ],
                );
              }
              return const SizedBox();
            }
        ),
      ),
    );
  }
}
