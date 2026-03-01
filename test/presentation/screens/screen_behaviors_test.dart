import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/repositories/repository.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/get_drink_detail_use_case.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/search_drink_use_case.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_detail_screen/drink_detail_bloc.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_detail_screen/drink_detail_screen.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_listing_screen/drink_listing_bloc.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_listing_screen/drink_listing_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Screen behaviors', () {
    testWidgets('clearing search resets listing to empty query results', (
      tester,
    ) async {
      final bloc = DrinkListingBloc(
        searchDrinkUseCase: _SearchBehaviorUseCase(),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const DrinkListingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No drinks found'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'margarita');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Margarita'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.text('No drinks found'), findsOneWidget);
      expect(find.text('Margarita'), findsNothing);
    });

    testWidgets('detail screen keeps fallback data when detail request fails', (
      tester,
    ) async {
      const fallbackDrink = DrinkListingEntity(
        id: '1',
        name: 'Fallback Name',
        description: 'Fallback Description',
      );

      final bloc = DrinkDetailBloc(
        getDrinkDetailUseCase: _AlwaysFailDrinkDetailUseCase(),
      )..add(GetDrinkDetailEvent(drinkId: fallbackDrink.id));
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const DrinkDetailScreen(drink: fallbackDrink),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Server Error'), findsOneWidget);
      expect(find.text('Fallback Name'), findsOneWidget);
      expect(find.text('Fallback Description'), findsOneWidget);
    });
  });
}

class _SearchBehaviorUseCase extends SearchDrinkUseCase {
  _SearchBehaviorUseCase() : super(_NoopRepository());

  @override
  Future<Either<Failure, List<DrinkListingEntity>>> call(
    SearchDrinkParams params,
  ) async {
    if (params.searchText.isEmpty) {
      return const Right([]);
    }
    return const Right([DrinkListingEntity(id: '1', name: 'Margarita')]);
  }
}

class _AlwaysFailDrinkDetailUseCase extends GetDrinkDetailUseCase {
  _AlwaysFailDrinkDetailUseCase() : super(_NoopRepository());

  @override
  Future<Either<Failure, DrinkListingEntity>> call(
    GetDrinkDetailParams params,
  ) async {
    return Left(ServerFailure(message: 'Server Error'));
  }
}

class _NoopRepository implements Repository {
  @override
  Future<Either<Failure, DrinkListingEntity>> getDrinkDetail({
    required String drinkId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<DrinkListingEntity>>> searchDrink({
    required String searchText,
  }) {
    throw UnimplementedError();
  }
}
