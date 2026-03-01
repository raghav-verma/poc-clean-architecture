import 'package:flutter_clean_arch_template/core/utils/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App routes', () {
    test('drink listing route is non-empty', () {
      expect(AppRoutes.drinkListingScreen, isNotEmpty);
      expect(AppRoutes.drinkListingScreen.startsWith('/'), isTrue);
    });

    test('drink detail route is non-empty', () {
      expect(AppRoutes.drinkDetailScreen, isNotEmpty);
      expect(AppRoutes.drinkDetailScreen.startsWith('/'), isTrue);
    });
  });
}
