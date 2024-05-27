import 'package:exchnage_app/models/BranchModel.dart';
import 'package:flutter/material.dart';

class CategoryDropDown extends StatefulWidget {
  CategoryDropDown({
    Key? key,
    required this.onChanged,
    required this.branches,
    this.branch,
  }) : super(key: key);

  final BranchModel? branch;
  List<BranchModel> branches = [];
  final ValueChanged<BranchModel?> onChanged;

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BranchModel>(
          value: widget.branch,
          isExpanded: true,
          hint: const Text('Select Branch'),
          items: widget.branches.map((branch) {
            return DropdownMenuItem<BranchModel>(
              value: branch,
              child: Row(
                children: [
                  Image.network(
                    branch.iconUrl ?? '',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    branch.branchName ?? '',
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    ' - ${branch.currency}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
