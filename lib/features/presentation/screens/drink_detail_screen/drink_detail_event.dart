part of 'drink_detail_bloc.dart';

abstract class DrinkDetailEvent extends Equatable {
  const DrinkDetailEvent();
}

class GetDrinkDetailEvent extends DrinkDetailEvent {
  final String drinkId;

  const GetDrinkDetailEvent({required this.drinkId});

  @override
  List<Object> get props => [drinkId];
}
