import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';

class AITeamPopup extends StatefulWidget {
  final VoidCallback onCreateTeam;

  const AITeamPopup({Key? key, required this.onCreateTeam}) : super(key: key);

  @override
  _AITeamPopupState createState() => _AITeamPopupState();
}

class _AITeamPopupState extends State<AITeamPopup> {
  final TextEditingController _teamNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double popupWidth = MediaQuery.of(context).size.width * 2 / 3;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, popupWidth),
    );
  }

  Widget contentBox(BuildContext context, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'AI 팀과 협업해보세요!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25),
          Text(
            'AI 에이전트가 당신의 팀이 됩니다',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _teamNameController,
                  decoration: InputDecoration(
                    hintText: '팀 이름을 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                child: Text('AI 팀 만들기', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6050DC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onPressed: () {
                  if (_teamNameController.text.isNotEmpty) {
                    Provider.of<CrewModel>(context, listen: false).setTeamName(_teamNameController.text);
                    widget.onCreateTeam();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: Text('사용방법', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onPressed: () {
                  // TODO: Show usage instructions
                },
              ),
              ElevatedButton(
                child: Text('데모 체험', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onPressed: () {
                  // TODO: Start demo experience
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}