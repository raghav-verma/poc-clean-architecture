import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';

abstract class Repository {
  Future<Either<Failure, List<DrinkListingEntity>>> searchDrink({
    required final String searchText,
  });

  Future<Either<Failure, DrinkListingEntity>> getDrinkDetail({
    required final String drinkId,
  });
}
