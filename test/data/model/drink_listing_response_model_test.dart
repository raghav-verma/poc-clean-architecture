import 'package:flutter_clean_arch_template/features/data/model/responses/drink_listing_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DrinkListingResponseModel', () {
    test('parses no-data string payload without throwing', () {
      final model = DrinkListingResponseModel.fromJson(const {
        'drinks': 'no data found',
      });

      expect(model.drinks, isNull);
    });

    test('parses drinks list payload', () {
      final model = DrinkListingResponseModel.fromJson({
        'drinks': [
          {
            'idDrink': '11007',
            'strDrink': 'Margarita',
            'strDrinkThumb': 'https://example.com/image.jpg',
            'strInstructions': 'Shake and strain',
          },
        ],
      });

      expect(model.drinks, isNotNull);
      expect(model.drinks, hasLength(1));
      expect(model.drinks!.first.idDrink, '11007');
      expect(model.drinks!.first.strDrink, 'Margarita');
    });
  });
}
