import 'dart:async';
import 'package:flutter/material.dart';
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
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
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
    Color color = isActive ? Colors.green : Colors.black;
    String status = isActive ? "Active" : "Inactive";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromARGB(188, 106, 206, 252),
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 40),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Operator - $formattedDate",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        status,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.5)),
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10), // Spacing between container and text
        Text(
          "Working Hours: 9:00 AM to 12:00 AM",
          style: TextStyle(color: Colors.blueGrey, fontSize: 14),
        ),
      ],
    );
  }
}
