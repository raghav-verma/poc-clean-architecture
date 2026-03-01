import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_clean_arch_template/core/config/my_shared_pref.dart';
import 'package:flutter_clean_arch_template/core/network/network_info.dart';
import 'package:flutter_clean_arch_template/core/theme/app_config.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/features/data/clients/rest_client.dart';
import 'package:flutter_clean_arch_template/features/data/datasources/local_datasource/local_datasource.dart';
import 'package:flutter_clean_arch_template/features/data/datasources/remote_datasource/remote_datasource.dart';
import 'package:flutter_clean_arch_template/features/data/repositories_implementation/repository_implementation.dart';
import 'package:flutter_clean_arch_template/features/domain/repositories/repository.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/get_drink_detail_use_case.dart';
import 'package:flutter_clean_arch_template/features/domain/usecases/search_drink_use_case.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_detail_screen/drink_detail_bloc.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_listing_screen/drink_listing_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  if (locator.isRegistered<RestClient>()) {
    return;
  }

  // BLoCs

  locator.registerFactory(
    () => DrinkListingBloc(searchDrinkUseCase: locator()),
  );

  locator.registerFactory(
    () => DrinkDetailBloc(getDrinkDetailUseCase: locator()),
  );

  // UseCases

  locator.registerLazySingleton(() => SearchDrinkUseCase(locator()));
  locator.registerLazySingleton(() => GetDrinkDetailUseCase(locator()));

  //DataSources

  locator.registerLazySingleton<LocalDatasource>(
    () => LocalDatasourceImplementation(mySharedPref: locator()),
  );

  locator.registerLazySingleton<RemoteDatasource>(
    () => RemoteDatasourceImplementation(client: locator()),
  );

  // Repository
  locator.registerLazySingleton<Repository>(
    () => RepositoryImplementation(
      localDataSource: locator(),
      remoteDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // Core Services

  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImplementation(locator()),
  );

  locator.registerLazySingleton<MySharedPref>(() => MySharedPref(locator()));

  locator.registerLazySingleton<AppConfig>(() => AppConfig());

  // External Dependencies

  // Dio
  final dio = Dio(BaseOptions(baseUrl: Constants.baseUrl));
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseHeader: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        error: true,
      ),
    );
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  locator.registerLazySingleton(() => RestClient(dio));
  locator.registerLazySingleton(() => InternetConnectionChecker.instance);
}
