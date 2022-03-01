// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataService extends ChangeNotifier {
  CollectionReference _commitments =
      FirebaseFirestore.instance.collection('commitments');

  final String? key;
  final String? description;

  DataService({
    this.key,
    this.description,
  });

  List<DataService> _listingsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DataService(
        key: doc.id,
        description: doc['description'],
      );
    }).toList();
  }

  Stream<List<DataService>> get commitments {
    return _commitments.snapshots().map(_listingsFromSnapshot);
  }

  Future<void> addCommitment(_description) {
    return _commitments
        .add({'description': _description})
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
