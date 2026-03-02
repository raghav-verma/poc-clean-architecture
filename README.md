# Flutter Clean Architecture Template

A Flutter starter template using **Clean Architecture** with **BLoC** state management, demonstrating a **cocktail drink browser** powered by [TheCocktailDB API](https://www.thecocktaildb.com/).

The app features **drink search** and **drink detail** screens with **offline caching** — serving as a reference for building scalable, testable Flutter apps using a layer-first approach.

## Architecture

```text
lib/
├── core/
│   ├── config/              # SharedPreferences wrapper
│   ├── error/               # Failures (domain) & Exceptions (data)
│   ├── network/             # Connectivity abstraction
│   ├── theme/               # Light/dark theme data, app config
│   ├── usecase/             # Abstract UseCase<T, Params> base class
│   └── utils/               # Constants, colors, fonts, routes, extensions
├── features/
│   ├── data/
│   │   ├── clients/         # Retrofit REST client (code-generated)
│   │   ├── datasources/     # Remote (API) + Local (SharedPreferences cache)
│   │   ├── model/           # Response models with toEntity() mapping
│   │   └── repositories_implementation/
│   ├── domain/
│   │   ├── entities/        # Pure Dart domain entities
│   │   ├── repositories/    # Abstract repository contracts
│   │   └── usecases/        # Single-responsibility use cases
│   └── presentation/
│       ├── screens/          # BLoC + Event + State + Screen per feature
│       └── widgets/          # Reusable UI components
├── injection.dart            # get_it dependency wiring
└── main.dart                 # App entry point
```

## Stack

| Package | Purpose |
|---|---|
| `flutter_bloc` + `bloc` | State management via BLoC pattern |
| `bloc_concurrency` | Event transformers (e.g. `restartable()` for search debouncing) |
| `get_it` | Service locator / dependency injection |
| `dio` + `retrofit` | Type-safe HTTP client with code generation |
| `json_annotation` + `json_serializable` | JSON serialization / deserialization |
| `shared_preferences` | Lightweight local cache for offline fallback |
| `hive_flutter` | Local database |
| `dartz` | Functional programming (`Either<Failure, Success>`) |
| `equatable` | Value-based equality for entities, events, and states |
| `internet_connection_checker` | Connectivity detection for online/offline strategy |
| `flutter_easyloading` | Loading overlay indicator |

## Getting Started

1. Clone the repository and rename project identifiers in `pubspec.yaml`, Android, and iOS package IDs.

2. Install dependencies:

```bash
flutter pub get
```

3. Run code generation (required for Retrofit client and JSON serialization):

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Update the API base URL in `lib/core/utils/constants.dart` if needed.

5. Run the app:

```bash
flutter run
```

## Adding a Feature

1. Add entity in `domain/entities`.
2. Extend repository contract in `domain/repositories`.
3. Add use case in `domain/usecases`.
4. Add response model in `data/model` with `toEntity()` mapping.
5. Add REST endpoint to `data/clients/rest_client.dart`.
6. Implement remote + local datasource methods.
7. Implement repository with online/offline logic.
8. Add BLoC + Event + State in `presentation/screens`.
9. Add screen widget consuming the BLoC.
10. Register all dependencies in `injection.dart`.

## Quality Gates

```bash
flutter analyze
flutter test
```

## Toolchain

- Flutter: 3.41.2
- Dart: 3.11.0
- Java: 17
