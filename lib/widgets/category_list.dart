import 'package:exchnage_app/models/BranchModel.dart';
import 'package:exchnage_app/services/db.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  const CategoryList({super.key, required this.onChanged});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = 'All';
  final db = Db();
  List<BranchModel> branches = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    branches.add(const BranchModel(branchName: 'All')); // Add this line
    db.getBranches().then((value) => setState(() => branches.addAll(value)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedCategory();
    });
  }

  void scrollToSelectedCategory() {
    final selectedCategoryIndex =
        branches.indexWhere((cat) => cat.branchName == currentCategory);
    if (selectedCategoryIndex != -1) {
      final scrollOffset = (selectedCategoryIndex * 100.0) - 170;
      scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        controller: scrollController,
        itemCount: branches.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var data = branches[index];
          return GestureDetector(
            onTap: () {
              if (currentCategory != data.branchName) {
                setState(() {
                  currentCategory = data.branchName ?? '';
                  widget.onChanged(data.branchName);
                });
                scrollToSelectedCategory();
              }
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: currentCategory == data.branchName
                    ? Colors.blue.shade900
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  children: [
                    if (data.iconUrl != null) ...[
                      Image.network(
                        data.iconUrl!,
                        width: 30,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      data.branchName ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: currentCategory == data.branchName
                            ? Colors.white
                            : Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
