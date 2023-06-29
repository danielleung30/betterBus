// ignore_for_file: non_constant_identifier_names

import 'package:better_bus/api/busStop.dart';

import 'apiHelper.dart';

Future<List<KowloonBusStop>> getKowloonBusData() async {
  List<KowloonBusStop> returnList = List.empty(growable: true);
  ApiResponse response =
      await Api.getData("https://data.etabus.gov.hk/v1/transport/kmb/stop");
  if (response.status == "success") {
    KowloonBusStopApiResponse kowloonBusStopApiResponse =
        KowloonBusStopApiResponse.fromJson(response.content);
    kowloonBusStopApiResponse.data.forEach((e) {
      KowloonBusStop stopData = KowloonBusStop.fromJson(e);
      returnList.add(stopData);
    });
  } else {
    throw "Fail to get Bus data";
  }
  return returnList;
}

class KowloonBusStopApiResponse {
  final String type;
  final String version;
  final String generated_timestamp;
  final List<dynamic> data;

  KowloonBusStopApiResponse(
      {required this.type,
      required this.version,
      required this.generated_timestamp,
      required this.data});

  factory KowloonBusStopApiResponse.fromJson(Map<String, dynamic> json) {
    return KowloonBusStopApiResponse(
      type: json['type'],
      version: json['version'],
      generated_timestamp: json['generated_timestamp'],
      data: json['data'],
    );
  }
}

class KowloonBusStop {
  final String stop;
  final String name_en;
  final String name_tc;
  final String name_sc;
  final String lat;
  final String long;

  KowloonBusStop(
      {required this.stop,
      required this.name_en,
      required this.name_tc,
      required this.name_sc,
      required this.lat,
      required this.long});

  factory KowloonBusStop.fromJson(Map<String, dynamic> json) {
    return KowloonBusStop(
      stop: json['stop'],
      name_en: json['name_en'],
      name_tc: json['name_tc'],
      name_sc: json['name_sc'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}
