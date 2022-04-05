import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';

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

class NotificationService extends ChangeNotifier {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final String? key;
  final String? title;
  final String? body;

  NotificationService({this.key, this.title, this.body});

  List<NotificationService> _notificationsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return NotificationService(
        key: doc.id,
        title: doc['title'],
        body: doc['body'],
      );
    }).toList();
  }

  Stream<List<NotificationService>> get notifications {
    if (kDebugMode) {
      print('Loading notifications');
    }
    final _user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('notifications')
        .where("user_id", isEqualTo: _user?.uid)
        .where("read", isEqualTo: false)
        .snapshots()
        .map(_notificationsFromSnapshot);
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
        if (kDebugMode) {
          print('Push notification received: $message');
        }
      },
    );
    if (kDebugMode) {
      _firebaseMessaging.getToken().then((value) {
        if (kDebugMode) {
          print('Token: $value');
        }
      });
    }
    String? token = await _firebaseMessaging.getToken(
      vapidKey:
          "BAG5adkrh-YOeQUTWaibQbfhH8MTckignRFvm5cyZohcRL-p04RymWoUJguPx2bkOsmcz654FutHq_GHilz4q8g",
    );
  }

  Future sendNotification(title, body, topic, function) async {
    final _user = FirebaseAuth.instance.currentUser;

    // Step 1: save the notification in Firestore
    return FirebaseFirestore.instance.collection('notifications').add({
      'user_id': _user?.uid,
      'title': 'Test',
      'body': 'Body',
      'read': false
    }).then((value) {
      if (kDebugMode) {
        print("Notification added");
      }
      // Step 2: Subscribe to the topic
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android) {
        if (kDebugMode) {
          print("Subscribed to topic: $topic");
        }
        FirebaseMessaging.instance.subscribeToTopic(topic);
      }

      if (kIsWeb) {
        // subscribe to push notification for web
      }
      // Step 3: send the push notification
      FirebaseFunctions.instanceFor()
          .httpsCallable(function,
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 30)))
          .call({'title': '', 'body': 'test'});
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add notification: $error");
      }
      //return error;
    });
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
