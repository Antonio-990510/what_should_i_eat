import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  final arrowBack = Icons.arrow_back;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('설정', style: TextStyle(fontSize: 25),),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(arrowBack),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(35, 10, 35, 200),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      '최근에 사용한 리스트 유지하기',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    const Expanded(child: Text('')),
                    CupertinoSwitch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFFF77A52),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      '랜덤 뽑기 진동 알림',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    const Expanded(child: Text('')),
                    CupertinoSwitch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFFF77A52),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      '랜덤 뽑기 소리 알림',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    const Expanded(child: Text('')),
                    CupertinoSwitch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFFF77A52),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      '랜덤 뽑기 애니메이션 ',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    const Expanded(child: Text('')),
                    CupertinoSwitch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFFF77A52),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Row(
                  children: const [
                    Text(
                      '로그아웃',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: const [
                    Text(
                      '버그 리포트',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
