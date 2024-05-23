import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exchnage_app/widgets/icons_list.dart';
import 'package:exchnage_app/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          RecentTransactionList()
        ],
      ),
    );
  }
}

class RecentTransactionList extends StatelessWidget {
  RecentTransactionList({
    super.key,
  });

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('transactions')
            .orderBy('timestamp', descending: true).limit(10)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No History Exchnage Found"));
          }
          var data = snapshot.data!.docs;

          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var cardData = data[index];
                return TransactionCard(
                  data: cardData ,
                );
              });
        });
  }
}
