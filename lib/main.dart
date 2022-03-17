import './services/user_service.dart';
import './services/theme_service.dart';
import './services/local_authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'services/data_service.dart';
import 'utilities/authorization_utility.dart';
import 'utilities/local_authorization_utility.dart';

//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (kIsWeb) {
  //   // initialiase the facebook javascript SDK
  //   FacebookAuth.i.webInitialize(
  //     appId: "356687176318853", //<-- YOUR APP_ID
  //     cookie: true,
  //     xfbml: true,
  //     version: "v9.0",
  //   );
  // }

  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
    // FirebaseFirestore.instance.settings =
    //     const Settings(persistenceEnabled: true);
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyC2lwITHjZIWtWK8TAlid104yt8cAmRrOU",
      appId: "1:236126728561:web:777f7f92d8ed6a5b7e86d0",
      messagingSenderId: "236126728561",
      projectId: "commit-b9e29",
    ));
  }

  runApp(const CommitApp());
}

class CommitApp extends StatelessWidget {
  const CommitApp({Key? key}) : super(key: key);

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
          StreamProvider<List<DataService>>.value(
              value: DataService().contracts,
              initialData: const [],
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
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android) {
            return MaterialApp(
                theme: theme.darkTheme == true ? dark : light,
                home: Scaffold(body: Consumer<LocalAuthenticationService>(
                    builder: (context,
                        LocalAuthenticationService localAuthentication, child) {
                  if (kDebugMode) {
                    print('Starting app, local user authentication status: ' +
                        localAuthentication.biometrics.toString());
                  }
                  if (localAuthentication.biometrics == true) {
                    return const LocalAuthorizationUtility();
                  } else {
                    return const AuthorizationUtility();
                  }
                })));
          } else {
            return MaterialApp(
                theme: theme.darkTheme == true ? dark : light,
                home: const Scaffold(body: AuthorizationUtility()));
          }
        }));
  }
}
