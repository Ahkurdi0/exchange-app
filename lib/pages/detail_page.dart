import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final dynamic data;

  const DetailsPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('data'),
            
            Text(
              "Category One: ${data['categoryOne']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Category Two: ${data['categoryTwo']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text("Other data fields can go here"),
          ],
        ),
      ),
    );
  }
}
