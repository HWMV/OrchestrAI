import 'package:flutter/material.dart';

class CategorySelectionView extends StatefulWidget {
  final Function(String) onCategorySelected;

  CategorySelectionView({required this.onCategorySelected});

  @override
  _CategorySelectionViewState createState() => _CategorySelectionViewState();
}

class _CategorySelectionViewState extends State<CategorySelectionView> {
  String _selectedCategory = '';

  final List<Map<String, dynamic>> _categories = [
    {'name': '머리', 'image': 'assets/head_1.png'},
    {'name': '태스크', 'image': 'assets/body_1.png'},
    {'name': '도구', 'image': 'assets/tool_1.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110, // Reduced height to prevent overflow
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category['name'];
          return Column(
            mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                  widget.onCategorySelected(category['name']);
                },
                child: Container(
                  width: 70, // Slightly reduced width
                  height: 70, // Slightly reduced height
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF6050DC) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    category['image'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 4), // Reduced space between image and text
              Text(
                category['name'],
                style: TextStyle(
                  color: isSelected ? Color(0xFF6050DC) : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12, // Reduced font size
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}