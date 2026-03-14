import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/features/profile_panel/bloc/profile_details_event.dart';
import 'package:leetcode_stats/features/profile_panel/bloc/profile_details_state.dart';

import '../../../repositories/profile_repository.dart';

class ProfileDetailsBloc extends Bloc<ProfileDetailsEvent, ProfileDetailsState>{
  final ProfileRepository profileRepo;
  ProfileDetailsBloc(this.profileRepo) : super(ProfileDetailsInitial()){
    on<LoadRecentSolved>((event, emit) async {
      emit(ProfileDetailsLoading());

      try{
        final ques = await profileRepo.getRecentSolved(event.username);
        emit(ProfileDetailsLoaded(ques));
      }catch(e){
        emit(ProfileDetailsError(e.toString()));
      }
    });
  }
}
