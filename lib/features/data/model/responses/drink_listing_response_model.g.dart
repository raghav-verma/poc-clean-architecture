// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_listing_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkListingResponseModel _$DrinkListingResponseModelFromJson(
  Map<String, dynamic> json,
) => DrinkListingResponseModel(drinks: _drinksFromJson(json['drinks']));

Map<String, dynamic> _$DrinkListingResponseModelToJson(
  DrinkListingResponseModel instance,
) => <String, dynamic>{'drinks': _drinksToJson(instance.drinks)};

DrinkModel _$DrinkModelFromJson(Map<String, dynamic> json) => DrinkModel(
  idDrink: json['idDrink'] as String,
  strDrink: json['strDrink'] as String?,
  strDrinkThumb: json['strDrinkThumb'] as String?,
  strInstructions: json['strInstructions'] as String?,
);

Map<String, dynamic> _$DrinkModelToJson(DrinkModel instance) =>
    <String, dynamic>{
      'idDrink': instance.idDrink,
      'strDrink': instance.strDrink,
      'strDrinkThumb': instance.strDrinkThumb,
      'strInstructions': instance.strInstructions,
    };
