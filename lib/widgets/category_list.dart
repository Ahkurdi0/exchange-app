import 'package:flutter/material.dart';
import 'package:exchnage_app/widgets/icons_list.dart'; // Ensure this is the correct path to your icons list

class CategoryList extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  CategoryList({super.key, required this.onChanged});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = 'All';
  List<Map<String, dynamic>> categoryList = [];
  final scrollController = ScrollController();
  var appIcons = AppIcons();

  final addCat = {
    "name": 'All',
    "image": 'assets/icons/fib.png',
  };

  @override
  void initState() {
    super.initState();
    categoryList = appIcons.homeExchangeCategories;
    categoryList.insert(0, addCat);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedCategory();
    });
  }

  void scrollToSelectedCategory() {
    final selectedCategoryIndex =
        categoryList.indexWhere((cat) => cat['name'] == currentCategory);
    if (selectedCategoryIndex != -1) {
      final scrollOffset = (selectedCategoryIndex * 100.0) - 170;
      scrollController.animateTo(
        scrollOffset,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: ListView.builder(
        controller: scrollController,
        itemCount: categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var data = categoryList[index];
          return GestureDetector(
            onTap: () {
              if (currentCategory != data['name']) {
                setState(() {
                  currentCategory = data['name'];
                  widget.onChanged(data['name']);
                });
                scrollToSelectedCategory();
              }
            },
            child: Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: currentCategory == data['name']
                    ? Colors.blue.shade900
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      data['image'],
                      
                      width: 30,
                      // color: currentCategory == data['name']
                      //     ? Colors.white
                      //     : Colors.blue.shade900,
                    ),
                    SizedBox(width: 10),
                    Text(
                      data['name'],
                      style: TextStyle(
                        fontSize: 16,
                        color: currentCategory == data['name']
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
