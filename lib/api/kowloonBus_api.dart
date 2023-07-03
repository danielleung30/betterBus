// ignore_for_file: non_constant_identifier_names

import 'package:better_bus/dao/busStopProvider.dart';
import 'package:better_bus/main.dart';

import '../models/APIResponse.dart';
import '../models/BusStop.dart';
import '../models/KowloonBusStop.dart';
import 'apiHelper.dart';

Future<List<BusStop>> getKowloonBusDataFromAPI() async {
  List<BusStop> returnList = List.empty(growable: true);

  CallResponse response =
      await Api.getData("https://data.etabus.gov.hk/v1/transport/kmb/stop");
  if (response.status == "success") {
    ApiResponse kowloonBusStopApiResponse =
        ApiResponse.fromJson(response.content);
    kowloonBusStopApiResponse.data.forEach((e) {
      BusStop stopData = BusStop.fromJson(e);
      returnList.add(stopData);
    });

    try {
      await getIt<BusStopProvider>().insertAll(returnList);
    } catch (e) {
      throw e;
    }
  } else {
    throw "Fail to get Bus data";
  }
  return returnList;
}

Future<List<BusStop>> getKowloonBusDataFromLocal() async {
  List<BusStop> returnList = List.empty(growable: true);
  returnList = await getIt<BusStopProvider>().getAll();
  return returnList;
}

Future<List<BusStop>> getKowloonBusData() async {
  List<BusStop> returnList = List.empty(growable: true);
  returnList = await getKowloonBusDataFromLocal();
  if (returnList.isEmpty) {
    returnList = await getKowloonBusDataFromAPI();
  }

  return returnList;
}
