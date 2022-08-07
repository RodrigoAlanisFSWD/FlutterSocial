import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      required this.size,
      required this.text,
      required this.onPressed,
      required this.backgroundColor,
      required this.textColor})
      : super(key: key);

  final Size size;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor, minimumSize: size),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ));
  }
}
