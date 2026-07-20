import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

typedef DatabaseTask = Future<void> Function(Database database);

class AppDatabase {
  static const _databaseName = 'reimagined_spoon.db';
  static const _databaseVersion = 1;

  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  final List<DatabaseTask> _onCreateTask = [];

  Future<Database>? _databaseFuture;


}