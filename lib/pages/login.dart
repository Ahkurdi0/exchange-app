import 'dart:ffi';
import 'dart:ui';
import 'package:exchnage_app/pages/dashbord.dart';
import 'package:exchnage_app/pages/forget_password.dart';
import 'package:exchnage_app/pages/sign_up.dart';
import 'package:exchnage_app/services/auth_service.dart';
import 'package:exchnage_app/utils/appvalidator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authService = AuthService();
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      bool success = await authService.login(data, context);

      setState(() {
        isLoader = false;
      });

      if (success) {
        // Navigate to the next page or show success message
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SomeNextPage()));
      }
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBF5FF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                SizedBox(height: 16),
                Text(
                  'Login Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color(0xFF0B59D7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Email', Icons.email),
                    validator: appValidator.validateEmail),
                SizedBox(height: 16),
                TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Pssword', Icons.lock),
                    validator: appValidator.validatePassword),
                SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordPage()));
                    }, child: Text('Forget Password?'))
                  ],
                ),
                SizedBox(height:10,),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      isLoader ? print("Loading") : _submitForm();
                    },
                    child: isLoader
                        ? Center(child: CircularProgressIndicator())
                        : Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0B59D7),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Color(0xFF0B59D7), fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText, IconData suffixIcon) {
    return InputDecoration(
      fillColor: Colors.white, // Set the fill color to white
      filled: true, // Enable the fillColor to take effect
      suffixIcon: Icon(suffixIcon, color: Color(0xFF0B59D7)),
      labelText: labelText,
      labelStyle: TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
      // Icon color remains the same
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:
            BorderSide.none, // Remove the border color by setting it to none
      ),
    );
  }
}
