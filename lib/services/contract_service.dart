import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notification_service.dart';

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
    }
    final _user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('contracts')
        .where("user_id", isEqualTo: _user?.uid)
        .snapshots()
        .map(_contractsFromSnapshot);
  }

  Future addContract(_title) {
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
      return error;
    });
  }

  Future activateContract(contractKey) {
    final _user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(contractKey)
        .update({'state': 'active'}).then((value) {
      if (kDebugMode) {
        print('Contract updated');
      }
      NotificationService().sendNotification(
          'title', 'body', contractKey, 'activateContractNotification');
    }).catchError((error) {
      if (kDebugMode) {
        print('Add failed: $error');
      }
      return error;
    });
  }

  Future editContract(_contractKey, _title) {
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractKey)
        .update({'title': _title}).then((value) {
      if (kDebugMode) {
        print('Contract updated');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Add failed: $error');
      }
      return error;
    });
  }

  Future deleteContract(_contractKey) {
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(_contractKey)
        .delete()
        // ignore: avoid_print
        .then((value) {
      if (kDebugMode) {
        print('Contract deleted');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Add failed: $error');
      }
      return error;
    });
  }

  Future addCommitment(contractKey, commitment) {
    return FirebaseFirestore.instance
        .collection('contracts')
        .doc(contractKey)
        .update({
      'commitments': FieldValue.arrayUnion([
        {"commitment": commitment},
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
      return error;
    });
  }

  Future editCommitment(
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
      return error;
    });
  }

  Future deleteCommitment(_contractKey, _commitmentArray, _commitmentIndex) {
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
      return error;
    });
  }
}
