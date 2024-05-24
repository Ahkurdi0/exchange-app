import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exchnage_app/models/BranchModel.dart';
import 'package:exchnage_app/models/ExchangeRateModel.dart';
import 'package:exchnage_app/models/TransactionModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Db {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  var currentUser = FirebaseAuth.instance.currentUser;

  Future<void> addUser(Map<String, dynamic> data, BuildContext context) async {
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
      await users.doc(currentUser?.uid).set(data);
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
    final CollectionReference branches = firestore.collection('branches');
    final QuerySnapshot snapshot = await branches.get();
    return snapshot.docs.map((doc) => BranchModel.fromSnap(doc)).toList();
  }

  Future<void> addBranch(BranchModel branch) async {
    final CollectionReference branches = firestore.collection('branches');
    await branches.doc(branch.uId).set(branch.toMap());
  }

// add new exchange rate
  void addExchangeRate(ExchangeRate exchangeRate) async {
    await firestore
        .collection('exchangeRates')
        .doc(exchangeRate.uId)
        .set(exchangeRate.toMap());
  }

  Future<List<ExchangeRate>> getExchangeRates() async {
    final CollectionReference exchangeRates =
        firestore.collection('exchangeRates');
    final QuerySnapshot snapshot = await exchangeRates.get();
    return snapshot.docs.map((doc) => ExchangeRate.fromSnap(doc)).toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final CollectionReference users = firestore.collection('users');
    await users
        .doc(currentUser?.uid)
        .collection('transactions')
        .doc(transaction.uId)
        .set(transaction.toMap());
  }

  Future<List<TransactionModel>> getUserTransactionsForMonth(
      DateTime month, String status,
      [BranchModel? category]) async {
    final CollectionReference users = firestore.collection('users');
    Query query = users
        .doc(currentUser!.uid)
        .collection('transactions')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true);

    if (category != null && category != 'All') {
      query = query
          .where('fromBranch', isEqualTo: category)
          .where('toBranch', isEqualTo: category);
    }

    final QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) => TransactionModel.fromSnap(doc)).toList();
  }
}
