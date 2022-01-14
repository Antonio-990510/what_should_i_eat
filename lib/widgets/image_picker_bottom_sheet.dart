import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/widgets/default_bottom_sheet.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({Key? key}) : super(key: key);

  void _onTapDeviceImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final String path =
          '${(await getApplicationDocumentsDirectory()).path}/${image.name}';
      await image.saveTo(path);
      Get.back(result: path);
    }
  }

  void _onTapSampleImage(String imagePath) {
    Get.back(result: imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Text(
        '이미지를 선택하세요',
        style: context.textTheme.headline5!.copyWith(
          color: Colors.black,
        ),
      ),
      action: null,
      body: SizedBox(
        height: 240,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(24.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: kSampleFoodImagePaths.length + 1,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: index == 0
                  ? _onTapDeviceImage
                  : () => _onTapSampleImage(kSampleFoodImagePaths[index - 1]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: index == 0
                    ? Container(
                        width: 80,
                        height: 80,
                        color: context.theme.colorScheme.background
                            .withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: Colors.black38,
                            ),
                            Text(
                              '기기 사진에서\n선택하기',
                              textAlign: TextAlign.center,
                              style: context.textTheme.subtitle2!.copyWith(
                                color: Colors.black54,
                                height: 1.4,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      )
                    : Image.asset(
                        kSampleFoodImagePaths[index - 1],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
