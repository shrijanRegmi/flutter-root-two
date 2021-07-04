import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:root_two/services/app/ad_provider.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/views/authentication/login_screen.dart';
import 'package:root_two/views/authentication/sign_up_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ScrollController _c;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _c = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final _adProvider = Provider.of<AdProvider>(context);

    return ViewModelProvider(
      viewModel: null,
      onInit: (vm) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _adProvider.loadInterstitialAd();
        });
      },
      onDispose: (vm) {
        _adProvider.onDispose();
      },
      builder: (vm) {
        return Scaffold(
          backgroundColor: Color(0xfff6f5f5),
          key: _scaffoldKey,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 150.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: -100.0,
                              left: -70.0,
                              child: SvgPicture.asset("images/auth_1.svg"),
                            ),
                            Positioned(
                              right: -40.0,
                              top: -20.0,
                              child: SvgPicture.asset("images/auth_4.svg"),
                            ),
                            Positioned(
                              top: 30.0,
                              right: 40.0,
                              child: SvgPicture.asset("images/auth_3.svg"),
                            ),
                            Positioned.fill(
                              top: -200.0,
                              child: Center(
                                child: SvgPicture.asset("images/auth_2.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 490.0,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _c,
                          children: <Widget>[
                            LoginScreen(_c),
                            SignUpScreen(_c),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
