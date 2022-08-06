import 'package:bloc/bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/auth/auth_event.dart';
import 'package:client/repositories/user.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.userRepositories, required this.authenticationBloc})
      : super(LoginInitial()) {
    on<LoginSubmit>(handleLoginSubmit);
  }

  Future<void> handleLoginSubmit(
      LoginSubmit event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final token = await userRepositories.login(event.email, event.password);
      authenticationBloc.add(LoggedIn(token: token));
      emit(LoginInitial());
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
