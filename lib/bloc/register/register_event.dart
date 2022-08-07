part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmit extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final File avatar;

  const RegisterSubmit(
      {required this.username,
      required this.email,
      required this.password,
      required this.avatar});

  @override
  List<Object> get props => [username, email, password, avatar];
}

class FinishRegister extends RegisterEvent {}
