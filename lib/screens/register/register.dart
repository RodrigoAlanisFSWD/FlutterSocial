import 'dart:io';

import 'package:client/bloc/register/register_bloc.dart';
import 'package:client/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final TextEditingController _username = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  File? _avatar;

  @override
  void initState() {
    _avatar = null;
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onRegisterSubmit() {
      BlocProvider.of<RegisterBloc>(context).add(RegisterSubmit(
          username: _username.text,
          email: _email.text,
          password: _password.text,
          avatar: _avatar!));
    }

    _pickAvatar() async {
      final ImagePicker _picker = ImagePicker();

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _avatar = File(image.path);
        });
      }
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Sign In")),
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: ((context, state) {
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.error.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ));
            }

            if (state is RegisterFinished) {
              BlocProvider.of<RegisterBloc>(context).add(FinishRegister());
              Navigator.popUntil(context, ModalRoute.withName("/"));
            }
          }),
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      child: TextField(
                        controller: _username,
                        decoration: const InputDecoration(
                            label: Text("Username"),
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    SizedBox(
                      width: 350,
                      child: TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            label: Text("Email"),
                            prefixIcon: Icon(Icons.email)),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    SizedBox(
                      width: 350,
                      child: TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                            label: Text("Password"),
                            prefixIcon: Icon(Icons.lock)),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Button(
                        backgroundColor: Colors.transparent,
                        textColor: Colors.blue,
                        size: const Size(350, 50),
                        text: _avatar != null
                            ? "Avatar Selected"
                            : "Select Avatar",
                        onPressed: () {
                          _pickAvatar();
                        }),
                    const Padding(padding: EdgeInsets.all(20)),
                    Button(
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        size: const Size(350, 50),
                        text: "Sign In",
                        onPressed: () {
                          _onRegisterSubmit();
                        }),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
