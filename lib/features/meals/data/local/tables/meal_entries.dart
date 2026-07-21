import 'package:drift/drift.dart';
import 'package:reimagined_spoon/features/foods/data/local/tables/foods.dart';

class MealEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get foodId =>
      integer().nullable().references(Foods, #id, onDelete: KeyAction.setNull)();

  TextColumn get foodNameSnapshot => text().customConstraint(
    'NOT NULL CHECK (food_name_snapshot = trim(food_name_snapshot) '
    'AND length(food_name_snapshot) > 0 )',
  )();

  late final RealColumn caloriesPerServingSnapshot = real().check(
    caloriesPerServingSnapshot.isBiggerOrEqualValue(0),
  )();

  late final RealColumn servingQuantity = real().check(servingQuantity.isBiggerThanValue(0))();

  TextColumn get mealCategory => text().customConstraint(
    "NOT NULL CHECK (meal_category IN ('breakfast', 'lunch', 'dinner', 'snack'))",
  )();

  DateTimeColumn get consumedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();
}
