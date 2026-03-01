import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/domain/repositories/repository.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/search_drink_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_drink_use_case_test.mocks.dart';

/// ---------------------------------------------------------------------------
/// Domain Layer Test: SearchDrinkUseCase
///
/// WHY THIS TEST EXISTS:
/// - Use cases are the core business logic — they MUST be tested in isolation.
/// - The only dependency is the Repository interface, which we mock.
/// - We verify that the use case correctly delegates to the repository and
///   returns the result without modifying it.
///
/// PATTERN FOR NEW USE CASES:
/// 1. Mock the Repository (already generated below).
/// 2. Write a test for the success path (Right).
/// 3. Write a test for the failure path (Left).
/// ---------------------------------------------------------------------------

@GenerateMocks([Repository])
void main() {
  late SearchDrinkUseCase useCase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    useCase = SearchDrinkUseCase(mockRepository);
  });

  // ---- Test data ----
  final tSearchText = 'margarita';
  final tDrinkList = [
    DrinkListingEntity(
      id: '1',
      name: 'Margarita',
      url: 'https://example.com/margarita.jpg',
      description: 'A classic cocktail',
    ),
  ];

  group('SearchDrinkUseCase', () {
    test(
      'should return a list of drinks from the repository on success',
      () async {
        // Arrange — tell the mock what to return
        when(
          mockRepository.searchDrink(searchText: tSearchText),
        ).thenAnswer((_) async => Right(tDrinkList));

        // Act — call the use case
        final result = await useCase(
          SearchDrinkParams(searchText: tSearchText),
        );

        // Assert — verify the result and that the repo was called correctly
        expect(result, Right(tDrinkList));
        verify(mockRepository.searchDrink(searchText: tSearchText));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return ServerFailure when the repository fails', () async {
      // Arrange
      final tFailure = ServerFailure(message: 'Server Error');
      when(
        mockRepository.searchDrink(searchText: tSearchText),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase(SearchDrinkParams(searchText: tSearchText));

      // Assert
      expect(result, Left(tFailure));
      verify(mockRepository.searchDrink(searchText: tSearchText));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
