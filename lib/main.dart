import 'package:commit/pages/RootPage.dart';
import 'package:commit/shares/loadingShare.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:commit/services/localAuthenticationService.dart';
import 'package:provider/provider.dart';
import 'package:commit/services/themeService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});

  // if (kIsWeb) {
  //   // initialiaze the facebook javascript SDK
  //   FacebookAuth.i.webInitialize(
  //     appId: "315647996686093", //<-- YOUR APP_ID
  //     cookie: true,
  //     xfbml: true,
  //     version: "v9.0",
  //   );
  // }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => LocalAuthenticationService()),
        ],
        child: Consumer<ThemeService>(
            builder: (context, ThemeService theme, child) {
          if (kDebugMode) {
            print('The theme is dark: ' + theme.darkTheme.toString());
          }
          return GetMaterialApp(
              title: "Flutter Provider",
              theme: theme.darkTheme ? dark : light,
              home: SafeArea(child: Scaffold(body: LoadingShare())));
        }));
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, route);
  }

  void route() {
    Get.offAll(RootPage());
  }
}
