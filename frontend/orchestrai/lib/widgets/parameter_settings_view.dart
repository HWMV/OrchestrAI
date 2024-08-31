import 'package:flutter/material.dart';
import '../models/crew_model.dart';

class ParameterSettingsView extends StatefulWidget {
  final AgentModel agent;
  final String selectedPart;
  final Function(String, String, String) onParameterChanged;
  final Function(String, String, List<String>) onTaskParameterChanged;

  ParameterSettingsView({
    Key? key,
    required this.agent,
    required this.selectedPart,
    required this.onParameterChanged,
    required this.onTaskParameterChanged,
  }) : super(key: key);

  @override
  _ParameterSettingsViewState createState() => _ParameterSettingsViewState();
}

class _ParameterSettingsViewState extends State<ParameterSettingsView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _roleController;
  late TextEditingController _goalController;
  late TextEditingController _backstoryController;
  late TextEditingController _taskDescriptionController;
  late TextEditingController _taskExpectedOutputController;
  List<String> _outputFiles = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _roleController = TextEditingController(text: widget.agent.role);
    _goalController = TextEditingController(text: widget.agent.goal);
    _backstoryController = TextEditingController(text: widget.agent.backstory);
    _taskDescriptionController =
        TextEditingController(text: widget.agent.task?.description ?? '');
    _taskExpectedOutputController =
        TextEditingController(text: widget.agent.task?.expectedOutput ?? '');
    _outputFiles = List.from(widget.agent.task?.outputFiles ?? []);
  }

  @override
  void didUpdateWidget(ParameterSettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.agent != widget.agent) {
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    _roleController.dispose();
    _goalController.dispose();
    _backstoryController.dispose();
    _taskDescriptionController.dispose();
    _taskExpectedOutputController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.selectedPart == '머리') {
        widget.onParameterChanged(
          _roleController.text,
          _goalController.text,
          _backstoryController.text,
        );
      } else if (widget.selectedPart == '태스크') {
        widget.onTaskParameterChanged(
          _taskDescriptionController.text,
          _taskExpectedOutputController.text,
          _outputFiles,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.agent.role}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              if (widget.selectedPart == '머리') ...[
                TextFormField(
                  controller: _roleController,
                  decoration: InputDecoration(labelText: '역할'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '역할은 필수입니다';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _goalController,
                  decoration: InputDecoration(labelText: '목표'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '목표는 필수입니다';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _backstoryController,
                  decoration: InputDecoration(labelText: '배경 이야기'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '배경 이야기는 필수입니다';
                    }
                    return null;
                  },
                ),
              ] else if (widget.selectedPart == '태스크') ...[
                Text('태스크 이름: ${widget.agent.task?.displayName ?? ''}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _taskDescriptionController,
                  decoration: InputDecoration(labelText: '태스크 설명'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '태스크 설명은 필수입니다';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _taskExpectedOutputController,
                  decoration: InputDecoration(
                    labelText: '예상 결과',
                    errorText: _taskExpectedOutputController.text.isEmpty
                        ? '예상 결과는 필수입니다'
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '예상 결과는 필수입니다';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text('출력 파일', style: Theme.of(context).textTheme.titleMedium),
                ..._outputFiles.asMap().entries.map((entry) {
                  int index = entry.key;
                  String file = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: '파일 이름'),
                          initialValue: file,
                          onChanged: (value) => _updateOutputFile(index, value),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _removeOutputFile(index),
                      ),
                    ],
                  );
                }).toList(),
                ElevatedButton(
                  onPressed: _addOutputFile,
                  child: Text('출력 파일 추가'),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOutputFile(int index, String value) {
    setState(() {
      _outputFiles[index] = value;
    });
  }

  void _removeOutputFile(int index) {
    setState(() {
      _outputFiles.removeAt(index);
    });
  }

  void _addOutputFile() {
    setState(() {
      _outputFiles.add('');
    });
  }
}
