class FoodLocalModel {
  static const tableName = 'foods';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnCaloriesPerServing = 'calories_per_serving';
  static const columnCreatedAt = 'created_at';
  static const columnUpdatedAt = 'updated_at';

  final int? id;
  final String name;
  final double caloriesPerServing;
  final int createdAt;
  final int updatedAt;

  const FoodLocalModel({
    this.id,
    required this.name,
    required this.caloriesPerServing,
    required this.createdAt,
    required this.updatedAt,
  });

  static const createTableQuery =
      ''' CREATE TABLE IF NOT EXISTS $tableName(
  $columnId INTEGER PRIMARY KEY,
  $columnName TEXT NOT NULL COLLATE NOCASE UNIQUE CHECK (
  $columnName = trim($columnName) AND length($columnName) > 0),
  $columnCaloriesPerServing REAL NOT NULL CHECK ($columnCaloriesPerServing >= 0),
  $columnCreatedAt INTEGER NOT NULL,
  $columnUpdatedAt INTEGER NOT NULL
  )''';

  Map<String, Object?> toMap() {
    return {
      columnName: name,
      columnCaloriesPerServing: caloriesPerServing,
      columnCreatedAt: createdAt,
      columnUpdatedAt: updatedAt,
    };
  }

  factory FoodLocalModel.fromMap(Map<String, Object?> map) {
    return FoodLocalModel(
      id: map[columnId] as int,
      name: map[columnName] as String,
      caloriesPerServing: (map[columnCaloriesPerServing] as num).toDouble(),
      createdAt: map[columnCreatedAt] as int,
      updatedAt: map[columnUpdatedAt] as int,
    );
  }
}
