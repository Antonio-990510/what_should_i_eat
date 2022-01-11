import 'package:flutter/material.dart';
//import 'package:html/dom.dart' as dom;
//import 'package:http/http.dart' as http;
import 'package:what_should_i_eat/services/restaurant_search_api.dart';
//import 'package:html/parser.dart' as parser;

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    //TODO:implement initState
    super.initState();
    getLocation();
  }

  void getLocation() async {
    try {
      //await Geolocator.requestPermission();
      // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // print(position);
      // searchRestaurant(position);
      String myLocation = await fetchData();
      getUser(myLocation);
    } catch (e) {
      debugPrint('인터넷 연결에 문제가 있습니다.');
    }
  }

  /*void restaurantCrolling() async {
     String url= '''https://pcmap.place.naver.com/restaurant/list?query=석수역 맛집''';
     http.Response response = await http.get(Uri.parse(url));
     dom.Document document = parser.parse(response.body);

    debugPrint(response.body);

    List<dom.Element> keywordElements = document.querySelectorAll('._1EKsQ _12tNp');
    List<Map<String, dynamic>> keywords = [];
    for (var element in keywordElements) {
      //dom.Element? star = element.querySelector('em');
      dom.Element? name = element.querySelector('.OXiLu');
      dom.Element? open = element.querySelector('._2FqTn _4DbfT');
      dom.Element? info = element.querySelector('._1gET-');
      keywords.add({
        'name': name?.text,
        'info': info?.text,
        //'star': star?.text,
        'open': open?.text
      });
    }
     debugPrint(keywords.toString());
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: getLocation,
          child: const Text(
            'Get My Location',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
