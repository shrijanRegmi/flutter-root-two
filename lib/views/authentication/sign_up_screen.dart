import 'package:flutter/material.dart';
import 'package:root_two/services/firebase/auth/auth_provider.dart';
import 'package:root_two/viewmodels/sign_up_vm.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/views/widgets/auth_container.dart';
import 'package:root_two/views/widgets/gradient_btn.dart';

class SignUpScreen extends StatefulWidget {
  final ScrollController _c;

  SignUpScreen(this._c);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpScreenVm>(
      viewModel: SignUpScreenVm(context: context),
      builder: (SignUpScreenVm vm) => Container(
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
                        "Sign up",
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
                                  Color(0xff413D7A)),
                            )
                          : Container(),
                    ],
                  ),
                  MyGradientBtn(
                    colors: [Color(0xff413D7A), Colors.purple],
                    icon: Icons.arrow_forward_ios,
                    function: () => vm.signUpUser(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      pass: _passController.text.trim(),
                    ),
                  ),
                ],
              ),
            ),
            AuthContainer(
              nameController: _nameController,
              emailController: _emailController,
              passController: _passController,
              errorMessage: vm.errorMessage,
              googleSignIn: () {
                _nameController.clear();
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
                  widget._c.animateTo(
                    -1,
                    duration: Duration(milliseconds: 800),
                    curve: Curves.ease,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      "Already have an account? Login here",
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
