import 'package:drift/drift.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';
import '../../../../foods/data/local/tables/foods.dart';
import '../tables/meal_entries.dart';

part 'meal_entry_dao.g.dart';

@DriftAccessor(tables: [Foods, MealEntries])
class MealEntryDao extends DatabaseAccessor<AppDatabase> with _$MealEntryDaoMixin {
  MealEntryDao(super.database);

  Future<int> insertMealEntry({
    required int foodId,
    required String foodNameSnapshot,
    required double caloriesPerServingSnapshot,
    required double servingQuantity,
    required String mealCategory,
    required DateTime consumedAt,
    required DateTime createdAt,
  }) {
    return into(mealEntries).insert(
      MealEntriesCompanion.insert(
        foodId: Value(foodId),
        foodNameSnapshot: foodNameSnapshot,
        caloriesPerServingSnapshot: caloriesPerServingSnapshot,
        servingQuantity: servingQuantity,
        mealCategory: mealCategory,
        consumedAt: consumedAt,
        createdAt: createdAt,
      ),
    );
  }

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
}
