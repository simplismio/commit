import 'package:commit/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommitmentService extends ChangeNotifier {
  final String? key;
  final String? description;
  final String? userId;
  static String? firebaseUid;

  CommitmentService({
    this.key,
    this.description,
    this.userId,
  });

  final CollectionReference _commitments =
      FirebaseFirestore.instance.collection('commitments');

  List<CommitmentService> _commitmentsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CommitmentService(
        key: doc.id,
        description: doc['description'],
        userId: doc['user_id'],
      );
    }).toList();
  }

  Stream<List<CommitmentService>> get commitments {
    // final FirebaseAuth _auth = FirebaseAuth.instance;

    final getUser = FirebaseAuth.instance.currentUser;
    print(getUser);
    firebaseUid = getUser?.uid;

    print('In stream ${firebaseUid}');
    return FirebaseFirestore.instance
        .collection('commitments')
        .where("user_id", isEqualTo: firebaseUid)
        .snapshots()
        .map(_commitmentsFromSnapshot);
  }

  Future<void> addCommitment(_userId, _description) {
    return _commitments
        .add({'user_id': _userId, 'description': _description})
        .then((value) => print("Commitment Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> editCommitment(_key, _description) {
    return _commitments
        .doc(_key)
        .update({'description': _description})
        .then((value) => print("Commitment updated"))
        .catchError((error) => print("Failed to merge data: $error"));
  }

  Future<void> deleteCommitment(_key) {
    return _commitments
        .doc(_key)
        .delete()
        .then((value) => print("Commitment deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
