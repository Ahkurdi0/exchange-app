import 'package:cloud_firestore/cloud_firestore.dart';
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
          return AlertDialog(
            title: Text('Error'),
            content: Text('No authenticated user found.'),
          );
        },
      );
      return;
    }

    try {
      await users.doc(currentUser.uid).set(data);
      print('User Added');
    } catch (e) {
      print('Failed to add user: $e');
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
}
