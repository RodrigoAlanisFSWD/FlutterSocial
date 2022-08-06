import 'package:client/bloc/user/user_bloc.dart';
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
    BlocProvider.of<UserBloc>(context).add(LoadUser());
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
          body: Center(
            child: Column(
              children: [
                BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state is UserLoading) {
                    return const CircularProgressIndicator(
                      color: Colors.blue,
                    );
                  }

                  if (state is UserLoaded) {
                    return Text(state.user.email);
                  } else {
                    return Text("");
                  }
                })
              ],
            ),
          ),
        ));
  }
}
