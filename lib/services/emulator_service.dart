import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EmulatorService {
  static void setupAuthEmulator() {
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  static void setupFirestoreEmulator() {
    if (FirebaseFirestore.instance.settings.host == null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        FirebaseFirestore.instance.settings = const Settings(
            host: '10.0.2.2:8080',
            sslEnabled: false,
            persistenceEnabled: false);
      } else {
        FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080',
          sslEnabled: false,
          persistenceEnabled: false,
        );
      }
    }
  }
}
