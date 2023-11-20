import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    required this.function,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: TextButton(
        onPressed: function,
        child: Container(
          alignment: Alignment.center,
          width: 250,
          height: 25,
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(5)),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
