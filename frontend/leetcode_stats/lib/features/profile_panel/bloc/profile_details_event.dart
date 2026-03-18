abstract class ProfileDetailsEvent {}
class LoadRecentSolved extends ProfileDetailsEvent{
  final String username;
  LoadRecentSolved(this.username);
}
class LoadProfile extends ProfileDetailsEvent{
  final String username;
  LoadProfile(this.username);
}