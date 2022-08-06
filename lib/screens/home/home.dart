import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Home")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome To Social Flutter"),
                const Padding(padding: EdgeInsets.all(10)),
                Button(
                  size: const Size(350, 50),
                  text: "To Sign In",
                  onPressed: () {
                    Navigator.pushNamed(context, "/sign-in");
                  },
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Button(
                  size: const Size(350, 50),
                  text: "To Profile",
                  onPressed: () {
                    Navigator.pushNamed(context, "/profile");
                  },
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Text(state is AuthenticationAuthenticated
                    ? "Authenticated"
                    : "Unaunthenticated")
              ],
            ),
          ),
        );
      },
    );
  }
}
