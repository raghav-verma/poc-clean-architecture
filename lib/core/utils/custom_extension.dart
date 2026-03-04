import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';

/// Joins a list of strings into a newline-separated message.
String joinErrorMessages(List<String> data) => data.join('\n');

/// Extracts "message" or "msg" values from a list of maps into a single
/// newline-separated error string.
String joinErrorMessagesFromMap(List<dynamic> data) {
  return data
      .whereType<Map>()
      .map((item) {
        if (item.containsKey("message")) return item["message"];
        if (item.containsKey("msg")) return item["msg"];
        return null;
      })
      .whereType<String>()
      .join('\n');
}

extension MyDioError on DioException {
  String getErrorFromDio() {
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout) {
      return Constants.errorNoInternet;
    }

    if (response != null &&
        response!.data != null &&
        response!.data is String) {
      return response!.data.toString();
    }

    if (response != null && response!.data != null && response!.data! is Map) {
      try {
        if (response!.data["message"] is List) {
          return joinErrorMessages(
            List<String>.from(response!.data["message"]),
          );
        } else if (response!.data["error"] is LinkedHashMap) {
          final Map<String, dynamic> errorMap = response!.data["error"];
          if (errorMap.containsKey("errors") && errorMap["errors"] is String) {
            return errorMap["errors"];
          } else if (errorMap.containsKey("errors") &&
              errorMap["errors"] is List &&
              errorMap["errors"].isNotEmpty) {
            final List<dynamic> errors = errorMap["errors"] as List<dynamic>;
            return joinErrorMessages(List<String>.from(errors));
          } else if (errorMap.containsKey("error_params") &&
              errorMap["error_params"] is List &&
              errorMap["error_params"].isNotEmpty) {
            final List<dynamic> errors =
                errorMap["error_params"] as List<dynamic>;
            return joinErrorMessagesFromMap(errors);
          }
        } else if (response!.data["error"] is String) {
          return response!.data["error"];
        }
      } on Exception {
        return Constants.errorUnknown;
      }
    }
    return Constants.errorUnknown;
  }
}

extension StringCaseExtensions on String {
  /// Capitalises the first letter of each word (title case).
  String titleCase() {
    return replaceAll(
      RegExp(' +'),
      ' ',
    ).split(" ").map((str) => str.inCaps).join(" ");
  }

  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> sortBy<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) => toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  Iterable<T> sortByDescending<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) => toList()..sort((a, b) => selector(b).compareTo(selector(a)));
}

