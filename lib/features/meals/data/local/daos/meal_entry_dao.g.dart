// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_entry_dao.dart';

// ignore_for_file: type=lint
mixin _$MealEntryDaoMixin on DatabaseAccessor<AppDatabase> {
  $FoodsTable get foods => attachedDatabase.foods;
  $MealEntriesTable get mealEntries => attachedDatabase.mealEntries;
  MealEntryDaoManager get managers => MealEntryDaoManager(this);
}

class MealEntryDaoManager {
  final _$MealEntryDaoMixin _db;
  MealEntryDaoManager(this._db);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db.attachedDatabase, _db.foods);
  $$MealEntriesTableTableManager get mealEntries =>
      $$MealEntriesTableTableManager(_db.attachedDatabase, _db.mealEntries);
}
