import 'package:bloc/bloc.dart';
import 'package:client/repositories/user.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

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
    final token = await userRepositories.hasToken();

    if (token) {
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
