import 'package:exchnage_app/models/TransactionModel.dart';
import 'package:exchnage_app/services/db.dart';
import 'package:exchnage_app/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
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
  final db = Db();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: db
          .getUserTransactionsForMonth(DateTime.now(), 'completed')
          .asStream(),
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionModel>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Recent Transactions Found"));
        }
        var data = snapshot.data!;

        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var transaction = data[index];
              return TransactionCard(
                transaction: transaction,
              );
            });
      },
    );
  }
}
