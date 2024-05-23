import 'package:exchnage_app/widgets/icons_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exchnage_app/widgets/category_dropdown.dart';
import 'package:exchnage_app/widgets/operator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  String categoryOne = 'AsiaPay';
  String categoryTwo = 'Fib';

  Map<String, dynamic> selectedCategory = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var isLoader = false;

  var sendEditControl = TextEditingController();
  var reciveEditControl = TextEditingController();
  var reciverInfoEditControl = TextEditingController();
  var commission = 0;
  var commissionType = 0.02;
  var uid = Uuid();

  @override
  void initState() {
    super.initState();
    sendEditControl.addListener(() {
      if (sendEditControl.text.isNotEmpty) {
        try {
          final amount = int.parse(sendEditControl.text);
          final amount2 = int.parse(sendEditControl.text);
          commission = (amount * commissionType)
              .toInt(); // Calculate 2% and convert to integer

          reciveEditControl.text = (amount2 - commission)
              .toString(); // Update 'reciveEditControl' without decimals
        } catch (e) {
          reciveEditControl.text = 'Error';
        }
      } else {
        reciveEditControl.text =
            ''; // Clear 'reciveEditControl' if 'sendEditControl' is empty
      }
    });
    updateCategory();
  }

  void updateCategory() {
    setState(() {
      selectedCategory = AppIcons().homeExchangeCategories.firstWhere(
            (cat) => cat['name'] == categoryOne,
            orElse: () => {
              'image': 'assets/images/default.png',
              'qrcode': 'assets/qr/default_qr.png'
            },
          );
    });
  }

  Future<void> _submitForm() async {
    int sendAmount = int.tryParse(sendEditControl.text) ?? 0;
    if (sendEditControl.text.isEmpty ||
        reciveEditControl.text.isEmpty ||
        reciverInfoEditControl.text.isEmpty ||
        sendAmount < 30000 ||
        sendAmount > 3000000) {
      String errorMessage = 'Please check and fill all the fields correctly.';
      if (sendAmount < 30000 || sendAmount > 3000000) {
        errorMessage = 'Amount must be between 30,000 and 3,000,000.';
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Input'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      Vibration.vibrate();
      return;
    }

    setState(() {
      isLoader = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("You are not logged in. Please log in and try again.")));
      setState(() {
        isLoader = false;
      });
      return;
    }

    int timestamp = DateTime.now().microsecondsSinceEpoch;
    var recive = int.parse(reciveEditControl.text);
    var reciverInfo = int.parse(reciverInfoEditControl.text);
    DateTime date = DateTime.now();
    var id = uid.v4();
    String monthyear = DateFormat('MMM y').format(date);

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('User not found'),
          content: Text('No such user exists in the database.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoader = false;
                });
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    int remainingAmount = userDoc.data()?['remainingAmount'] ?? 0;
    int totalDebit = userDoc.data()?['totalDebit'] ?? 0;
    int totalCredit = userDoc.data()?['totalCredit'] ?? 0;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      "remainingAmount": remainingAmount - sendAmount,
      "totalDebit": totalDebit + sendAmount,
      "totalCredit": totalCredit + recive,
      "updatedAt": timestamp
    });

    var data = {
      "id": id,
      "send": sendAmount,
      "recive": recive,
      "reciverInfo": reciverInfo,
      "categoryOne": categoryOne,
      "categoryTwo": categoryTwo,
      "timestamp": timestamp,
      "monthyear": monthyear,
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "remainingAmount": remainingAmount,
      "category": selectedCategory['name'],
      "type": 'pending',
      "commission": commission,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(id)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print("Error writing document: $e");
    }

    setState(() {
      sendEditControl.clear();
      reciveEditControl.clear();
      reciverInfoEditControl.clear();
      categoryOne = 'AsiaPay';
      categoryTwo = 'Fib';
      updateCategory();
      isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Operator(),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You Send', style: TextStyle(fontSize: 22)),
                  SizedBox(height: 6),
                  CategoryDropDown(
                    cattype: categoryOne,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          categoryOne = value;
                          updateCategory();
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Text('You Get', style: TextStyle(fontSize: 22)),
                  CategoryDropDown(
                    cattype: categoryTwo,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          categoryTwo = value;
                          updateCategory();
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Send the amount', style: TextStyle(fontSize: 22)),
                  TextFormField(
                    controller: sendEditControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Enter amount between 30,000 and 3,000,000'),
                  ),
                  Text('Minimum amount: 30,000 Maximum : 3,000,000',
                      style: TextStyle(fontSize: 14, color: Colors.red)),
                  SizedBox(height: 16),
                  Text('Get the amount', style: TextStyle(fontSize: 22)),
                  TextFormField(
                    controller: reciveEditControl,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 214, 214, 214),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  Text('Commission: $commission',
                      style: TextStyle(fontSize: 14, color: Colors.red)),
                  SizedBox(height: 16),
                  Text('Your $categoryTwo number',
                      style: TextStyle(fontSize: 22)),
                  TextFormField(
                    controller: reciverInfoEditControl,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(hintText: 'Your $categoryTwo number'),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isLoader) {
                          _submitForm();
                        }
                      },
                      child: isLoader
                          ? CircularProgressIndicator()
                          : Text('Exchange'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
