import 'package:intl/intl.dart';

class Eta {
  final String co;
  final String route;
  final String dir;
  final int service_type;
  final int seq;
  final String dest_tc;
  final String dest_sc;
  final String dest_en;
  final int eta_seq;
  final String eta;
  final String rmk_tc;
  final String rmk_sc;
  final String rmk_en;
  final String data_timestamp;

  Eta(
      {required this.co,
      required this.route,
      required this.dir,
      required this.service_type,
      required this.seq,
      required this.dest_tc,
      required this.dest_sc,
      required this.dest_en,
      required this.eta_seq,
      required this.eta,
      required this.rmk_tc,
      required this.rmk_sc,
      required this.rmk_en,
      required this.data_timestamp});

  factory Eta.fromJSON(Map<String, dynamic> json) {
    return Eta(
        co: json['co'],
        route: json['route'],
        dir: json['dir'],
        service_type: json['service_type'],
        seq: json['seq'],
        dest_tc: json['dest_tc'],
        dest_sc: json['dest_sc'],
        dest_en: json['dest_en'],
        eta_seq: json['eta_seq'],
        eta: json['eta'] == null ? "" : json['eta'],
        rmk_tc: json['rmk_tc'],
        rmk_sc: json['rmk_sc'],
        rmk_en: json['rmk_en'],
        data_timestamp: json['data_timestamp']);
  }

  static int calEATMinutes(String currentTimestamp, String etaTimestamp) {
    DateTime callTime =
        DateTime.parse(currentTimestamp.split("+")[0].replaceFirst("T", " "));
    DateTime etaTime =
        DateTime.parse(etaTimestamp.split("+")[0].replaceFirst("T", " "));
    return etaTime.difference(callTime).inMinutes;
  }
}
