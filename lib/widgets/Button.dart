import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      required this.size,
      required this.text,
      required this.onPressed})
      : super(key: key);

  final Size size;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blue, minimumSize: size),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
