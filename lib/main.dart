import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:commit/screens/iam/localAuthorization.dart';
import 'package:commit/screens/public/homeScreen.dart';
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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => LocalAuthenticationService()),
        ],
        child: Consumer<ThemeService>(
            builder: (context, ThemeService theme, child) {
          print('The theme is dark: ' + theme.darkTheme.toString());
          return GetMaterialApp(
              title: "Flutter Provider",
              theme: theme.darkTheme ? dark : light,
              home: SafeArea(child: Scaffold(body:
                  Consumer<LocalAuthenticationService>(builder: (context,
                      LocalAuthenticationService localAuthentication, child) {
                print('Starting app, local user authentication status: ' +
                    localAuthentication.biometrics.toString());

                if (localAuthentication.biometrics == true) {
                  return LocalAuthorization();
                } else {
                  return HomeScreen();
                }
              }))));
        }));
  }
}
