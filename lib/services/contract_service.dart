import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/contract_model.dart';
import 'email_service.dart';
//import 'notification_service.dart';

class ContractService extends ChangeNotifier {
  List<ContractModel> _contractsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ContractModel(
          key: doc.id,
          title: doc['title'],
          ownerUserId: doc['owner_user_id'],
          participants: doc['participants'],
          commitments: doc['commitments']);
    }).toList();
  }

  Stream<List<ContractModel>> get contracts {
    if (kDebugMode) {
      print('Loading contracts');
    }
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return FirebaseFirestore.instance
          .collection('contracts')
          .where('participants', arrayContainsAny: [user.uid, user.email])
          .snapshots()
          .map(_contractsFromSnapshot);
    } else {
      return FirebaseFirestore.instance
          .collection('contracts')
          .where('participants', isEqualTo: user?.uid)
          .snapshots()
          .map(_contractsFromSnapshot);
    }
  }

  checkForEmailAsParticipant(contract) {
    final user = FirebaseAuth.instance.currentUser;
    List newParticipants = [];

    if (contract.participants.contains(user?.email)) {
      contract.participants.forEach((item) {
        if (item == user?.email) {
          newParticipants.add(user?.uid);
        } else {
          newParticipants.add(item);
        }
      });
      if (newParticipants.isNotEmpty) {
        return FirebaseFirestore.instance
            .collection('contracts')
            .doc(contract.key)
            .update({'participants': newParticipants}).then((value) {
          if (kDebugMode) {
            print('Contract updated');
          }
        }).catchError((error) {
          if (kDebugMode) {
            print('Error: $error');
          }
          return error;
        });
      }
    }
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
