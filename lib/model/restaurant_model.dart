import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/widgets/adaptive_image.dart';

class RestaurantModel {
  final double rating;
  final String name;
  final AdaptiveImage image;
  final String link;
  final String menu;

  RestaurantModel({
    required this.rating,
    required this.name,
    required String imageSrc,
    required this.link,
    required this.menu,
  })  : image = AdaptiveImage(
          width: double.infinity,
          path: imageSrc,
          height: double.infinity,
          radius: 0.0,
        ),
        assert(0.0 <= rating && rating <= 5.0) {
    if (Get.context != null) {
      precacheImage(image.imageWidget.image, Get.context!);
    }
  }
}
