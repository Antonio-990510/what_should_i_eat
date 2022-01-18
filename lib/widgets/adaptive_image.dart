import 'dart:io';

import 'package:flutter/material.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:get/get.dart';

class AdaptiveImage extends StatelessWidget {
  /// [path]가 [kSampleFoodImagePaths]에 속하면 [Image.asset]을 생성하고 웹 페이지이면
  /// [Image.network]을 생성하고 아무것도 아니면 [Image.file]을 생성한다.
  AdaptiveImage({
    Key? key,
    required this.path,
    this.radius = 0.0,
    this.width = double.infinity,
    this.height = double.infinity,
  })  : imageWidget = kSampleFoodImagePaths.contains(path)
            ? Image.asset(
                path,
                height: height,
                width: width,
                fit: BoxFit.cover,
              )
            : path.isURL
                ? Image.network(
                    path,
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(path),
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  ),
        super(key: key);

  final String path;
  final double radius;
  final double width;
  final double height;
  final Image imageWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageWidget,
    );
  }
}
