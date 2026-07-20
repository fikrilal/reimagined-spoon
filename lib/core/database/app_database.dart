import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:reimagined_spoon/features/foods/data/local/tables/foods.dart';
import '../../features/foods/data/local/daos/food_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Foods], daos: [FoodDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'reimagined_spoon'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
