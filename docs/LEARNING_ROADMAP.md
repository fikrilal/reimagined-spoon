# Learning Roadmap

## Objective

Build a small offline nutrition tracker while developing a practical
understanding of Dart, Flutter, GetX, and SQLite. The roadmap measures
understanding, not only completed screens.

## Working Method

For each milestone:

1. Read the relevant fundamentals.
2. Describe the intended behavior.
3. Propose a small design.
4. Implement it independently.
5. Run the relevant checks.
6. Review the result.
7. Record lessons and open questions in the engineering journal.

## Day 1: Dart and Flutter Foundations

### Topics

- Project configuration and intended tooling
- Dart null safety, collections, and object ownership
- Futures, `async`, `await`, and exceptions
- Widget composition and state
- Build and rebuild behavior
- Forms and validation

### Practical Goal

Create the application shell and a non-persisted food form and list. Use
temporary in-memory data only; do not introduce SQLite yet.

### Questions to Answer

- What is the difference between a widget and its rendered state?
- What causes a widget subtree to rebuild?
- Why must `build` avoid side effects?
- What does `await` do to control flow?
- How does an asynchronous exception reach its caller?
- When is a nullable type appropriate?
- Where should form validation occur?

### Exit Criteria

- A food can be entered and displayed in memory.
- Invalid input is rejected with a useful message.
- State ownership and rebuild behavior can be explained.
- Static analysis has been run and its result recorded.

## Day 2: GetX Fundamentals

### Topics

- Observable state and `Obx` rebuild scope
- Controllers and their lifecycle
- Dependency registration and lookup
- Bindings and navigation
- UI state versus business data
- Hidden dependency risks

### Practical Goal

Move the in-memory food workflow to deliberate GetX state management.

### Questions to Answer

- What does `.obs` create?
- How does `Obx` determine which observables it watches?
- What is the rebuild scope of each reactive widget?
- Who creates and disposes each controller?
- What is the difference between dependency injection and global access?
- Which state belongs in a controller and which can remain in a widget?
- What would ordinary Flutter look like without GetX?

### Exit Criteria

- Each use of GetX has a stated purpose.
- Controller ownership and lifecycle can be explained.
- Reactive rebuilds are kept reasonably focused.
- The developer can describe what GetX abstracts from Flutter.

## Day 3: SQLite Fundamentals

### Topics

- Relational schema design
- Primary keys, foreign keys, and constraints
- CRUD and parameterized queries
- Transactions
- Schema versions and migrations
- Row-to-model mapping
- Database error propagation

### Practical Goal

Persist foods locally and verify that they survive an application restart. Then
design the relationship between foods and meal entries.

### Questions to Answer

- Why is SQLite the source of truth rather than the controller?
- What constraints belong in the database?
- What happens to meal entries when a food is deleted?
- Why should query parameters not be interpolated into SQL?
- When is a transaction required?
- How is a database row mapped into a Dart object?
- How will schema version two be introduced safely?

### Exit Criteria

- Food CRUD uses SQLite.
- Data survives restart.
- The schema has an explicit version.
- Constraints and deletion behavior are deliberate.
- Persistence failures reach the application layer.
- Database behavior has focused tests.

## Day 4: End-to-End Behavior

### Topics

- Connecting widgets, controllers, repositories, and persistence
- Loading and failure states
- Date and time handling
- Derived totals
- Duplicate submission prevention
- Resource lifecycle and error recovery

### Practical Goal

Implement meal logging and the daily summary.

### Questions to Answer

- What happens from button press to database write?
- When does the UI show success?
- What prevents duplicate submissions?
- Is the daily total stored or derived, and why?
- How are calendar dates represented?
- What happens if a write fails halfway through?
- What state must be refreshed after a mutation?

### Exit Criteria

- A food can be added to a daily meal log.
- Daily entries and calorie totals are displayed.
- Entries can be deleted.
- Relevant loading, empty, validation, and failure states exist.
- Failed writes do not produce false success.
- The complete data flow can be traced and explained.

## Day 5: Verification and Review

### Topics

- Unit, widget, and database tests
- Static analysis
- Naming and responsibility review
- Documentation
- Demonstration preparation

### Practical Goal

Verify the important behaviors and prepare a short technical walkthrough.

### Questions to Answer

- Which behavior is most likely to regress?
- Which tests provide meaningful confidence?
- Are tests checking behavior or implementation details?
- Which controller has too many responsibilities?
- Which dependency is hardest to replace in a test?
- What would need to change before production use?
- What was learned that transfers beyond GetX?

### Exit Criteria

- Relevant tests and static analysis have been run.
- Known limitations and meaningful decisions are documented.
- The README reflects the actual repository.
- The final demonstration can be given without relying on notes for basic
  architectural explanations.

## Final Demonstration

The demonstration should take approximately 10–15 minutes:

1. Explain the project goal and scope.
2. Create and validate a food.
3. Restart the application and show persistence.
4. Edit or delete a food.
5. Add a food to a daily meal log.
6. Show the calculated daily total.
7. Explain one loading or failure path.
8. Trace one user action from widget to SQLite and back.
9. Explain one GetX lifecycle decision.
10. Explain one database design tradeoff.
11. Show the most valuable automated tests.
12. Describe one limitation and the next sensible improvement.

## Stretch Work

Only consider stretch work after every definition-of-done item is satisfied.
Choose at most one:

- Add and verify a database migration.
- Add an index and justify it with a query.
- Add another nutrition field.
- Improve accessibility.
- Add a more explicit error-recovery flow.
