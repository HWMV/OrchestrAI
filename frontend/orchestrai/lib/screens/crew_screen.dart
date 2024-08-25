import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';
import 'agent_screen.dart';

class CrewScreen extends StatelessWidget {
  final List<Offset> chairPositions = [
    Offset(0.25, 0.4),
    Offset(0.75, 0.4),
    Offset(0.25, 0.7),
    Offset(0.75, 0.7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OrchestrAI')),
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
              ...List.generate(4, (index) {
                return Positioned(
                  left: MediaQuery.of(context).size.width *
                      chairPositions[index].dx,
                  top: MediaQuery.of(context).size.height *
                      chairPositions[index].dy,
                  child: GestureDetector(
                    onTap: () async {
                      if (index < crewModel.agents.length) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AgentScreen(agentIndex: index),
                          ),
                        );
                      } else if (crewModel.agents.length < 4) {
                        crewModel.addAgent(AgentModel(
                          name: "New Agent ${crewModel.agents.length + 1}",
                          role: "New Role",
                          goal: "New Goal",
                          headAsset: 'default',
                          bodyAsset: 'default',
                          toolAsset: 'default',
                          task: Task(name: "New Task"),
                          tools: [Tool(name: "New Tool")],
                        ));
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgentScreen(
                                agentIndex: crewModel.agents.length - 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Maximum number of agents reached')),
                        );
                      }
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        children: [
                          Image.asset('assets/chair.png'),
                          if (index < crewModel.agents.length)
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Image.asset(
                                'assets/agent_${crewModel.agents[index].headAsset}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/crew_model.dart';
// import 'agent_screen.dart';

// class CrewScreen extends StatelessWidget {
//   final List<Offset> chairPositions = [
//     Offset(0.25, 0.4),
//     Offset(0.75, 0.4),
//     Offset(0.25, 0.7),
//     Offset(0.75, 0.7),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('OrchestrAI')),
//       body: Consumer<CrewModel>(
//         builder: (context, crewModel, child) {
//           return Stack(
//             children: [
//               Image.asset(
//                 'assets/main.png',
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//               ...List.generate(4, (index) {
//                 return Positioned(
//                   left: MediaQuery.of(context).size.width *
//                       chairPositions[index].dx,
//                   top: MediaQuery.of(context).size.height *
//                       chairPositions[index].dy,
//                   child: GestureDetector(
//                     onTap: () async {
//                       if (index < crewModel.agents.length) {
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 AgentScreen(agentIndex: index),
//                           ),
//                         );
//                       } else if (crewModel.agents.length < 4) {
//                         crewModel.addAgent(AgentModel(
//                           headAsset: '',
//                           bodyAsset: '',
//                           toolAsset: '',
//                         ));
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AgentScreen(
//                                 agentIndex: crewModel.agents.length - 1),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content:
//                                   Text('Maximum number of agents reached')),
//                         );
//                       }
//                     },
//                     child: SizedBox(
//                       width: 100,
//                       height: 100,
//                       child: index < crewModel.agents.length
//                           ? Image.asset('assets/agent_${index + 1}.png')
//                           : Image.asset('assets/chair.png'),
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
