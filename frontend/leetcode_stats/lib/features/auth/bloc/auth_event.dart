abstract class AuthEvent {}

class LoginRequest extends AuthEvent{
  final username;
  LoginRequest(this.username);
}
class LogoutRequest extends AuthEvent{}