import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/app/ad_provider.dart';
import 'package:root_two/services/app/level_provider.dart';
import 'package:root_two/services/app/save_data.dart';
import 'package:root_two/services/firebase/auth/auth_provider.dart';
import 'package:root_two/viewmodels/vm_provider.dart';
import 'package:root_two/wrapper.dart';
import 'package:root_two/wrapper_builder.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xff413D7A),
    systemNavigationBarColor: Color(0xff413D7A),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snap) {
        if (snap.hasData)
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<LevelProvider>(
                create: (_) => LevelProvider(),
              ),
              ChangeNotifierProvider<SaveData>(
                create: (_) => SaveData(),
              ),
              ChangeNotifierProvider<AdProvider>(
                create: (_) => AdProvider(),
              ),
              StreamProvider<AppUser>.value(
                initialData: null,
                value: AuthProvider().initUserDetail,
              ),
            ],
            child: WrapperBuilder(
              builder: () => MyMaterialApp(),
            ),
          );
        return Container();
      },
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _adProvider = Provider.of<AdProvider>(context);

    return ViewModelProvider(
      viewModel: null,
      onInit: (vm) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _adProvider?.updateIsBannerLoaded(false);
          _adProvider?.loadBannerAd();
        });
      },
      builder: (vm) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Nunito',
            canvasColor: Color(0xffF3F5F8),
          ),
          home: Column(
            children: [
              Expanded(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Root Two',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    fontFamily: 'Nunito',
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: Wrapper(),
                ),
              ),
              (_adProvider?.isBannerLoaded ?? false)
                  ? Container(
                      height: 60.0,
                      color: Colors.white,
                      child: AdWidget(
                        ad: _adProvider.bannerAd,
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
