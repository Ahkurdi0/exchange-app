import 'package:exchnage_app/pages/dashbord.dart';
import 'package:exchnage_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
   AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
           return LoginScreen();
          
        }
         return Dashboard();

        
       
      },
    );
  }
}
