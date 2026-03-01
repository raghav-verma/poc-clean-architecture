import 'dart:convert';

import 'package:flutter_clean_arch_template/core/config/my_shared_pref.dart';
import 'package:flutter_clean_arch_template/core/error/exceptions.dart';
import 'package:flutter_clean_arch_template/features/data/model/responses/drink_listing_response_model.dart';

/// Local storage contract for caching.
abstract class LocalDatasource {
  /// Returns cached listing, or empty list if none.
  List<DrinkModel> getListing();

  /// Caches the given listing locally.
  void saveListing(List<DrinkModel> list);
}

/// Hive/SharedPreferences-backed [LocalDatasource] implementation.
class LocalDatasourceImplementation extends LocalDatasource {
  final MySharedPref mySharedPref;

  LocalDatasourceImplementation({required this.mySharedPref});

  @override
  void saveListing(List<DrinkModel> list) {
    try {
      mySharedPref.saveDrinkListingCache(
        jsonEncode(list.map((drink) => drink.toJson()).toList(growable: false)),
      );
    } on Exception {
      throw CacheException(message: 'Unable to cache drink listing');
    }
  }

  @override
  List<DrinkModel> getListing() {
    try {
      final String cached = mySharedPref.getDrinkListingCache();
      if (cached.isEmpty) {
        return [];
      }
      final decoded = jsonDecode(cached);
      if (decoded is! List) {
        throw const FormatException('Invalid cache payload');
      }
      return decoded
          .whereType<Map>()
          .map((item) => DrinkModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    } on Exception {
      throw CacheException(message: 'Unable to read drink listing cache');
    }
  }
}
