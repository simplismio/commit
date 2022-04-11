import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'email_service.dart';
//import 'notification_service.dart';

class ContractService extends ChangeNotifier {
  final String? key;
  final String? title;
  final String? ownerUserId;
  final List? participants;
  final List? commitments;

  ContractService(
      {this.key,
      this.title,
      this.ownerUserId,
      this.participants,
      this.commitments});

  List<ContractService> _contractsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ContractService(
          key: doc.id,
          title: doc['title'],
          ownerUserId: doc['owner_user_id'],
          participants: doc['participants'],
          commitments: doc['commitments']);
    }).toList();
  }

  Stream<List<ContractService>> get contracts {
    if (kDebugMode) {
      print('Loading contracts');
    }
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('contracts')
        .where('participants', arrayContains: user?.uid)
        .snapshots()
        .map(_contractsFromSnapshot);
  }

  Future addContract(contractTitle, participantUids, participantEmails,
      participantUsernames, emailTitle, body) async {
    final user = FirebaseAuth.instance.currentUser;

    participantUids.add(user?.uid);

    return FirebaseFirestore.instance.collection('contracts').add({
      'owner_user_id': user?.uid,
      'title': contractTitle,
      'participants': participantUids,
      'commitments': []
    }).then((value) async {
      if (kDebugMode) {
        print("Contract added");
      }

      for (var i = 0; i < participantEmails.length; i++) {
        print(participantEmails[i]);
        await EmailService().sendEmail(
          'addContractEmail',
          participantEmails[i],
          participantUsernames[i],
          emailTitle,
          body,
        );
      }
      return null;
    }).catchError((error) {
      if (kDebugMode) {
        print("Error: $error");
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
      // await NotificationService().sendNotification(
      //     title, body, contractKey, 'editContractNotification');
      // return null;
    }).catchError((error) {
      if (kDebugMode) {
        print('Error: $error');
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
      // await NotificationService().sendNotification(
      //     title, body, contractKey, 'deleteContractNotification');
      // return null;
    }).catchError((error) {
      if (kDebugMode) {
        print('Error: $error');
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
      // await NotificationService().sendNotification(
      //     title, body, contractKey, 'addCommitmentNotification');
      // return null;
    }).catchError((error) {
      if (kDebugMode) {
        print('Error: $error');
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
      // await NotificationService().sendNotification(
      //     title, body, contractKey, 'editCommitmentNotification');
      // return null;
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
      // await NotificationService().sendNotification(
      //     title, body, contractKey, 'deleteCommitmentNotification');
      // return null;
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to merge data: $error");
      }
      return error;
    });
  }
}
