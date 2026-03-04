import 'package:equatable/equatable.dart';

/// Base failure type for domain layer error handling.
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Failure originating from a remote source.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Failure originating from local cache.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
