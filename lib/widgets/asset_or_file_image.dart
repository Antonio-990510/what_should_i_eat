import 'dart:io';

import 'package:flutter/material.dart';
import 'package:what_should_i_eat/constants.dart';

class AssetOrFileImage extends StatelessWidget {
  /// [path]가 [kSampleFoodImagePaths]에 속하면 [Image.asset]을 생성하고 아니면
  /// [Image.file]을 생성한다.
  const AssetOrFileImage({
    Key? key,
    required this.path,
    required this.radius,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String path;
  final double radius;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: kSampleFoodImagePaths.contains(path)
          ? Image.asset(
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
    );
  }
}
