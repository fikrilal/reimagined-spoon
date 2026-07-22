import 'package:drift/drift.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';
import 'package:reimagined_spoon/features/foods/data/local/tables/foods.dart';

part 'food_dao.g.dart';

@DriftAccessor(tables: [Foods])
class FoodDao extends DatabaseAccessor<AppDatabase> with _$FoodDaoMixin {
  FoodDao(super.database);

  Future<int> insertFood({
    required String name,
    required double caloriesPerServing,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return into(foods).insert(
      FoodsCompanion.insert(
        name: name,
        caloriesPerServing: caloriesPerServing,
        createdAt: createdAt,
        updatedAt: updatedAt,
      ),
    );
  }

  Future<List<Food>> getActiveFoods() {
    final query = select(foods)
      ..where((food) => food.deletedAt.isNull())
      ..orderBy([(table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }

  Future<Food?> getActiveFoodById(int id) {
    final query = select(foods)..where((food) => food.id.equals(id) & food.deletedAt.isNull());
    return query.getSingleOrNull();
  }

  Future<int> updateFood({
    required int id,
    required String name,
    required double caloriesPerServing,
    required String servingLabel,
    required DateTime updatedAt,
  }) {
    final query = update(foods)..where((food) => food.id.equals(id) & food.deletedAt.isNull());
    return query.write(
      FoodsCompanion(
        name: Value(name),
        caloriesPerServing: Value(caloriesPerServing),
        servingLabel: Value(servingLabel),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<int> softDeleteFood({required int id, required DateTime deletedAt}) {
    final timestamp = deletedAt.toUtc();

    final query = update(foods)..where((food) => food.id.equals(id) & food.deletedAt.isNull());
    return query.write(FoodsCompanion(deletedAt: Value(timestamp), updatedAt: Value(timestamp)));
  }

  Future<List<Food>> searchActiveFoods(String searchTerm) {
    final normalizedTerm = searchTerm.trim();

    if (normalizedTerm.isEmpty) {
      return getActiveFoods();
    }

    final escapedTerm = _escapeLikePattern(normalizedTerm);

    final query = select(
      foods,
    )..where((food) => food.deletedAt.isNull() & food.name.like('%$escapedTerm%', escapeChar: '!'));

    return query.get();
  }

  String _escapeLikePattern(String value) {
    return value.replaceAll('!', '!!').replaceAll('%', '!%').replaceAll('_', '!_');
  }
}
