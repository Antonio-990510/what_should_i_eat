import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('뭐 먹을까?', style: context.textTheme.headline4),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BarButton(
                      onPressed: () {},
                      label: '카카오로 로그인',
                      color: const Color(0xFFF7E600),
                    ),
                    BarButton(
                      onPressed: () {},
                      label: '비회원으로 이용하기',
                      labelColor: Colors.black54,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
