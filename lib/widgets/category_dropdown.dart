import 'package:flutter/material.dart';
import 'package:exchnage_app/widgets/icons_list.dart'; // Make sure this path is correct

class CategoryDropDown extends StatelessWidget {
  CategoryDropDown({
    super.key,
    required this.onChanged,
    this.cattype,
  });

  final String? cattype;
  final ValueChanged<String?> onChanged;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: cattype,
        isExpanded: true,
        hint: Text('Select Category'),
        items: appIcons.homeExchangeCategories.map((category) {
          return DropdownMenuItem<String>(
            value: category['name'],
            child: Row(
              children: [
                Image.asset(
                  category['image'], // Using image assets
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10),
                Text(
                  category['name'],
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged);
  }
}
