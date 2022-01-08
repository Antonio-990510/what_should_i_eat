import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';
import 'package:http/http.dart' as http;
import 'package:what_should_i_eat/pages/loading.dart';
import 'package:geolocator/geolocator.dart';

const String _kNativeAppKey = 'db88ffc1aed093e91db845b457d49495';
const String _kJavaScriptKey = '7353032fb3c902fbc319097fbc35a44a';
const String _kRestApiKey = '665888240dc5aa6f10d609f5be6c20d1';



Future<List> searchRestaurant(Position position) async {
  var url = Uri.parse(
      'https://dapi.kakao.com/v2/maps/sdk.js?appkey=$_kJavaScriptKey&libraries=services');
  var response = await http.get(url);

  String latitude = position.latitude.toString();
  String longitude = position.longitude.toString();
  String address;
  final flutterJs = getJavascriptRuntime();
  final result = flutterJs.evaluate('''
  
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=$_kNativeAppKey&libraries=services"></script>
    var geocoder=new kakao.maps.services.Geocoder();
    
    searchDetailAddrFromCoords($latitude, $longitude, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var detailAddr=result[0].address.address_name;
            console.log(detailAddr);
        }   
    });
  
function searchDetailAddrFromCoords($latitude, $longitude, callback) {
    geocoder.coord2Address($latitude, $longitude, callback);
}

''');
  print(latitude);
  print(longitude);
 // print(result.stringResult);
  return [];
}
