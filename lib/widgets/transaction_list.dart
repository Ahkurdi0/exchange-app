import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exchnage_app/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TranectionList extends StatelessWidget {
  TranectionList(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});

  final userId = FirebaseAuth.instance.currentUser!.uid;

  final String category;
  final String type;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .where('monthyear', isEqualTo: monthYear)
        .where("type", isEqualTo: type);

    if (category != 'All') {
      query = query.where('categoryOne', isEqualTo: category);
    }

    return FutureBuilder<QuerySnapshot>(
        future: query.limit(150).get(),
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
                  data: cardData,
                );
              });
        });
  }
}
