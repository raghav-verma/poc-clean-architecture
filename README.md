# Flutter Clean Architecture Template

A Flutter starter template using Clean Architecture, BLoC, dependency injection, network layer, and local cache fallback.

## Architecture

```text
lib/
|- core/
|  |- config/              # shared preferences + local database providers
|  |- error/               # failures and exceptions
|  |- main_bloc/           # app-level auth/session state
|  |- network/             # connectivity abstraction
|  |- theme/
|  |- usecase/
|  `- utils/
|- features/
|  |- data/
|  |  |- clients/          # retrofit client
|  |  |- datasources/      # remote + local
|  |  |- model/
|  |  `- repositories_implementation/
|  |- domain/
|  |  |- entities/
|  |  |- repositories/
|  |  `- usecases/
|  `- presentation/
|     `- screens/
|- injection.dart          # get_it wiring
`- main.dart               # app entry point
```

## Stack

- `flutter_bloc` + `bloc`
- `get_it`
- `dio` + `retrofit`
- `shared_preferences` + `hive_flutter`
- `dartz` + `equatable`
- `internet_connection_checker`

## Getting Started

1. Rename project identifiers in `pubspec.yaml`, Android, and iOS package IDs.
2. Run:

```bash
flutter pub get
```

3. Update API base URL in `lib/core/utils/constants.dart`.
4. Run the app:

```bash
flutter run
```

## Adding a Feature

1. Add entity in `domain/entities`.
2. Extend repository contract in `domain/repositories`.
3. Add use case in `domain/usecases`.
4. Add data source methods + response models.
5. Implement repository mapping/error handling.
6. Add BLoC + event + state in `presentation`.
7. Add screen and route.
8. Register dependencies in `injection.dart`.

## Quality Gates

```bash
flutter analyze
flutter test
```

## Toolchain

- Flutter: 3.41.2
- Dart: 3.11.0
- Java: 17
