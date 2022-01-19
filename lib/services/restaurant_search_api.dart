import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';

Future<String> fetchData() async {
  await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  //현재위치를 position이라는 변수로 저장
  String lat = position.latitude.toString();
  String lon = position.longitude.toString();
  //위도와 경도를 나눠서 변수 선언
  debugPrint(lat);
  debugPrint(lon);
  // 잘 나오는지 확인!
  Map<String, String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "43tzihsoch",
    // 개인 클라이언트 아이디
    "X-NCP-APIGW-API-KEY": "qkom6gatLvpU05ZuXLNyd0ZRcA7J5ubknwaTkCYH"
    // 개인 시크릿 키
  };

  Response response = await get(
      Uri.parse(
          "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=addr,roadaddr"),
      headers: headerss);
  String jsonData = response.body;
  debugPrint(jsonData);
  Map<String, dynamic> userAddress = jsonDecode(jsonData);
  var address = Address.fromJson(userAddress);
  String userLocation = address.toString();
  return userLocation;
}

class Address {
  final String si;
  final String gu;
  final String dong;
  final String detail1;
  final String detail2;

  Address(this.si, this.gu, this.dong, this.detail1, this.detail2);

  Address.fromJson(Map<String, dynamic> json)
      : si = json["results"][0]['region']['area1']['name'],
        gu = json["results"][0]['region']['area2']['name'],
        dong = json["results"][0]['region']['area3']['name'],
        detail1 = json["results"][0]['land']['number1'],
        detail2 = json["results"][0]['land']['number2'];

  Map<String, dynamic> toJson() => {
        'si': si,
        'gu': gu,
        'dong': dong,
        'detail1': detail1,
        'detail2': detail2,
      };

  @override
  String toString() {
    return si + " " + gu + " " + dong + " " + detail1 + "-" + detail2;
  }
}

Future<dynamic> getUser(String gusi) async {
  debugPrint(gusi);
  List<RestaurantModel> restaurantList = [];
  List<String> foodList = [
    "맛집",
    "고깃",
    "햄버거",
    "해산물",
    "족발",
    "보쌈",
    "피자",
    "치킨",
    "국밥",
    "분식"
  ];

  for (int i = 0; i < foodList.length; i++) {
    final uri = Uri.parse(
        "https://openapi.naver.com/v1/search/local.json?query=$gusi ${foodList[i]}&display=20&start=1&sort=random");
    final Map<String, String> header = {
      "X-Naver-Client-Id": "uWDv77C8E2CmY5bUBJ92",
      "X-Naver-Client-Secret": "aSgxIylTMz",
      "display": "1"
    };

    final response = await http.get(uri, headers: header);
    //debugPrint(response.body);
    String jsonRestaurantData = response.body;
    final restaurantJsonList =
        (jsonDecode(jsonRestaurantData)["items"] as List<dynamic>);

    for (final model in restaurantJsonList) {
      restaurantList
          .add(RestaurantModel.fromNaverApiJson(model as Map<String, dynamic>));
    }
    //return response.body;
  }
  for (final model in restaurantList) {
    debugPrint(model.toString());
  }
  List<int> selectedRestaurantList = [];
  while (true) {
    var rnd = Random().nextInt(45) + 1;
    if (!selectedRestaurantList.contains(rnd)) {
      final uri = Uri.parse(
          "https://openapi.naver.com/v1/search/image.json?query=${restaurantList[rnd].name}&display=1&start=1&sort=sim");
      final Map<String, String> header = {
        "X-Naver-Client-Id": "uWDv77C8E2CmY5bUBJ92",
        "X-Naver-Client-Secret": "aSgxIylTMz",
        "display": "1"
      };
      final response = await http.get(uri, headers: header);
      String jsonRestaurantData = response.body;
      final restaurantJsonList = (jsonDecode(jsonRestaurantData)["items"] as List<dynamic>);
      try{
        final path = restaurantJsonList
            .toString()
            .split(",")[2]
            .toString()
            .split(" ")[2]
            .toString();
        debugPrint(path);
        restaurantList[rnd] = restaurantList[rnd].copyWith(imagePath: path);
        debugPrint(restaurantList[rnd].toString());
        selectedRestaurantList.add(rnd);
        debugPrint(selectedRestaurantList.toString());
      }catch(e){
        debugPrint("이미지가 없습니다. 다른 식당을 찾습니다.");
      }
    }
    if (selectedRestaurantList.length == 8) {
      selectedRestaurantList=[];
      break;
    }
  }

  /* 구글API
  var googlePlace = GooglePlace("AIzaSyC6vX3AEvK755bv1e4vQs4OjfC86iNeBIk");
  var findRestaurant = await googlePlace.search.getNearBySearchJson(
      Location(lat: 37.43331166666667, lng: 126.90393666666667), 2500,
      type: "restaurant", keyword: "");
  debugPrint(findRestaurant);

  DetailsResponse? detail = await googlePlace.details.get("ChIJN1t_tDeuEmsRUsoyG83frY4",
      fields: "name,rating,formatted_phone_number");

  for (int i = 0; i < selectedRestaurantList.length; i++) {
    String? result = await googlePlace.photos.getJson(
        "${restaurantList[selectedRestaurantList[i]]}", 1240, 400);
    //debugPrint(result.toString());
  }
*/

  /*for (int i = 0; i < selectedRestaurantList.length; i++) {
    debugPrint(restaurantList[selectedRestaurantList[i]].name);
    final uri = Uri.parse(
        "https://openapi.naver.com/v1/search/image.json?query=${restaurantList[selectedRestaurantList[i]].name}&display=3&start=1&sort=sim");

    final Map<String, String> header = {
      "X-Naver-Client-Id": "uWDv77C8E2CmY5bUBJ92",
      "X-Naver-Client-Secret": "aSgxIylTMz",
      "display": "1"
    };

    final response = await http.get(uri, headers: header);
    //debugPrint(response.body);
    String jsonRestaurantData = response.body;
    final restaurantJsonList =
        (jsonDecode(jsonRestaurantData)["items"] as List<dynamic>);
    //debugPrint(restaurantJsonList.toString().split(",")[2].toString().split(" ")[2].toString());
    for (final i in restaurantJsonList) {
      final path = i
          .toString()
          .split(",")[2]
          .toString()
          .split(" ")[2]
          .toString();
      debugPrint(path);
      restaurantList[i] = restaurantList[i].copyWith(imagePath: path);
      debugPrint(restaurantList[i].toString());
    }
  }*/
}
