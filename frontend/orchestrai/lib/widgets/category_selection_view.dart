import 'package:flutter/material.dart';

class CategorySelectionView extends StatelessWidget {
  final Function(String) onCategorySelected;

  CategorySelectionView({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['머리', '태스크', '도구'].map((category) {
        return ElevatedButton(
          child: Text(category),
          onPressed: () => onCategorySelected(category),
        );
      }).toList(),
    );
  }
}
