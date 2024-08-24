import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/crew_model.dart';
import 'screens/crew_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CrewModel()..addDummyData(),
      child: OrchestrAIApp(),
    ),
  );
}

class OrchestrAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrchestrAI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CrewScreen(),
    );
  }
}
