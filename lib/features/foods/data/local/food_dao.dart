import 'package:sqflite/sqflite.dart';
import 'food_local_model.dart';

class FoodDao {
  final DatabaseExecutor _db;

  const FoodDao(this._db);

  Future<void> createTable() async {
    await _db.execute(FoodLocalModel.createTableQuery);
  }
}