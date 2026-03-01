import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_clean_arch_template/core/utils/app_colors.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';

extension WidgetFunction on Widget {
  dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  showSuccessToast({
    required final BuildContext context,
    required final String message,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.blackColor.withValues(alpha: 0.85),
      fontSize: 14.0,
    );
  }

  showErrorToast({
    required final BuildContext context,
    required final String message,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.blackColor.withValues(alpha: 0.85),
      fontSize: 14.0,
    );
  }

  showProgressDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                //color: AppColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              height: 60,
              width: 60,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }

  showDebugToast({
    required final BuildContext context,
    required final String message,
  }) {
    Fluttertoast.showToast(
      msg: message,
      //textColor: AppColors.white,
      //backgroundColor: AppColors.app_color,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }
}

extension MyDioError on DioException {
  String getErrorFromDio() {
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout) {
      return Constants.errorNoInternet;
    }
    // final stream401Listener = sl<Stream401Listener>();
    //
    // /// Listain
    // if (response != null &&
    //     response!.statusCode != null &&
    //     response!.statusCode == 401) {
    //   stream401Listener.addResponse(true);
    // }

    if (response != null &&
        response!.data != null &&
        response!.data is String) {
      return response!.data.toString();
    }

    if (response != null && response!.data != null && response!.data! is Map) {
      //print(response!.data.toString());
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
  toErrorMessage(List<String> data) {
    var error = "";
    for (var element in data) {
      error += "$element\n";
    }
    if (error.endsWith("\n")) {
      error = error.substring(0, error.length - 1);
    }
    return error;
  }

  toErrorMessageFromMap(List<dynamic> data) {
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

  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  bool isValidNumber() {
    return length == 10 && isNumber();
  }

  bool isNumber() {
    return RegExp(r'^[1-9]\d*$').hasMatch(this);
  }

  bool isVideo(String mediaType) {
    return mediaType.contains("video");
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

extension NumberOperations on int {
  bool isEven() {
    return this % 2 == 0 ? true : false;
  }
}

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> sortBy<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) => toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  Iterable<T> sortByDescending<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) => sortBy(selector).toList().reversed;
}
