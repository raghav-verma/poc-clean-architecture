/// Thrown when a remote API call fails.
class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

/// Thrown when a local cache operation fails.
class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}
