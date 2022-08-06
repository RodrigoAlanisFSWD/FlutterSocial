import 'package:client/bloc/login/login_bloc.dart';
import 'package:client/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onLoginSubmit() {
      BlocProvider.of<LoginBloc>(context)
          .add(LoginSubmit(email: _email.text, password: _password.text));
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Sign In")),
        body: BlocListener(
          listener: ((context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Sign In Failed"),
                backgroundColor: Colors.red,
              ));
            }
          }),
          child: BlocBuilder(builder: ((context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          label: Text("Email"), prefixIcon: Icon(Icons.email)),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
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
                        _onLoginSubmit();
                      }),
                  const Padding(padding: EdgeInsets.all(5)),
                  OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(350, 50)),
                      icon: Image.asset(
                        'assets/google.png',
                        width: 25,
                        height: 25,
                      ),
                      label: const Text(
                        "Continue With Google",
                        style: TextStyle(color: Colors.white),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("You Dont Have An Account ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/sign-up");
                          },
                          child: const Text("click here"))
                    ],
                  )
                ],
              ),
            );
          })),
        ));
  }

  Future<void> SignIn() async {
    final email = _email.text;
    final password = _password.text;
  }
}
