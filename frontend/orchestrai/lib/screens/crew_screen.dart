import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';
import '../widgets/collaboration_popup.dart';
import '../widgets/hamburger_view.dart';
import 'agent_screen.dart';
import '../widgets/assembled_agent_view.dart';

class CrewScreen extends StatefulWidget {
  @override
  _CrewScreenState createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen> {
  final List<Offset> chairPositions = [
    Offset(0.35, 0.34),
    Offset(0.35, 0.53),
    Offset(0.62, 0.34),
    Offset(0.62, 0.53),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrchestrAI'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('로그인', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // TODO: Implement login functionality
            },
          ),
          TextButton(
            child: Text('회원가입', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // TODO: Implement signup functionality
            },
          ),
        ],
      ),
      drawer: HamburgerView(),
      body: Consumer<CrewModel>(
        builder: (context, crewModel, child) {
          return Stack(
            children: [
              Image.asset(
                'assets/main.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              if (crewModel.teamName != null)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: MediaQuery.of(context).size.width * 0.5 - 100,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF6050DC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        crewModel.teamName!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ...List.generate(4, (index) {
                return Positioned(
                  left: MediaQuery.of(context).size.width *
                      chairPositions[index].dx,
                  top: MediaQuery.of(context).size.height *
                      chairPositions[index].dy,
                  child: GestureDetector(
                    onTap: () async {
                      if (crewModel.agents[index] == null) {
                        crewModel.addDefaultAgent(index);
                      }
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentScreen(agentIndex: index),
                        ),
                      );
                      setState(() {});
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (crewModel.agents[index] == null)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          )
                        else
                          SizedBox(
                            width: 120,
                            height: 200,
                            child: AssembledAgentView(
                                agent: crewModel.agents[index]!),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CrewModel>(
        builder: (context, crewModel, child) {
          List<AgentModel> activeAgents =
              crewModel.agents.whereType<AgentModel>().toList();

          if (activeAgents.isEmpty) {
            return SizedBox.shrink();
          }

          return Container(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              child: Text(
                '협업 시작',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                List<AgentModel> activeAgents =
                    crewModel.agents.whereType<AgentModel>().toList();
                if (activeAgents.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CollaborationPopup(agents: activeAgents);
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('에이전트를 먼저 추가해주세요.')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
