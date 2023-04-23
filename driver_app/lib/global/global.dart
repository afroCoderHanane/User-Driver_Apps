import 'dart:async';
import 'dart:ui';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../assistants/driver_data.dart';
import '../models/user_model.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
bool isDriverActive = false;
String statusText = " Go Online";
Color statusColor = Colors.green;
DriverData onlineDriverData = DriverData();
UserModel? userModelCurrentInfo;

StreamSubscription<Position>? streamSubscriptionPosition;
// UserModel? userModelCurrentInfo;
//
// StreamSubscription<Position>? streamSubscriptionPosition;