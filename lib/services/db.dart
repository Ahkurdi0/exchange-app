import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exchnage_app/models/BranchModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Db {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(Map<String, dynamic> data, BuildContext context) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('No user logged in');
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('No authenticated user found.'),
          );
        },
      );
      return;
    }

    try {
      await users.doc(currentUser.uid).set(data);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign Up Failed'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<List<BranchModel>> getBranches() async {
    final CollectionReference branches =
        FirebaseFirestore.instance.collection('branches');
    final QuerySnapshot snapshot = await branches.get();
    return snapshot.docs.map((doc) => BranchModel.fromSnap(doc)).toList();
  }

  Future<void> addBranch(BranchModel branch) async {
    final CollectionReference branches =
        FirebaseFirestore.instance.collection('branches');
    await branches.doc(branch.uId).set(branch.toMap());
  }
}
