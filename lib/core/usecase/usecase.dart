import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Base class for UseCases
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Class used when no parameter needs to be passed
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
