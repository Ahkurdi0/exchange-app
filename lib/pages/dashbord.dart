import 'package:exchnage_app/pages/branchScreen.dart';
import 'package:exchnage_app/pages/history_exchanges.dart';
import 'package:exchnage_app/pages/home_exchange.dart';
import 'package:exchnage_app/pages/login.dart';
import 'package:exchnage_app/pages/setting.dart';
import 'package:exchnage_app/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  var PageViewList = [HomePageExchange(), HistoryTranaction() , BranchScreen(), SettingScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      body: PageViewList[currentIndex],
    );
  }
}
