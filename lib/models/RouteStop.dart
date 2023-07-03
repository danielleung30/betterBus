import 'package:better_bus/models/DBModel.dart';

import 'Eta.dart';

class RouteStop implements DBModel {
  final String route;
  final String bound;
  final String service_type;
  final String seq;
  final String stop;
  List<Eta> etaList = List.empty(growable: true);

  bool expand = false;
  RouteStop(
      {required this.route,
      required this.bound,
      required this.service_type,
      required this.seq,
      required this.stop});

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      route: json['route'],
      bound: json['bound'],
      service_type: json['service_type'],
      seq: json['seq'],
      stop: json['stop'],
    );
  }

  Map<String, Object?> toDBJson() => {
        "route": route,
        "bound": bound,
        "service_type": service_type,
        "seq": seq,
        "stop": stop,
      };
}
