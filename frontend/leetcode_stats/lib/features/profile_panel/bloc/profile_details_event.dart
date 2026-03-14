abstract class ProfileDetailsEvent {}
class LoadRecentSolved extends ProfileDetailsEvent{
  final String username;
  LoadRecentSolved(this.username);
}