import 'package:commit/pages/iam/localAuthorization.dart';
import 'package:commit/pages/public/homeScreen.dart';
import 'package:commit/services/dataService.dart';
import 'package:commit/services/userService.dart';
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
  //SharedPreferences.setMockInitialValues({});

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
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => LocalAuthenticationService()),
          StreamProvider<List<DataService>>.value(
            value: DataService().commitments,
            initialData: const [],
          ),
          StreamProvider<UserService?>.value(
            value: UserService().user,
            initialData: null,
            catchError: (BuildContext context, e) {
              if (kDebugMode) {
                print("Error:$e");
              }
              return null;
            },
          ),
        ],
        child: Consumer<ThemeService>(
            builder: (context, ThemeService theme, child) {
          if (kDebugMode) {
            print('The theme is dark: ' + theme.darkTheme.toString());
          }
          return GetMaterialApp(
              theme: theme.darkTheme == true ? dark : light,
              home: Scaffold(body: Consumer<LocalAuthenticationService>(builder:
                  (context, LocalAuthenticationService localAuthentication,
                      child) {
                if (kDebugMode) {
                  print('Starting app, local user authentication status: ' +
                      localAuthentication.biometrics.toString());
                }
                if (localAuthentication.biometrics == true) {
                  return const LocalAuthorization();
                } else {
                  return const HomeScreen();
                }
              })));
        }));
  }
}
