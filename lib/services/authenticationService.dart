// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//import 'package:crypto/crypto.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Future signUp({String? email, String? password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn(String? email, String? password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future resetPassword(String? email) async {
    print(email);

    try {
      await _auth.sendPasswordResetEmail(email: email!);
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

  // Future<UserCredential?> signInWithFacebook() async {
  //   final LoginResult result = await FacebookAuth.instance.login();
  //   if (result.status == LoginStatus.success) {
  //     print('FACEBOOK success');
  //     final OAuthCredential credential =
  //         FacebookAuthProvider.credential(result.accessToken!.token);
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   }
  //   return null;
  // }

  // String generateNonce([int length = 32]) {
  //   final charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // Future<UserCredential> signInWithApple() async {
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);

  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );

  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );

  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }

  Future signOut() async {
    await _auth.signOut();

    if (kDebugMode) {
      print('signout');
    }
  }
}
