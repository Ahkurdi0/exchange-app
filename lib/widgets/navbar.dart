import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.1),
          //   spreadRadius: 0,
          //   blurRadius: 0,
          //   offset: Offset(0, -1), // Shadow position
          // ),
        ],
      ),
      child: SalomonBottomBar(
        currentIndex: widget.selectedIndex,
        onTap: (index) => widget.onDestinationSelected(index),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        unselectedItemColor: Colors.grey[600],
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.swap_horiz),
            title: Text("Exchange"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.timeline),
            title: Text("History"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.location_on),
            title: Text("Branches"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.tune),
            title: Text("Settings"),
            selectedColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
