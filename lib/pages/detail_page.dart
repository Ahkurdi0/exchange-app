import 'package:exchnage_app/models/TransactionModel.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final TransactionModel transaction;

  const DetailsPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('transaction'),
            Text(
              "From Branch: ${transaction.fromBranch?.branchName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Category Two: ${transaction.toBranch?.branchName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Category Two: ${transaction.user?.lastName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text("Other transaction fields can go here"),
          ],
        ),
      ),
    );
  }
}
