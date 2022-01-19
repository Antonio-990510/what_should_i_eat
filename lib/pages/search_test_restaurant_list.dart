import 'package:flutter/material.dart';
import 'package:what_should_i_eat/services/restaurant_search_api.dart';

class SearchTestRestaurantList extends StatefulWidget {
  const SearchTestRestaurantList({Key? key}) : super(key: key);

  @override
  _SearchTestRestaurantListState createState() =>
      _SearchTestRestaurantListState();
}

class _SearchTestRestaurantListState extends State<SearchTestRestaurantList> {
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
      getRestaurantList(myLocation);
    } catch (e) {
      debugPrint('인터넷 연결에 문제가 있습니다.');
    }
  }

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
