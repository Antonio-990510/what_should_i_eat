import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RestaurantModel {
  final double rating;
  final String name;
  final Image image;
  final String link;
  final String menu;

  RestaurantModel({
    required this.rating,
    required this.name,
    required String imageSrc,
    required this.link,
    required this.menu,
  })  : image = Image.network(
          imageSrc,
          fit: BoxFit.cover,
        ),
        assert(0.0 <= rating && rating <= 5.0) {
    if (Get.context != null) {
      precacheImage(image.image, Get.context!);
    }
  }
}
