import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Emulator model class
class EmulatorModel {
  /// Emulator class variables
  final bool testingOnEmulator = true;
  final String localIP = '192.168.60.121';

  /// Emulator model class constructor
  /// Setup all emulators
  EmulatorModel() {
    setupAuthEmulator();
    if (kDebugMode) {
      print('Set up Auth emulator');
    }
    setupFirestoreEmulator();
    if (kDebugMode) {
      print('Set up Firestore emulator');
    }
    setupStorageEmulator();
    if (kDebugMode) {
      print('Set up Storage emulator');
    }
    setupFunctionsEmulator();
    if (kDebugMode) {
      print('Set up Functions emulator');
    }
  }

  /// Function to setup the Auth emulator
  void setupAuthEmulator() {
    if (testingOnEmulator == false) {
      FirebaseAuth.instance.useAuthEmulator(localIP, 9099);
    } else {
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    }
  }

  /// Function to setup the Firestore emulator
  void setupFirestoreEmulator() {
    if (FirebaseFirestore.instance.settings.host == null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (testingOnEmulator == false) {
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
        if (testingOnEmulator == false) {
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

  /// Function to setup the Storage emulator
  void setupStorageEmulator() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (testingOnEmulator == false) {
        FirebaseStorage.instance.useStorageEmulator(localIP, 9199);
      } else {
        FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
      }
    } else {
      FirebaseStorage.instance.useStorageEmulator('0.0.0.0', 9199);
    }
  }

  /// Function to setup the Functions emulator
  void setupFunctionsEmulator() {
    if (testingOnEmulator == false) {
      FirebaseFunctions.instance.useFunctionsEmulator(localIP, 3001);
    } else {
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 3001);
    }
  }
}
