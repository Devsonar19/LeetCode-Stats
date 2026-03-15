abstract class AuthState {}

class AuthInitial extends AuthState{}
class AuthLoading extends AuthState{}

class AuthSuccess extends AuthState{
  final String username;
  AuthSuccess(this.username);
}

class AuthFailure extends AuthState{
  final String error;
  AuthFailure(this.error);
}