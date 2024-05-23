import 'package:flutter/material.dart';

class Commission extends StatefulWidget {
  const Commission({super.key});

  @override
  State<Commission> createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 204, 204, 204).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ], color: const Color.fromARGB(255, 180, 180, 180).withOpacity(0.1)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10,),
          Row(
            children: [
              Text('Fees'),
              Spacer(),
              Text('Fees'),
            ],
          ),

          
          ],
        ),
      ),
    );
  }
}
