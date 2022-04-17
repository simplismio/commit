import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {}

class NotificationModel with ChangeNotifier {
  final String? key;
  final String? title;
  final String? body;

  NotificationModel({this.key, this.title, this.body});

  static String? notificationPermission;

  List<NotificationModel> _notificationsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return NotificationModel(
        key: doc.id,
        title: doc['title'],
        body: doc['body'],
      );
    }).toList();
  }

  Stream<List<NotificationModel>> get notifications {
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

  initialize() async {
    // NotificationSettings settings =
    //     await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    // if (kDebugMode) {
    //   print('User granted permission: ${settings.authorizationStatus}');
    // }

    //notificationPermission = settings.authorizationStatus.toString();
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (kDebugMode) {
          print('Push notification received: $message');
        }
      },
    );
    if (kDebugMode) {
      FirebaseMessaging.instance.getToken().then((value) {
        if (kDebugMode) {
          print('Token: $value');
        }
      });
    }
  }

  Future sendPushNotification(title, body, topic, function) async {
    final user = FirebaseAuth.instance.currentUser;

    // Step 1: save the notification in Firestore
    await FirebaseFirestore.instance.collection('notifications').add({
      'user_id': user?.uid,
      'title': title,
      'body': body,
      'read': false
    }).then((value) async {
      if (kDebugMode) {
        print("Notification added");
      }
      // Step 2: Subscribe to the topic
      await subscribeToTopic(topic);

      // Step 3: send the push notification
      FirebaseFunctions.instanceFor()
          .httpsCallable(function,
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 30)))
          .call({'title': title, 'body': body, 'topic': topic});
      return null;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add notification: $error");
      }
      return error;
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

  Future subscribeToTopic(topic) async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      if (kDebugMode) {
        print("Subscribed to topic: $topic");
      }
      FirebaseMessaging.instance.subscribeToTopic(topic);
    }

    if (kIsWeb) {
      // subscribe to push notification for web
      String? token = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BAG5adkrh-YOeQUTWaibQbfhH8MTckignRFvm5cyZohcRL-p04RymWoUJguPx2bkOsmcz654FutHq_GHilz4q8g",
      );

      FirebaseFunctions.instanceFor()
          .httpsCallable('subscribeTokenToTopicWeb',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 30)))
          .call({'token': token, 'topic': topic});
    }
  }
}
