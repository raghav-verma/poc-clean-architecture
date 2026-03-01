import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_template/core/error/exceptions.dart';
import 'package:flutter_clean_arch_template/core/error/failures.dart';
import 'package:flutter_clean_arch_template/core/network/network_info.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/features/data/datasources/local_datasource/local_datasource.dart';
import 'package:flutter_clean_arch_template/features/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:flutter_clean_arch_template/features/data/model/responses/drink_listing_response_model.dart';
import 'package:flutter_clean_arch_template/features/data/repositories_implementation/repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_implementation_test.mocks.dart';

@GenerateMocks([RemoteDatasource, LocalDatasource, NetworkInfo])
void main() {
  late RepositoryImplementation repository;
  late MockRemoteDatasource mockRemoteDatasource;
  late MockLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RepositoryImplementation(
      remoteDataSource: mockRemoteDatasource,
      localDataSource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );

    when(mockLocalDatasource.saveListing(any)).thenAnswer((_) {});
    when(mockLocalDatasource.getListing()).thenReturn([]);
  });

  const tSearchText = 'margarita';
  final tDrinkModel = DrinkModel(
    idDrink: '1',
    strDrink: 'Margarita',
    strDrinkThumb: 'https://example.com/margarita.jpg',
    strInstructions: 'Mix and serve',
  );
  final tResponseModel = DrinkListingResponseModel(drinks: [tDrinkModel]);

  void setNetworkConnected(bool connected) {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => connected);
  }

  group('searchDrink', () {
    test('checks if the device is online', () async {
      setNetworkConnected(true);
      when(
        mockRemoteDatasource.searchDrink(searchText: tSearchText),
      ).thenAnswer((_) async => tResponseModel);

      await repository.searchDrink(searchText: tSearchText);

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() => setNetworkConnected(true));

      test('returns remote data and caches it on success', () async {
        when(
          mockRemoteDatasource.searchDrink(searchText: tSearchText),
        ).thenAnswer((_) async => tResponseModel);

        final result = await repository.searchDrink(searchText: tSearchText);

        expect(result, isA<Right<Failure, List<dynamic>>>());
        verify(mockRemoteDatasource.searchDrink(searchText: tSearchText));
        verify(mockLocalDatasource.saveListing(any)).called(1);
      });

      test('returns remote data even when cache write fails', () async {
        when(
          mockRemoteDatasource.searchDrink(searchText: tSearchText),
        ).thenAnswer((_) async => tResponseModel);
        when(
          mockLocalDatasource.saveListing(any),
        ).thenThrow(CacheException(message: 'Cache write failed'));

        final result = await repository.searchDrink(searchText: tSearchText);

        expect(result, isA<Right<Failure, List<dynamic>>>());
        verify(mockRemoteDatasource.searchDrink(searchText: tSearchText));
      });

      test(
        'returns ServerFailure when remote throws ServerException',
        () async {
          when(
            mockRemoteDatasource.searchDrink(searchText: tSearchText),
          ).thenThrow(ServerException(message: 'Server Error'));

          final result = await repository.searchDrink(searchText: tSearchText);

          expect(result, Left(ServerFailure(message: 'Server Error')));
        },
      );

      test('returns ServerFailure when response has null drinks', () async {
        when(
          mockRemoteDatasource.searchDrink(searchText: tSearchText),
        ).thenAnswer((_) async => DrinkListingResponseModel(drinks: null));

        final result = await repository.searchDrink(searchText: tSearchText);

        expect(
          result,
          Left(ServerFailure(message: Constants.errorNoDataFound)),
        );
      });
    });

    group('device is offline', () {
      setUp(() => setNetworkConnected(false));

      test('returns cached drinks when cache exists', () async {
        when(mockLocalDatasource.getListing()).thenReturn([tDrinkModel]);

        final result = await repository.searchDrink(searchText: tSearchText);

        expect(result, isA<Right<Failure, List<dynamic>>>());
        verify(mockLocalDatasource.getListing()).called(1);
        verifyZeroInteractions(mockRemoteDatasource);
      });

      test('returns no-internet failure when cache is empty', () async {
        when(mockLocalDatasource.getListing()).thenReturn([]);

        final result = await repository.searchDrink(searchText: tSearchText);

        expect(result, Left(ServerFailure(message: Constants.errorNoInternet)));
        verify(mockLocalDatasource.getListing()).called(1);
        verifyZeroInteractions(mockRemoteDatasource);
      });

      test(
        'returns CacheFailure when cache read throws CacheException',
        () async {
          when(
            mockLocalDatasource.getListing(),
          ).thenThrow(CacheException(message: 'Cache read failed'));

          final result = await repository.searchDrink(searchText: tSearchText);

          expect(result, Left(CacheFailure(message: 'Cache read failed')));
          verifyZeroInteractions(mockRemoteDatasource);
        },
      );
    });
  });
}
