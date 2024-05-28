import 'package:exchnage_app/models/BranchModel.dart';
import 'package:exchnage_app/models/ExchangeRateModel.dart';
import 'package:exchnage_app/models/TransactionModel.dart';
import 'package:exchnage_app/pages/review_page.dart';
import 'package:exchnage_app/services/db.dart';
import 'package:exchnage_app/utils/appvalidator.dart';
import 'package:exchnage_app/widgets/category_dropdown.dart';
import 'package:exchnage_app/widgets/operator.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
  var toPhoneController = TextEditingController();
  double commission = 0;
  double ownerCommission = 0.01;
  var uid = const Uuid();
  final db = Db();
  List<BranchModel> branches = [];
  List<ExchangeRate> rates = [];

  void updateAmounts() async {
    final amount = double.tryParse(sendEditControl.text) ?? 0;
    final commissionOne = categoryOne?.commissionAmount ?? 0;
    final commissionTwo = categoryTwo?.commissionAmount ?? 0;

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

    commission = (amount * exchangeRate) *
        (ownerCommission + commissionOne + commissionTwo);

    reciveEditControl.text = ((amount * exchangeRate) - commission).toString();
  }

//  submit the data
  void navigateToReviewPage() async {
    TransactionModel transaction = TransactionModel(
      uId: uid.v4(),
      status: 'pending',
      totalCommission: commission,
      fromBranch: categoryOne,
      toBranch: categoryTwo,
      sendingAmount: double.tryParse(sendEditControl.value.text),
      receivingAmount: double.tryParse(reciveEditControl.value.text),
      toPhone: toPhoneController.value.text,
      createdAt: DateTime.now(),
      // Add other fields as necessary
    );

    if (_formKey.currentState!.validate() &&
        transaction.totalCommission != null &&
        transaction.fromBranch != null &&
        transaction.toBranch != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewPage(transaction: transaction),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please fill all the fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
                  const Text('You Send',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B59D7))),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: sendEditControl,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Send Amount ', // This is the label
                      labelStyle: const TextStyle(
                          color: Colors.blue), // Style for the label
                      hintText: '0.0',
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Style for the hint
                      suffix: Text(categoryOne?.currency ?? 'IQD'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Rounded rectangle border
                        borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2), // Border color and width
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number between 30000 and 3000000';
                      }
                      final number = int.tryParse(value);
                      if (number == null ||
                          number < 30000 ||
                          number > 3000000) {
                        return 'Please enter a amount between 30000 and 3000000';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        updateAmounts();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 5, // This will be the thickness of your line
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B59D7).withOpacity(.9),
                      borderRadius: BorderRadius.circular(
                          8), // This will be the radius of your line
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('You Get',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B59D7))),
                  const SizedBox(
                    height: 10,
                  ),
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
                  TextFormField(
                    controller: reciveEditControl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Get Amount', // This is the label
                      labelStyle: const TextStyle(
                          color: Colors.blue), // Style for the label
                      hintText: '0',
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Style for the hint
                      suffix: Text(categoryTwo?.currency ?? 'IQD'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Rounded rectangle border
                        borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2), // Border color and width
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        updateAmounts();
                      });
                    },
                  ),
                  Text('Commission: ${commission.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF0B59D7))),
                  const SizedBox(height: 30),
                  Text(
                      'Your ${categoryTwo?.branchName ?? 'Fib'} Account Number',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B59D7))),
                  TextFormField(
                    controller: toPhoneController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: const Text('07'),
                      labelStyle: const TextStyle(
                          color: Colors.blue), // Style for the label
                      hintText: 'Enter Phone Number',
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Style for the hint
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Rounded rectangle border
                        borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2), // Border color and width
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    validator: (value) {
                      RegExp regExp = RegExp(r'^[0-9]{9}$');
                      if (value?.isEmpty ?? true) {
                        return "Please enter phone number! 07********";
                      } else if (!regExp.hasMatch(value!)) {
                        return "Please enter 9 digits for your phone number!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!isLoader) {
                            navigateToReviewPage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B59D7),
                        ),
                        child: isLoader
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Exchange',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
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
