import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/login/login_bloc.dart';
import 'package:client/bloc/register/register_bloc.dart';
import 'package:client/bloc/user/user_bloc.dart';
import 'package:client/models/user.dart';
import 'package:client/repositories/user.dart';
import 'package:client/screens/home/home.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/screens/profile/profile.dart';
import 'package:client/screens/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final UserRepositories userRepositories = UserRepositories();
  final AuthenticationBloc authenticationBloc =
      AuthenticationBloc(userRepositories: userRepositories);
  runApp(MyApp(
    userRepositories: userRepositories,
    authenticationBloc: authenticationBloc,
  ));
}

class MyApp extends StatefulWidget {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  const MyApp(
      {Key? key,
      required this.userRepositories,
      required this.authenticationBloc})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyApp> createState() => _MyAppState(
      userRepositories: userRepositories,
      authenticationBloc: authenticationBloc);
}

class _MyAppState extends State<MyApp> {
  final UserRepositories userRepositories;
  final AuthenticationBloc authenticationBloc;

  _MyAppState(
      {required this.userRepositories, required this.authenticationBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: authenticationBloc..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        routes: {
          "/": (_) => const Home(),
          "/sign-in": (_) => BlocProvider<LoginBloc>(
                create: (BuildContext context) => LoginBloc(
                    userRepositories: userRepositories,
                    authenticationBloc: authenticationBloc),
                child: const Login(),
              ),
          "/sign-up": (_) => BlocProvider(
                create: (context) => RegisterBloc(
                    userRepositories: userRepositories,
                    authenticationBloc: authenticationBloc),
                child: const Register(),
              ),
          "/profile": (_) => BlocProvider(
                create: (context) =>
                    UserBloc(userRepositories: userRepositories),
                child: const Profile(),
              )
        },
      ),
    );
  }
}
