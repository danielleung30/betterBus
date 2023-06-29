// ignore_for_file: prefer_const_constructors, prefer_collection_literals

import 'dart:async';
import 'dart:ffi';

import 'package:better_bus/api/busStop.dart';
import 'package:better_bus/api/kowloonBus_api.dart';
import 'package:better_bus/controller/appController.dart';
import 'package:better_bus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LatLng currentLocation = LatLng(0, 0);
  AppController appController = getIt<AppController>();
  List<Marker> markerList = List.empty(growable: true);
  Set<Marker> markerSet = Set();
  double zoom = 17.0;
  KowloonBusStop? selectedBusStop;

  bool loadingRoute = false;
  bool textisExpanded = false;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _createMarker();
    setState(() {});
  }

  bool checkIsNearMarker(double center_lat, double center_lon,
      double target_lat, double _target_lon) {
    double distanceInMeters = Geolocator.distanceBetween(
        center_lat, center_lon, target_lat, _target_lon);
    if (distanceInMeters < 1000) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    if (appController.position != null) {
      currentLocation = LatLng(
          appController.position!.latitude, appController.position!.longitude);
    } else {
      currentLocation = LatLng(0, 0);
    }
    super.initState();
  }

  _onMarkerTapped(KowloonBusStop stop) async {
    selectedBusStop = stop;
    loadingRoute = true;
    setState(() {});

    await Future.delayed(Duration(seconds: 3));
    loadingRoute = false;
    setState(() {});
  }

  _createMarker() {
    markerList.clear();
    for (int i = 0; i < appController.stopData.length; i++) {
      if (checkIsNearMarker(
          currentLocation.latitude,
          currentLocation.longitude,
          double.parse(appController.stopData[i].lat),
          double.parse(appController.stopData[i].long))) {
        markerList.add(Marker(
          markerId: MarkerId(appController.stopData[i].stop),
          position: LatLng(double.parse(appController.stopData[i].lat),
              double.parse(appController.stopData[i].long)),
          infoWindow: InfoWindow(title: appController.stopData[i].name_tc),
          onTap: () {
            _onMarkerTapped(appController.stopData[i]);
          },
        ));
      }
    }
    markerSet = Set.of(markerList);
  }

  @override
  Widget build(BuildContext context) {
    if (appController.permission != LocationPermission.always &&
        appController.permission != LocationPermission.whileInUse) {
      return Text("Please enable Location permission");
    }

    return Stack(
      children: [
        GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: (position) {
              currentLocation =
                  LatLng(position.target.latitude, position.target.longitude);
            },
            onCameraIdle: () {
              _createMarker();
              setState(() {});
            },
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: zoom,
            ),
            markers: markerSet),
        if (selectedBusStop != null) _busList()
      ],
    );
  }

  _busList() {
    return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.1,
        maxChildSize: 0.9,
        expand: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
              padding: EdgeInsets.all(0),
              color: Colors.black,
              child: _buildRouteList(scrollController));
        });
  }

  _buildRouteList(ScrollController scrollController) {
    if (loadingRoute) {
      ListView(
        controller: scrollController,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 22,
              ),
              Container(
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16)),
              ),
            ],
          ),
          ListTile(
              title: Text(selectedBusStop!.name_tc,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          SizedBox(
            height: 44,
          ),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    }

    return ListView(
      controller: scrollController,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 22,
            ),
            Container(
              height: 5,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16)),
            ),
          ],
        ),
        ListTile(
            title: Text(selectedBusStop!.name_tc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        SingleChildScrollView(
          child: Container(
              child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                textisExpanded = !textisExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text("798"),
                  );
                },
                body: ListTile(
                    title: Text("93k"),
                    subtitle: const Text(
                        'To delete this panel, tap the trash can icon'),
                    trailing: const Icon(Icons.delete),
                    onTap: () {
                      print("123");
                    }),
                isExpanded: textisExpanded,
              ),
            ],
          )),
        ),
      ],
    );
  }
}
