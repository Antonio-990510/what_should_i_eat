import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:http/http.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';
import 'package:http/http.dart' as http;
import 'package:what_should_i_eat/pages/loading.dart';
import 'package:geolocator/geolocator.dart';

const String _kNativeAppKey = 'db88ffc1aed093e91db845b457d49495';
const String _kJavaScriptKey = '7353032fb3c902fbc319097fbc35a44a';
const String _kRestApiKey = '665888240dc5aa6f10d609f5be6c20d1';

Future<String> fetchData() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  //현재위치를 position이라는 변수로 저장
  String lat = position.latitude.toString();
  String lon = position.longitude.toString();
  //위도와 경도를 나눠서 변수 선언
  print(lat);
  print(lon);
  // 잘 나오는지 확인!
  Map<String,String> headerss = {
    "X-NCP-APIGW-API-KEY-ID": "43tzihsoch", // 개인 클라이언트 아이디
    "X-NCP-APIGW-API-KEY": "qkom6gatLvpU05ZuXLNyd0ZRcA7J5ubknwaTkCYH" // 개인 시크릿 키
  };

  Response response = await get(
      Uri.parse(//이 부분이 코딩셰프님 영상과 차이가 있다. 플러터 버젼업이 되면서 이 메소드를 써야 제대로 uri를 인식한다.
          "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lon},${lat}&sourcecrs=epsg:4326&output=json"),
      headers: headerss);
  // 미리 만들어둔 headers map을 헤더에 넣어준다.
  String jsonData = response.body;
  //response에서 body부분만 받아주는 변수 만들어주공~
  print(jsonData);// 확인한번하고
  var myJson_gu =
  jsonDecode(jsonData)["results"][1]['region']['area2']['name'];
  var myJson_si =
  jsonDecode(jsonData)["results"][1]['region']['area1']['name'];
  var myJson_dong =
  jsonDecode(jsonData)["results"][1]['region']['area3']['name'];
  List<String> gusi = [myJson_si, myJson_gu, myJson_dong];
  String address=gusi[0]+" "+gusi[1]+" "+gusi[2];
  print(address);
  return address; //구랑 시를 받아서 gusi라는 귀여운 이름으로 받는다...?
}

Future<dynamic> getUser(String gusi) async {
  print(gusi);
  final uri = Uri.parse(
      "https://openapi.naver.com/v1/search/local.json?query=" +
          "$gusi 맛집" +
          "&display=20&start=1&sort=random");
  final Map<String, String> header = {
    "X-Naver-Client-Id": "uWDv77C8E2CmY5bUBJ92",
    "X-Naver-Client-Secret": "aSgxIylTMz",
    "display": "1"
  };


  final response = await http.get(uri, headers: header);
  print(response.body);
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
