import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';

class ComponentSelectionView extends StatelessWidget {
  final String part;
  final List<String> selectedTools;
  final String selectedHead;
  final String selectedTask;
  final Function(String) onAssetChanged;

  ComponentSelectionView({
    required this.part,
    required this.selectedTools,
    required this.selectedHead,
    required this.selectedTask,
    required this.onAssetChanged,
  });

  @override
  Widget build(BuildContext context) {
    int itemCount = part == '도구' ? 9 : 10;
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        // childAspectRatio: 0.75, // 이름을 표시할 공간을 확보하기 위해 조정
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        String asset;
        bool isSelected;
        String? agentName;
        String? taskName;
        String? toolName;
        
        if (part == '머리') {
          asset = 'head_${index + 1}.png';
          isSelected = asset == selectedHead;
          agentName = CrewModel.customAgentDisplayNames[CrewModel.predefinedAgentNames[index]] ?? 
                      CrewModel.predefinedAgentNames[index];
        } else if (part == '태스크') {
          asset = 'body_${index + 1}.png';
          isSelected = asset == selectedTask;
          taskName = CrewModel.customTaskDisplayNames[CrewModel.predefinedTaskNames[index]] ?? 
                      CrewModel.predefinedTaskNames[index];
        } else {  // 도구
          asset = 'tool_${index + 1}.png';
          toolName = CrewModel.customToolDisplayNames[CrewModel.predefinedToolNames[index]] ?? 
                      CrewModel.predefinedToolNames[index];
          isSelected = selectedTools.contains('tool_${index + 1}');
        }

        return GestureDetector(
          onTap: () => onAssetChanged(part == '도구' ? 'tool_${index + 1}' : asset),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/$asset',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $asset');
                          return Icon(Icons.error);
                        },
                      ),
                      if (part == '도구' && isSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(Icons.check_circle, color: Colors.blue),
                        ),
                    ],
                  ),
                ),
                if (part == '머리' && agentName != null)
                  _buildNameText(agentName),
                if (part == '태스크' && taskName != null)
                  _buildNameText(taskName),
                if (part == '도구' && toolName != null)
                  _buildNameText(toolName),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameText(String name) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}