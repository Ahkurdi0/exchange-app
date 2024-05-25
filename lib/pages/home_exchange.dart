import 'package:exchnage_app/pages/login.dart';
import 'package:exchnage_app/widgets/add_transaction_form.dart';
import 'package:exchnage_app/widgets/hero_card.dart';
import 'package:exchnage_app/widgets/transactions_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors

// ignore_for_file: prefer_const_literals_to_create_immutables
class HomePageExchange extends StatefulWidget {
  const HomePageExchange({super.key});

  @override
  State<HomePageExchange> createState() => _HomePageExchangeState();
}

class _HomePageExchangeState extends State<HomePageExchange> {
  var isLogoutLoading = false;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  _dialoBuildder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: AddTransactionForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        //   floatingActionButton: FloatingActionButton(
        //     backgroundColor: Color.fromARGB(255, 0, 38, 255),
        //     onPressed: () {
        //       _dialoBuildder(context);
        //     },
        //     child: Icon(
        //       Icons.add,
        //       color: Colors.white,
        //     ),
        //   ),
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 20, 0),
          child: Column(
            children: [
              // TransactionsCard(),
              AddTransactionForm(),
            ],
          ),
        ),
      ),
    ));
  }
}
