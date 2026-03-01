import 'package:equatable/equatable.dart';

/// Drink listing item.
class DrinkListingEntity extends Equatable {
  const DrinkListingEntity({
    required this.id,
    this.name,
    this.url,
    this.description,
  });

  final String id;
  final String? name;
  final String? url;
  final String? description;

  @override
  List<Object?> get props => [id, name, url, description];
}
