import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_template/core/error/exceptions.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/core/network/network_info.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/features/data/datasources/local_datasource/local_datasource.dart';
import 'package:flutter_clean_arch_template/features/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:flutter_clean_arch_template/features/data/model/responses/drink_listing_response_model.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/repositories/repository.dart';

class RepositoryImplementation extends DrinkRepository {
  final LocalDatasource localDataSource;
  final RemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;

  RepositoryImplementation({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DrinkListingEntity>>> searchDrink({
    required final String searchText,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final DrinkListingResponseModel result = await remoteDataSource
            .searchDrink(searchText: searchText);
        if (result.drinks != null) {
          // Cache is best-effort for online responses.
          try {
            localDataSource.saveListing(result.drinks!);
          } on CacheException {
            // Keep returning fresh remote data even if local cache fails.
          }
        }
        // No-match responses are valid empty results, not failures.
        return Right(_convertDrinkList(result));
      } else {
        final cachedList = localDataSource.getListing();
        if (cachedList.isNotEmpty) {
          final cachedResponse = DrinkListingResponseModel(drinks: cachedList);
          return Right(_convertDrinkList(cachedResponse));
        }
        return Left(ServerFailure(message: Constants.errorNoInternet));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DrinkListingEntity>> getDrinkDetail({
    required final String drinkId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final DrinkListingResponseModel result = await remoteDataSource
            .getDrinkDetail(drinkId: drinkId);
        final drinks = _convertDrinkList(result);
        if (drinks.isNotEmpty) {
          return Right(drinks.first);
        }
        return Left(ServerFailure(message: Constants.errorNoDataFound));
      } else {
        return Left(ServerFailure(message: Constants.errorNoInternet));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  List<DrinkListingEntity> _convertDrinkList(DrinkListingResponseModel model) {
    if (model.drinks == null || model.drinks!.isEmpty) {
      return [];
    }
    return model.drinks!.map((drink) => drink.toEntity()).toList();
  }
}
