import '../models/APIResponse.dart';
import '../models/Eta.dart';
import 'apiHelper.dart';

Future<List<Eta>> getETA(
    String stopId, String route, String serviceType) async {
  List<Eta> returnList = List.empty(growable: true);
  CallResponse response = await Api.getData(
      "https://data.etabus.gov.hk/v1/transport/kmb/eta/$stopId/$route/$serviceType");
  if (response.status == "success") {
    ApiResponse apiResponse = ApiResponse.fromJson(response.content);
    apiResponse.data.forEach((e) {
      Eta stopData = Eta.fromJSON(e);
      returnList.add(stopData);
    });
  } else {
    throw "Fail to get ETA data";
  }
  return returnList;
}
