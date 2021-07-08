import 'package:flutter/material.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/splash_screen.dart';
import 'package:root_two/views/authentication/auth_screen.dart';
import 'package:root_two/views/home/home_screen.dart';

class Wrapper extends StatefulWidget {
  final AppUser appUser;
  Wrapper(this.appUser);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return SplashScreen();

    if (widget.appUser == null) {
      return AuthScreen();
    } else {
      return HomeScreen();
    }
  }
}
