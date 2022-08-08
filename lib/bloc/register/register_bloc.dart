import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/repositories/user.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  RegisterBloc(
      {required this.userRepositories, required this.authenticationBloc})
      : super(RegisterInitial()) {
    on<RegisterSubmit>(handleRegisterSubmit);
    on<FinishRegister>(handleFinishRegister);
  }

  Future<void> handleRegisterSubmit(
      RegisterSubmit event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    if (event.username == "" ||
        event.email == "" ||
        event.password == "" ||
        event.avatar == null) {
      emit(const RegisterFailure(error: "Please Enter All The Data"));
      return;
    }

    try {
      final tokens = await userRepositories.register(
          event.username, event.email, event.password);
      final code =
          await userRepositories.uploadAvatar(event.avatar, tokens.token);

      if (code != 200) {
        return emit(const RegisterFailure(error: "Error At Uploading Avatar"));
      }

      authenticationBloc
          .add(LoggedIn(token: tokens.token, refresh: tokens.refresh));
      emit(RegisterFinished());
    } catch (error) {
      emit(RegisterFailure(error: error.toString()));
    }
  }

  handleFinishRegister(FinishRegister event, Emitter<RegisterState> emit) {
    emit(RegisterInitial());
  }
}
