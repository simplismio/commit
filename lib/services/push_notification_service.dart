import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  final _user = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance.collection('notifications').add({
    'user_id': _user?.uid,
    'title': message.notification!.title!,
    'body': message.notification!.body!,
    'read': false
  }).then((value) {
    if (kDebugMode) {
      print("Notification added");
    }
  }).catchError((error) {
    if (kDebugMode) {
      print("Failed to add notification: $error");
    }
    //return error;
  });
}

class PushNotificationService extends ChangeNotifier {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final String? key;
  final String? title;

  PushNotificationService({this.key, this.title});

  List<PushNotificationService> _pushNotificationsFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PushNotificationService(
        key: doc.id,
        title: doc['title'],
      );
    }).toList();
  }

  Stream<List<PushNotificationService>> get notifications {
    if (kDebugMode) {
      print('Loading notifications');
    }
    final _user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('notifications')
        .where("user_id", isEqualTo: _user?.uid)
        .snapshots()
        .map(_pushNotificationsFromSnapshot);
  }

  setNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    final _user = FirebaseAuth.instance.currentUser;

    FirebaseMessaging.onMessage.listen(
      (message) async {
        await FirebaseFirestore.instance.collection('notifications').add({
          'user_id': _user?.uid,
          'title': message.notification!.title!,
          'body': message.notification!.body!,
          'read': false
        }).then((value) {
          if (kDebugMode) {
            print("Notification added");
          }
        }).catchError((error) {
          if (kDebugMode) {
            print("Failed to add notification: $error");
          }
          //return error;
        });
      },
    );
    if (kDebugMode) {
      _firebaseMessaging.getToken().then((value) {
        if (kDebugMode) {
          print('Token: $value');
        }
      });
    }
  }

  Future markNotificationAsRead(notificationKey) async {
    return FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationKey)
        .update({'read': true}).then((value) {
      if (kDebugMode) {
        print("Notification updated");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to merge data: $error");
      }
      return error;
    });
  }
}
