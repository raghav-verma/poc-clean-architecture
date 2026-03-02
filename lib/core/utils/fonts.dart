import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_template/core/utils/app_colors.dart';

class FontsConstants {
  static const String sourceSansPro = "Source Sans Pro";
}

/// Centralised text-style factory.
///
/// Instead of many near-identical static methods, a single [textStyle]
/// factory covers all weight variants via the [fontWeight] parameter.
class AppFonts {
  static TextStyle textStyle({
    double fontSize = 12.0,
    double letterSpacing = 0,
    double wordSpacing = 0.3,
    double height = 1.5,
    String fontType = FontsConstants.sourceSansPro,
    Color fontColor = AppColors.textColor4B,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration decoration = TextDecoration.none,
    Color backgroundColor = Colors.transparent,
  }) {
    return TextStyle(
      letterSpacing: letterSpacing,
      height: height,
      wordSpacing: wordSpacing,
      fontFamily: fontType,
      color: fontColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
      background: backgroundColor != Colors.transparent
          ? (Paint()..color = backgroundColor)
          : null,
    );
  }

  // Convenience aliases for common weights.

  static TextStyle thinStyle({
    double fontSize = 12.0,
    Color fontColor = Colors.white,
    double letterSpacing = 0.2,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w200,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle lightStyle({
    double fontSize = 12.0,
    Color fontColor = Colors.white,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w300,
        height: height,
      );

  static TextStyle regularStyle({
    double fontSize = 12.0,
    Color fontColor = Colors.white,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w400,
        height: height,
      );

  static TextStyle mediumStyle({
    double fontSize = 12.0,
    Color fontColor = AppColors.textColor4B,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w500,
        height: height,
      );

  static TextStyle semiBoldStyle({
    double fontSize = 12.0,
    Color fontColor = AppColors.textColor4B,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w600,
        height: height,
      );

  static TextStyle boldStyle({
    double fontSize = 12.0,
    Color fontColor = AppColors.textColor4B,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w700,
        height: height,
      );

  static TextStyle extraBoldStyle({
    double fontSize = 12.0,
    Color fontColor = Colors.white,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w800,
        height: height,
      );

  static TextStyle blackStyle({
    double fontSize = 12.0,
    Color fontColor = Colors.white,
    double height = 1.5,
  }) =>
      textStyle(
        fontSize: fontSize,
        fontColor: fontColor,
        fontWeight: FontWeight.w900,
        height: height,
      );
}
