import 'package:flutter/material.dart';
import 'package:root_two/views/home/level_screen.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLevelScreen;
  final Function function;
  MyAppBar({
    @required this.title,
    @required this.color,
    this.isLevelScreen,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: color,
            ),
            onPressed: () {
              if (isLevelScreen != null) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LevelScreen(),
                  ),
                );
              } else {
                function();
              }
            },
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "$title",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16.0, color: color),
          ),
        ],
      ),
    );
  }
}
