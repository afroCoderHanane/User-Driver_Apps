import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  Position? userCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;


  checkIfLocationPermisionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }
  readCurrentDriverInformation() async
  {
    currentFirebaseUser = fAuth.currentUser;

    await FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((DatabaseEvent snap)
    {
      if(snap.snapshot.value != null)
      {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.car_color = (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model = (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["car_number"];

        if (kDebugMode) {
          print("Car Details :: ");
        }
        if (kDebugMode) {
          print(onlineDriverData.car_color);
        }
        if (kDebugMode) {
          print(onlineDriverData.car_model);
        }
        if (kDebugMode) {
          print(onlineDriverData.car_number);
        }
      }
    });

  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
    LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermisionAllowed();
    readCurrentDriverInformation();

    //AssistantMethods.readCurrentOnlineUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            locateDriverPosition();
          },
        ),

        //ui for online drive
        statusText != "Now Online"
            ? Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.black87,
        )
            : Container(),
        Positioned(
            top: statusText != "Now Online"
                ? MediaQuery.of(context).size.height * 0.5
                : 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isDriverActive != true) {
                      driverIsOnlineNow();
                      updateDriverLocationAtRealtime();
                      setState(() {
                        statusText = "Now Online";
                        isDriverActive = true;
                        statusColor = Colors.red[900]!;
                      });

                      //display Toast
                      Fluttertoast.showToast(msg: "You are Online");
                    } else {
                      driverIsOfflineNow();

                      setState(() {
                        statusText = "Go Online";
                        isDriverActive = false;
                        statusColor = Colors.green[400]!;
                      });

                      Fluttertoast.showToast(msg: "You are Offline");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: statusText != "Now Online"
                      ? Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  )
                      : const Icon(
                    Icons.phonelink_ring,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            )),
      ],
    );
  }


  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    userCurrentPosition = pos;
    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
      currentFirebaseUser!.uid,
      userCurrentPosition!.latitude,
      userCurrentPosition!.longitude);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) {});
  }

  updateDriverLocationAtRealtime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
          userCurrentPosition = position;

          if (isDriverActive == true) {
            Geofire.setLocation(currentFirebaseUser!.uid,
                userCurrentPosition!.latitude, userCurrentPosition!.longitude);
          }

          LatLng latLng =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

          newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
        });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
    streamSubscriptionPosition?.cancel();
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    // });
  }
}
