import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';
import 'package:what_should_i_eat/widgets/custom_back_button.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/custom_rating_bar.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({
    Key? key,
    required this.restaurantModel,
  }) : super(key: key);

  final RestaurantModel restaurantModel;

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  bool _enableHeroAnimation = true;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _enableHeroAnimation = false;
      });
    });
    super.initState();
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    if (flightDirection.index == 0) {
      return Stack(
        children: [
          FadeTransition(
            opacity: ReverseAnimation(animation),
            child: fromHeroContext.widget,
          ),
          FadeTransition(
            opacity: animation,
            child: toHeroContext.widget,
          ),
        ],
      );
    }
    return toHeroContext.widget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO(민성): 이 페이지에서 다른 화면으로 전환시 전면 광고 띄우기
    return DefaultScaffold(
      noAppbar: true,
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Stack(
            children: [
              ClipRect(
                child: SizedBox(
                  height: context.height * 2 / 5,
                  width: context.width,
                  child: widget.restaurantModel.image,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: CustomBackButton(style: CustomBackButtonStyle.fill),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.background,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, -2),
                      spreadRadius: 2.0,
                      blurRadius: 4.0),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: _enableHeroAnimation ? 'mainTitle' : 'disabled',
                    flightShuttleBuilder: _flightShuttleBuilder,
                    child: Text(
                      widget.restaurantModel.name,
                      style: context.textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.restaurantModel.menu,
                    style: context.textTheme.subtitle1!.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomRatingBar(rating: widget.restaurantModel.rating??0.0),
                  const Expanded(child: SizedBox()),
                  PrimaryBarButton(onPressed: () {}, label: '지도앱으로 이동'),
                  TextOnlyBarButton(
                    onPressed: () {},
                    labelColor: Colors.white70,
                    label: '이 식당 제외하고 다시 찾기',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
