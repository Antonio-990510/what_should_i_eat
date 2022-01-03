import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:what_should_i_eat/widgets/custom_back_button.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key}) : super(key: key);

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
                child: Image.network(
                  'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTAyMjVfMjAg%2FMDAxNjE0MjYxNjY1MzUz.oWiPlZ1FZrW4nAKN0NRWOh5jM5UXgmpRBREbjlGnP1Ug.USL3XgByqVuONUvKRhm6mfm0ywLDjaVUFYl3d8hLzEAg.JPEG.wy2014%2FIMG_0351_jpg.jpg&type=sc960_832',
                  height: context.height * 2 / 5,
                  width: context.width,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: CustomBackButton(hasCircleFill: true),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: _enableHeroAnimation ? 'mainTitle' : 'disabled',
                    flightShuttleBuilder: _flightShuttleBuilder,
                    child: Text(
                      '한성대 양꼬치',
                      style: context.textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '양꼬치, 꿔바로우',
                    style: context.textTheme.subtitle1!.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RatingBarIndicator(
                    rating: 3.6,
                    itemBuilder: (context, index) {
                      return Icon(
                        Icons.star_rounded,
                        color: context.theme.colorScheme.secondary,
                      );
                    },
                    itemSize: 24.0,
                    unratedColor: const Color(0x80B6B6B6),
                    direction: Axis.horizontal,
                  ),
                  const Expanded(child: SizedBox()),
                  BarButton(onPressed: () {}, label: '지도앱으로 이동'),
                  BarButton(
                    onPressed: () {},
                    color: Colors.transparent,
                    overlayColor: Colors.white24,
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
