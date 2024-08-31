import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';

class ComponentSelectionView extends StatelessWidget {
  final String part;
  final int optionCount;
  final List<Map<String, String>> selectedTools;
  final String selectedHead;
  final String selectedTask;
  final Function(String) onAssetChanged;

  ComponentSelectionView({
    required this.part,
    required this.optionCount,
    required this.selectedTools,
    required this.selectedHead,
    required this.selectedTask,
    required this.onAssetChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (part == '머리' || part == '태스크') {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        itemCount: optionCount,
        itemBuilder: (context, index) {
          String asset = '${part == '머리' ? 'head' : 'body'}_${index + 1}.png';
          bool isSelected =
              part == '머리' ? asset == selectedHead : asset == selectedTask;
          return GestureDetector(
            onTap: () => onAssetChanged(asset),
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/$asset'),
            ),
          );
        },
      );
    } else if (part == '도구') {
      return Consumer<CrewModel>(
        builder: (context, crewModel, child) {
          return ListView.builder(
            itemCount: crewModel.availableTools.length,
            itemBuilder: (context, index) {
              String toolName = crewModel.availableTools[index]['name']!;
              bool isSelected = selectedTools.contains(toolName);
              return ListTile(
                title: Text(toolName),
                trailing: isSelected
                    ? Icon(Icons.check_box, color: Colors.blue)
                    : Icon(Icons.check_box_outline_blank),
                onTap: () => onAssetChanged(toolName),
              );
            },
          );
        },
      );
    }
    return Container();
  }
}
