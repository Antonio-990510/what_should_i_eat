import 'dart:io';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

Future<File> getMyListFile(PathProviderPlatform platform) async {
  return File('${await platform.getApplicationDocumentsPath()}/my_list.json');
}

Future<void> removeMyListFile(PathProviderPlatform platform) async {
  final file = await getMyListFile(platform);
  try {
    file.deleteSync();
  } on FileSystemException {
    return;
  }
}
