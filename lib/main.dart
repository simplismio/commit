import 'dart:async';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/analytics_model.dart';
import './models/biometric_model.dart';
import './models/contract_model.dart';
import 'helpers/emulator_helper.dart';
import './models/theme_model.dart';
import 'helpers/authorization_helper.dart';
import 'helpers/biometric_helper.dart';
import 'models/language_model.dart';
import 'helpers/media_helper.dart';
import 'models/notification_model.dart';
import 'models/user_model.dart';

//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> main() async {
  /// Making native code initialization before Flutter app initiazliation
  WidgetsFlutterBinding.ensureInitialized();

  /// Initiate Facebook Web API for authentication
  // if (kIsWeb) {
  //   // initialiase the facebook javascript SDK
  //   FacebookAuth.i.webInitialize(
  //     appId: "356687176318853", //<-- YOUR APP_ID
  //     cookie: true,
  //     xfbml: true,
  //     version: "v9.0",
  //   );
  // }

  /// Initialize App for mobile & web
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await Firebase.initializeApp(
      name: 'Commit',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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

  /// Initalize Notifications model
  NotificationModel().initialize();

  /// InitializeAnalytics & Performance measurements if consent given by user
  if (AnalyticsModel().analytics == true) {
    await FirebaseAnalytics.instance.logAppOpen();
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  }

  /// Initialize Crashlytics, Emulator & InApp Messages if in debug mode
  if (kDebugMode) {
    try {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      EmulatorHelper().initialize();
      String? firebaseInstallationId =
          await FirebaseInstallations.instance.getId();
      print('Firebase Installation ID: $firebaseInstallationId');
    } catch (e) {
      print(e);
    }
  }

  /// Initialize the app
  /// Wrap initialization with crashlytic listener
  /// Wrap initialization with user stream to check authentication stream as early as possible
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

/// Commit class
/// Initializes all streams and notifiers
/// Initializes MaterialApp for mobile & web
/// Initializes (local) authentication
class CommitApp extends StatelessWidget {
  const CommitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeModel()),
          ChangeNotifierProvider(create: (_) => BiometricModel()),
          ChangeNotifierProvider(create: (_) => MediaHelper()),
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
                    return const BiometricHelper();
                  } else {
                    return const AuthorizationHelper();
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
                home: const Scaffold(body: AuthorizationHelper()));
          }
        }));
  }
}
