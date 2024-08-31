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
  Map<int, TextEditingController> _inputControllers = {};
  Map<int, bool> _isInputConfirmed = {};

  @override
  void initState() {
    super.initState();
    _agents = List.from(widget.agents);
    for (int i = 0; i < _agents.length; i++) {
      _inputControllers[i] = TextEditingController();
      _isInputConfirmed[i] = false;
    }
  }

  @override
  void dispose() {
    _inputControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '실행 순서 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ReorderableListView(
                shrinkWrap: true,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final AgentModel item = _agents.removeAt(oldIndex);
                    _agents.insert(newIndex, item);
                  });
                },
                children: List.generate(_agents.length, (index) {
                  return AgentListItem(
                    key: ValueKey(_agents[index]),
                    agent: _agents[index],
                    inputController: _inputControllers[index]!,
                    isInputConfirmed: _isInputConfirmed[index]!,
                    onConfirmToggle: () {
                      setState(() {
                        _isInputConfirmed[index] = !_isInputConfirmed[index]!;
                      });
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '드래그하여 순서를 변경할 수 있습니다.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text('협업 실행', style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6050DC),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: Implement collaboration execution
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgentListItem extends StatelessWidget {
  final AgentModel agent;
  final TextEditingController inputController;
  final bool isInputConfirmed;
  final VoidCallback onConfirmToggle;

  AgentListItem({
    required Key key,
    required this.agent,
    required this.inputController,
    required this.isInputConfirmed,
    required this.onConfirmToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.menu),
            title: Text(agent.role),
            subtitle: Text('태스크: ${agent.task?.displayName ?? ''}'),
            trailing: Icon(Icons.check_circle, color: isInputConfirmed ? Colors.green : Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      hintText: '추가입력값을 입력해주세요',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    enabled: !isInputConfirmed,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onConfirmToggle,
                  child: Text(isInputConfirmed ? '수정' : '확인'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInputConfirmed ? Colors.white : Color(0xFF6050DC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}