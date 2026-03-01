import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/search_drink_use_case.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_listing_screen/drink_listing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'drink_listing_bloc_test.mocks.dart';

@GenerateMocks([SearchDrinkUseCase])
void main() {
  late MockSearchDrinkUseCase mockSearchDrinkUseCase;

  setUp(() {
    mockSearchDrinkUseCase = MockSearchDrinkUseCase();
  });

  const tSearchText = 'margarita';
  final tDrinkList = [
    const DrinkListingEntity(
      id: '1',
      name: 'Margarita',
      url: 'https://example.com/margarita.jpg',
      description: 'A classic cocktail',
    ),
  ];

  group('DrinkListingBloc', () {
    blocTest<DrinkListingBloc, DrinkListingState>(
      'emits [DrinkLoadedState(empty)] and skips use case for empty query',
      build: () {
        return DrinkListingBloc(searchDrinkUseCase: mockSearchDrinkUseCase);
      },
      act: (bloc) => bloc.add(const SearchDrinkEvent(searchText: '   ')),
      expect: () => [
        isA<DrinkLoadedState>().having(
          (s) => s.drinkList,
          'empty list',
          isEmpty,
        ),
      ],
      verify: (_) {
        verifyNever(mockSearchDrinkUseCase.call(any));
      },
    );

    blocTest<DrinkListingBloc, DrinkListingState>(
      'emits [DrinkLoadingState, DrinkLoadedState] when search succeeds',
      build: () {
        when(
          mockSearchDrinkUseCase.call(any),
        ).thenAnswer((_) async => Right(tDrinkList));
        return DrinkListingBloc(searchDrinkUseCase: mockSearchDrinkUseCase);
      },
      act: (bloc) => bloc.add(const SearchDrinkEvent(searchText: tSearchText)),
      expect: () => [
        isA<DrinkLoadingState>(),
        isA<DrinkLoadedState>()
            .having((s) => s.drinkList.length, 'list length', 1)
            .having(
              (s) => s.drinkList.first.name,
              'first drink name',
              'Margarita',
            ),
      ],
      verify: (_) {
        verify(mockSearchDrinkUseCase.call(any)).called(1);
      },
    );

    blocTest<DrinkListingBloc, DrinkListingState>(
      'emits [DrinkLoadingState, DrinkErrorState] when search fails with ServerFailure',
      build: () {
        when(
          mockSearchDrinkUseCase.call(any),
        ).thenAnswer((_) async => Left(ServerFailure(message: 'Server Error')));
        return DrinkListingBloc(searchDrinkUseCase: mockSearchDrinkUseCase);
      },
      act: (bloc) => bloc.add(const SearchDrinkEvent(searchText: tSearchText)),
      expect: () => [
        isA<DrinkLoadingState>(),
        isA<DrinkErrorState>().having(
          (s) => s.message,
          'error message',
          'Server Error',
        ),
      ],
    );

    blocTest<DrinkListingBloc, DrinkListingState>(
      'emits [DrinkLoadingState, DrinkErrorState] when search fails with CacheFailure',
      build: () {
        when(
          mockSearchDrinkUseCase.call(any),
        ).thenAnswer((_) async => Left(CacheFailure(message: 'Cache Error')));
        return DrinkListingBloc(searchDrinkUseCase: mockSearchDrinkUseCase);
      },
      act: (bloc) => bloc.add(const SearchDrinkEvent(searchText: tSearchText)),
      expect: () => [
        isA<DrinkLoadingState>(),
        isA<DrinkErrorState>().having(
          (s) => s.message,
          'error message',
          'Cache Error',
        ),
      ],
    );

    blocTest<DrinkListingBloc, DrinkListingState>(
      'maps unknown failures to generic no-internet message',
      build: () {
        when(
          mockSearchDrinkUseCase.call(any),
        ).thenAnswer((_) async => Left(_UnknownFailure()));
        return DrinkListingBloc(searchDrinkUseCase: mockSearchDrinkUseCase);
      },
      act: (bloc) => bloc.add(const SearchDrinkEvent(searchText: tSearchText)),
      expect: () => [
        isA<DrinkLoadingState>(),
        isA<DrinkErrorState>().having(
          (s) => s.message,
          'error message',
          Constants.errorNoInternet,
        ),
      ],
    );

    blocTest<DrinkListingBloc, DrinkListingState>(
      'keeps only the latest query result when requests overlap',
      build: () {
        when(mockSearchDrinkUseCase.call(any)).thenAnswer((invocation) async {
          final params =
              invocation.positionalArguments.first as SearchDrinkParams;

          if (params.searchText == 'first') {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return const Right([DrinkListingEntity(id: '1', name: 'First')]);
          }

          return const Right([DrinkListingEntity(id: '2', name: 'Second')]);
        });
        return DrinkListingBloc(searchDrinkUseCase: mockSearchDrinkUseCase);
      },
      act: (bloc) async {
        bloc.add(const SearchDrinkEvent(searchText: 'first'));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        bloc.add(const SearchDrinkEvent(searchText: 'second'));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<DrinkLoadingState>(),
        isA<DrinkLoadedState>().having(
          (s) => s.drinkList.first.name,
          'latest result',
          'Second',
        ),
      ],
    );

    test('initial state is DrinkListingInitial', () {
      final bloc = DrinkListingBloc(searchDrinkUseCase: mockSearchDrinkUseCase);
      expect(bloc.state, isA<DrinkListingInitial>());
    });
  });
}

class _UnknownFailure extends Failure {}
