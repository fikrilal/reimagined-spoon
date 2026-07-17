# Project Brief

## Project

Offline Nutrition Tracker

## Problem Statement

A user needs a simple way to maintain a personal list of foods and record which
foods they consumed on a given day. The application must work without an internet
connection and preserve its data across application restarts.

## Learning Purpose

This project exists to practise:

- Building forms, lists, and navigation with Flutter
- Managing reactive UI state and dependencies with GetX
- Persisting relational data with SQLite
- Handling asynchronous operations and failures explicitly
- Testing business and persistence behavior

The application is an educational exercise, not a production nutrition product.

## Target User

A single local user who wants to record basic daily food consumption. There are
no user accounts and no data synchronization.

## Core Entities

### Food

Represents a reusable food record.

Suggested information:

- Unique identifier
- Name
- Calories per serving
- Date created
- Date last updated

Additional nutrition fields should not be added until the core workflow works.

### Meal Entry

Represents a food consumed on a particular date.

Suggested information:

- Unique identifier
- Food reference
- Serving quantity
- Meal category
- Consumption timestamp
- Date created

The developer must decide what data should be copied into the meal entry and
what should remain referenced from the food record.

## Required Use Cases

### Manage Foods

The user can:

- View all foods
- Create a food
- Edit a food
- Delete a food
- Search foods by name

### Record Consumption

The user can:

- Select a food
- Enter a serving quantity
- Select a meal category
- Add the entry to a daily log

Initial meal categories are breakfast, lunch, dinner, and snack.

### View a Daily Log

The user can:

- Select a date
- View meal entries for that date
- View the total calculated calories
- Delete an incorrect meal entry

## Required Application States

Relevant screens must deliberately handle:

- Initial state
- Loading state
- Empty state
- Populated state
- Validation failure
- Persistence failure

A spinner alone is not an error-handling strategy.

## Validation Rules

At minimum:

- Food name must not be empty after trimming whitespace.
- Food calories must be a valid non-negative number.
- Serving quantity must be greater than zero.
- A meal category must be selected.
- Invalid input must not be written to the database.

The developer should decide whether duplicate food names are allowed and record
the decision in `DECISIONS.md`.

## Persistence Requirements

- SQLite is the source of truth for persisted data.
- Data must survive an application restart.
- The schema must have an explicit version.
- Tables must use primary keys.
- Relationships must be represented deliberately.
- Foreign-key behavior must be explicitly chosen and tested.
- Multi-step writes that must succeed together must use a transaction.
- Database errors must not be silently ignored.

## Non-Functional Requirements

### Maintainability

- Names should reveal responsibility.
- UI code should not directly execute SQL.
- Persistence details should not leak unnecessarily into widgets.
- Controllers should not become unrelated collections of application behavior.

### Reliability

- Repeated button presses must not unintentionally create duplicate records.
- Failed writes must not leave the UI displaying unpersisted success.
- Resources must be disposed according to their lifecycle requirements.

### Usability

- Forms must communicate why input is invalid.
- Destructive actions must be deliberate.
- Empty screens must tell the user what to do next.
- Long food lists must remain searchable.

### Testability

Important behavior should be testable without manually running the entire app.

## Out of Scope

The first version will not include:

- Authentication or multiple users
- Remote APIs or cloud synchronization
- Barcode scanning or images
- Push notifications
- Diet recommendations or weight tracking
- Advanced charts
- Import or export
- Localization
- Production deployment

These exclusions may only be reconsidered after the core project is complete.

## Definition of Done

The project is complete when:

- All required use cases work.
- Data survives an application restart.
- Validation prevents invalid writes.
- Loading, empty, success, and failure states are represented.
- The database schema and relationship behavior can be explained.
- Relevant static analysis completes without unresolved issues.
- Important business and database behavior has automated tests.
- The developer can explain when and why the UI rebuilds.
- The developer can explain each GetX dependency and its lifecycle.
- The developer can explain the flow from a user action to SQLite and back.
- Known limitations and tradeoffs are documented.
- A short end-to-end demonstration can be completed without hidden setup.
