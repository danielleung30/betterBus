import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import '../api/apiHelper.dart';
import '../api/kowloonBus_api.dart';

class AppController {
  String currentPage = "MAP";
  bool isLoading = true;
  bool isError = false;
  bool serviceEnabled = false;
  String errorMessage = "";
  LocationPermission permission = LocationPermission.denied;
  Position? position;
  List<KowloonBusStop> stopData = List.empty(growable: true);

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
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      throw "Not connected to Internet";
    }

    stopData = await getKowloonBusData();

    isLoading = false;
    return true;
  }
}
