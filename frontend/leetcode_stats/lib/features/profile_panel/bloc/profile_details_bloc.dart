import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/features/profile_panel/bloc/profile_details_event.dart';
import 'package:leetcode_stats/features/profile_panel/bloc/profile_details_state.dart';

import '../../../repositories/profile_repository.dart';

class ProfileDetailsBloc extends Bloc<ProfileDetailsEvent, ProfileDetailsState>{
  final ProfileRepository profileRepo;
  ProfileDetailsBloc(this.profileRepo) : super(ProfileDetailsInitial()){
    on<LoadRecentSolved>((event, emit) async {
      emit(ProfileDetailsLoading());

      try {
        final data = await profileRepo.getProfile(event.username);
        final ques = await profileRepo.getRecentSolved(event.username);
        final dailyQues = await profileRepo.getDailyQuestion(event.username);

        final user = (data is Map)
            ? Map<String, dynamic>.from(data)
            : <String, dynamic>{};

        if(user == null){
          emit(ProfileDetailsError("User not found"));
          return;
        }

        emit(ProfileDetailsLoaded(
          ques,
          dailyQues,
          user,
        ));
      } catch (e) {
        emit(ProfileDetailsError(e.toString()));
      }
    });
  }
}
