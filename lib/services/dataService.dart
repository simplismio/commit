// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  CollectionReference commitments =
      FirebaseFirestore.instance.collection('commitments');

  final Stream<QuerySnapshot> commitmentStream = FirebaseFirestore.instance
      .collection('commitments')
      .snapshots(includeMetadataChanges: true);

  Future<void> addCommitment(_description) {
    return commitments
        .add({'description': _description})
        .then((value) => print("Commitment Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> editCommitment(_key, _description) {
    return commitments
        .doc(_key)
        .update({'description': _description})
        .then((value) => print("Commitment updated"))
        .catchError((error) => print("Failed to merge data: $error"));
  }

  Future<void> deleteCommitment(_key) {
    return commitments
        .doc(_key)
        .delete()
        .then((value) => print("Commitment deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
