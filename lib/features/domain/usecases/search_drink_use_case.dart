import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/core/usecase/usecase.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/repositories/repository.dart';

class SearchDrinkUseCase
    extends UseCase<List<DrinkListingEntity>, SearchDrinkParams> {
  final Repository _repository;

  SearchDrinkUseCase(this._repository);

  @override
  Future<Either<Failure, List<DrinkListingEntity>>> call(
    SearchDrinkParams params,
  ) async {
    return _repository.searchDrink(searchText: params.searchText);
  }
}

class SearchDrinkParams extends Equatable {
  final String searchText;

  const SearchDrinkParams({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}
