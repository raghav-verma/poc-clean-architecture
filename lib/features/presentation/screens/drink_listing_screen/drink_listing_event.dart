part of 'drink_listing_bloc.dart';

abstract class DrinkListingEvent extends Equatable {
  const DrinkListingEvent();
}

class SearchDrinkEvent extends DrinkListingEvent {
  final String searchText;

  const SearchDrinkEvent({required this.searchText});

  @override
  List<Object> get props => [searchText];
}
