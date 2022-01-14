import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';
import 'package:what_should_i_eat/providers/world_cup_provider.dart';
import 'package:what_should_i_eat/widgets/only_one_pointer_recognizer.dart';
import 'package:what_should_i_eat/widgets/custom_back_button.dart';
import 'package:what_should_i_eat/widgets/custom_rating_bar.dart';

class WorldCupPage extends StatefulWidget {
  /// [restaurantA]과 [restaurantB]가 1대1 대결로 사용자에게 선택을 받는다.
  ///
  /// 선택된 식당을 `Get.back()`할 때 반환한다.
  const WorldCupPage({
    Key? key,
    required this.restaurantA,
    required this.restaurantB,
  }) : super(key: key);

  final RestaurantModel restaurantA;
  final RestaurantModel restaurantB;

  @override
  State<WorldCupPage> createState() => _WorldCupPageState();
}

class _WorldCupPageState extends State<WorldCupPage>
    with TickerProviderStateMixin {
  late final AnimationController _topController;
  late final AnimationController _bottomController;
  late final AnimationController _textController;

  late final Animation<double> _topFadeAnimation;
  late final Animation<double> _topSizeAnimation;
  late final Animation<double> _bottomFadeAnimation;
  late final Animation<double> _bottomSizeAnimation;
  late final Animation<double> _textAnimation;

  String _winnerName = 'VS';
  bool _didPop = false;

  @override
  void initState() {
    super.initState();
    _topController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _topFadeAnimation = CurvedAnimation(
      parent: ReverseAnimation(_topController),
      curve: Curves.easeIn,
    );
    _bottomFadeAnimation = CurvedAnimation(
      parent: ReverseAnimation(_bottomController),
      curve: Curves.easeIn,
    );
    _topSizeAnimation = CurvedAnimation(
      parent: _bottomController,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 1.0, end: 2.0));
    _bottomSizeAnimation = CurvedAnimation(
      parent: _topController,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 1.0, end: 2.0));

    _textAnimation = ReverseAnimation(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
  }

  void _onTap(RestaurantModel model, bool isTopCard) async {
    setState(() {
      _winnerName = model.name;
    });
    if (isTopCard) {
      _bottomController.forward();
    } else {
      _topController.forward();
    }
    await _textController.forward();
    await Future.delayed(kDelayAfterTapWorldCupCard);

    if (!_didPop) Get.find<WorldCupProvider>().onTapCard(model);
  }

  @override
  void dispose() {
    _topController.dispose();
    _bottomController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnlyOnePointerRecognizer(
      child: WillPopScope(
        onWillPop: () {
          _didPop = true;
          return Future(() => true);
        },
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: SizeTransition(
                      sizeFactor: _topFadeAnimation,
                      child: AnimatedBuilder(
                        animation: _topSizeAnimation,
                        child: ImageCard(
                          onTap: () => _onTap(widget.restaurantA, true),
                          textAnimation: _textAnimation,
                          contentPosition: ContentPosition.topRight,
                          restaurantModel: widget.restaurantA,
                        ),
                        builder: (_, child) => SizedBox(
                          height: constraints.maxHeight /
                              2 *
                              _topSizeAnimation.value,
                          width: constraints.maxWidth,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizeTransition(
                      sizeFactor: _bottomFadeAnimation,
                      child: AnimatedBuilder(
                        animation: _bottomSizeAnimation,
                        child: ImageCard(
                          onTap: () => _onTap(widget.restaurantB, false),
                          textAnimation: _textAnimation,
                          contentPosition: ContentPosition.bottomLeft,
                          restaurantModel: widget.restaurantB,
                        ),
                        builder: (_, child) => SizedBox(
                          height: constraints.maxHeight /
                              2 *
                              _bottomSizeAnimation.value,
                          width: constraints.maxWidth,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CustomBackButton(
                      style: CustomBackButtonStyle.border,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _textAnimation,
                          curve: const Interval(0.6, 1.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GetBuilder<WorldCupProvider>(builder: (provider) {
                              return Text(
                                provider.currentRound,
                                style: context.textTheme.headline6!.copyWith(
                                  color: const Color(0xffa7a7a7),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }),
                            Text(
                              'VS',
                              style: context.textTheme.headline4!.copyWith(
                                color: const Color(0xffc1c1c1),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: FadeTransition(
                        opacity: Tween(
                          begin: 1.0,
                          end: 0.0,
                        ).animate(_textAnimation),
                        child: Text(
                          _winnerName,
                          style: context.textTheme.headline4!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

enum ContentPosition {
  bottomLeft,
  topRight,
}

@visibleForTesting
class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.textAnimation,
    required this.restaurantModel,
    required this.contentPosition,
    required this.onTap,
  }) : super(key: key);

  final Animation<double> textAnimation;
  final RestaurantModel restaurantModel;
  final ContentPosition contentPosition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isTopRight = contentPosition == ContentPosition.topRight;
    final CrossAxisAlignment crossAxisAlignment =
        isTopRight ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: AnimatedBuilder(
        animation: textAnimation,
        builder: (_, child) => FadeTransition(
          opacity: textAnimation,
          child: child,
        ),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          verticalDirection:
              isTopRight ? VerticalDirection.down : VerticalDirection.up,
          children: [
            SizedBox(
              // 뒤로가기 버튼의 위치는 비워둔다.
              width: context.width - (isTopRight ? 120 : 48),
              child: Text(
                restaurantModel.name,
                style: context.textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: isTopRight ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              restaurantModel.menu,
              style: context.textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            CustomRatingBar(rating: restaurantModel.rating),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.darken,
                ),
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: restaurantModel.image,
                ),
              ),
              Positioned(
                top: isTopRight ? 0 : null,
                right: isTopRight ? 0 : null,
                left: isTopRight ? null : 0,
                bottom: isTopRight ? null : 0,
                child: content,
              ),
            ],
          ),
        );
      },
    );
  }
}
