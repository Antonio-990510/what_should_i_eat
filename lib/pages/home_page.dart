import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/pages/loading_page.dart';
import 'package:what_should_i_eat/pages/search_result_page.dart';
import 'package:what_should_i_eat/providers/world_cup_provider.dart';
import 'package:what_should_i_eat/sample_restaurant_list.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      resizeToAvoidBottomInset: false,
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
                PrimaryBarButton(
                  onPressed: () {
                    Get.bottomSheet(
                      const MyListBottomSheet(),
                      enableDrag: false,
                    );
                  },
                  label: '나의 리스트에서 랜덤 찾기',
                ),
                const SizedBox(height: 8),
                PrimaryBarButton(
                  onPressed: () {
                    Get.put(WorldCupProvider())
                        .startWorldCup(sampleRestaurantList);
                  },
                  label: '주변 식당 월드컵',
                ),
                const SizedBox(height: 8),
                PrimaryBarButton(
                  onPressed: () {},
                  label: '조건부 랜덤 찾기',
                ),
                const SizedBox(height: 8),
                PrimaryBarButton(
                  onPressed: () async {
                    Get.to(() => const LoadingPage());
                    await Future.delayed(const Duration(seconds: 2));
                    Get.off(
                      () => SearchResultPage(
                        restaurantModel: sampleRestaurantList.first,
                      ),
                    );
                  },
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
