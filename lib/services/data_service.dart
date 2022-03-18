import 'package:flutter/foundation.dart' show kDebugMode, ChangeNotifier;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService extends ChangeNotifier {
  final String? key;
  final String? description;
  final String? userId;
  final List? commitments;

  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 3001);
  // await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  DataService({this.key, this.description, this.userId, this.commitments});

  List<DataService> _contractsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DataService(
          key: doc.id,
          description: doc['description'],
          userId: doc['user_id'],
          commitments: doc['commitments']);
    }).toList();
  }

  Stream<List<DataService>> get contracts {
    if (kDebugMode) {
      print('Loading contracts');
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    }

    final _user = FirebaseAuth.instance.currentUser;

    // FirebaseFirestore.instance
    //     .collection('contracts')
    //     .doc('eN0BqtJIzUKIolOocC7p') // <-- Document ID
    //     .update({
    //       'commitments': FieldValue.arrayUnion(
    //         [
    //           {"description": 'Co2'}
    //         ],
    //       )
    //     }) // <-- Add data
    //     .then((_) => print('New commitment added'))
    //     .catchError((error) => print('Add failed: $error'));

    return FirebaseFirestore.instance
        .collection('contracts')
        .where("user_id", isEqualTo: _user?.uid)
        .snapshots()
        .map(_contractsFromSnapshot);
  }

  Future<void> addContract(_userId, _description) {
    if (kDebugMode) {
      FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    }

    return FirebaseFirestore.instance
        .collection('contracts')
        .add({'user_id': _userId, 'description': _description})
        // ignore: avoid_print
        .then((value) => print("Contract Added"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> editContract(_key, _description) {
    if (kDebugMode) {
      FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    }

    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_key)
        .update({'description': _description})
        // ignore: avoid_print
        .then((value) => print("Commitment updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to merge data: $error"));
  }

  Future<void> deleteContract(_key) {
    if (kDebugMode) {
      FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    }
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_key)
        .delete()
        // ignore: avoid_print
        .then((value) => print("Commitment deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> addCommitment(_contractId, _userId, _description) {
    if (kDebugMode) {
      FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    }

    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractId) // <-- Document ID
        .update({
      'commitments': FieldValue.arrayUnion(
        [
          {"description": _description, "user_id": _userId}
        ],
      )
    }) // <-- Add data
        .then((_) {
      if (kDebugMode) {
        print('New commitment added');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Add failed: $error');
      }
    });
  }

  Future<void> editCommitment(_key, _description) {
    if (kDebugMode) {
      FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    }
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_key)
        .update({'description': _description}).then((value) {
      if (kDebugMode) {
        print("Commitment updated");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to merge data: $error");
      }
    });
  }

  Future<void> deleteCommitment(_key) {
    if (kDebugMode) {
      FirebaseFirestore.instance.settings = const Settings(
          host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    }
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_key)
        .delete()
        // ignore: avoid_print
        .then((value) => print("Commitment deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
