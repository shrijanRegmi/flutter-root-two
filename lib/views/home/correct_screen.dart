import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/views/home/play_screen.dart';
import 'package:root_two/views/widgets/gradient_btn.dart';

class CorrectScreen extends StatelessWidget {
  final AppUser user;
  final int points;
  final int level;
  final bool gameCompleted;
  CorrectScreen({
    this.user,
    this.points = 0,
    this.level,
    this.gameCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    'images/congrats.svg',
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFF7533),
                    ),
                    child: Center(
                      child: Text(
                        '${user.userName.substring(0, 1)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      !gameCompleted
                          ? 'Congrats! Correct'
                          : "Congratulations ! You have completed all the levels of this game.",
                      style: TextStyle(
                        fontSize: !gameCompleted ? 32.0 : 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (points > 0)
                    Text(
                      'You earned $points ${points > 1 ? 'points' : 'point'}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(
                    height: 50.0,
                  ),
                  MyGradientBtn(
                    title: !gameCompleted ? "Next" : "Go Home",
                    curved: false,
                    verticalPadding: 8.0,
                    colors: [
                      Color(0xffFF7533),
                      Color(0xffEF956A),
                    ],
                    function: () {
                      Navigator.pop(context);

                      if (gameCompleted) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayScreen(
                              getLevel: level,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
