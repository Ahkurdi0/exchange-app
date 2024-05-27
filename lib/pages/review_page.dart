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
        title: const Text('Transaction Review'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildTransactionDetailTile(
                      'Transaction ID', widget.transaction.uId),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTransactionDetailTile('To Branch',
                            widget.transaction.toBranch?.branchName),
                      ),
                      Expanded(
                        child: _buildTransactionDetailTile('From Branch',
                            widget.transaction.fromBranch?.branchName),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTransactionDetailTile('Sending Amount',
                            widget.transaction.sendingAmount?.toString()),
                      ),
                      Expanded(
                        child: _buildTransactionDetailTile('Receiving Amount',
                            widget.transaction.receivingAmount?.toString()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTransactionDetailTile('Total Commission',
                            widget.transaction.totalCommission?.toString()),
                      ),
                      Expanded(
                        child: _buildTransactionDetailTile(
                            'Your ${widget.transaction.toBranch?.branchName} Phone',
                            widget.transaction.toPhone),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 200,
                    child: _buildTransactionDetailTile('From Branch QR Code',
                        widget.transaction.fromBranch?.qrCodeUrl,
                        isImage: true),
                  ),
                  const SizedBox(height: 15),
                  if (imagePath != null)
                    Text(
                      'Uploaded Image: ${path.basename(imagePath!)}',
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    ),
                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload Transaction Document"),
                  ),
                ],
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetailTile(String title, String? subtitle,
      {bool isImage = false}) {
    return ListTile(
      title: Text(title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
      subtitle: isImage && subtitle != null
          ? Image.network(subtitle)
          : Text(subtitle ?? 'N/A', style: const TextStyle(fontSize: 16.0)),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          onPressed: isLoading ? null : _handleSubmit,
          icon: isLoading
              ? const CircularProgressIndicator()
              : const Icon(Icons.payment, color: Colors.white),
          label: const Text("Submit", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    setState(() {
      isLoading = true;
    });

    if (imagePath != null && currentUserData?.uId != null) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('transactionDocuments/${path.basename(imagePath!)}');
      await ref.putFile(File(imagePath!));

      final String downloadURL = await ref.getDownloadURL();

      db.addTransaction(
        widget.transaction.copyWith(
          transactionDocumentUrl: downloadURL,
          user: currentUserData,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
Future<void> _handleSubmit() async {
  setState(() {
    isLoading = true;
  });

  if (imagePath != null && currentUserData?.uId != null) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('transactionDocuments/${path.basename(imagePath!)}');
    await ref.putFile(File(imagePath!));

    final String downloadURL = await ref.getDownloadURL();

    db.addTransaction(
      widget.transaction.copyWith(
        transactionDocumentUrl: downloadURL,
        user: currentUserData,
      ),
    );
    

    // Reset imagePath and currentUserData
    imagePath = null;
    currentUserData = null;
  }

  setState(() {
    isLoading = false;
  });

  // Navigate back to the "add exchange" page
  Navigator.pop(context);
}  }
}
