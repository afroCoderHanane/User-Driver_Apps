import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users_app/global/map_key.dart';
import '../assistants/geofire_assistant.dart';
import '../global/global.dart';
import '../models/active_nearby_available_drivers.dart';
import '../widget/my_drawer.dart';

extension IterableExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //add map style
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double bottomPaddingOfMap = 0;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  Position? userCurrentPosition;
  double containerHeight = 120;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;
  StreamController<LocationPermission> _permissionStreamController =
      StreamController<LocationPermission>.broadcast();
  StreamSubscription<LocationPermission>? _permissionSubscription;

  String userName = "your Name";
  String userEmail = "your Email";

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  // final Set<Polyline> _polyline = {};

  final _originLatitude = 34.101535, _originLongitude = -117.709360;
  final _destLatitude = 34.090684, _destLongitude = -117.699440;

  PolylinePoints polylinePoints = PolylinePoints();

  Map<PolylineId, Polyline> polylines = {};

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;
  BitmapDescriptor? originPin;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
    // Add this line to add the permission to the stream
    _permissionStreamController.add(_locationPermission!);
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //add marker

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
  }

  List<LatLng> latLen = [
    const LatLng(34.101535, -117.709360),
    const LatLng(34.090684, -117.699440)
  ];

  Timer? updateDriverMarkersTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermissionAllowed();

    updateDriverMarkersTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      displayActiveDriversOnUsersMap();
    });

    _permissionSubscription =
        _permissionStreamController.stream.listen((permission) {
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        locateUserPosition();
      }
    });

    _getPolyline();
    // _polyline.add(Polyline(
    //   polylineId: PolylineId('1'),
    //   points: latLen,
    //   color: Colors.green,
    // ));

    //AssistantMethods.readCurrentOnlineUserInfo();
  }

  @override
  void dispose() {
    updateDriverMarkersTimer?.cancel();
    _permissionSubscription?.cancel();
    super.dispose();
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            LatLng newPosition = LatLng(
                activeNearbyAvailableDriver.locationLatitude!,
                activeNearbyAvailableDriver.locationLongitude!);
            updateDriverMarkerPosition(
                activeNearbyAvailableDriver.driverId!, newPosition);
            // displayActiveDriversOnUsersMap();
            break;

          //display those online/active drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = <Marker>{};

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      Marker marker1 = const Marker(
        markerId: MarkerId("Collins"),
        position: LatLng(34.101535, -117.709360),
        // icon: originPin!
      );
      Marker marker2 = const Marker(
        markerId: MarkerId("AK"),
        position: LatLng(34.090684, -117.699440),
        // icon: originPin!
      );
      driversMarkerSet.add(marker1);
      driversMarkerSet.add(marker2);

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  double calculateBearing(LatLng oldPosition, LatLng newPosition) {
    double deltaLongitude = newPosition.longitude - oldPosition.longitude;
    double y = sin(deltaLongitude) * cos(newPosition.latitude);
    double x = cos(oldPosition.latitude) * sin(newPosition.latitude) -
        sin(oldPosition.latitude) *
            cos(newPosition.latitude) *
            cos(deltaLongitude);

    double bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360;
  }

  void updateDriverMarkerPosition(String driverId, LatLng newPosition) {
    setState(() {
      Marker? oldDriverMarker = IterableExtension(
              markersSet.where((marker) => marker.markerId.value == driverId))
          .firstOrNull;
      if (oldDriverMarker != null) {
        double bearing =
            calculateBearing(oldDriverMarker.position, newPosition);

        Marker updatedDriverMarker = Marker(
          markerId: oldDriverMarker.markerId,
          position: newPosition,
          icon: activeNearbyIcon!,
          // rotation: bearing, // Set the calculated bearing angle as rotation
          anchor: const Offset(0.5, 0.5),
        );
        markersSet.remove(oldDriverMarker);
        markersSet.add(updatedDriverMarker);
      }
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(3, 3));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/bus_resized.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  createActivePin() {
    if (originPin == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/pick-drop.png")
          .then((value) => originPin = value);
    }
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue.shade700,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();
    createActivePin();
    return Scaffold(
      key: sKey,
      drawer: MyDrawer(
        name: userName,
        email: userEmail,
      ),
      body: Stack(children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          initialCameraPosition: _kGooglePlex,
          markers: markersSet,
          polylines: Set<Polyline>.of(polylines.values),
          // polylines: _polyline,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            setState(() {
              bottomPaddingOfMap = 125;
            });

            locateUserPosition();
          },
        ),

        //custom hamburger button
        Positioned(
          top: 30,
          left: 14,
          child: GestureDetector(
            onTap: () {
              sKey.currentState!.openDrawer();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.menu,
                color: Colors.red[900],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedSize(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 120),
            child: Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.local_police_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Disclaimer",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                          "The shuttle path is a tentative, subject to change. It does not reflect the accurate route of the driver! ",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                )),
          ),
        ),
      ]),
    );
  }
}
