import 'package:bloc/bloc.dart';
import 'package:client/models/user.dart';
import 'package:client/repositories/user.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositories userRepositories;

  UserBloc({required this.userRepositories}) : super(UserInitial()) {
    on<LoadUser>(handleLoadUser);
    on<UnloadUser>(handleUnloadUser);
  }

  Future<void> handleLoadUser(
    LoadUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    var user = await userRepositories.getProfile();
    emit(UserLoaded(user: user));
  }

  handleUnloadUser(
    UnloadUser event,
    Emitter<UserState> emit,
  ) {
    emit(UserInitial());
  }
}
