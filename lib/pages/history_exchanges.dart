import 'package:exchnage_app/widgets/category_list.dart';
import 'package:exchnage_app/widgets/tab_bar_view.dart';
import 'package:exchnage_app/widgets/time_line_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryTranaction extends StatefulWidget {
  const HistoryTranaction({Key? key}) : super(key: key);

  @override
  _HistoryTransactionState createState() => _HistoryTransactionState();
}

class _HistoryTransactionState extends State<HistoryTranaction> {
  String category = 'All';
  String monthyear = '';

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    monthyear = DateFormat('MMM y').format(now); // Format current date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchanges'),
      ),
      body: Column(
        children: [
          TimeLineMonth(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  monthyear = value; // Update monthyear based on user selection
                });
              }
            },
          ),
          CategoryList(
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  category = value; // Update category based on user selection
                });
              }
            },
          ),
          TypeTabBar(category: category, monthyear: monthyear)
        ],
      ),
    );
  }
}
