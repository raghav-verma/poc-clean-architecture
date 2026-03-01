import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/error/exceptions.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/core/utils/custom_extension.dart';
import 'package:flutter_clean_arch_template/features/data/clients/rest_client.dart';
import 'package:flutter_clean_arch_template/features/data/model/responses/drink_listing_response_model.dart';

/// Remote API data source contract.
abstract class RemoteDatasource {
  Future<DrinkListingResponseModel> searchDrink({
    required final String searchText,
  });

  Future<DrinkListingResponseModel> getDrinkDetail({
    required final String drinkId,
  });
}

/// [RestClient]-backed implementation of [RemoteDatasource].
class RemoteDatasourceImplementation extends RemoteDatasource {
  final RestClient client;

  RemoteDatasourceImplementation({required this.client});

  void _processDio(err) {
    if (err is DioException) {
      throw ServerException(message: err.getErrorFromDio());
    } else {
      throw ServerException(message: Constants.errorUnknown);
    }
  }

  @override
  Future<DrinkListingResponseModel> searchDrink({
    required String searchText,
  }) async {
    try {
      return await client.searchDrink(searchText);
    } on DioException catch (e) {
      throw ServerException(message: e.getErrorFromDio());
    } catch (e) {
      _processDio(e);
      rethrow;
    }
  }

  @override
  Future<DrinkListingResponseModel> getDrinkDetail({
    required String drinkId,
  }) async {
    try {
      return await client.lookupDrink(drinkId);
    } on DioException catch (e) {
      throw ServerException(message: e.getErrorFromDio());
    } catch (e) {
      _processDio(e);
      rethrow;
    }
  }
}
