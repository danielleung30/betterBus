import 'dart:io';

import 'package:better_bus/lang/en.dart';
import 'package:better_bus/lang/tc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import '../api/apiHelper.dart';
import '../api/kowloonBus_api.dart';
import '../api/routeStop_api.dart';
import '../lang/baseLang.dart';
import '../models/BusStop.dart';
import '../models/KowloonBusStop.dart';

class AppController {
  String currentPage = "MAP";
  String currentLang = "tc";

  Lang currentLangPackage = TC_LANG();

  bool isLoading = true;
  bool isError = false;
  bool serviceEnabled = false;
  String errorMessage = "";
  LocationPermission permission = LocationPermission.denied;
  Position? position;
  List<BusStop> stopData = List.empty(growable: true);

  Future<bool> init() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw "Please enable location service";
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      throw "Please allow location service";
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      throw "Not connected to Internet";
    }
    switch (currentLang) {
      case "tc":
        currentLangPackage = TC_LANG();
        break;
      case "en":
        currentLangPackage = EN_LANG();
        break;
      default:
        currentLangPackage = TC_LANG();
        break;
    }

    stopData = await getKowloonBusData();
    await getRouteStopData();

    isLoading = false;
    return true;
  }
}
