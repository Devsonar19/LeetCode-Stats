import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/features/dashboard/widgets/daily_question_card.dart';
import 'package:leetcode_stats/repositories/profile_repository.dart';

import '../bloc/profile_details_bloc.dart';
import '../bloc/profile_details_event.dart';
import '../bloc/profile_details_state.dart';
import '../widgets/recent_solved_card.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final String username;
  const ProfileDetailsScreen({super.key, required this.username});

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
                return const Center(child: CircularProgressIndicator());
              }
              if(state is ProfileDetailsError){
                return Center(child: Text(state.error));
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
