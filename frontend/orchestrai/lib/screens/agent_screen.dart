import 'package:flutter/material.dart';
import 'package:orchestrai/widgets/lego_agent_builder.dart';
import 'package:orchestrai/widgets/parameter_sidebar.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';

class AgentScreen extends StatefulWidget {
  final int agentIndex;

  AgentScreen({required this.agentIndex});

  @override
  _AgentScreenState createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  String selectedPart = 'head';
  late AgentModel agent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      agent = Provider.of<CrewModel>(context, listen: false)
          .agents[widget.agentIndex];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CrewModel>(
      builder: (context, crewModel, child) {
        agent = crewModel.agents[widget.agentIndex];
        return Scaffold(
          appBar: AppBar(
              title: Text('Agent ${widget.agentIndex + 1}: ${agent.name}')),
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: LegoAgentBuilder(
                  agent: agent,
                  onPartSelected: (part) {
                    setState(() {
                      selectedPart = part;
                    });
                  },
                  onAssetChanged: (part, asset) {
                    setState(() {
                      switch (part) {
                        case 'head':
                          agent.headAsset = asset;
                          break;
                        case 'body':
                          agent.bodyAsset = asset;
                          break;
                        case 'tool':
                          agent.toolAsset = asset;
                          break;
                      }
                    });
                    crewModel.updateAgent(agent);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ParameterSidebar(
                  agent: agent,
                  selectedPart: selectedPart,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () {
              if (_validateAgent()) {
                _completeAgentCreation(crewModel);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all required fields')),
                );
              }
            },
          ),
        );
      },
    );
  }

  bool _validateAgent() {
    return agent.name.isNotEmpty &&
        agent.role.isNotEmpty &&
        agent.goal.isNotEmpty &&
        agent.task.name.isNotEmpty &&
        agent.tools.isNotEmpty;
  }

  void _completeAgentCreation(CrewModel crewModel) {
    crewModel.updateAgent(agent);
    // 추가적인 완료 로직 구현 가능
  }
}

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
        // _buildPartSelector(context, 'tool', agent.toolAsset, 100),
        _buildPartSelector(context, 'tool',
            agent.tools.isNotEmpty ? agent.tools.first.name : 'default', 100),
      ],
    );
  }

  Widget _buildPartSelector(
      BuildContext context, String part, String currentAsset, double height) {
    return GestureDetector(
      onTap: () => onPartSelected(part),
      child: Stack(
        children: [
          Image.asset('assets/${part}_1.png', height: height),
          // Image.asset('assets/${part}_$currentAsset.png', height: height),
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
