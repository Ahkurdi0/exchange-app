import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewSubmitPage extends StatefulWidget {
  final Map<String, String> data;

  const ReviewSubmitPage({Key? key, required this.data}) : super(key: key);

  @override
  _ReviewSubmitPageState createState() => _ReviewSubmitPageState();
}

class _ReviewSubmitPageState extends State<ReviewSubmitPage> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review and Submit')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('Field')),
                DataColumn(label: Text('Value')),
              ],
              rows: widget.data.entries.map((entry) => DataRow(
                cells: [
                  DataCell(Text(entry.key)),
                  DataCell(Text(entry.value)),
                ],
              )).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : () => _submitData(),
                child: _isSubmitting
                    ? CircularProgressIndicator()
                    : Text('Submit to Database'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    setState(() {
      _isSubmitting = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .add(widget.data);

        Navigator.pop(context); // Optionally pop the page after submitting
      } catch (e) {
        print('Error submitting data: $e');
      }
    }
    setState(() {
      _isSubmitting = false;
    });
  }
}
