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
      String myLocation = await fetchData();
      debugPrint(myLocation);
      getUser(myLocation);
    } catch (e) {
      debugPrint('인터넷 연결에 문제가 있습니다.');
    }
  }

  /*void restaurantCrolling() async {
     String url= '''https://pcmap.place.naver.com/restaurant/list?query=석수역%20맛집''';
    String url= '''https://search.map.kakao.com/mapsearch/map.daum?callback=jQuery18102443191294827569_1642036613679&q=%EA%B2%BD%EA%B8%B0%EB%8F%84+%EC%95%88%EC%96%91%EC%8B%9C+%EB%A7%8C%EC%95%88%EA%B5%AC+%EC%84%9D%EC%88%98%EB%8F%99+374-5+%EC%9D%8C%EC%8B%9D%EC%A0%90&msFlag=S&page=1&sort=1''';
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
