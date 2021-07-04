import 'package:flutter/material.dart';
import 'package:root_two/services/firebase/auth/auth_provider.dart';
import 'package:root_two/viewmodels/login_vm.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/views/widgets/auth_container.dart';
import 'package:root_two/views/widgets/gradient_btn.dart';

class LoginScreen extends StatefulWidget {
  final ScrollController _c;

  @override
  _LoginScreenState createState() => _LoginScreenState();

  LoginScreen(this._c);
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginScreenVm>(
      viewModel: LoginScreenVm(context: context),
      builder: (LoginScreenVm vm) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26.0,
                          color: Color(0xff413D7A),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      vm.showProgressBar
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff413D7A),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  MyGradientBtn(
                    icon: Icons.arrow_forward_ios,
                    colors: [Color(0xff413D7A), Colors.purple],
                    function: () => vm.loginUser(
                      email: _emailController.text.trim(),
                      pass: _passController.text.trim(),
                    ),
                  ),
                ],
              ),
            ),
            AuthContainer(
              emailController: _emailController,
              passController: _passController,
              errorMessage: vm.errorMessage,
              googleSignIn: () async {
                _emailController.clear();
                _passController.clear();
                AuthProvider().signInWithGoogle();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                if (!vm.showProgressBar) {
                  widget._c.animateTo(MediaQuery.of(context).size.width,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.ease);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      "Don't have an account? Create one here",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        color: Color(0xff413D7A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
