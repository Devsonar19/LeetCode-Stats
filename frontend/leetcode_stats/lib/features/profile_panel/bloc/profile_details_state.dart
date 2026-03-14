abstract class ProfileDetailsState {}
class ProfileDetailsInitial extends ProfileDetailsState {}
class ProfileDetailsLoading extends ProfileDetailsState {}

class ProfileDetailsLoaded extends ProfileDetailsState{
  final List recentSolved;
  ProfileDetailsLoaded(this.recentSolved);
}

class ProfileDetailsError extends ProfileDetailsState{
  final String error;
  ProfileDetailsError(this.error);
}