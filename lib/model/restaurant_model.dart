import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RestaurantModel {
  final double? rating;
  final String name;

  Image? image;
  final String link;
  final String menu;
  final String description;
  final String address;
  final String telephone;

  set img(Image? img)=>(img==null)?image=null:image=img;

  RestaurantModel({
    required this.rating,
    required this.name,
    required String imageSrc,
    required this.link,
    required this.menu,
    required this.description,
    required this.telephone,
    required this.address,
  }) : image = Image.network(
          imageSrc,
          fit: BoxFit.cover,
        ),
        assert(0.0 <= rating! && rating <= 5.0) {
    if (Get.context != null) {
      precacheImage(image!.image, Get.context!);
    }
  }


  RestaurantModel.fromNaverApiJson(Map<String, dynamic> json)
      : name = json["title"],
        link = json["link"],
        menu = json["category"],
        description = json["description"],
        telephone = json["telephone"],
        image=null,
        rating=null,
        address = json["address"];

  @override
  String toString() {
    return name +
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

  String getName(){
    List<String> searchAddress=address.split(" ");
    return name;//searchAddress[2]+" "+/+" "+menu
  }
}
