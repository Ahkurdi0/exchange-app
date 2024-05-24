import 'package:exchnage_app/models/TransactionModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Material(
        color: const Color.fromARGB(
            255, 198, 235, 255), // Background color of the whole card
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            // Define the action when the card is clicked
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailsPage(
            //         transaction: transaction), // Navigate to the details page
            //   ),
            // );
          },
          borderRadius: BorderRadius.circular(20),
          highlightColor:
              Colors.grey.withOpacity(0.2), // Highlight color when pressed
          splashColor: Colors.grey.withOpacity(0.1), // Splash color
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.09),
                  blurRadius: 10.0,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ListTile(
              minVerticalPadding: 10,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(
                      transaction.fromBranch?.iconUrl ?? '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    Icon(
                      FontAwesomeIcons.exchange,
                      color: Colors.grey.withOpacity(0.2),
                      size: 20,
                    ),
                    Image.network(
                      transaction.toBranch?.iconUrl ?? '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              title: Row(
                children: [
                  Text(transaction.fromBranch?.branchName ?? ''),
                  const Text(' to '),
                  Text(transaction.toBranch?.branchName ?? ''),
                  const Spacer(),
                  Text(
                    transaction.receivingAmount.toString(),
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        transaction.createdAt?.toIso8601String() ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        transaction.toPhone ?? '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 47, 255),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
