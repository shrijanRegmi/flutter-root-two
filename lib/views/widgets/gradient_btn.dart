import 'package:flutter/material.dart';

class MyGradientBtn extends StatelessWidget {
  final String title;
  final Function function;
  final IconData icon;
  final List<Color> colors;
  final bool curved;
  final double horizonalPadding;
  final double verticalPadding;
  MyGradientBtn({
    this.title,
    this.icon,
    this.colors,
    this.function,
    this.horizonalPadding = 30.0,
    this.verticalPadding = 10.0,
    this.curved = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(curved ? 50.0 : 4.0),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 10.0,
                offset: Offset(0, 0),
              )
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizonalPadding,
            vertical: verticalPadding,
          ),
          child: icon != null && title != null
              ? Row(
                  children: <Widget>[
                    Icon(icon, color: Colors.white),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("$title", style: TextStyle(color: Colors.white))
                  ],
                )
              : title != null
                  ? Padding(
                      padding: title == "Play Now"
                          ? const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 1.0,
                            )
                          : const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 5.0,
                            ),
                      child: Text(
                        "$title",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: title == "Play Now" ? 12.0 : 20.0,
                        ),
                      ),
                    )
                  : Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
