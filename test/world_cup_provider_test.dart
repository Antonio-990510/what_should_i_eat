import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';
import 'package:what_should_i_eat/pages/world_cup_page.dart';
import 'package:what_should_i_eat/providers/world_cup_provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('WorldCupProvider 테스트', () {
    testWidgets('두 개로 시작하는 경우 모든 아이템이 보인다.', (tester) async {
      mockNetworkImagesFor(() async {
        final list = sampleRestaurantList.getRange(0, 2).toList();
        await tester.pumpWidget(GetMaterialApp(home: Container()));
        final provider = Get.put(WorldCupProvider());

        provider.startWorldCup(List.from(list));
        await tester.pumpAndSettle();

        for (var restaurant in list) {
          expect(find.text(restaurant.name), findsOneWidget);
        }
      });
    });

    testWidgets('세 개로 시작하는 경우 부전승한 식당이 존재한다.', (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(GetMaterialApp(home: Container()));
        final provider = Get.put(WorldCupProvider());

        provider.startWorldCup(sampleRestaurantList.getRange(0, 3).toList());
        await tester.pumpAndSettle();

        expect(provider.unearnedWinModel != null, true);
        expect(find.text(provider.unearnedWinModel!.name), findsNothing);
      });
    });

    testWidgets('4강 첫 경기에서 승리한 식당은 두 번째 경기에 나오지 않는다.', (tester) async {
      await tester.runAsync(() async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(GetMaterialApp(home: Container()));
          final provider = Get.put(WorldCupProvider());

          provider.startWorldCup(sampleRestaurantList.getRange(0, 4).toList());
          await tester.pumpAndSettle();

          await tester.tap(find.byType(ImageCard).first);
          await tester.pumpAndSettle();
          await Future.delayed(kDelayAfterTapWorldCupCard);
          await tester.pumpAndSettle();

          final winner = provider.winners.first;

          expect(provider.winners.length, 1);
          expect(find.text(winner.name), findsNothing);
        });
      });
    });

    testWidgets('하나의 라운드(예를 들어 4강)이 끝나면 승자는 다음 라운드(예를 들어 결승)에 등장한다.',
        (tester) async {
      await tester.runAsync(() async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(GetMaterialApp(home: Container()));
          final provider = Get.put(WorldCupProvider());

          provider.startWorldCup(sampleRestaurantList.getRange(0, 4).toList());
          await tester.pumpAndSettle();

          await tester.tap(find.byType(ImageCard).first);
          await tester.pumpAndSettle();
          await Future.delayed(kDelayAfterTapWorldCupCard);
          await tester.pumpAndSettle();

          final winner = provider.winners.first;

          await tester.tap(find.byType(ImageCard).last);
          await tester.pumpAndSettle();
          await Future.delayed(kDelayAfterTapWorldCupCard);
          await tester.pumpAndSettle();

          expect(find.text(winner.name), findsOneWidget);
        });
      });
    });

    testWidgets('음식점 갯수에 맞게 "x강" 문구가 나타난다.', (tester) async {
      await tester.runAsync(() async {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(GetMaterialApp(home: Container()));
          final provider = Get.put(WorldCupProvider());
          final list = sampleRestaurantList;
          final length = list.length;

          provider.startWorldCup(list);
          await tester.pumpAndSettle();

          final roundName = WorldCupProvider.convertToRoundOfNumFrom(length);
          expect(find.text(roundName), findsOneWidget);
        });
      });
    });
  });
}

List<RestaurantModel> get sampleRestaurantList => [
      RestaurantModel(
        rating: 4.2,
        name: '한성대 양꼬치',
        imageSrc:
            'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTAyMjVfMjAg%2FMDAxNjE0MjYxNjY1MzUz.oWiPlZ1FZrW4nAKN0NRWOh5jM5UXgmpRBREbjlGnP1Ug.USL3XgByqVuONUvKRhm6mfm0ywLDjaVUFYl3d8hLzEAg.JPEG.wy2014%2FIMG_0351_jpg.jpg&type=sc960_832',
        link: '',
        menu: '양꼬치, 꿔바로우',
        telephone: '',
        description: '',
        address: '',
      ),
      RestaurantModel(
        rating: 3.6,
        name: '나폴레옹과자점 본점',
        imageSrc:
            'https://s3-ap-northeast-1.amazonaws.com/dcreviewsresized/20210129104716_photo1_3b4aadf8a61f.jpg',
        link: '',
        menu: '나폴레옹 빵',
        telephone: '',
        description: '',
        address: '',
      ),
      RestaurantModel(
        rating: 4.8,
        name: '냉면최고',
        imageSrc: 'https://t1.daumcdn.net/cfile/blog/9954544A5B12667A15',
        link: '',
        menu: '물냉면, 비빔냉면',
        telephone: '',
        description: '',
        address: '',
      ),
      RestaurantModel(
        rating: 5.0,
        name: '육풍',
        imageSrc:
            'https://mblogthumb-phinf.pstatic.net/MjAyMDAzMjFfMjc3/MDAxNTg0Nzk0MDc0MzQ0.0RTLoWO_TduBCFiS8ptc30wOw6BbF7ULDVcaParuKo0g.kgndzTK_fRhajkNA1UvFw96uSc71Y4XVygSOibvUOK0g.JPEG.mjp6378/IMG_0091.jpg?type=w800',
        link: '',
        menu: '돼지고기, 소고기',
        telephone: '',
        description: '',
        address: '',
      ),
      RestaurantModel(
        rating: 5.0,
        name: '나눈 부전승이지렁',
        imageSrc:
            'https://mblogthumb-phinf.pstatic.net/MjAyMDAzMjFfMjc3/MDAxNTg0Nzk0MDc0MzQ0.0RTLoWO_TduBCFiS8ptc30wOw6BbF7ULDVcaParuKo0g.kgndzTK_fRhajkNA1UvFw96uSc71Y4XVygSOibvUOK0g.JPEG.mjp6378/IMG_0091.jpg?type=w800',
        link: '',
        menu: '돼지고기, 소고기',
        telephone: '',
        description: '',
        address: '',
      ),
    ];
