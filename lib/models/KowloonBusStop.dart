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

  Map<String, Object?> toDBJson() => {
        "stop": stop,
        "name_en": name_en,
        "name_tc": name_tc,
        "name_sc": name_sc,
        "lat": lat,
        "long": long,
      };
}
