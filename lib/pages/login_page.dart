import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/pages/home_page.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Hero(
                tag: 'mainTitle',
                child: Text('뭐 먹을까?', style: context.textTheme.headline4),
              ),
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
                  onPressed: () => Get.off(const HomePage()),
                  label: '비회원으로 이용하기',
                  labelColor: Colors.black54,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
