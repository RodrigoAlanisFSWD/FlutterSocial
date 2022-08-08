part of 'auth_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String refresh;

  const LoggedIn({required this.token, required this.refresh});

  @override
  List<Object> get props => [token, refresh];

  @override
  String toString() => "LoggedIn ($token)";
}

class LoggedOut extends AuthenticationEvent {}
