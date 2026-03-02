import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';

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
          return "".toErrorMessage(
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
            return "".toErrorMessage(List<String>.from(errors));
          } else if (errorMap.containsKey("error_params") &&
              errorMap["error_params"] is List &&
              errorMap["error_params"].isNotEmpty) {
            final List<dynamic> errors =
                errorMap["error_params"] as List<dynamic>;
            return "".toErrorMessageFromMap(List<dynamic>.from(errors));
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

  String getErrorType() {
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout) {
      return Constants.errorTypeTimeout;
    }
    if (response != null && response!.data != null && response!.data! is Map) {
      try {
        if (response!.data["errors"] is LinkedHashMap) {
          final Map<String, dynamic> errorMap = response!.data["error"];
          if (errorMap.containsKey("type") && errorMap["type"] is String) {
            return errorMap["type"];
          }
        }
      } on Exception {
        return Constants.errorUnknown;
      }
    }
    return Constants.errorUnknown;
  }
}

extension ErrorStringExtensions on String {
  String toErrorMessage(List<String> data) {
    var error = "";
    for (var element in data) {
      error += "$element\n";
    }
    if (error.endsWith("\n")) {
      error = error.substring(0, error.length - 1);
    }
    return error;
  }

  String toErrorMessageFromMap(List<dynamic> data) {
    var error = "";
    for (var element in data) {
      if (element.containsKey("message")) {
        error += element["message"] + "\n";
      } else if (element.containsKey("msg")) {
        error += element["msg"] + "\n";
      }
    }
    if (error.endsWith("\n")) {
      error = error.substring(0, error.length - 1);
    }
    return error;
  }

  String sentenceCase() {
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
  ) => sortBy(selector).toList().reversed;
}

