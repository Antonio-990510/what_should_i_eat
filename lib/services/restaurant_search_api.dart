import 'package:flutter_js/flutter_js.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';
import 'package:http/http.dart' as http;

const String _kNativeAppKey = 'db88ffc1aed093e91db845b457d49495';
const String _kJavaScriptKey = '7353032fb3c902fbc319097fbc35a44a';
const String _kRestApiKey = '665888240dc5aa6f10d609f5be6c20d1';

Future<List> searchRestaurant() async {
  var url = Uri.parse(
      'https://dapi.kakao.com/v2/maps/sdk.js?appkey=$_kJavaScriptKey&libraries=services');
  var response = await http.get(url);

  final flutterJs = getJavascriptRuntime();
  final result = flutterJs.evaluate('''
script.src = '//dapi.kakao.com/v2/maps/sdk.js?appkey=$_kNativeAppKey&libraries=services&autoload=false';
script.onload = () => {
  kakao.maps.load(() => {
    console.assert(kakao.maps.Map);
  });
};
''');
  print(result.stringResult);
  return [];
}
