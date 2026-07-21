import 'package:drift/drift.dart';

class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().customConstraint(
    'NOT NULL COLLATE NOCASE UNIQUE '
    'CHECK (name = trim(name) AND length(name) > 0)',
  )();

  late final RealColumn caloriesPerServing = real().check(
    caloriesPerServing.isBiggerOrEqualValue(0),
  )();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime()();
}
