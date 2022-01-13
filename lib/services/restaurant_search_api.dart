import 'dart:convert';
import 'package:flutter/material.dart';
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
  var restaurant;
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
    debugPrint(response.body);
    String jsonRestaurantData = response.body;
    Map<String, dynamic> restaurantList = jsonDecode(jsonRestaurantData);
    restaurant = RestaurantModel.fromJson(restaurantList);
    //return response.body;
  }
  debugPrint(restaurant.toString());
}

// Future<List> searchRestaurant(Position position) async {
//   var url = Uri.parse(
//       'https://dapi.kakao.com/v2/maps/sdk.js?appkey=$_kJavaScriptKey&libraries=services');
//   var response = await http.get(url);
//
//   String latitude = position.latitude.toString();
//   String longitude = position.longitude.toString();
//   String address;
//   final flutterJs = getJavascriptRuntime();
//   final result = flutterJs.evaluate('''
//
//   <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=$_kNativeAppKey&libraries=services"></script>
//     var geocoder=new kakao.maps.services.Geocoder();
//
//     searchDetailAddrFromCoords($latitude, $longitude, function(result, status) {
//         if (status === kakao.maps.services.Status.OK) {
//             var detailAddr=result[0].address.address_name;
//             console.log(detailAddr);
//         }
//     });
//
// function searchDetailAddrFromCoords($latitude, $longitude, callback) {
//     geocoder.coord2Address($latitude, $longitude, callback);
// }
//
// ''');
//   print(latitude);
//   print(longitude);
//  // print(result.stringResult);
//   return [];
// }
