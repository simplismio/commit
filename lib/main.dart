import 'package:commit/pages/iam/authorization.dart';
import './pages/iam/local_authorization.dart';
import './services/commitment_service.dart';
import './services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './services/local_authentication_service.dart';
import 'package:provider/provider.dart';
import './services/theme_service.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (kIsWeb) {
  //   // initialiase the facebook javascript SDK
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
          StreamProvider<List<CommitmentService>>.value(
              value: CommitmentService().commitments,
              initialData: [],
              catchError: (BuildContext context, e) {
                if (kDebugMode) {
                  print("Error:$e");
                }
                return [];
              }),
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
                  return const Authorization();
                }
              })));
        }));
  }
}
