import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';
import 'package:what_should_i_eat/pages/search_result_page.dart';
import 'package:what_should_i_eat/pages/world_cup_page.dart';

class WorldCupProvider extends GetxController {
  List<RestaurantModel> _list = [];

  @visibleForTesting
  List<RestaurantModel> winners = [];

  int _leftIndex = 0;

  @visibleForTesting
  RestaurantModel? unearnedWinModel;

  static String convertToRoundOfNumFrom(int round) {
    switch (round) {
      case 2:
        return '결승';
      case 4:
        return '준결승';
      default:
        return '$round강';
    }
  }

  /// 현재 월드컵이 진행중이라면 진행중인 강을 반환한다.
  ///
  /// 예를들어 4강을 진행중이라면 `4강`을 반환한다.
  String get currentRound {
    int roundNum = _list.length + (unearnedWinModel != null ? 1 : 0);
    return convertToRoundOfNumFrom(roundNum);
  }

  RestaurantModel _randomListItem() {
    return _list[Random().nextInt(_list.length)];
  }

  /// 부전승을 할 식당을 설정한다.
  void _setUnearnedWinModelToWinners() {
    assert(_list.length.isOdd);
    unearnedWinModel = _randomListItem();
    _list.remove(unearnedWinModel);
    winners.add(unearnedWinModel!);
  }

  void startWorldCup(List<RestaurantModel> models) async {
    _list = models;
    _list.shuffle();
    winners = [];
    _leftIndex = 0;
    if (_list.length.isOdd) {
      _setUnearnedWinModelToWinners();
    }
    _fight(isStarting: true);
  }

  void _fight({bool isStarting = false}) {
    final model1 = _list[_leftIndex];
    final model2 = _list[_leftIndex + 1];
    if (isStarting) {
      Get.to(
        () => WorldCupPage(
          restaurantA: model1,
          restaurantB: model2,
        ),
      );
    } else {
      Get.off(
        () => WorldCupPage(
          restaurantA: model1,
          restaurantB: model2,
        ),
        preventDuplicates: false,
        transition: Transition.rightToLeft,
      );
    }
  }

  void onTapCard(RestaurantModel winner) {
    winners.insert(0, winner);
    _leftIndex = _leftIndex + 2;
    // 하나의 라운드가 끝난 경우. 예를 들어 8강이 끝나고 4강으로 진입하는 것이 있다.
    if (_leftIndex + 1 >= _list.length) {
      // 최종 후보자가 나온 경우
      if (winners.length == 1) {
        Get.off(() => SearchResultPage(restaurantModel: winner));
        return;
      }
      _leftIndex = 0;
      _list = winners;
      winners = [];
      if (_list.length.isOdd) {
        _setUnearnedWinModelToWinners();
      } else {
        unearnedWinModel = null;
      }
      _list.shuffle();
    }
    _fight();
  }
}
