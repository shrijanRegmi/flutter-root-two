import 'package:flutter/material.dart';

class SmallBtn extends StatelessWidget {
  final String title;
  final Color color;
  final Function function;
  SmallBtn(
      {@required this.title, @required this.color, @required this.function});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: function,
      color: color,
      textColor: Colors.white,
      child: Container(
        child: Center(
          child: Text("$title", style: TextStyle(fontSize: 12.0),),
        ),
      ),
    );
  }
}
