import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';
import '../widgets/assembled_agent_view.dart';
import '../widgets/category_selection_view.dart';
import '../widgets/component_selection_view.dart';
import '../widgets/parameter_settings_view.dart';

class AgentScreen extends StatefulWidget {
  final int agentIndex;

  AgentScreen({required this.agentIndex});

  @override
  _AgentScreenState createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  String selectedCategory = '';
  late AgentModel agent;

  @override
  void initState() {
    super.initState();
    agent = Provider.of<CrewModel>(context, listen: false)
        .agents[widget.agentIndex]!;
  }

  void _updateAgentAsset(String asset, String category) {
    setState(() {
      switch (category) {
        case '머리':
          agent.headAsset = asset;
          int index = int.parse(asset.split('_').last.split('.').first) - 1;
          String agentRole = CrewModel.predefinedAgentNames[index];
          var details = CrewModel.predefinedAgentDetails[agentRole] ?? {};
          agent.role = agentRole;
          agent.goal = details['goal'] ?? '';
          agent.backstory = details['backstory'] ?? '';
          agent.displayName =
              CrewModel.customAgentDisplayNames[agentRole] ?? agentRole;
          break;
        case '태스크':
          agent.bodyAsset = asset;
          int index = int.parse(asset.split('_').last.split('.').first) - 1;
          String taskName = CrewModel.predefinedTaskNames[index];
          var taskDetails = CrewModel.predefinedTaskDetails[taskName] ?? {};
          agent.task = Task(
            displayName: CrewModel.customTaskDisplayNames[taskName] ?? taskName,
            description: taskDetails['description'] ?? '',
            expectedOutput: taskDetails['expectedOutput'] ?? '',
            outputFiles: [],
          );
          break;
        case '도구':
          _toggleTool(asset);
          break;
      }
    });
    Provider.of<CrewModel>(context, listen: false)
        .updateAgent(agent, widget.agentIndex);
  }

  void _toggleTool(String toolName) {
    setState(() {
      if (agent.tools.contains(toolName)) {
        agent.tools.remove(toolName);
      } else if (agent.tools.length < 4) {
        agent.tools.add(toolName);
      }
    });
    Provider.of<CrewModel>(context, listen: false)
        .updateAgent(agent, widget.agentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI에이전트를 만들어보세요'),
        actions: [
          TextButton(
            onPressed: _completeAgentCreation,
            child: Text('완료', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: AssembledAgentView(agent: agent),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                CategorySelectionView(
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
                Expanded(
                  child: selectedCategory.isNotEmpty
                      ? ComponentSelectionView(
                          part: selectedCategory,
                          optionCount: selectedCategory == '머리'
                              ? CrewModel.predefinedAgentNames.length
                              : (selectedCategory == '태스크'
                                  ? CrewModel.predefinedTaskNames.length
                                  : Provider.of<CrewModel>(context,
                                          listen: false)
                                      .availableTools
                                      .length),
                          selectedTools: agent.tools,
                          selectedHead: agent.headAsset,
                          selectedTask: agent.bodyAsset,
                          onAssetChanged: (asset) {
                            _updateAgentAsset(asset, selectedCategory);
                          },
                        )
                      : Center(child: Text('카테고리를 선택해주세요')),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ParameterSettingsView(
              key: ValueKey('${agent.role}_${agent.task?.displayName}'),
              agent: agent,
              selectedPart: selectedCategory,
              onParameterChanged: (role, goal, backstory) {
                setState(() {
                  agent.role = role;
                  agent.goal = goal;
                  agent.backstory = backstory;
                });
                Provider.of<CrewModel>(context, listen: false)
                    .updateAgent(agent, widget.agentIndex);
              },
              onTaskParameterChanged:
                  (description, expectedOutput, outputFiles) {
                setState(() {
                  if (agent.task != null) {
                    agent.task!.description = description;
                    agent.task!.expectedOutput = expectedOutput;
                    agent.task!.outputFiles = outputFiles;
                  }
                });
                Provider.of<CrewModel>(context, listen: false)
                    .updateAgent(agent, widget.agentIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _completeAgentCreation() {
    Provider.of<CrewModel>(context, listen: false)
        .updateAgent(agent, widget.agentIndex);
    Navigator.pop(context);
  }
}