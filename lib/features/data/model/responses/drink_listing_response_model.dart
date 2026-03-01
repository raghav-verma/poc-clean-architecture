import 'package:json_annotation/json_annotation.dart';

part 'drink_listing_response_model.g.dart';

List<DrinkModel>? _drinksFromJson(Object? rawValue) {
  if (rawValue is! List) {
    // CocktailDB returns {"drinks":"no data found"} for empty/no-match queries.
    return null;
  }

  return rawValue
      .whereType<Map>()
      .map((item) => DrinkModel.fromJson(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}

Object? _drinksToJson(List<DrinkModel>? drinks) => drinks;

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

  String idDrink;
  String? strDrink;
  String? strDrinkThumb;
  String? strInstructions;

  factory DrinkModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkModelToJson(this);
}
