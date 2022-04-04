import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

class EmulatorService {
  static bool testingOnRealDevice = true;
  static String localIP = '192.168.60.121';

  static void setupAuthEmulator() {
    if (testingOnRealDevice == true) {
      FirebaseAuth.instance.useAuthEmulator(localIP, 9099);
    } else {
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    }
  }

  static void setupFirestoreEmulator() {
    if (FirebaseFirestore.instance.settings.host == null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (testingOnRealDevice == true) {
          FirebaseFirestore.instance.settings = Settings(
              host: '$localIP:8080',
              sslEnabled: false,
              persistenceEnabled: false);
        } else {
          FirebaseFirestore.instance.settings = const Settings(
              host: '10.0.2.2:8080',
              sslEnabled: false,
              persistenceEnabled: false);
        }
      } else {
        if (testingOnRealDevice == true) {
          FirebaseFirestore.instance.settings = Settings(
              host: '$localIP:8080',
              sslEnabled: false,
              persistenceEnabled: false);
        } else {
          FirebaseFirestore.instance.settings = const Settings(
              host: '0.0.0.0:8080',
              sslEnabled: false,
              persistenceEnabled: false);
        }
      }
    }
  }

  static void setupStorageEmulator() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (testingOnRealDevice == true) {
        FirebaseStorage.instance.useStorageEmulator(localIP, 9199);
      } else {
        FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
      }
    } else {
      FirebaseStorage.instance.useStorageEmulator('0.0.0.0', 9199);
    }
  }

  static void setupFunctionsEmulator() {
    if (testingOnRealDevice == true) {
      FirebaseFunctions.instance.useFunctionsEmulator(localIP, 3001);
    } else {
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 3001);
    }
  }
}
