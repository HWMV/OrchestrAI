import 'package:flutter/material.dart';

class HamburgerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              'OrchestrAI Menu',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          ExpansionTile(
            title: Text('Agents'),
            children: <Widget>[
              ListTile(
                title: Text('마켓 분석가'),
                onTap: () {
                  // TODO: Implement agent 1 action
                },
              ),
              ListTile(
                title: Text('마케팅 전략가'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
               ListTile(
                title: Text('콘텐츠 창작자'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              ListTile(
                title: Text('포토그래퍼'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              ListTile(
                title: Text('크리에이티브 디렉터'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              ListTile(
                title: Text('리서처'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              ListTile(
                title: Text('테크니컬 분석가'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              ListTile(
                title: Text('재무분석가'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              ListTile(
                title: Text('투자추천 전문가'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              ListTile(
                title: Text('커스텀 에이전트'),
                onTap: () {
                  // TODO: Implement agent 2 action
                },
              ),
              // Add more agents as needed
            ],
          ),
          ExpansionTile(
            title: Text('Tasks'),
            children: <Widget>[
              ListTile(
                title: Text('프로덕션 분석'),
                onTap: () {
                  // TODO: Implement task 1 action
                },
              ),
              ListTile(
                title: Text('경쟁사 분석'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('캠페인 개발'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('인스타그램 광고카피'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('사진찍기'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('리서치'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('태크니컬 분석'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('파이낸셜 분석'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('투자 추천'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              ListTile(
                title: Text('커스텀 태스크'),
                onTap: () {
                  // TODO: Implement task 2 action
                },
              ),
              // Add more tasks as needed
            ],
          ),
          ExpansionTile(
            title: Text('Tools'),
            children: <Widget>[
              ListTile(
                title: Text('인터넷 검색'),
                onTap: () {
                  // TODO: Implement tool 1 action
                },
              ),
              ListTile(
                title: Text('인스타그램 검색'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              ListTile(
                title: Text('Dall-E 이미지 생성'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              ListTile(
                title: Text('주식가격 검색'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              ListTile(
                title: Text('주식뉴스 검색'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              ListTile(
                title: Text('손익계산서 검색'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              ListTile(
                title: Text('대차대조표 검색'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              ListTile(
                title: Text('내부자 거래 검색'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              ListTile(
                title: Text('커스텀 도구'),
                onTap: () {
                  // TODO: Implement tool 2 action
                },
              ),
              // Add more tools as needed
            ],
          ),
        ],
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: Text(
          'This is the About Us page. Add your content here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}