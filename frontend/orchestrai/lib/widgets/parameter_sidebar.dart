// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/crew_model.dart';

// class ParameterSidebar extends StatelessWidget {
//   final AgentModel agent;
//   final String selectedPart;

//   ParameterSidebar({required this.agent, required this.selectedPart});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         if (selectedPart == 'head') _buildAgentParameters(context),
//         if (selectedPart == 'body') _buildTaskParameters(context),
//         if (selectedPart == 'tool') _buildToolParameters(context),
//       ],
//     );
//   }

//   Widget _buildAgentParameters(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(labelText: 'Agent Name'),
//           controller: TextEditingController(text: agent.name),
//           onChanged: (value) {
//             agent.name = value;
//             Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
//           },
//         ),
//         TextField(
//           decoration: InputDecoration(labelText: 'Agent Role'),
//           controller: TextEditingController(text: agent.role),
//           onChanged: (value) {
//             agent.role = value;
//             Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
//           },
//         ),
//         TextField(
//           decoration: InputDecoration(labelText: 'Agent Goal'),
//           controller: TextEditingController(text: agent.goal),
//           onChanged: (value) {
//             agent.goal = value;
//             Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
//           },
//         ),
//         TextField(
//           decoration: InputDecoration(labelText: 'Agent Backstory'),
//           controller: TextEditingController(text: agent.backstory),
//           maxLines: 3,
//           onChanged: (value) {
//             agent.backstory = value;
//             Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildTaskParameters(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           decoration: InputDecoration(labelText: 'Task Name'),
//           controller: TextEditingController(text: agent.task.name),
//           onChanged: (value) {
//             agent.task.name = value;
//             Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
//           },
//         ),
//         TextField(
//           decoration: InputDecoration(labelText: 'Task Description'),
//           controller: TextEditingController(text: agent.task.description),
//           maxLines: 2,
//           onChanged: (value) {
//             agent.task.description = value;
//             Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
//           },
//         ),
//         TextField(
//           decoration: InputDecoration(labelText: 'Expected Output'),
//           controller: TextEditingController(text: agent.task.expectedOutput),
//           onChanged: (value) {
//             agent.task.expectedOutput = value;
//             Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildToolParameters(BuildContext context) {
//     return Column(
//       children: [
//         ...agent.tools.asMap().entries.map((entry) {
//           int idx = entry.key;
//           ToolModel tool = entry.value;
//           return ExpansionTile(
//             title: Text('Tool ${idx + 1}'),
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Tool Name'),
//                 controller: TextEditingController(text: tool.name),
//                 onChanged: (value) {
//                   tool.name = value;
//                   Provider.of<CrewModel>(context, listen: false)
//                       .updateAgent(agent);
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Tool Description'),
//                 controller: TextEditingController(text: tool.description),
//                 maxLines: 2,
//                 onChanged: (value) {
//                   tool.description = value;
//                   Provider.of<CrewModel>(context, listen: false)
//                       .updateAgent(agent);
//                 },
//               ),
//               ElevatedButton(
//                 child: Text('Remove Tool'),
//                 onPressed: () {
//                   Provider.of<CrewModel>(context, listen: false)
//                       .removeToolFromAgent(agent, tool);
//                 },
//               ),
//             ],
//           );
//         }).toList(),
//         if (agent.tools.length < 4)
//           ElevatedButton(
//             child: Text('Add Tool'),
//             onPressed: () {
//               Provider.of<CrewModel>(context, listen: false).addToolToAgent(
//                 agent,
//                 ToolModel(name: 'New Tool', description: 'Tool description'),
//               );
//             },
//           ),
//       ],
//     );
//   }
// }
