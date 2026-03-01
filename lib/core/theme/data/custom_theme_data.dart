import 'package:flutter/material.dart';

ThemeData get darkThemeData => ThemeData(
  primaryColor: const Color(0xff263746),
  secondaryHeaderColor: const Color(0xffFFFFFF),
  brightness: Brightness.dark,
  extensions: <ThemeExtension<dynamic>>[DarkCustomThemeData()],
);

ThemeData get lightThemeData => ThemeData(
  primaryColor: const Color(0xffFFFFFF),
  secondaryHeaderColor: const Color(0xff314150),
  brightness: Brightness.light,
  extensions: <ThemeExtension<dynamic>>[LightCustomThemeData()],
);

abstract class CustomThemeData extends ThemeExtension<CustomThemeData> {
  late Color backgroundColor;
  late Color bottomAppBarSelectedColor;
  late Color bottomAppBarUnSelectedColor;
  late Color defaultTextColor;
  late Color defaultGreyTextColor;
  late Color defaultButtonColor;
}

class DarkCustomThemeData implements CustomThemeData {
  @override
  Color backgroundColor = const Color(0xff263746);

  @override
  Color bottomAppBarSelectedColor = const Color(0xff50AAA6);

  @override
  Color bottomAppBarUnSelectedColor = const Color(0xffE1E3FF);

  @override
  Color defaultTextColor = const Color(0xffFFFFFF);

  @override
  Color defaultGreyTextColor = const Color(0xffFFFFFF).withValues(alpha: 0.6);

  @override
  Color defaultButtonColor = const Color(0xff50AAA6);

  //Extras
  @override
  ThemeExtension<CustomThemeData> copyWith({Color? success, Color? failure}) {
    return DarkCustomThemeData();
  }

  @override
  ThemeExtension<CustomThemeData> lerp(
    ThemeExtension<CustomThemeData>? other,
    double t,
  ) {
    if (other is! CustomThemeData) return this;
    return DarkCustomThemeData();
  }

  @override
  ThemeExtension<dynamic> get type => DarkCustomThemeData();

  @override
  String toString() {
    return 'Dark Theme';
  }
}

class LightCustomThemeData implements CustomThemeData {
  @override
  Color backgroundColor = const Color(0xffFFFFFF);

  @override
  Color bottomAppBarSelectedColor = const Color(0xff50AAA6);

  @override
  Color bottomAppBarUnSelectedColor = const Color(0xffE1E3FF);

  @override
  Color defaultTextColor = const Color(0xff314150);

  @override
  Color defaultGreyTextColor = const Color(0xff314150).withValues(alpha: 0.6);

  @override
  Color defaultButtonColor = const Color(0xff50AAA6);

  //Extras
  @override
  ThemeExtension<CustomThemeData> copyWith({Color? success, Color? failure}) {
    return DarkCustomThemeData();
  }

  @override
  ThemeExtension<CustomThemeData> lerp(
    ThemeExtension<CustomThemeData>? other,
    double t,
  ) {
    if (other is! CustomThemeData) return this;
    return DarkCustomThemeData();
  }

  @override
  ThemeExtension<dynamic> get type => LightCustomThemeData();

  @override
  String toString() {
    return 'Light Theme';
  }
}
