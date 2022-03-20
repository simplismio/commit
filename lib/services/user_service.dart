import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode, ChangeNotifier;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'emulator_service.dart';
import 'package:crypto/crypto.dart';

class UserService extends ChangeNotifier {
  String? uid;
  // final String username;

  UserService({
    this.uid,
    // this.username,
  });

  UserService? _userFromFirebaseUser(User? user) {
    if (kDebugMode && user != null) {
      // ignore: avoid_print
      print('Firebase UID is: ${user.uid}');
    }
    return UserService(uid: user?.uid);
  }

  Stream<UserService?> get user {
    if (kDebugMode) {
      EmulatorService.setupAuthEmulator();
    }
    return FirebaseAuth.instance.userChanges().map(_userFromFirebaseUser);
  }

  Future signUpUsingEmailAndPassword({String? email, String? password}) async {
    try {
      if (kDebugMode) {
        print('Signing up user');
        EmulatorService.setupAuthEmulator();
      }
      await FirebaseAnalytics.instance
          .logSignUp(signUpMethod: 'email/password');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signInUsingEmailAndPassword(String? email, String? password) async {
    try {
      if (kDebugMode) {
        print('Signing in user');
        EmulatorService.setupAuthEmulator();
      }
      await FirebaseAnalytics.instance.logLogin();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future resetPassword(String? email) async {
    try {
      if (kDebugMode) {
        print('Sending password reset email');
        EmulatorService.setupAuthEmulator();
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      if (kDebugMode) {
        EmulatorService.setupAuthEmulator();
        print('Signing out user');
      }
      await FirebaseAuth.instance.signOut();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    if (kDebugMode) {
      EmulatorService.setupAuthEmulator();
    }
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      if (kDebugMode) {
        print('User login using Facebook');
      }
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      if (kDebugMode) {
        EmulatorService.setupAuthEmulator();
      }
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    return null;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    if (kDebugMode) {
      EmulatorService.setupAuthEmulator();
    }
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
