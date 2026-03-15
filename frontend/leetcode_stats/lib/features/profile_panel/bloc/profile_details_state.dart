abstract class ProfileDetailsState {}
class ProfileDetailsInitial extends ProfileDetailsState {}
class ProfileDetailsLoading extends ProfileDetailsState {}

class ProfileDetailsLoaded extends ProfileDetailsState{
  final List recentSolved;
  final Map<String, dynamic> dailyQues;
  ProfileDetailsLoaded(this.recentSolved, this.dailyQues);
}

class ProfileDetailsError extends ProfileDetailsState{
  final String error;
  ProfileDetailsError(this.error);
}