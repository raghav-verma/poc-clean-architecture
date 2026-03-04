import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_clean_arch_template/core/theme/app_config.dart';
import 'package:flutter_clean_arch_template/core/theme/data/custom_theme_data.dart';
import 'package:flutter_clean_arch_template/core/utils/app_colors.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';
import 'package:flutter_clean_arch_template/core/utils/routes.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_listing_screen/drink_listing_bloc.dart';
import 'package:flutter_clean_arch_template/features/domain/entities/drink_listing_entity.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_detail_screen/drink_detail_bloc.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_detail_screen/drink_detail_screen.dart';
import 'package:flutter_clean_arch_template/features/presentation/screens/drink_listing_screen/drink_listing_screen.dart';
import 'package:flutter_clean_arch_template/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: AppColors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final DrinkListingBloc _drinkListingBloc;

  @override
  void initState() {
    super.initState();
    _drinkListingBloc = locator<DrinkListingBloc>();
  }

  @override
  void dispose() {
    _drinkListingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      locale: const Locale('en'),
      builder: EasyLoading.init(),
      supportedLocales: const [Locale('en')],
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: locator<AppConfig>().themeMode,
      home: _buildDrinkListingScreen(),
      routes: _registerRoutes(),
    );
  }

  /// All the routes for this Application are defined here
  Map<String, WidgetBuilder> _registerRoutes() {
    return {
      AppRoutes.drinkListingScreen: (context) => _buildDrinkListingScreen(),
      AppRoutes.drinkDetailScreen: (context) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if (arguments is! DrinkListingEntity) {
          return const _InvalidRouteScreen(
            message: 'Drink details are unavailable for this route.',
          );
        }
        final drink = arguments;
        return BlocProvider<DrinkDetailBloc>(
          create: (context) =>
              locator<DrinkDetailBloc>()
                ..add(GetDrinkDetailEvent(drinkId: drink.id)),
          child: DrinkDetailScreen(drink: drink),
        );
      },
    };
  }

  Widget _buildDrinkListingScreen() {
    return BlocProvider<DrinkListingBloc>.value(
      value: _drinkListingBloc,
      child: const DrinkListingScreen(),
    );
  }
}

class _InvalidRouteScreen extends StatelessWidget {
  final String message;

  const _InvalidRouteScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
