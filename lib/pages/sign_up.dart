import 'dart:ffi';
import 'dart:ui';

// import 'package:exchnage_app/pages/dashbord.dart';
import 'package:exchnage_app/pages/login.dart';
import 'package:exchnage_app/services/auth_service.dart';
import 'package:exchnage_app/utils/appvalidator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDebit': 0,
      };

      // bool success = await authService.createUser(data, context);
      await authService.createUser(data, context);

      setState(() {
        isLoader = false;
      });

      // if (success) {

      // }
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
                  'Create new Account',
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
                    controller: _firstNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        _buildInputDecoration('First Name', Icons.person),
                    validator: appValidator.validateUserName),
                SizedBox(height: 16),
                TextFormField(
                    controller: _lastNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        _buildInputDecoration('Last Name', Icons.person),
                    validator: appValidator.validateUserName),
                SizedBox(height: 16),
                TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Email', Icons.email),
                    validator: appValidator.validateEmail),
                SizedBox(height: 16),
                TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        _buildInputDecoration('Phone Number', Icons.phone),
                    validator: appValidator.validatePhoneNumber),
                SizedBox(height: 16),
                TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Password', Icons.lock),
                    validator: appValidator.validatePassword),
                SizedBox(height: 20),
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
                            'Create Account',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0B59D7),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Login ',
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
      labelText: labelText,
      labelStyle: TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
      suffixIcon: Icon(suffixIcon,
          color: Color(0xFF0B59D7)), // Icon color remains the same
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:
            BorderSide.none, // Remove the border color by setting it to none
      ),
    );
  }
}
