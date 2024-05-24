import 'package:exchnage_app/models/BranchModel.dart';
import 'package:exchnage_app/models/ExchangeRateModel.dart';
import 'package:exchnage_app/services/db.dart';
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
  BranchModel? categoryOne;
  BranchModel? categoryTwo;

  Map<String, dynamic> selectedCategory = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var isLoader = false;

  var sendEditControl = TextEditingController();
  var reciveEditControl = TextEditingController();
  var reciverInfoEditControl = TextEditingController();
  double commission = 0;
  double ownerCommission = 0.01;
  var uid = const Uuid();
  final db = Db();
  List<BranchModel> branches = [];
  List<ExchangeRate> rates = [];

  void updateAmounts() async {
    final amount = double.tryParse(sendEditControl.text) ?? 0;
    commission = amount *
        (ownerCommission +
            (categoryOne?.commissionAmount ?? 0) +
            (categoryTwo?.commissionAmount ?? 0));

    // check if the currency of cat one and cat two were different
    double exchangeRate = 1.0;
    if (categoryOne?.currency != categoryTwo?.currency) {
      ExchangeRate rate = rates.firstWhere(
        (rate) =>
            rate.fromCurrency == categoryOne?.currency &&
            rate.toCurrency == categoryTwo?.currency,
        orElse: () => const ExchangeRate(rate: 1.0),
      );
      exchangeRate = rate.rate ?? 1.0;
    }
    reciveEditControl.text = ((amount * exchangeRate)).toString();
  }

//  submit the data
  Future<void> _submitForm() async {
    double sendAmount = double.tryParse(sendEditControl.text) ?? 0;
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
          title: const Text('Invalid Input'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          title: const Text('User not found'),
          content: const Text('No such user exists in the database.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoader = false;
                });
              },
              child: const Text('OK'),
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
      isLoader = false;
    });
  }

  @override
  void initState() {
    super.initState();

    db.getBranches().then((value) => setState(() => branches = value));
    db.getExchangeRates().then((value) => rates = value);
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
              const Operator(),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('You Send', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 6),
                  CategoryDropDown(
                      branches: branches
                          .where((branch) =>
                              categoryTwo == null ||
                              branch.uId != categoryTwo!.uId)
                          .toList(),
                      branch: categoryOne,
                      onChanged: (BranchModel? value) {
                        setState(() {
                          categoryOne = value;
                          updateAmounts();
                        });
                      }),
                  const SizedBox(height: 16),
                  const Text('Send the amount', style: TextStyle(fontSize: 22)),
                  TextFormField(
                    controller: sendEditControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      suffix: Text(categoryOne?.currency ?? 'IQD'),
                    ),
                    onChanged: (value) {
                      setState(() {
                        updateAmounts();
                      });
                    },
                  ),
                  const Text('Minimum amount: 30,000 Maximum : 3,000,000',
                      style: TextStyle(fontSize: 14, color: Colors.red)),
                  const SizedBox(height: 16),
                  const Text('You Get', style: TextStyle(fontSize: 22)),
                  CategoryDropDown(
                    branches: branches
                        .where((branch) =>
                            categoryOne == null ||
                            branch.uId != categoryOne!.uId)
                        .toList(),
                    branch: categoryTwo,
                    onChanged: (BranchModel? value) {
                      setState(() {
                        categoryTwo = value;
                        updateAmounts();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Get the amount', style: TextStyle(fontSize: 22)),
                  TextFormField(
                    controller: reciveEditControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      suffix: Text(categoryTwo?.currency ?? 'IQD'),
                    ),
                    onChanged: (value) {
                      setState(() {
                        updateAmounts();
                      });
                    },
                  ),
                  Text('Commission: ${commission.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14, color: Colors.red)),
                  const SizedBox(height: 16),
                  // Text('Your ${categoryTwo?.branchName ?? ''} number',
                  //     style: const TextStyle(fontSize: 22)),
                  // TextFormField(
                  //   controller: reciverInfoEditControl,
                  //   keyboardType: TextInputType.number,
                  //   decoration: InputDecoration(
                  //       hintText:
                  //           'Your ${categoryTwo?.branchName ?? ''} number'),
                  // ),
                  // const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isLoader) {
                          _submitForm();
                        }

                        // ExchangeRate exchangeRate = ExchangeRate(
                        //   uId: uid.v4(),
                        //   fromCurrency: "USDT",
                        //   rate: 0.0055,
                        //   toCurrency: "YEN",
                        // );
                        // db.addExchangeRate(exchangeRate);

                        // BranchModel branchModel = BranchModel(
                        //     api: "https:v1/api",
                        //     branchName: "Zain Cash",
                        //     commissionAmount: 0.15,
                        //     hasApi: true,
                        //     iconUrl:
                        //         "https://firebasestorage.googleapis.com/v0/b/exchnage-wallet-kurd.appspot.com/o/icons%2Fzaincash.png?alt=media&token=b721565b-8141-4b37-b221-1e50c530261a",
                        //     phoneNumber: "",
                        //     qrCodeUrl: "",
                        //     qrCodeValue: "",
                        //     uId: uid.v4());

                        // Db().addBranch(branchModel);
                      },
                      child: isLoader
                          ? const CircularProgressIndicator()
                          : const Text('Exchange'),
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
