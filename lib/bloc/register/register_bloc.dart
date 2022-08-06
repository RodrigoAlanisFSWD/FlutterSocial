import 'package:bloc/bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/repositories/user.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  RegisterBloc(
      {required this.userRepositories, required this.authenticationBloc})
      : super(RegisterInitial()) {
    on<RegisterSubmit>(handleRegisterSubmit);
  }

  Future<void> handleRegisterSubmit(
      RegisterSubmit event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    try {
      final token = await userRepositories.register(
          event.username, event.email, event.password);
      authenticationBloc.add(LoggedIn(token: token));
      emit(RegisterInitial());
    } catch (error) {
      emit(RegisterFailure(error: error.toString()));
    }
  }
}
