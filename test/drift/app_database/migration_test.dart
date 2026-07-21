// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v1 to v2 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldFoodsData = <v1.FoodsData>[
      const v1.FoodsData(
        id: 1,
        name: 'Apple',
        caloriesPerServing: 100,
        createdAt: 1000,
        updatedAt: 1000,
      ),
    ];
    final expectedNewFoodsData = <v2.FoodsData>[
      const v2.FoodsData(
        id: 1,
        name: 'Apple',
        caloriesPerServing: 100,
        createdAt: 1000,
        updatedAt: 1000,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.foods, oldFoodsData);
      },
      validateItems: (newDb) async {
        expect(expectedNewFoodsData, await newDb.select(newDb.foods).get());
      },
    );
  });

  test('migration from v3 to v4 preserves foods and meal entries', () async {
    final oldFoodsData = <v3.FoodsData>[
      const v3.FoodsData(
        id: 1,
        name: 'Apple',
        caloriesPerServing: 100,
        createdAt: 1000,
        updatedAt: 1000,
      ),
    ];

    final oldMealEntriesData = <v3.MealEntriesData>[
      const v3.MealEntriesData(
        id: 1,
        foodNameSnapshot: 'Apple',
        caloriesPerServingSnapshot: 100,
        servingQuantity: 1,
        mealCategory: 'breakfast',
        consumedAt: 2000,
        createdAt: 1000,
      ),
    ];

    final expectedFoodsData = <v4.FoodsData>[
      const v4.FoodsData(
        id: 1,
        name: 'Apple',
        caloriesPerServing: 100,
        createdAt: 1000,
        updatedAt: 1000,
      ),
    ];

    final expectedMealEntriesData = <v4.MealEntriesData>[
      const v4.MealEntriesData(
        id: 1,
        foodNameSnapshot: 'Apple',
        caloriesPerServingSnapshot: 100,
        servingQuantity: 1,
        mealCategory: 'breakfast',
        consumedAt: 2000,
        createdAt: 1000,
      ),
    ];

    await verifier.testWithDataIntegrity(
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.foods, oldFoodsData);
        batch.insertAll(oldDb.mealEntries, oldMealEntriesData);
      },
      validateItems: (newDb) async {
        final actualFoods = await newDb.select(newDb.foods).get();
        final actualMealEntries = await newDb.select(newDb.mealEntries).get();
        expect(actualFoods, expectedFoodsData);
        expect(actualMealEntries, expectedMealEntriesData);
      },
      oldVersion: 3,
      newVersion: 4,
    );
  });
}
