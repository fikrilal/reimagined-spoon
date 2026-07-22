# SQLite Intensive Learning Plan

## Purpose

This plan prioritizes SQLite because the available learning time is limited and
the project is expected to demonstrate more than basic CRUD.

The objective is not to produce long SQL statements. The objective is to
understand relational design, data integrity, query behavior, atomic writes,
migrations, and performance well enough to explain and debug them.

## Current Position

- Drift and SQLite are the persisted source of truth for foods.
- `FoodController` coordinates the food UI with `FoodDao`; food data survives a
  full application restart.
- The database is at schema version 6 and has generated snapshots for versions
  1 through 6.
- `foods` and `meal_entries` include database constraints, soft deletion,
  historical meal snapshots, and explicit foreign-key behavior.
- `MealEntryDao` can atomically create a meal entry from a food and query entries
  within a half-open UTC time range.
- Automated migration tests verify all supported version paths and focused data
  preservation across versions 1→2, 3→4, 4→5, and 5→6.
- A release APK was installed over an older signed APK to verify that the real
  Android update path preserves and migrates the existing database.
- Full food CRUD/search, aggregate queries, rollback tests, and query-plan
  evidence remain incomplete.

## Immediate SQLite Checkpoint

Complete query and transaction fundamentals before adding another schema
version:

1. Add food lookup by identifier.
2. Add food update and verify its affected-row count.
3. Add soft delete and prove active-food queries exclude deleted rows.
4. Add case-insensitive, parameterized food-name search.
5. Add daily and per-category calorie aggregate queries.
6. Force a transactional write to fail and prove that every write rolls back.
7. Compare `EXPLAIN QUERY PLAN` output for the meal-date query with and without
   the `meal_entries_consumed_at` index.

Do not add another migration unless a real schema requirement appears. Advanced
syntax is useful only after these behaviors are correct and tested.

## Learning Principles

### Design Before Helper Code

Do not begin with a large `DatabaseHelper`. First decide the schema, constraints,
relationships, deletion behavior, time representation, and migration strategy.

### SQL Before Flutter Integration

Practise schema and queries independently from widgets and GetX where possible.
This separates SQL mistakes from asynchronous UI and state-management mistakes.

### Integrity at Multiple Boundaries

Form validation improves user experience, but it is not the final integrity
boundary. Important invariants should also be represented by database constraints.

### Parameterize Values

Never build SQL by interpolating user input. Use placeholders and argument lists
for values. SQL identifiers such as table and column names cannot be parameterized
and should come from application-owned constants, not user input.

### Verify, Do Not Guess

Use tests, deliberate failure cases, `PRAGMA` inspection, and
`EXPLAIN QUERY PLAN` to confirm behavior.

## Dependencies

The implemented database dependencies are:

- `drift` for typed tables, queries, DAOs, and migration APIs
- `drift_flutter` for opening the Flutter database connection
- `drift_dev` and `build_runner` for generated code, schema snapshots, and
  migration tooling

Dependencies imported directly by application code should be declared directly
in `pubspec.yaml`, even when another package currently brings them transitively.

## Domain Schema

The learning schema uses two related entities so it can support joins,
aggregates, foreign keys, indexes, and transaction exercises.

```text
foods
├── id
├── name
├── calories_per_serving
├── created_at
├── updated_at
├── deleted_at
└── serving_label

meal_entries
├── id
├── food_id
├── food_name_snapshot
├── calories_per_serving_snapshot
├── serving_quantity
├── meal_category
├── consumed_at
└── created_at

foods 1 ─────── N meal_entries
```

`meal_entries.food_id` is nullable and uses `ON DELETE SET NULL`. Name and
calorie snapshots preserve historical meaning even when the current food is
edited or removed.

## Implemented Schema Decisions

The rationale and consequences of durable choices belong in `DECISIONS.md`.

### Duplicate Names

Food names are trimmed, non-empty, unique, and compared with SQLite `NOCASE`.
Therefore `Apple` and `apple` represent the same logical food. The limitation is
that SQLite's built-in `NOCASE` behavior is primarily ASCII-oriented.

### Numeric Rules

Calories may equal zero but cannot be negative. Meal-entry serving quantity must
be greater than zero. Dart validation remains responsible for rejecting
non-finite values before they reach SQLite.

### Delete Behavior

The implemented relationship uses:

- Soft deletion for ordinary food removal through `foods.deleted_at`.
- `SET NULL` if a food row is physically deleted.
- Snapshots on meal entries so historical names and calories remain stable.

This behavior must be tested before physical deletion is exposed through the UI.

### Historical Values

Editing a food must not change historical daily totals. A meal entry therefore
stores the food name and calories-per-serving values that existed when it was
recorded.

### Time Representation

With the current Drift configuration, `DateTimeColumn` values are stored as
integer timestamps. Application writes and day boundaries are normalized to UTC,
then queried as a half-open range:
`startInclusive <= consumedAt < endExclusive`.

### Meal Category

Meal categories are constrained text values: `breakfast`, `lunch`, `dinner`,
and `snack`. A separate lookup table is unnecessary unless categories become
user-configurable.

## Schema Requirements

The first real schema must deliberately use and explain:

- Integer primary keys
- `NOT NULL` constraints
- Numeric `CHECK` constraints
- A foreign key from meal entries to foods
- Explicit foreign-key delete behavior
- An explicit database version
- Creation and update timestamps
- At least one index justified by an actual query

Foreign-key enforcement must be enabled for every database connection before
dependent writes are performed.

## Query Curriculum

### Level 1: Correct CRUD

Implement and verify:

- Insert one food and return its generated identifier
- Select foods in a deterministic order
- Select one food by identifier
- Update a food and verify affected-row count
- Delete a food and verify affected-row count
- Search food names with parameterized input
- Map database rows to immutable Dart objects

Failure exercises:

- Insert a null required value
- Insert invalid calories
- Update a missing identifier
- Delete a referenced food under the chosen foreign-key policy

### Level 2: Relationships and Aggregates

Write queries that answer:

- Which meal entries were recorded for one local calendar day?
- What food name belongs to each meal entry?
- What is the total calorie consumption for a day?
- What is the total per meal category?
- Which foods have never been consumed?
- Which foods were consumed more than a chosen number of times?
- Which day has the highest total calories?

Concepts to demonstrate:

- `INNER JOIN`
- `LEFT JOIN`
- `WHERE`
- `ORDER BY`
- `GROUP BY`
- `SUM`, `COUNT`, and `AVG`
- `HAVING`
- Subqueries

### Level 3: Transactions and Atomicity

Create exercises where multiple statements must succeed or fail together:

- Insert a food and its first meal entry atomically
- Insert several meal entries as one logical operation
- Force the second statement to fail and verify rollback
- Compare a transaction with an unordered sequence of independent writes

Be able to explain:

- Why a transaction is required
- What the transaction boundary represents
- What becomes observable after commit
- What remains after rollback
- Why UI success must only be shown after commit succeeds

### Level 4: CTEs and Window Functions

After confirming the SQLite version available on the target device, practise:

- Ranking foods by total consumption
- Producing a running calorie total by date
- Calculating a rolling seven-day average
- Comparing each day's calories with the previous day
- Separating query stages with a common table expression (`WITH`)

Do not use a window function merely to make a query look advanced. Explain why
it is clearer or more efficient than an equivalent application-side loop.

### Level 5: Indexes and Query Plans

For important queries:

1. Run `EXPLAIN QUERY PLAN` before adding an index.
2. Identify scans, searches, and temporary sorting.
3. Add an index justified by the query's filter, join, or ordering needs.
4. Run the query plan again.
5. Explain the improvement and the write/storage cost of the index.

Candidate query patterns include:

- Meal entries filtered by consumption time
- Meal entries joined by `food_id`
- Foods searched or ordered by normalized name
- Composite filtering by date and meal category

Do not create indexes for every column. Each index must have a demonstrated
reader and a documented tradeoff.

## Migration Curriculum

### Version 1

Created the initial `foods` table.

### Version 2

Added `meal_entries`, including its nullable food relationship, historical
snapshots, numeric constraints, meal-category constraint, and timestamps.

### Version 3

Added nullable `foods.deleted_at` to support soft deletion.

### Version 4

Added the `meal_entries_consumed_at` index for time-range queries.

### Version 5

Added non-null `foods.serving` with a valid default so existing rows could be
backfilled safely.

### Version 6

Renamed `foods.serving` to `foods.serving_label` while preserving existing
values.

### Completed Migration Exercise

1. Generated immutable Drift schema snapshots for versions 1 through 6.
2. Used `stepByStep` migration callbacks for every adjacent version.
3. Validated every supported old-to-new schema path automatically.
4. Added focused data-integrity tests for migrations that introduce or transform
   important data.
5. Installed a newer release APK over an existing signed APK without clearing
   application data.
6. Confirmed that old rows remained available after the first database open.

Never use uninstalling the app or deleting the database as the migration
strategy. A released schema snapshot is historical evidence and must not be
edited to resemble the latest schema.

`dart run drift_dev make-migrations` is run after an intentional table or column
change and a `schemaVersion` increment. It generates the new snapshot and step
scaffolding; the developer must still implement and test the migration logic.

For a manual APK update, Android also requires the same application ID and
signing certificate, plus a higher `versionCode`. Database migration happens
when the updated application opens the database, not while the APK is copied.

## Flutter Integration Boundaries

Use this minimal flow:

```text
Widget
  ↓ user intent and rendering
FoodController
  ↓ application state and async coordination
FoodDao / MealEntryDao
  ↓ typed persistence operations and query ownership
AppDatabase
  ↓ connection, schema version, creation, migration
SQLite
```

### AppDatabase Owns

- Database path construction
- Opening one configured database connection
- Foreign-key configuration
- Schema creation
- Schema version upgrades
- Connection lifecycle

### DAOs Own

- Food and meal-entry persistence operations
- Query parameters
- Typed Drift result mapping
- Transaction boundaries that protect one logical write

### FoodController Owns

- Loading, populated, and failure state presented to the UI
- Coordinating DAO calls
- Updating reactive state only after persistence succeeds

### Widgets Own

- Input collection and validation feedback
- Rendering loading, empty, populated, and failure states
- Forwarding user intent

Widgets must not execute SQL directly.

## Implementation Order

Completed:

1. Defined schema rules and recorded the initial food decisions.
2. Implemented Drift database creation and version handling.
3. Persisted food insertion and active-food listing through `FoodDao`.
4. Loaded persisted data through `FoodController`.
5. Proved persistence across restart.
6. Added the meal-entry relationship and transactional snapshot insertion.
7. Evolved and tested schema versions 1 through 6.
8. Verified the v5→v6 upgrade through the release APK installation path.

Next:

1. Complete food CRUD and search DAO behavior with focused tests.
2. Implement and test join and aggregate queries for a local calendar day.
3. Add transaction failure and rollback tests.
4. Measure the meal-date query and justify the existing index with query-plan
   evidence.
5. Connect meal logging and summaries to GetX and Flutter.
6. Attempt a useful CTE or window-function exercise only after the preceding
   behavior is complete.

## Verification Checklist

### Schema

- Database version is explicit.
- Foreign keys are enabled and verified.
- Table and index definitions match the intended schema.
- Invalid rows are rejected by constraints.

### CRUD

- Generated identifiers are returned correctly.
- Missing-row updates and deletes are distinguished from success.
- SQL values are parameterized.
- Mapping handles SQLite value types deliberately.

### Persistence

- Data survives hot restart.
- Data survives stopping and reopening the application.
- Empty, loading, populated, and failure states are observable.

### Transactions

- Successful transactions commit every required write.
- Forced failures roll back every write in the transaction.
- The UI does not report success before commit.

### Migrations

- Every supported old-to-new schema path validates successfully.
- Focused tests prove important values survive column additions and renames.
- The migration is tested without deleting application data.
- New constraints, foreign keys, and indexes are verified.
- The release upgrade uses the same application ID and signing certificate.

### Performance

- Important query plans are recorded before and after indexing.
- Every custom index has a justified query.
- Application code does not introduce an N+1 query loop.

## Compressed Schedule

### Completed: Schema, Persistence, and Migration Reliability

- Created the relational schema and Drift integration
- Verified restart persistence
- Added schema versions 1 through 6
- Added generated and data-integrity migration tests
- Verified a manual release APK upgrade

### Next Session: CRUD, Search, and Aggregates

- Complete food lookup, update, soft delete, and search
- Practise joins and daily aggregates using meal snapshots
- Verify foreign-key and soft-delete behavior

### Final SQLite Session: Reliability and Performance

- Practise transaction commit and rollback
- Inspect the indexed and unindexed query plans
- Practise CTE and window queries where supported

## Exit Criteria

SQLite learning is complete enough for the project when the developer can:

- Explain the schema and every constraint
- Trace a persisted write from widget to SQLite and back
- Demonstrate data surviving application restart
- Demonstrate a foreign-key failure or chosen delete behavior
- Demonstrate a transaction rollback
- Write and explain a join with aggregate grouping
- Explain one migration without deleting existing data
- Compare a query plan before and after an index
- Explain one intermediate or advanced query without relying on copied syntax
