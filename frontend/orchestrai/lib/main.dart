import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/crew_model.dart';
import 'screens/crew_screen.dart';
import 'screens/ai_team_popup.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CrewModel(), //..addDummyData(),
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
      home: AITeamPopupOverlay(),
    );
  }
}
class AITeamPopupOverlay extends StatefulWidget {
  @override
  _AITeamPopupOverlayState createState() => _AITeamPopupOverlayState();
}

class _AITeamPopupOverlayState extends State<AITeamPopupOverlay> {
  bool _showPopup = true;

  void _navigateToCrewScreen() {
    setState(() {
      _showPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CrewScreen(),
        if (_showPopup)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            child: Center(
              child: AITeamPopup(
                onCreateTeam: _navigateToCrewScreen,
              ),
            ),
          ),
      ],
    );
  }
}