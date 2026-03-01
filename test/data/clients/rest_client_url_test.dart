import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Rest client URL composition', () {
    test('builds expected search URL path with API version segment', () {
      final dio = Dio(BaseOptions(baseUrl: Constants.baseUrl));

      final requestOptions = Options(method: 'GET')
          .compose(
            dio.options,
            Constants.searchDrinkEndPoint,
            queryParameters: {'s': 'margarita'},
          )
          .copyWith(baseUrl: Constants.baseUrl);

      expect(
        requestOptions.uri.toString(),
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita',
      );
    });
  });
}
