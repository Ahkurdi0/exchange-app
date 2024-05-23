import 'package:exchnage_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
    var isLogoutLoading = false;

  @override
  Widget build(BuildContext context) {
      logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
    setState(() {
      isLogoutLoading = false;
    });
  }
    return Scaffold(

      body: Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('Setting Screen'),
          // SizedBox(height: 20,),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                logOut();
              },
              child: Text('Logout'),
            ),
          ),
        ],
       ),
      ),
    );
  }
}