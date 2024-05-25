import 'dart:io';

import 'package:exchnage_app/models/UserModel.dart';
import 'package:exchnage_app/services/db.dart';
import 'package:flutter/material.dart';
import 'package:exchnage_app/models/TransactionModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatefulWidget {
  final TransactionModel transaction;

  const ReviewPage({super.key, required this.transaction});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String? imagePath;
  Db db = Db();
  bool isLoading = false;
  UserModel? currentUserData;

  @override
  void initState() {
    db.getCurrentUserData().then((value) => currentUserData = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Transaction ID'),
            subtitle: Text(widget.transaction.uId ?? 'N/A'),
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('To Branch'),
                  subtitle:
                      Text(widget.transaction.toBranch?.branchName ?? 'N/A'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('From Branch'),
                  subtitle:
                      Text(widget.transaction.fromBranch?.branchName ?? 'N/A'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Sending Amount'),
                  subtitle: Text(
                      widget.transaction.sendingAmount?.toString() ?? 'N/A'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('Receiving Amount'),
                  subtitle: Text(
                      widget.transaction.receivingAmount?.toString() ?? 'N/A'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Total Commission'),
                  subtitle: Text(
                      widget.transaction.totalCommission?.toString() ?? 'N/A'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                      'Your ${widget.transaction.toBranch?.branchName} Phone'),
                  subtitle: Text(widget.transaction.toPhone ?? 'N/A'),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 200,
                child: ListTile(
                  title: const Text('From Branch QR Code'),
                  subtitle: widget.transaction.fromBranch?.qrCodeUrl != null ||
                          (widget.transaction.fromBranch?.qrCodeUrl
                                  ?.isNotEmpty ??
                              false)
                      ? Image.network(
                          widget.transaction.fromBranch!.qrCodeUrl!,
                        )
                      : const Text('N/A'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (imagePath != null)
                Text(
                  'Uploaded Image: ${path.basename(imagePath!)}',
                ),
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      imagePath = pickedFile.path;
                    });
                  }
                },
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Transaction Document"),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800], // This is the background color
          ),
          onPressed: isLoading
              ? null
              : () async {
                  // Add this line
                  setState(() {
                    isLoading = true; // Add this line
                  });
                  if (imagePath != null && currentUserData?.uId != null) {
                    // Upload to Firebase Storage
                    firebase_storage.Reference ref =
                        firebase_storage.FirebaseStorage.instance.ref().child(
                            'transactionDocuments/${path.basename(imagePath!)}');
                    await ref.putFile(File(imagePath!));

                    // Get download URL
                    final String downloadURL = await ref.getDownloadURL();

                    // Save download URL to Firestore
                    db.addTransaction(
                      widget.transaction.copyWith(
                          transactionDocumentUrl: downloadURL,
                          user: currentUserData),
                    );
                  } else {
                    print(currentUserData.toString());
                  }
                  setState(() {
                    isLoading = false; // Add this line
                  });
                },
          icon: isLoading
              ? const CircularProgressIndicator()
              : const Icon(
                  // Add this line
                  Icons.payment,
                  color: Colors.white,
                ),
          label: const Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
