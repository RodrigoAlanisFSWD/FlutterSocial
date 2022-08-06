import 'package:client/bloc/register/register_bloc.dart';
import 'package:client/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final TextEditingController _username = TextEditingController();
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();

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
          password: _password.text));
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Sign In")),
        body: BlocListener(
          listener: ((context, state) {
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Sign Up Failes"),
                backgroundColor: Colors.red,
              ));
            }
          }),
          child: BlocBuilder(
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
                    const Padding(padding: EdgeInsets.all(20)),
                    Button(
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
