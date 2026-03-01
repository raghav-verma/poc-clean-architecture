import 'package:equatable/equatable.dart';

/// Base failure type for domain layer error handling.
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

/// Failure originating from a remote source.
class ServerFailure extends Failure {
  final String message;

  ServerFailure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Failure originating from local cache.
class CacheFailure extends Failure {
  final String message;

  CacheFailure({required this.message});

  @override
  List<Object> get props => [message];
}
