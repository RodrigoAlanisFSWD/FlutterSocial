import 'package:client/repositories/user.dart';

import 'auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepositories userRepositories;

  AuthenticationBloc({required this.userRepositories})
      : super(AuthenticationInitialState()) {
    on<AppStarted>(handleAppStarted);
    on<LoggedIn>(handleLoggedIn);
    on<LoggedOut>(handleLoggedOut);
  }

  Future<void> handleAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    final bool hasToken = await userRepositories.hasToken();

    if (hasToken) {
      emit(AuthenticationAuthenticated());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> handleLoggedIn(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    await userRepositories.persisteToken(event.token);
    emit(AuthenticationAuthenticated());
  }

  Future<void> handleLoggedOut(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    await userRepositories.deleteToken();
    emit(AuthenticationUnauthenticated());
  }
}
