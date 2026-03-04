import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/get_drink_detail_use_case.dart';

part 'drink_detail_event.dart';
part 'drink_detail_state.dart';

class DrinkDetailBloc extends Bloc<DrinkDetailEvent, DrinkDetailState> {
  final GetDrinkDetailUseCase _getDrinkDetailUseCase;

  DrinkDetailBloc({required final GetDrinkDetailUseCase getDrinkDetailUseCase})
    : _getDrinkDetailUseCase = getDrinkDetailUseCase,
      super(DrinkDetailInitial()) {
    on<GetDrinkDetailEvent>(_onGetDrinkDetail);
  }

  Future<void> _onGetDrinkDetail(
    GetDrinkDetailEvent event,
    Emitter<DrinkDetailState> emit,
  ) async {
    emit(DrinkDetailLoadingState());
    final data = await _getDrinkDetailUseCase.call(
      GetDrinkDetailParams(drinkId: event.drinkId),
    );
    data.fold(
      (failure) => emit(DrinkDetailErrorState(message: failure.message)),
      (drink) => emit(DrinkDetailLoadedState(drink: drink)),
    );
  }
}
