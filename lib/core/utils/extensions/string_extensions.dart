extension StringExtensions on String {
  String get capitalizeFirstLetter {
    return replaceFirst(this[0], this[0].toUpperCase());
  }

  String get capitalizeFirstLetterOfEveryWord {
    return toLowerCase()
        .split(' ')
        .map((word) {
          final String leftText = (word.length > 1)
              ? word.substring(1, word.length)
              : '';
          return word[0].toUpperCase() + leftText;
        })
        .join(' ');
  }

  String get capitalize {
    return toUpperCase();
  }

  String get removeSpecialChar {
    return replaceAll(RegExp('[^A-Za-z0-9]'), ' ').trim();
  }

  bool get isValidEmail {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  bool get isValidMobileNumber {
    return length == 10 && isNumber;
  }

  bool get isNumber {
    return RegExp(r'^[1-9]\d*$').hasMatch(this);
  }

  String get getExtensionFromUrl {
    String extension = '';
    extension = split('?')[0];
    try {
      return '.${extension.split('.').last}';
    } catch (e) {
      return '';
    }
  }

  bool get isSvg {
    String extension = getExtensionFromUrl;
    if (extension.toLowerCase() == '.svg') {
      return true;
    } else {
      return false;
    }
  }
}
