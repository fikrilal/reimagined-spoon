import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  test('inserts and reads one food', () async {
    final timeStamp = DateTime.utc(2026, 7, 20, 12);

    final insertId = await database.foodDao.insertFood(
      name: 'Apple',
      caloriesPerServing: 52,
      createdAt: timeStamp,
      updatedAt: timeStamp,
      deletedAt: timeStamp,
    );

    final foods = await database.foodDao.getAllFoods();

    expect(insertId, 1);
    expect(foods, hasLength(1));

    final food = foods.single;

    expect(food.id, insertId);
    expect(food.name, 'Apple');
    expect(food.caloriesPerServing, 52.0);
    expect(food.createdAt.isAtSameMomentAs(timeStamp), isTrue);
    expect(food.updatedAt.isAtSameMomentAs(timeStamp), isTrue);
  });

  test('returns foods ordered by name ascending', () async {
    final timeStamp = DateTime.utc(2026, 7, 20, 12);

    await database.foodDao.insertFood(
      name: 'Banana',
      caloriesPerServing: 89.0,
      createdAt: timeStamp,
      updatedAt: timeStamp,
      deletedAt: timeStamp,
    );

    await database.foodDao.insertFood(
      name: 'Apple',
      caloriesPerServing: 52.0,
      createdAt: timeStamp,
      updatedAt: timeStamp,
      deletedAt: timeStamp,
    );

    final foods = await database.foodDao.getAllFoods();

    final foodNames = foods.map((food) => food.name).toList();

    expect(foodNames, ['Apple', 'Banana']);
  });

  test('rejects duplicate names ignoring case', () async {
    final timeStamp = DateTime.utc(2026, 7, 20, 12);

    await database.foodDao.insertFood(
      name: 'Apple',
      caloriesPerServing: 52.0,
      createdAt: timeStamp,
      updatedAt: timeStamp,
      deletedAt: timeStamp,
    );

    await expectLater(
      database.foodDao.insertFood(
        name: 'apple',
        caloriesPerServing: 52.0,
        createdAt: timeStamp,
        updatedAt: timeStamp,
        deletedAt: timeStamp,
      ),
      throwsA(isA<SqliteException>()),
    );

    final foods = await database.foodDao.getAllFoods();
    expect(foods, hasLength(1));
    expect(foods.single.name, 'Apple');
  });

  tearDown(() async {
    await database.close();
  });
}
