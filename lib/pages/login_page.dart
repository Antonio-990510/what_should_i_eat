import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/pages/home_page.dart';
import 'package:what_should_i_eat/widgets/animated_text_background.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      padding: EdgeInsets.zero,
      body: AnimatedTextBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Hero(
                        tag: 'mainTitle',
                        child: Text(
                          '뭐 먹을까?',
                          style: context.textTheme.headline3!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BarButton(
                      onPressed: () {},
                      iconData: Icons.messenger, // TODO(민성): kakao icon으로 수정
                      label: '카카오로 로그인',
                    ),
                    BarButton(
                      onPressed: () => Get.off(() => const HomePage()),
                      label: '비회원으로 이용하기',
                      labelColor: const Color(0xE6FFFFFF),
                      color: Colors.transparent,
                      overlayColor: Colors.white24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
