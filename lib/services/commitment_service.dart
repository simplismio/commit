import 'package:commit/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommitmentService extends ChangeNotifier {
  final CollectionReference _commitments =
      FirebaseFirestore.instance.collection('commitments');

  final Query<Map<String, dynamic>> _commitmentsByLoggedInUser =
      FirebaseFirestore.instance
          .collection('commitments')
          .where('user_id', isEqualTo: user.uid);

  final String? key;
  final String? description;

  CommitmentService({
    this.key,
    this.description,
  });

  List<CommitmentService> _commitmentsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CommitmentService(
        key: doc.id,
        description: doc['description'],
      );
    }).toList();
  }

  Stream<List<CommitmentService>> get commitments {
    return _commitmentsByLoggedInUser.snapshots().map(_commitmentsFromSnapshot);
  }

  Future<void> addCommitment(_user_id, _description) {
    return _commitments
        .add({'user_id': _user_id, 'description': _description})
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
