abstract class AuthenticationEvent {}

class AuthenticationStarted extends AuthenticationEvent {
  final String username;
  final String password;

  AuthenticationStarted(this.username, this.password);
}

class AuthenticationLoggedOut extends AuthenticationEvent {}
