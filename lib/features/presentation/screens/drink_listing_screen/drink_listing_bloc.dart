import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/search_drink_use_case.dart';

part 'drink_listing_event.dart';

part 'drink_listing_state.dart';

class DrinkListingBloc extends Bloc<DrinkListingEvent, DrinkListingState> {
  final SearchDrinkUseCase _searchDrinkUseCase;

  DrinkListingBloc({required final SearchDrinkUseCase searchDrinkUseCase})
    : _searchDrinkUseCase = searchDrinkUseCase,
      super(DrinkListingInitial()) {
    on<SearchDrinkEvent>(_onSearchDrink, transformer: restartable());
  }

  Future<void> _onSearchDrink(
    SearchDrinkEvent event,
    Emitter<DrinkListingState> emit,
  ) async {
    final searchText = event.searchText.trim();
    if (searchText.isEmpty) {
      emit(const DrinkLoadedState(drinkList: <DrinkListingEntity>[]));
      return;
    }

    emit(DrinkLoadingState());
    final data = await _searchDrinkUseCase.call(
      SearchDrinkParams(searchText: searchText),
    );
    data.fold(
      (failure) => emit(DrinkErrorState(message: failure.message)),
      (loadedList) => emit(DrinkLoadedState(drinkList: loadedList)),
    );
  }
}
