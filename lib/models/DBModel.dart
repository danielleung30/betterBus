import 'package:better_bus/models/BusStop.dart';

import 'RouteStop.dart';

abstract class DBModel {
  Map<String, Object?> toDBJson();

  static fromJson(String type, Map<String, dynamic> json) {
    switch (type) {
      case 'BusStop':
        return BusStop.fromJson(json);
      case 'RouteStop':
        return RouteStop.fromJson(json);
      default:
        throw UnsupportedError("Not Support this type");
    }
  }
}
