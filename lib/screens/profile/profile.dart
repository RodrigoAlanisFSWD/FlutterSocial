import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/user/user_bloc.dart';
import 'package:client/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    final userBloc = BlocProvider.of<UserBloc>(context);
    if (userBloc.state is UserInitial) {
      userBloc.add(LoadUser());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Get Profile Failed",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Scaffold(
            appBar: AppBar(title: const Text("Profile")),
            body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserLoading) {
                return const CircularProgressIndicator(
                  color: Colors.blue,
                );
              }

              if (state is UserLoaded) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        state.user.avatarUrl,
                        width: 250,
                      ),
                      const Padding(padding: EdgeInsets.all(15)),
                      Text(
                        state.user.username,
                        style: const TextStyle(fontSize: 25),
                      ),
                      const Padding(padding: EdgeInsets.all(15)),
                      Text(state.user.email),
                      const Padding(padding: EdgeInsets.all(15)),
                      Button(
                          size: const Size(350, 50),
                          text: "Logout",
                          onPressed: () {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(LoggedOut());

                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.blue,
                          textColor: Colors.white)
                    ],
                  ),
                );
              }

              return const Text("");
            })));
  }
}
