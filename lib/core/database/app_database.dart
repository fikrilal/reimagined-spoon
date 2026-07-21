import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:reimagined_spoon/features/foods/data/local/tables/foods.dart';
import '../../features/foods/data/local/daos/food_dao.dart';
import '../../features/meals/data/local/daos/meal_entry_dao.dart';
import '../../features/meals/data/local/tables/meal_entries.dart';
import 'app_database.steps.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Foods, MealEntries], daos: [FoodDao, MealEntryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'reimagined_spoon'));

  AppDatabase.forTesting(super.executor);

  OpeningDetails? _lastOpeningDetails;

  OpeningDetails? get lastOpeningDetails => _lastOpeningDetails;

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: _schemaUpgrade,
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        _lastOpeningDetails = details;
      },
    );
  }
}

extension Migrations on GeneratedDatabase {
  OnUpgrade get _schemaUpgrade => stepByStep(
    from1To2: (migrator, schema) async {
      await migrator.createTable(schema.mealEntries);
    },
    from2To3: (migrator, schema) async {
      await migrator.addColumn(schema.foods, schema.foods.deletedAt);
    },
    from3To4: (migrator, schema) async {
      await migrator.createIndex(schema.mealEntriesConsumedAt);
    },
    from4To5: (migrator, schema) async {
      await migrator.addColumn(schema.foods, schema.foods.serving);
    },
    from5To6: (migrator, schema) async {
      await migrator.renameColumn(schema.foods, 'serving', schema.foods.servingLabel);
    },
  );
}
