import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/get_drink_detail_use_case.dart';

part 'drink_detail_event.dart';
part 'drink_detail_state.dart';

class DrinkDetailBloc extends Bloc<DrinkDetailEvent, DrinkDetailState> {
  final GetDrinkDetailUseCase _getDrinkDetailUseCase;

  DrinkDetailBloc({required final GetDrinkDetailUseCase getDrinkDetailUseCase})
    : _getDrinkDetailUseCase = getDrinkDetailUseCase,
      super(DrinkDetailInitial()) {
    on<DrinkDetailEvent>((event, emit) async {
      if (event is GetDrinkDetailEvent) {
        emit(DrinkDetailLoadingState());
        final data = await _getDrinkDetailUseCase.call(
          GetDrinkDetailParams(drinkId: event.drinkId),
        );
        data.fold(
          (failure) async {
            if (failure is CacheFailure) {
              emit(DrinkDetailErrorState(message: failure.message));
            } else if (failure is ServerFailure) {
              emit(DrinkDetailErrorState(message: failure.message));
            } else {
              emit(
                const DrinkDetailErrorState(message: Constants.errorNoInternet),
              );
            }
          },
          (drink) async {
            emit(DrinkDetailLoadedState(drink: drink));
          },
        );
      }
    });
  }
}
