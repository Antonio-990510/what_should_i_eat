import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// const String _kNativeAppKey = 'db88ffc1aed093e91db845b457d49495';
// const String _kJavaScriptKey = '7353032fb3c902fbc319097fbc35a44a';
// const String _kRestApiKey = '665888240dc5aa6f10d609f5be6c20d1';

Future<String> fetchData() async {
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
  //"https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json"

  String jsonData = response.body;

  debugPrint(jsonData);
  var myJsonGu = jsonDecode(jsonData)["results"][0]['region']['area2']['name'];
  var myJsonSi = jsonDecode(jsonData)["results"][0]['region']['area1']['name'];
  var myJsonDong =
      jsonDecode(jsonData)["results"][0]['region']['area3']['name'];
  var myJsonDetail = jsonDecode(jsonData)["results"][0]['land']['number1'];
  var myJsonDetail2 = jsonDecode(jsonData)["results"][0]['land']['number2'];
  debugPrint(myJsonDetail2);

  List<String> myLocation = [
    myJsonSi,
    myJsonGu,
    myJsonDong,
    myJsonDetail,
    myJsonDetail2
  ];
  String address = myLocation[0] +
      " " +
      myLocation[1] +
      " " +
      myLocation[2] +
      " " +
      myLocation[3] +
      "-" +
      myLocation[4];

  debugPrint(address);
  return address;
}

Future<dynamic> getUser(String gusi) async {
  debugPrint(gusi);
  final uri = Uri.parse(
      "https://openapi.naver.com/v1/search/local.json?query=$gusi 맛집&display=20&start=1&sort=random");
  final Map<String, String> header = {
    "X-Naver-Client-Id": "uWDv77C8E2CmY5bUBJ92",
    "X-Naver-Client-Secret": "aSgxIylTMz",
    "display": "1"
  };

  final response = await http.get(uri, headers: header);
  debugPrint(response.body);
  return response.body;
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
