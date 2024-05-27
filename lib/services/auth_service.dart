import 'package:exchnage_app/models/UserModel.dart';
import 'package:exchnage_app/pages/dashbord.dart';
import 'package:exchnage_app/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  var db = Db();
  Future<bool> createUser(UserModel userModel, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email ?? '',
        password: userModel.password ?? '',
      );

      await db.addUser(userModel, context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ));
      return true;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again later.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('An unexpected error occurred. Please try again later.')),
      );
      return false;
    }
  }

  Future<bool> login(data, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ));
      return true;
    } on FirebaseAuthException catch (e) {
      final errorMessages = {
        'user-not-found': 'No user found for that email.',
        'wrong-password': 'Wrong password provided for that user.',
        'user-disabled': 'This user has been disabled.',
        'invalid-email': 'The email address is not valid.',
      };

      String message = errorMessages[e.code] ?? 'An error occurred. Please try again later.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An unexpected error occurred. Please try again later.')),
      );
      return false;
    }
  }
}
