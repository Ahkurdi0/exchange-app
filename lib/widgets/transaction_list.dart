import 'package:exchnage_app/models/TransactionModel.dart';
import 'package:exchnage_app/services/db.dart';
import 'package:exchnage_app/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList(
      {super.key,
      required this.category,
      required this.type,
      required this.monthYear});

  final String category;
  final String type;
  final String monthYear;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final db = Db();

  DateTime parseMonthYear(String monthYear) {
    var parts = monthYear.split(' ');
    var month = DateFormat.MMMM().parse(parts[0]).month;
    var year = int.parse(parts[1]);
    return DateTime(year, month);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: db.getUserTransactionsForMonth(
          parseMonthYear(widget.monthYear), widget.type),
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionModel>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No History Exchange Found"));
        }
        List<TransactionModel> transactions = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            var transaction = transactions[index];
            return TransactionCard(
              transaction: transaction,
            );
          },
        );
      },
    );
  }
}
