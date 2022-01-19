import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/widgets/adaptive_image.dart';

class RestaurantModel {
  final double rating;
  final String name;
  final AdaptiveImage image;
  final String link;
  final String menu;
  final String description;
  final String address;
  final String telephone;

  RestaurantModel({
    required this.rating,
    required this.name,
    required String imageSrc,
    required this.link,
    required this.menu,
    required this.description,
    required this.telephone,
    required this.address,
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

  RestaurantModel copyWith({String? imagePath}) {
    return RestaurantModel(
      rating: rating,
      name: name,
      imageSrc: imagePath ?? image.path,
      link: link,
      menu: menu,
      description: description,
      telephone: telephone,
      address: address,
    );
  }

  RestaurantModel.fromNaverApiJson(Map<String, dynamic> json)
      : name = json["title"],
        link = json["link"],
        menu = json["category"],
        description = json["description"],
        telephone = json["telephone"],
        // TODO: 사진, 별점 얻어오기
        image = AdaptiveImage(path: kSampleFoodImagePaths.first),
        rating = 0.0,
        address = json["address"];

  @override
  String toString() {
    return name +
        " " +
        image.path +
        " " +
        link +
        " " +
        menu +
        " " +
        description +
        "-" +
        telephone +
        " " +
        address;
  }
}
