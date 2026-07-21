import 'package:drift/drift.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';
import '../../../../foods/data/local/tables/foods.dart';
import '../tables/meal_entries.dart';

part 'meal_entry_dao.g.dart';

@DriftAccessor(tables: [Foods, MealEntries])
class MealEntryDao extends DatabaseAccessor<AppDatabase> with _$MealEntryDaoMixin {
  MealEntryDao(super.database);

  Future<int> insertMealFromFood({
    required int foodId,
    required double servingQuantity,
    required String mealCategory,
    required DateTime consumedAt,
    required DateTime createdAt,
  }) {
    return transaction(() async {
      final foodQuery = select(foods)..where((table) => table.id.equals(foodId));

      final food = await foodQuery.getSingleOrNull();

      if (food == null) {
        throw StateError('Food with id $foodId was not found');
      }

      return into(mealEntries).insert(
        MealEntriesCompanion.insert(
          foodId: Value(food.id),
          foodNameSnapshot: food.name,
          caloriesPerServingSnapshot: food.caloriesPerServing,
          servingQuantity: servingQuantity,
          mealCategory: mealCategory,
          consumedAt: consumedAt.toUtc(),
          createdAt: createdAt.toUtc(),
        ),
      );
    });
  }

  Future<List<MealEntry>> getMealEntriesBetween({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) {
    final startUtc = startInclusive.toUtc();
    final endUtc = endExclusive.toUtc();

    if (!startUtc.isBefore(endUtc)) {
      throw ArgumentError('startInclusive must be before endExclusive');
    }

    final query = select(mealEntries)
      ..where(
        (table) =>
            table.consumedAt.isBiggerOrEqualValue(startUtc) &
            table.consumedAt.isSmallerThanValue(endUtc),
      )
      ..orderBy([
        (table) => OrderingTerm.desc(table.consumedAt),
        (table) => OrderingTerm.desc(table.id),
      ]);

    return query.get();
  }
}
