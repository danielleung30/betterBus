import 'package:better_bus/dao/databaseProvider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/BusStop.dart';
import '../models/KowloonBusStop.dart';
import 'AbstractProvider.dart';

class BusStopProvider extends DBProvider<BusStop> {
  BusStopProvider()
      : super(
            'busStop',
            (("CREATE TABLE IF NOT EXISTS busStop"
                "("
                "stop TEXT PRIMARY KEY,"
                "name_en TEXT,"
                "name_tc TEXT,"
                "name_sc TEXT,"
                "lat TEXT,"
                "long TEXT"
                ")")));
  // @override
  // static String tableName = 'busStop';

  // @override
  // static String createTableString = ("CREATE TABLE IF NOT EXISTS $tableName"
  //     "("
  //     "stop TEXT PRIMARY KEY,"
  //     "name_en TEXT,"
  //     "name_tc TEXT,"
  //     "name_sc TEXT,"
  //     "lat TEXT,"
  //     "long TEXT"
  //     ")");

  // static Future createTable(Database db) async {
  //   await db.execute("CREATE TABLE IF NOT EXISTS $tableName"
  //       "("
  //       "stop TEXT PRIMARY KEY,"
  //       "name_en TEXT,"
  //       "name_tc TEXT,"
  //       "name_sc TEXT,"
  //       "lat TEXT,"
  //       "long TEXT"
  //       ")");
  // }

  // Future<void> insertAll(List<BusStop> busStop) async {
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

  // Future<List<KowloonBusStop>> getAll(
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
  //   List<KowloonBusStop> results = result.isNotEmpty
  //       ? result.map((e) => KowloonBusStop.fromJson(e)).toList()
  //       : [];
  //   return results;
  // }
}
