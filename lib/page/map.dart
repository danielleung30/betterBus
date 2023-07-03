// ignore_for_file: prefer_const_constructors, prefer_collection_literals

import 'dart:async';
import 'package:better_bus/api/eta_api.dart';
import 'package:better_bus/controller/appController.dart';
import 'package:better_bus/main.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/routeStop_api.dart';
import '../models/BusStop.dart';
import '../models/Eta.dart';
import '../models/RouteStop.dart';

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
  BusStop? selectedBusStop;
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();
  List<RouteStop> routeStop = List.empty();

  Timer? timer;
  int count = 60;
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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateETA());
    super.initState();
  }

  _updateETA() {
    count--;
    if (routeStop.isNotEmpty && count == 0) {
      count = 60;
      routeStop.forEach((e) {
        getETA(e.stop, e.route, e.service_type).then((value) {
          e.etaList = value.where((eta) => eta.dir == e.bound).toList();
          setState(() {});
        });
      });
    }
  }

  _onMarkerTapped(BusStop stop) async {
    loadingRoute = true;
    count = 60;
    setState(() {});

    routeStop = await getRouteStopsByStopId(stop.stop) as List<RouteStop>;
    if (selectedBusStop != null) {
      draggableScrollableController.animateTo(0.4,
          duration: Duration(seconds: 1), curve: Curves.bounceInOut);
    }
    selectedBusStop = stop;
    loadingRoute = false;
    setState(() {});

    routeStop.forEach((e) {
      getETA(e.stop, e.route, e.service_type).then((value) {
        e.etaList = value.where((eta) => eta.dir == e.bound).toList();
        setState(() {});
      });
    });
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
  void dispose() {
    timer?.cancel();
    super.dispose();
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
        controller: draggableScrollableController,
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
      shrinkWrap: true,
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
                routeStop[index].expand = !routeStop[index].expand;
              });
            },
            children: _buildRouteStop(),
          )),
        ),
      ],
    );
  }

  _buildRouteStop() {
    List<ExpansionPanel> list = List.empty(growable: true);
    for (int i = 0; i < routeStop.length; i++) {
      list.add(ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            leading: Text(
              routeStop[i].route,
              style: TextStyle(fontSize: 20),
            ),
            title: routeStop[i].etaList.isEmpty
                ? null
                : Text("往${routeStop[i].etaList[0].dest_tc}"),
            trailing: routeStop[i].etaList.isEmpty ||
                    routeStop[i].etaList[0].eta.isEmpty
                ? Text("-")
                : Text(
                    "${Eta.calEATMinutes(routeStop[i].etaList[0].data_timestamp, routeStop[i].etaList[0].eta)}分鐘"),
          );
        },
        body: routeStop[i].etaList.isEmpty || routeStop[i].etaList[0].eta == ""
            ? ListView(
                shrinkWrap: true,
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: routeStop[i].etaList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(
                          "${routeStop[i].etaList[index].rmk_tc} ${Eta.calEATMinutes(routeStop[i].etaList[index].data_timestamp, routeStop[i].etaList[index].eta)}分鐘"),
                      onTap: () {
                        print(routeStop[i].stop);
                      });
                },
              ),
        isExpanded: routeStop[i].expand,
      ));
    }

    return list;
  }
}
