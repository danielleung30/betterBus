import '../dao/routeStopProvider.dart';
import '../main.dart';
import '../models/APIResponse.dart';
import '../models/Route.dart';
import '../models/RouteStop.dart';
import 'apiHelper.dart';

Future<List<RouteStop>> getRoutesStopFromAPI() async {
  List<RouteStop> returnList = List.empty(growable: true);
  CallResponse response = await Api.getData(
      "https://data.etabus.gov.hk/v1/transport/kmb/route-stop");
  if (response.status == "success") {
    ApiResponse apiResponse = ApiResponse.fromJson(response.content);
    apiResponse.data.forEach((e) {
      RouteStop stopData = RouteStop.fromJson(e);
      returnList.add(stopData);
    });

    try {
      await getIt<RouteStopProvider>().insertAll(returnList);
    } catch (e) {
      throw e;
    }
  } else {
    throw "Fail to get Bus data";
  }
  return returnList;
}

Future<List> getRouteStopDataFromLocal() async {
  List returnList = List.empty(growable: true);
  returnList = await getIt<RouteStopProvider>().getAll();
  return returnList;
}

Future<void> getRouteStopData() async {
  int count = await getIt<RouteStopProvider>().getCount();
  if (count < 0) {
    await getRoutesStopFromAPI();
  }
}

Future<List> getRouteStopsByStopId(String stopId) async {
  List? returnList = List.empty(growable: true);
  Map<String, dynamic> query = {"stop": stopId};
  returnList = await getIt<RouteStopProvider>().getAll(query: query);
  if (returnList != null) {
    return returnList;
  }
  return [];
}
