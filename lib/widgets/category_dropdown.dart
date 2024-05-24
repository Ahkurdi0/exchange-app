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
    return DropdownButton<BranchModel>(
      value: widget.branch,
      isExpanded: true,
      hint: const Text('Select Category'),
      items: widget.branches.map((branch) {
        return DropdownMenuItem<BranchModel>(
          value: branch, // Changed to BranchModel
          child: Row(
            children: [
              Image.network(
                branch.iconUrl ?? '', // Using network images
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
      onChanged: widget.onChanged, // Changed to accept BranchModel
    );
  }
}
