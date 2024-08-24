import 'package:flutter/material.dart';
import '../models/crew_model.dart';

class LegoAgentBuilder extends StatelessWidget {
  final AgentModel agent;
  final Function(String) onPartSelected;
  final Function(String, String) onAssetChanged;

  LegoAgentBuilder({
    required this.agent,
    required this.onPartSelected,
    required this.onAssetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPartSelector(context, 'head', agent.headAsset, 100),
        _buildPartSelector(context, 'body', agent.bodyAsset, 150),
        _buildPartSelector(context, 'tool', agent.toolAsset, 100),
      ],
    );
  }

  Widget _buildPartSelector(BuildContext context, String part, String currentAsset, double height) {
    return GestureDetector(
      onTap: () => onPartSelected(part),
      child: Stack(
        children: [
          Image.asset('assets/${part}_$currentAsset.png', height: height),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showAssetSelectionDialog(context, part),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssetSelectionDialog(BuildContext context, String part) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select $part'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (var i = 1; i <= 3; i++)
                  ListTile(
                    title: Text('${part.capitalize()} $i'),
                    leading: Image.asset('assets/${part}_$i.png', height: 50),
                    onTap: () {
                      onAssetChanged(part, '$i');
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}