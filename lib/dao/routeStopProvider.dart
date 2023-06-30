import 'package:sqflite/sqflite.dart';
import '../models/Route.dart';
import '../models/RouteStop.dart';
import 'AbstractProvider.dart';
import 'databaseProvider.dart';

class RouteStopProvider extends DBProvider<RouteStop> {
  RouteStopProvider()
      : super(
            "routeStop",
            ("CREATE TABLE IF NOT EXISTS routeStop"
                "("
                "route TEXT,"
                "bound TEXT,"
                "service_type TEXT,"
                "name_sc TEXT,"
                "seq TEXT,"
                "stop TEXT"
                ")"));

  // static final String tableName = 'route';

  // static Future createTable(Database db) async {
  //   await db.execute("CREATE TABLE IF NOT EXISTS $tableName"
  //       "("
  //       "route TEXT,"
  //       "bound TEXT,"
  //       "service_type TEXT,"
  //       "name_sc TEXT,"
  //       "seq TEXT,"
  //       "stop TEXT"
  //       ")");
  // }

  // Future<void> insertAll(List<RouteStop> busStop) async {
  //   final Database db = await dbProvider.database;
  //   await db.transaction((txn) async {
  //     final batch = txn.batch();
  //     busStop.forEach((element) async {
  //       batch.insert(tableName, element.toDBJson(),
  //           conflictAlgorithm: ConflictAlgorithm.replace);
  //     });
  //     await batch.commit(noResult: true);
  //   });
  // }

  // Future<List<RouteStop>> getAll(
  //     {List<String>? columns, Map<String, dynamic>? query}) async {
  //   final Database db = await dbProvider.database;
  //   late List<Map<String, dynamic>> result;
  //   if (query != null && query.isNotEmpty) {
  //     String whereString = "";
  //     List<String> whereArgs = [];
  //     query.forEach((key, value) {
  //       if (whereString != "") {
  //         whereString += " && ";
  //       }
  //       if (value is String && value.contains("&")) {
  //         whereString += " $key LIKE ? ";
  //       } else {
  //         whereString += " $key = ? ";
  //       }

  //       whereArgs.add(value);
  //     });

  //     result = await db.query(tableName,
  //         columns: columns, where: whereString, whereArgs: whereArgs);
  //   } else {
  //     result = await db.query(tableName, columns: columns);
  //   }
  //   List<RouteStop> results = result.isNotEmpty
  //       ? result.map((e) => RouteStop.fromJson(e)).toList()
  //       : [];
  //   return results;
  // }
}
