import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/core/usecase/usecase.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/repositories/repository.dart';

class GetDrinkDetailUseCase
    extends UseCase<DrinkListingEntity, GetDrinkDetailParams> {
  final Repository _repository;

  GetDrinkDetailUseCase(this._repository);

  @override
  Future<Either<Failure, DrinkListingEntity>> call(
    GetDrinkDetailParams params,
  ) async {
    return _repository.getDrinkDetail(drinkId: params.drinkId);
  }
}

class GetDrinkDetailParams extends Equatable {
  final String drinkId;

  const GetDrinkDetailParams({required this.drinkId});

  @override
  List<Object?> get props => [drinkId];
}
