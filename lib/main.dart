import 'package:client/screens/home/home.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/screens/register/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      routes: {
        "/": (context) => const Home(),
        "/sign-up": (context) => const Register(),
        "/sign-in": (context) => const Login(),
      },
    );
  }
}
