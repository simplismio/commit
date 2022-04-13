import 'dart:async';

import 'package:commit/Models/language_Model.dart';
import 'package:commit/Models/media_Model.dart';
import 'package:commit/Models/notification_Model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/analytics_Model.dart';
import './models/biometric_Model.dart';
import './models/contract_Model.dart';
import './models/emulator_Model.dart';
import './models/theme_Model.dart';
import './models/user_Model.dart';
import 'utilities/authorization_utility.dart';
import 'utilities/biometric_utility.dart';

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
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC2lwITHjZIWtWK8TAlid104yt8cAmRrOU",
            authDomain: "commit-b9e29.firebaseapp.com",
            projectId: "commit-b9e29",
            storageBucket: "commit-b9e29.appspot.com",
            messagingSenderId: "236126728561",
            appId: "1:236126728561:web:777f7f92d8ed6a5b7e86d0",
            measurementId: "G-8Z10Z47T7F"));
  }

  NotificationModel().initialize();

  if (AnalyticsModel().analytics == true) {
    await FirebaseAnalytics.instance.logAppOpen();
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  }

  if (kDebugMode) {
    try {
      EmulatorModel.setupAuthEmulator();
      EmulatorModel.setupFirestoreEmulator();
      EmulatorModel.setupStorageEmulator();
      EmulatorModel.setupFunctionsEmulator();
    } catch (e) {
      print(e);
    }
  }

  runZonedGuarded<Future<void>>(() async {
    runApp(StreamProvider<UserModel?>.value(
        value: UserModel().user,
        initialData: null,
        catchError: (BuildContext context, e) {
          if (kDebugMode) {
            print("Error:$e");
          }
          return null;
        },
        child: const CommitApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class CommitApp extends StatelessWidget {
  const CommitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeModel()),
          ChangeNotifierProvider(create: (_) => BiometricModel()),
          ChangeNotifierProvider(create: (_) => MediaModel()),
          ChangeNotifierProvider(create: (_) => LanguageModel()),
          ChangeNotifierProvider(create: (_) => NotificationModel()),
          ChangeNotifierProvider(create: (_) => AnalyticsModel()),
          StreamProvider<List<ContractModel>>.value(
              value: ContractModel().contracts,
              initialData: const [],
              catchError: (BuildContext context, e) {
                if (kDebugMode) {
                  print("Error:$e");
                }
                return [];
              }),
          StreamProvider<List<NotificationModel>>.value(
              value: NotificationModel().notifications,
              initialData: const [],
              catchError: (BuildContext context, e) {
                if (kDebugMode) {
                  print("Error:$e");
                }
                return [];
              }),
          StreamProvider<List<UserModel>>.value(
              value: UserModel().users,
              initialData: const [],
              catchError: (BuildContext context, e) {
                if (kDebugMode) {
                  print("Error:$e");
                }
                return [];
              }),
        ],
        child:
            Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
          if (kDebugMode) {
            print('The theme is dark: ' + theme.darkTheme.toString());
          }
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android) {
            return MaterialApp(
                navigatorObservers: AnalyticsModel().analytics == true
                    ? [
                        FirebaseAnalyticsObserver(
                            analytics: FirebaseAnalytics.instance),
                      ]
                    : [],
                theme: theme.darkTheme == true ? dark : light,
                home: Scaffold(body: Consumer<BiometricModel>(builder:
                    (context, BiometricModel localAuthentication, child) {
                  if (kDebugMode) {
                    print('Starting app, local user authentication status: ' +
                        localAuthentication.biometrics.toString());
                  }
                  if (localAuthentication.biometrics == true) {
                    return const BiometricUtility();
                  } else {
                    return const AuthorizationUtility();
                  }
                })));
          } else {
            return MaterialApp(
                navigatorObservers: AnalyticsModel().analytics == true
                    ? [
                        FirebaseAnalyticsObserver(
                            analytics: FirebaseAnalytics.instance),
                      ]
                    : [],
                theme: theme.darkTheme == true ? dark : light,
                home: const Scaffold(body: AuthorizationUtility()));
          }
        }));
  }
}
