import 'dart:io';

import 'package:better_bus/dao/busStopProvider.dart';
import 'package:better_bus/dao/routeStopProvider.dart';
import 'package:better_bus/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String path = join(dbDirectory.path, 'master.db');
    var database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await initDBTable(db, version);
    });
    return database;
  }

  Future<void> initDBTable(Database db, int version) async {
    await getIt<BusStopProvider>().createTable(db);
    await getIt<RouteStopProvider>().createTable(db);
  }
}
