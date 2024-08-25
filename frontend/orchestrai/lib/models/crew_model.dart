// import 'package:flutter/foundation.dart';

// class CrewModel extends ChangeNotifier {
//   String crewName = '';
//   List<AgentModel> agents = [];

//   void setCrewName(String name) {
//     crewName = name;
//     notifyListeners();
//   }

//   void addAgent(AgentModel agent) {
//     if (agents.length < 4) {
//       agents.add(agent);
//       notifyListeners();
//     }
//   }

//   void updateAgent(AgentModel agent) {
//     final index = agents.indexWhere((a) => a.name == agent.name);
//     if (index != -1) {
//       agents[index] = agent;
//       notifyListeners();
//     }
//   }

//   void addToolToAgent(AgentModel agent, ToolModel tool) {
//     if (agent.tools.length < 4) {
//       agent.tools.add(tool);
//       updateAgent(agent);
//     }
//   }

//   void removeToolFromAgent(AgentModel agent, ToolModel tool) {
//     agent.tools.remove(tool);
//     updateAgent(agent);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'crewName': crewName,
//       'agents': agents.map((agent) => agent.toJson()).toList(),
//     };
//   }

//   void addDummyData() {
//     crewName = "Test Crew";
//     agents = [
//       AgentModel(
//         name: "Researcher",
//         role: "Information Gatherer",
//         goal: "Collect and organize data",
//         backstory: "Experienced in data analysis and research methodologies",
//         headAsset: 'default',
//         bodyAsset: 'default',
//         toolAsset: 'default',
//         task: TaskModel(
//           name: "Web Research",
//           description: "Gather information from reliable web sources",
//           expectedOutput: "Comprehensive report on findings",
//         ),
//         tools: [
//           ToolModel(
//             name: "Web Scraper",
//             description: "Tool for extracting data from websites",
//           ),
//         ],
//       ),
//       AgentModel(
//         name: "Analyst",
//         role: "Data Interpreter",
//         goal: "Analyze and interpret collected data",
//         backstory: "Expert in statistical analysis and data visualization",
//         headAsset: 'default',
//         bodyAsset: 'default',
//         toolAsset: 'default',
//         task: TaskModel(
//           name: "Data Analysis",
//           description: "Perform statistical analysis on gathered data",
//           expectedOutput: "Analytical report with insights and visualizations",
//         ),
//         tools: [
//           ToolModel(
//             name: "Statistical Software",
//             description: "Advanced tool for statistical analysis",
//           ),
//         ],
//       ),
//     ];
//     notifyListeners();
//   }
// }

// class AgentModel {
//   String name;
//   String role;
//   String goal;
//   String backstory;
//   String headAsset;
//   String bodyAsset;
//   String toolAsset;
//   TaskModel task;
//   List<ToolModel> tools;

//   AgentModel({
//     this.name = '',
//     this.role = '',
//     this.goal = '',
//     this.backstory = '',
//     this.headAsset = 'default',
//     this.bodyAsset = 'default',
//     this.toolAsset = 'default',
//     TaskModel? task,
//     List<ToolModel>? tools,
//   })  : task = task ?? TaskModel(),
//         tools = tools ?? [];

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'role': role,
//       'goal': goal,
//       'backstory': backstory,
//       'headAsset': headAsset,
//       'bodyAsset': bodyAsset,
//       'toolAsset': toolAsset,
//       'task': task.toJson(),
//       'tools': tools.map((tool) => tool.toJson()).toList(),
//     };
//   }
// }

// class TaskModel {
//   String name;
//   String description;
//   String expectedOutput;

//   TaskModel({
//     this.name = '',
//     this.description = '',
//     this.expectedOutput = '',
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'description': description,
//       'expectedOutput': expectedOutput,
//     };
//   }
// }

// class ToolModel {
//   String name;
//   String description;

//   ToolModel({
//     this.name = '',
//     this.description = '',
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'description': description,
//     };
//   }
// }
import 'package:flutter/foundation.dart';

class CrewModel extends ChangeNotifier {
  List<AgentModel> agents = [];

  void addAgent(AgentModel agent) {
    agents.add(agent);
    notifyListeners();
  }

  void updateAgent(AgentModel agent) {
    int index = agents.indexWhere((a) => a.name == agent.name);
    if (index != -1) {
      agents[index] = agent;
      notifyListeners();
    }
  }

  void addDummyData() {
    addAgent(AgentModel(
      name: "Agent 1",
      role: "Role 1",
      goal: "Goal 1",
      headAsset: "1",
      bodyAsset: "1",
      toolAsset: "1",
      task: Task(name: "Task 1"),
      tools: [Tool(name: "Tool 1")],
    ));
    // 필요하다면 더 많은 더미 데이터를 추가할 수 있습니다.
  }
}

class AgentModel {
  String name;
  String role;
  String goal;
  String headAsset;
  String bodyAsset;
  String toolAsset;
  Task task;
  List<Tool> tools;

  AgentModel({
    required this.name,
    required this.role,
    required this.goal,
    required this.headAsset,
    required this.bodyAsset,
    required this.toolAsset,
    required this.task,
    required this.tools,
  });
}

class Task {
  String name;
  Task({required this.name});
}

class Tool {
  String name;
  Tool({required this.name});
}