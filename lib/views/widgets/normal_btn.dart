import 'package:flutter/material.dart';

class NormalBtn extends StatelessWidget {
  final String title;
  final Color color;
  final Function function;

  NormalBtn({this.title, this.color, this.function});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledTextColor: Colors.grey,
      onPressed: function,
      color: color,
      textColor: Colors.white,
      child: Container(
        constraints: BoxConstraints(maxWidth: 100.0),
        child: Center(
          child: Text("$title"),
        ),
      ),
    );
  }
}
