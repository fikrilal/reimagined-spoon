# SQLite Intensive Learning Plan

## Purpose

This plan prioritizes SQLite because the available learning time is limited and
the project is expected to demonstrate more than basic CRUD.

The objective is not to produce long SQL statements. The objective is to
understand relational design, data integrity, query behavior, atomic writes,
migrations, and performance well enough to explain and debug them.

## Current Position

- The Flutter form and in-memory food list work.
- Form validation and controller disposal are implemented.
- Navigation returns a validated `FoodModel` to `HomePage`.
- A GetX `FoodController`, reactive list, and route binding exist.
- The reactive migration must be completed by removing the remaining `setState`
  dependency and proving that `Obx` rebuilds the list.
- GetX and `sqflite` are installed.
- SQLite schema, migrations, repositories, and queries are not implemented.

## Immediate GetX Timebox

Spend no more than 15 minutes completing the current GetX checkpoint:

1. Remove the remaining `setState` around `FoodController.addFood`.
2. Confirm that `Obx` updates the empty state and list.
3. Remove duplicate and unused imports.
4. Run `flutter analyze` and record the result.
5. Preserve the checkpoint in source control when the intended files are staged.

Do not add more GetX abstractions before starting SQLite.

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

The intended Flutter dependencies are:

- `sqflite` for platform SQLite access
- `path` for constructing the database path

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
└── updated_at

meal_entries
├── id
├── food_id
├── servings
├── meal_type
├── consumed_at
└── created_at

foods 1 ─────── N meal_entries
```

## Decisions Required Before DDL

Record the answers in `DECISIONS.md` before treating the schema as final.

### Duplicate Names

Decide whether food names are unique and whether uniqueness is case-sensitive.
For example, determine whether `Apple` and `apple` represent the same food.

### Numeric Rules

Decide whether calories may equal zero or must be greater than zero. Decide the
valid range for servings.

### Delete Behavior

Choose what happens to meal entries when their referenced food is deleted:

- `RESTRICT`: prevent deletion while history references the food
- `CASCADE`: delete the related history
- `SET NULL`: preserve history without the active food reference

The choice must match the product behavior, not convenience.

### Historical Values

Decide whether editing a food's calories should change historical daily totals.
If history must remain stable, a meal entry needs a snapshot of the relevant
food values at the time it is recorded.

### Time Representation

Choose how timestamps are stored, for example UTC epoch integers or normalized
ISO-8601 text. Document how local calendar days are derived from the stored value.

### Meal Category

Decide whether meal categories are constrained text values or a separate table.
For this one-week project, constrained text is sufficient unless categories must
be user-configurable.

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

Create the smallest schema that supports food persistence and CRUD.

### Version 2

Add meal entries, their relationship, constraints, and required indexes.

### Migration Exercise

1. Install or create a version-1 database with existing food rows.
2. Upgrade to version 2 without deleting the database.
3. Verify that version-1 data remains available.
4. Verify the new schema using SQLite metadata or `PRAGMA` queries.
5. Verify foreign-key and index behavior.

Never use uninstalling the app or deleting the database as the migration
strategy.

## Flutter Integration Boundaries

Use this minimal flow:

```text
Widget
  ↓ user intent and rendering
FoodController
  ↓ application state and async coordination
FoodRepository
  ↓ food persistence operations and SQL ownership
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

### FoodRepository Owns

- Food CRUD SQL
- Query parameters
- Row-to-model mapping
- Meaningful persistence errors

### FoodController Owns

- Loading, populated, and failure state presented to the UI
- Coordinating repository calls
- Updating reactive state only after persistence succeeds

### Widgets Own

- Input collection and validation feedback
- Rendering loading, empty, populated, and failure states
- Forwarding user intent

Widgets must not execute SQL directly.

## Implementation Order

1. Complete the small GetX checkpoint.
2. Decide schema behavior and record decisions.
3. Write and inspect version-1 DDL.
4. Implement `AppDatabase` creation and version handling.
5. Implement food row mapping.
6. Implement and test food CRUD in `FoodRepository`.
7. Load repository data through `FoodController`.
8. Prove persistence across a full application restart.
9. Add version-2 meal-entry schema through a migration.
10. Implement join and aggregate queries.
11. Add transaction failure tests.
12. Measure important queries and add justified indexes.
13. Attempt CTE and window-function exercises after version verification.

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

- Existing version-1 data survives the version-2 upgrade.
- The migration is tested without deleting the database.
- New constraints, foreign keys, and indexes are verified.

### Performance

- Important query plans are recorded before and after indexing.
- Every custom index has a justified query.
- Application code does not introduce an N+1 query loop.

## Compressed Schedule

### Session 1: Schema and Food Persistence

- Finish GetX timebox
- Make and record schema decisions
- Implement version-1 food schema
- Implement food CRUD
- Verify restart persistence

### Session 2: Relationships and Aggregates

- Add version-2 migration
- Add meal-entry relationship
- Practise joins and daily aggregates
- Verify foreign-key behavior

### Session 3: Reliability and Performance

- Practise transaction commit and rollback
- Inspect query plans
- Add justified indexes
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
