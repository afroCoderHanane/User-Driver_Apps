
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_app/schedulescreen/Services/notifi_service.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:users_app/splashScreen/splash_screen.dart';
import 'firebase_options.dart';
import 'onboarding_screen/onboardig_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingCompleted = prefs.getBool("onboarding_completed") ?? false;

  runApp(MyApp(
    child: MaterialApp(
      title: 'Driver App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: onboardingCompleted ? MySplashScreen() : OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final Widget? child;
  MyApp({this.child});
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child!);
  }
}
