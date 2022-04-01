import 'dart:io';
import 'dart:typed_data';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'emulator_service.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class UserService extends ChangeNotifier {
  String? uid;
  String? avatar;
  String? username;
  String? email;

  UserService({
    this.uid,
    this.avatar,
    this.username,
    this.email,
  });

  UserService? _userFromFirebaseUser(User? user) {
    if (kDebugMode && user != null) {
      // ignore: avoid_print
      print('Firebase UID is: ${user.uid}');
    }
    return UserService(
        uid: user?.uid,
        avatar: user?.photoURL,
        username: user?.displayName,
        email: user?.email);
  }

  Stream<UserService?> get user {
    if (kDebugMode) {
      EmulatorService.setupAuthEmulator();
    }
    return FirebaseAuth.instance.userChanges().map(_userFromFirebaseUser);
  }

  Future signUpUsingEmailAndPassword(
      {String? username, String? email, String? password}) async {
    try {
      if (kDebugMode) {
        print('Signing up user');
        EmulatorService.setupAuthEmulator();
      }
      await FirebaseAnalytics.instance
          .logSignUp(signUpMethod: 'email/password');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      final _user = FirebaseAuth.instance.currentUser;
      _user?.updateDisplayName(username);
      await _user?.reload();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

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
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future updateUserProfile(
      String? currentAvatarUrl,
      File? newAvatarUrlMobile,
      Future<Uint8List> newAvatarUrlWebData,
      String? username,
      String? email) async {
    dynamic avatarUrl;
    String path = 'avatars/' + randomAlphaNumeric(30);

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref(path)
            .putFile(newAvatarUrlMobile!);
        avatarUrl = await firebase_storage.FirebaseStorage.instance
            .ref(path)
            .getDownloadURL();
      } on firebase_core.FirebaseException catch (e) {
        if (kDebugMode) {
          print(e.message);
        }
        return e.message;
      }
    } else {
      Uint8List newAvatarUrlWebList = await newAvatarUrlWebData;
      try {
        await firebase_storage.FirebaseStorage.instance.ref(path).putData(
            newAvatarUrlWebList, SettableMetadata(contentType: 'image/jpeg'));
        avatarUrl = await firebase_storage.FirebaseStorage.instance
            .ref(path)
            .getDownloadURL();
      } on firebase_core.FirebaseException catch (e) {
        if (kDebugMode) {
          print(e.message);
        }
        return e.message;
      }
    }

    try {
      if (kDebugMode) {
        print('Updating the user profile');
      }
      final _user = FirebaseAuth.instance.currentUser;

      if (newAvatarUrlMobile != null || newAvatarUrlWebData != null) {
        await _user?.updatePhotoURL(avatarUrl);
      }
      await _user?.updateDisplayName(username);
      await _user?.updateEmail(email!);
      await _user?.reload();

      print(currentAvatarUrl);

      try {
        List<String> split1 = currentAvatarUrl!.split("avatars%2F");
        List<String> split2 = split1[1].split("?alt=");
        await firebase_storage.FirebaseStorage.instanceFor()
            .ref()
            .child('avatars/' + split2[0])
            .delete();
      } on firebase_core.FirebaseException catch (e) {
        if (kDebugMode) {
          print(e.message);
        }
        return e.message;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e;
    }
  }
}
