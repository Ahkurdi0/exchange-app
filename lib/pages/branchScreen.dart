import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchScreen extends StatelessWidget {
  const BranchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('wallets').doc('cash').collection('fastpay').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              final document = data.docs[index];
              return ListTile(
                title: Text(document['name']),
                subtitle: Text(document['api']),
                trailing: Text(document['commission']),
              );
            },
          );
        },
      ),
    );
  }
}
