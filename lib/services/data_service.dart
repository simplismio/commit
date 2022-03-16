import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService extends ChangeNotifier {
  static String? contractKeyforQuery;

  final String? key;
  final String? description;
  final String? userId;
  final List? commitments;
  static String? firebaseUid;

  DataService({this.key, this.description, this.userId, this.commitments});

  final CollectionReference _contracts =
      FirebaseFirestore.instance.collection('contracts');

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
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final getUser = _auth.currentUser;
    firebaseUid = getUser?.uid;

    if (kDebugMode) {
      print('Loading contracts');
    }
    // _contracts
    //     .doc('WIMJXZomRXNg8bTq4HZz') // <-- Document ID
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
        .where("user_id", isEqualTo: firebaseUid)
        .snapshots()
        .map(_contractsFromSnapshot);
  }

  Future<void> addContract(_userId, _description) {
    return _contracts
        .add({'user_id': _userId, 'description': _description})
        // ignore: avoid_print
        .then((value) => print("Contract Added"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> editContract(_key, _description) {
    return _contracts
        .doc(_key)
        .update({'description': _description})
        // ignore: avoid_print
        .then((value) => print("Commitment updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to merge data: $error"));
  }

  Future<void> deleteContract(_key) {
    return _contracts
        .doc(_key)
        .delete()
        // ignore: avoid_print
        .then((value) => print("Commitment deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> addCommitment(_contractId, _userId, _description) {
    return _contracts
        .doc(_contractId) // <-- Document ID
        .update({
          'commitments': FieldValue.arrayUnion(
            [
              {"description": _description, "user_id": _userId}
            ],
          )
        }) // <-- Add data
        .then((_) => print('New commitment added'))
        .catchError((error) => print('Add failed: $error'));
  }

  Future<void> editCommitment(_key, _description) {
    return _contracts
        .doc(_key)
        .update({'description': _description})
        // ignore: avoid_print
        .then((value) => print("Commitment updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to merge data: $error"));
  }

  Future<void> deleteCommitment(_key) {
    return _contracts
        .doc(_key)
        .delete()
        // ignore: avoid_print
        .then((value) => print("Commitment deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
