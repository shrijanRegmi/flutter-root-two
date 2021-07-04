import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_field.dart';

class AuthContainer extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passController;
  final Function googleSignIn;
  final Function facebookSignIn;
  final String errorMessage;
  AuthContainer(
      {this.nameController,
      this.emailController,
      this.passController,
      this.googleSignIn,
      this.facebookSignIn,
      this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.only(
            top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10.0,
                offset: Offset(0, 1)),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            nameController != null
                ? Column(
                    children: <Widget>[
                      AuthField(
                        "Full Name",
                        nameController,
                        Icons.format_color_text,
                        textCapitalization: TextCapitalization.words,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  )
                : Container(),
            AuthField("Email", emailController, Icons.email),
            SizedBox(
              height: 20.0,
            ),
            AuthField("Password", passController, Icons.lock),
            SizedBox(
              height: 30.0,
            ),
            if (errorMessage != null)
              Column(
                children: <Widget>[
                  Text(
                    "$errorMessage",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            Text(
              "or via",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // GestureDetector(
                //   onTap: facebookSignIn,
                //   child: SvgPicture.asset("images/facebook.svg"),
                // ),
                // SizedBox(
                //   width: 10.0,
                // ),
                GestureDetector(
                  onTap: googleSignIn,
                  child: SvgPicture.asset("images/google.svg"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
