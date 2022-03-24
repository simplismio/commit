import 'emulator_service.dart';
import 'package:flutter/foundation.dart'
    show ChangeNotifier, TargetPlatform, defaultTargetPlatform, kDebugMode;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContractService extends ChangeNotifier {
  final String? key;
  final String? title;
  final String? userId;
  final List? commitments;

  ContractService({this.key, this.title, this.userId, this.commitments});

  List<ContractService> _contractsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ContractService(
          key: doc.id,
          title: doc['title'],
          userId: doc['user_id'],
          commitments: doc['commitments']);
    }).toList();
  }

  Stream<List<ContractService>> get contracts {
    if (kDebugMode) {
      print('Loading contracts');
      EmulatorService.setupAuthEmulator();
    }

    final _user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('contracts')
        .where("user_id", isEqualTo: _user?.uid)
        .snapshots()
        .map(_contractsFromSnapshot);
  }

  Future<void> addContract(_title) {
    final _user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('contracts')
        .add({'user_id': _user?.uid, 'title': _title, 'commitments': []}).then(
            (value) {
      if (kDebugMode) {
        print("Contract Added");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to add user: $error");
      }
    });
  }

  Future<void> editContract(_contractKey, _title) {
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractKey)
        .update({'title': _title})
        // ignore: avoid_print
        .then((value) => print("Contract updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to merge data: $error"));
  }

  Future<void> deleteContract(_contractKey) {
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractKey)
        .delete()
        // ignore: avoid_print
        .then((value) => print("Contract deleted"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> addCommitment(_contractKey, _commitment) {
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractKey)
        .update({
      'commitments': FieldValue.arrayUnion([
        {"commitment": _commitment},
      ])
    }) // <-- Add data
        .then((value) {
      if (kDebugMode) {
        print('New commitment added');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Add failed: $error');
      }
    });
  }

  Future<void> editCommitment(
      _contractKey, _commitmentArray, _commitmentKey, _commitment) {
    _commitmentArray[_commitmentKey]['commitment'] = _commitment;

    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractKey)
        .update({'commitments': _commitmentArray}).then((value) {
      if (kDebugMode) {
        print("Commitment updated");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to merge data: $error");
      }
    });
  }

  Future<void> deleteCommitment(
      _contractKey, _commitmentArray, _commitmentIndex) {
    _commitmentArray.removeAt(_commitmentIndex);

    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractKey)
        .update({'commitments': _commitmentArray}).then((value) {
      if (kDebugMode) {
        print("Commitment deleted");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to merge data: $error");
      }
    });
  }
}
