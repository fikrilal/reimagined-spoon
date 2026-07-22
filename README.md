# Offline Nutrition Tracker

A small Flutter application for practising Dart, Flutter, GetX, and SQLite
fundamentals.

This is a learning project, not a production nutrition or medical application.
Its purpose is to develop a clear understanding of UI state, controller
lifecycle, asynchronous operations, relational data, and local persistence.

## Status

Food creation and listing now use a GetX controller backed by Drift and SQLite.
The database is at schema version 6 and includes foods, meal entries, soft
deletion support, historical meal snapshots, and an index for consumption-time
queries.

Schema upgrades from versions 1 through 6 are covered by generated schema
snapshots and migration tests. The version-5 to version-6 upgrade has also been
verified by installing a newer release APK over an existing installation and
confirming that persisted data survives.

The next milestone is to complete food CRUD and search, then expose meal logging
and daily aggregate queries through the application UI.

## Core Features

- Create, view, edit, and delete food records
- Search foods by name
- Add foods to a daily meal log
- View foods recorded for a selected day
- View a simple daily calorie summary
- Persist data locally with SQLite
- Handle loading, empty, validation, success, and failure states

See [Project Brief](docs/PROJECT_BRIEF.md) for the complete scope.

## Learning Objectives

The project focuses on:

- Dart null safety and asynchronous programming
- Flutter widget composition and lifecycle
- GetX reactive state, dependency management, and controller lifecycle
- SQLite schema design, CRUD, transactions, and migrations
- Separation between presentation, application, and persistence concerns
- Unit, widget, and database testing

See [Learning Roadmap](docs/LEARNING_ROADMAP.md) for the planned sequence.

## Prerequisites

- Flutter SDK with Dart 3.11 or a compatible version
- An Android emulator, iOS simulator, desktop target, or physical device
- A code editor with Flutter support

## Commands

Fetch dependencies:

```sh
flutter pub get
```

Run static analysis:

```sh
flutter analyze
```

Run tests:

```sh
flutter test
```

Run the database migration tests only:

```sh
flutter test test/drift/app_database/migration_test.dart
```

Regenerate Drift code after changing Drift tables, DAOs, or database
declarations:

```sh
dart run build_runner build --delete-conflicting-outputs
```

After intentionally changing the schema and incrementing `schemaVersion`,
generate the new immutable schema snapshot and migration step once:

```sh
dart run drift_dev make-migrations
```

Run the application:

```sh
flutter run
```

## Project Structure

```text
lib/
├── core/
│   ├── bindings/       # Application-level dependency registration
│   ├── controllers/    # Cross-feature application state
│   └── database/       # Drift database, generated code, and migration steps
├── features/
│   ├── foods/          # Food model, table, DAO, controller, and views
│   ├── meals/          # Meal-entry table and DAO
│   └── home/           # Current food-list screen
└── navigation/         # GetX routes

test/
├── drift/              # Versioned schema snapshots and migration tests
└── features/           # Focused DAO tests
```

## Documentation

- [Project Brief](docs/PROJECT_BRIEF.md)
- [Learning Roadmap](docs/LEARNING_ROADMAP.md)
- [SQLite Intensive Plan](docs/SQLITE_LEARNING_PLAN.md)
- [Engineering Journal](docs/ENGINEERING_JOURNAL.md)
- [Engineering Decisions](docs/DECISIONS.md)

## Constraints

- Offline only
- No authentication
- No remote API
- No cloud synchronization
- No medical or dietary recommendations
- No production release requirement

## Disclaimer

Nutrition values in this project are manually entered and are not verified.
The application must not be treated as a source of medical advice.
