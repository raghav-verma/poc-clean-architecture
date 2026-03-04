import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';

part 'drink_listing_response_model.g.dart';

List<DrinkModel>? _drinksFromJson(Object? rawValue) {
  if (rawValue is! List) {

    return null;
  }

  return rawValue
      .whereType<Map>()
      .map((item) => DrinkModel.fromJson(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}

List<Map<String, dynamic>>? _drinksToJson(List<DrinkModel>? drinks) =>
    drinks?.map((drink) => drink.toJson()).toList(growable: false);

@JsonSerializable()
class DrinkListingResponseModel {
  DrinkListingResponseModel({this.drinks});

  @JsonKey(fromJson: _drinksFromJson, toJson: _drinksToJson)
  List<DrinkModel>? drinks;

  factory DrinkListingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkListingResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkListingResponseModelToJson(this);
}

@JsonSerializable()
class DrinkModel {
  DrinkModel({
    required this.idDrink,
    this.strDrink,
    this.strDrinkThumb,
    this.strInstructions,
  });

  final String idDrink;
  final String? strDrink;
  final String? strDrinkThumb;
  final String? strInstructions;

  /// Converts this API model into a domain entity.
  DrinkListingEntity toEntity() {
    return DrinkListingEntity(
      id: idDrink,
      name: strDrink,
      url: strDrinkThumb,
      description: strInstructions,
    );
  }

  factory DrinkModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkModelToJson(this);
}
