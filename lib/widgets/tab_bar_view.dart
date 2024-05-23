import 'package:exchnage_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

class TypeTabBar extends StatelessWidget {
  const TypeTabBar(
      {super.key, required this.category, required this.monthyear});
  final String category;
  final String monthyear;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(
              text: 'Pendding',
            ),
            Tab(
              text: 'Completed',
            ),
          ]),
          Expanded(
            child: TabBarView(children: [
              TranectionList(
                  category: category, type: "pending", monthYear: monthyear),
              TranectionList(
                  category: category, type: "completed", monthYear: monthyear),
            ]),
          )
        ],
      ),
    ));
  }
}
