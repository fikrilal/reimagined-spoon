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
}
