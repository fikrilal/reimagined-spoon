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
    );

    final foods = await database.foodDao.getActiveFoods();

    expect(insertId, 1);
    expect(foods, hasLength(1));

    final food = foods.single;

    expect(food.id, insertId);
    expect(food.name, 'Apple');
    expect(food.caloriesPerServing, 52.0);
    expect(food.createdAt.isAtSameMomentAs(timeStamp), isTrue);
    expect(food.updatedAt.isAtSameMomentAs(timeStamp), isTrue);
    expect(food.deletedAt, isNull);
    expect(food.servingLabel, 'serving');
  });

  test('returns foods ordered by name ascending', () async {
    final timeStamp = DateTime.utc(2026, 7, 20, 12);

    await database.foodDao.insertFood(
      name: 'Banana',
      caloriesPerServing: 89.0,
      createdAt: timeStamp,
      updatedAt: timeStamp,
    );

    await database.foodDao.insertFood(
      name: 'Apple',
      caloriesPerServing: 52.0,
      createdAt: timeStamp,
      updatedAt: timeStamp,
    );

    final foods = await database.foodDao.getActiveFoods();

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
    );

    await expectLater(
      database.foodDao.insertFood(
        name: 'apple',
        caloriesPerServing: 52.0,
        createdAt: timeStamp,
        updatedAt: timeStamp,
      ),
      throwsA(isA<SqliteException>()),
    );

    final foods = await database.foodDao.getActiveFoods();
    expect(foods, hasLength(1));
    expect(foods.single.name, 'Apple');
  });

  test('returns an active food by id', () async {
    final timestamp = DateTime.utc(2026, 7, 22, 12);

    final insertedId = await database.foodDao.insertFood(
      name: 'Apple',
      caloriesPerServing: 52,
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    final food = await database.foodDao.getActiveFoodById(insertedId);

    expect(food, isNotNull);
    expect(food!.id, insertedId);
    expect(food.name, 'Apple');
    expect(food.caloriesPerServing, 52);
    expect(food.deletedAt, isNull);
  });

  test('updates an active food', () async {
    final createdAt = DateTime.utc(2026, 7, 22, 10);
    final updatedAt = DateTime.utc(2026, 7, 22, 12);

    final insertedId = await database.foodDao.insertFood(
      name: 'Apple',
      caloriesPerServing: 52.0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
    final affectedRows = await database.foodDao.updateFood(
      id: insertedId,
      name: 'Updated Apple',
      caloriesPerServing: 60.0,
      servingLabel: 'updated serving',
      updatedAt: updatedAt,
    );

    expect(affectedRows, 1);

    final food = await database.foodDao.getActiveFoodById(insertedId);

    expect(food, isNotNull);
    expect(food!.name, 'Updated Apple');
    expect(food.caloriesPerServing, 60.0);
    expect(food.servingLabel, 'updated serving');
    expect(food.createdAt.isAtSameMomentAs(createdAt), isTrue);
    expect(food.updatedAt.isAtSameMomentAs(updatedAt), isTrue);
  });

  test('returns zero when updating a missing food', () async {
    final affectedRows = await database.foodDao.updateFood(
      id: 999,
      name: 'Missing Food',
      caloriesPerServing: 100,
      servingLabel: '1 item',
      updatedAt: DateTime.utc(2026, 7, 22, 12),
    );

    expect(affectedRows, 0);
  });

  test('rejects updating a food to a duplicate name', () async {
    final timestamp = DateTime.utc(2026, 7, 22, 12);

    await database.foodDao.insertFood(
      name: 'Apple',
      caloriesPerServing: 52,
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    final bananaId = await database.foodDao.insertFood(
      name: 'Banana',
      caloriesPerServing: 89,
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    await expectLater(
      database.foodDao.updateFood(
        id: bananaId,
        name: 'apple',
        caloriesPerServing: 89,
        servingLabel: '100 g',
        updatedAt: timestamp.add(const Duration(hours: 1)),
      ),
      throwsA(isA<SqliteException>()),
    );

    final banana = await database.foodDao.getActiveFoodById(bananaId);

    expect(banana, isNotNull);
    expect(banana!.name, 'Banana');
  });

  tearDown(() async {
    await database.close();
  });
}
