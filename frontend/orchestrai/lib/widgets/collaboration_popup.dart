import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';

class CollaborationPopup extends StatefulWidget {
  final List<AgentModel> agents;

  CollaborationPopup({required this.agents});

  @override
  _CollaborationPopupState createState() => _CollaborationPopupState();
}

class _CollaborationPopupState extends State<CollaborationPopup> {
  late List<AgentModel> _agents;
  bool _isLoading = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    _agents = List.from(widget.agents);
  }

  Future<void> _executeCrew() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final crewModel = Provider.of<CrewModel>(context, listen: false);
      final result = await crewModel.executeCrew();
      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('실행 순서 설정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final AgentModel item = _agents.removeAt(oldIndex);
                    _agents.insert(newIndex, item);
                  });
                },
                children: _agents
                    .map((agent) => AgentListItem(
                          key: ValueKey(agent),
                          agent: agent,
                        ))
                    .toList(),
              ),
            ),
            Text('드래그하여 순서를 변경할 수 있습니다.',
                style: TextStyle(fontStyle: FontStyle.italic)),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_result.isNotEmpty)
              Text(_result, style: TextStyle(fontSize: 16))
            else
              ElevatedButton(
                child: Text('협업 실행'),
                onPressed: _executeCrew,
              ),
          ],
        ),
      ),
    );
  }
}

class AgentListItem extends StatelessWidget {
  final AgentModel agent;

  AgentListItem({required Key key, required this.agent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.drag_handle),
        title: Text(agent.role),
        subtitle: Text('태스크: ${agent.task?.displayName ?? '할당된 태스크 없음'}'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
