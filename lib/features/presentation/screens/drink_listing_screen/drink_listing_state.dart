part of 'drink_listing_bloc.dart';

abstract class DrinkListingState extends Equatable {
  const DrinkListingState();
}

class DrinkListingInitial extends DrinkListingState {
  @override
  List<Object> get props => [];
}

class DrinkLoadingState extends DrinkListingState {
  @override
  List<Object> get props => [];
}

class DrinkErrorState extends DrinkListingState {
  final String message;

  const DrinkErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class DrinkLoadedState extends DrinkListingState {
  final List<DrinkListingEntity> drinkList;

  const DrinkLoadedState({required this.drinkList});

  @override
  List<Object> get props => [drinkList];
}
