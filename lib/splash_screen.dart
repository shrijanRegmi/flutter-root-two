import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'images/loading.json',
                  width: 100.0,
                  height: 100.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Root Two',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff413D7A),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Take your brain to the\nnext level',
                  style: TextStyle(
                    color: Color(0xff413D7A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
