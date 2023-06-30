import 'package:sqflite/sqflite.dart';

import '../models/DBModel.dart';
import 'databaseProvider.dart';

class DBProvider<T extends DBModel> {
  final dbProvider = DatabaseProvider.dbProvider;
  final String tableName;
  final String createTableString;

  DBProvider(this.tableName, this.createTableString);

  Future createTable(Database db) async {
    await db.execute(createTableString);
  }

  Future<void> insertAll(List<T> collection) async {
    final Database db = await dbProvider.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      collection.forEach((element) async {
        batch.insert(tableName, element.toDBJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
      await batch.commit(noResult: true);
    });
  }

  Future<int> getCount() async {
    final Database db = await dbProvider.database;
    List<Map<String, Object?>> list =
        await db.rawQuery("SELECT COUNT(*) FROM $tableName");
    if (list == null || list.length < 0) {
      return 0;
    }
    return Sqflite.firstIntValue(list)!;
  }

  Future<List> getAll(
      {List<String>? columns, Map<String, dynamic>? query}) async {
    final Database db = await dbProvider.database;
    late List<Map<String, dynamic>> result;
    if (query != null && query.isNotEmpty) {
      String whereString = "";
      List<String> whereArgs = [];
      query.forEach((key, value) {
        if (whereString != "") {
          whereString += " && ";
        }
        if (value is String && value.contains("&")) {
          whereString += " $key LIKE ? ";
        } else {
          whereString += " $key = ? ";
        }

        whereArgs.add(value);
      });

      result = await db.query(tableName,
          columns: columns, where: whereString, whereArgs: whereArgs);
    } else {
      result = await db.query(tableName, columns: columns);
    }

    List<T> results = result.isNotEmpty
        ? result.map((e) => DBModel.fromJson(T.toString(), e) as T).toList()
        : [];
    return results;
  }
}
