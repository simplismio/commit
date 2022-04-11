import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EmailService {
  Future sendEmail(function, email, username, title, body) async {
    try {
      FirebaseFunctions.instanceFor()
          .httpsCallable(function,
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 30)))
          .call({
        'email': email,
        'username': username,
        'title': title,
        'body': body,
      });
      return null;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }
}
