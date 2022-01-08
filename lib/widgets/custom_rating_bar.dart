import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({
    Key? key,
    required this.rating,
    this.itemSize = 24.0,
  }) : super(key: key);

  final double rating;
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) {
        return Icon(
          Icons.star_rounded,
          color: context.theme.colorScheme.secondary,
        );
      },
      itemSize: itemSize,
      unratedColor: const Color(0x80B6B6B6),
      direction: Axis.horizontal,
    );
  }
}
