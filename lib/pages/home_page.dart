import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Hero(
                    tag: 'mainTitle',
                    child: Text(
                      '뭐 먹을까?',
                      style: context.textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BarButton(
                  onPressed: () {},
                  label: '주변 식당 16강 월드컵',
                ),
                const SizedBox(height: 8),
                BarButton(
                  onPressed: () {},
                  label: '조건부 랜덤 찾기',
                ),
                const SizedBox(height: 8),
                BarButton(
                  onPressed: () {},
                  label: '주변 식당 랜덤 찾기',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
