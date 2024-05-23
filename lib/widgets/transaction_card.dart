import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:exchnage_app/widgets/icons_list.dart'; // Ensure this contains the correct path and class definition
import 'package:exchnage_app/pages/detail_page.dart'; // Check this path is correct

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.data,
  });

  final dynamic data;
  var appIcons = AppIcons(); // This should refer to the updated AppIcons class with image paths

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formattedDate = DateFormat('d MMM hh:mm a').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Material(
        color: Color.fromARGB(255, 198, 235, 255), // Background color of the whole card
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            // Define the action when the card is clicked
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(data: data), // Navigate to the details page
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          highlightColor: Colors.grey.withOpacity(0.2), // Highlight color when pressed
          splashColor: Colors.grey.withOpacity(0.1), // Splash color
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.09),
                  blurRadius: 10.0,
                  spreadRadius: 1,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ListTile(
              minVerticalPadding: 10,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      appIcons.getExchangeCategoryImage('${data['categoryOne']}'),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    Icon(
                      FontAwesomeIcons.exchange,
                      color: Colors.grey.withOpacity(0.2),
                      size: 20,
                    ),
                    Image.asset(
                      appIcons.getExchangeCategoryImage('${data['categoryTwo']}'),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              title: Row(
                children: [
                  Text("${data['categoryOne']}"),
                  Text(' to '),
                  Text(data['categoryTwo']),
                  Spacer(),
                  Text(
                    "${data['recive']}",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        "${data['reciverInfo']}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 47, 255),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
