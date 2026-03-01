part of 'drink_detail_bloc.dart';

abstract class DrinkDetailState extends Equatable {
  const DrinkDetailState();
}

class DrinkDetailInitial extends DrinkDetailState {
  @override
  List<Object> get props => [];
}

class DrinkDetailLoadingState extends DrinkDetailState {
  @override
  List<Object> get props => [];
}

class DrinkDetailErrorState extends DrinkDetailState {
  final String message;

  const DrinkDetailErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class DrinkDetailLoadedState extends DrinkDetailState {
  final DrinkListingEntity drink;

  const DrinkDetailLoadedState({required this.drink});

  @override
  List<Object> get props => [drink];
}
