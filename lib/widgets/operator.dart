import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Use this package for date and time formatting

class Operator extends StatefulWidget {
  const Operator({super.key});

  @override
  _OperatorState createState() => _OperatorState();
}

class _OperatorState extends State<Operator> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Update the state every minute to ensure it reflects any change in active/inactive status
    timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd h:mm a').format(now);

    final startTime = DateTime(now.year, now.month, now.day, 9, 0); // 9:00 AM
    final endTime =
        DateTime(now.year, now.month, now.day + 1, 0, 0); // 12:00 AM next day

    bool isActive = now.isAfter(startTime) && now.isBefore(endTime);
    Color color =
        isActive ? const Color.fromARGB(255, 0, 255, 8) : Colors.black;
    String status = isActive ? "Active" : "Inactive";

    var padding = Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Working Time',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.5)),
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "9:00 AM to 12:00 AM",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Image.asset(
                'assets/operator.png',
                width: 80,
                height: 80,
                color: Colors.blue.shade900,
              ),
            ],
          )
        ],
      ),
    );
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF0B59D7).withOpacity(0.9),
        borderRadius: BorderRadius.circular(10), // Rounded rectangle border
      ),
      child: padding,
    );
  }
}
