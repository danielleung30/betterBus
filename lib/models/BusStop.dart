import 'package:better_bus/models/DBModel.dart';

class BusStop implements DBModel {
  final String stop;
  final String name_en;
  final String name_tc;
  final String name_sc;
  final String lat;
  final String long;

  BusStop(
      {required this.stop,
      required this.name_en,
      required this.name_tc,
      required this.name_sc,
      required this.lat,
      required this.long});

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      stop: json['stop'],
      name_en: json['name_en'],
      name_tc: json['name_tc'],
      name_sc: json['name_sc'],
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, Object?> toDBJson() => {
        "stop": stop,
        "name_en": name_en,
        "name_tc": name_tc,
        "name_sc": name_sc,
        "lat": lat,
        "long": long,
      };
  String getName(String lang) {
    switch (lang) {
      case "tc":
        return name_tc;
      case "en":
        return name_en;
      default:
        return name_tc;
    }
  }
}
