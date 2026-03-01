import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/features/data/model/responses/drink_listing_response_model.dart';
import 'package:retrofit/retrofit.dart';
part 'rest_client.g.dart';

/// Retrofit API client.
@RestApi(baseUrl: Constants.baseUrl)
abstract class RestClient {
  /// Run: dart run build_runner build --delete-conflicting-outputs
  factory RestClient(final Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach auth token here when the project enables authenticated APIs.
          // options.headers[Constants.authorization] = "Bearer $accessToken";
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
    return _RestClient(dio);
  }

  @GET(Constants.searchDrinkEndPoint)
  Future<DrinkListingResponseModel> searchDrink(
    @Query("s") final String searchText,
  );

  @GET(Constants.lookupDrinkEndPoint)
  Future<DrinkListingResponseModel> lookupDrink(
    @Query("i") final String drinkId,
  );
}
