import 'package:flutter/material.dart';

class ToolPromptModal extends StatefulWidget {
  final Function(String) onSubmit;

  const ToolPromptModal({required this.onSubmit});

  @override
  State<ToolPromptModal> createState() => _ToolPromptModalState();
}

class _ToolPromptModalState extends State<ToolPromptModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('도구 프롬프트 입력'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: '프롬프트를 입력하세요',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('제출'),
          onPressed: () {
            widget.onSubmit(_controller.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// 사용 예시:
// showDialog(
//   context: context,
//   builder: (BuildContext context) {
//     return ToolPromptModal(
//       onSubmit: (String prompt) {
//         // 프롬프트 처리 로직
//         print('입력된 프롬프트: $prompt');
//       },
//     );
//   },
// );
