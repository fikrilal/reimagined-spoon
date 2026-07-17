# Offline Nutrition Tracker

A small Flutter application for practising Dart, Flutter, GetX, and SQLite
fundamentals.

This is a learning project, not a production nutrition or medical application.
Its purpose is to develop a clear understanding of UI state, controller
lifecycle, asynchronous operations, relational data, and local persistence.

## Status

Planning and project setup.

GetX and SQLite dependencies have not been selected or added yet. Choosing and
explaining those dependencies is part of the learning exercise.

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

Run the application:

```sh
flutter run
```

## Project Structure

Document the actual structure after the first implementation milestone. Do not
design a large folder hierarchy in advance; add boundaries when concrete
responsibilities require them.

## Documentation

- [Project Brief](docs/PROJECT_BRIEF.md)
- [Learning Roadmap](docs/LEARNING_ROADMAP.md)
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
