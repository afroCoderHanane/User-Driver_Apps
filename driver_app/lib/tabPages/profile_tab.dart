import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../assistants/info_design_ui.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';


class ProfileTabPage extends StatefulWidget
{
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Text(
              onlineDriverData.name ?? "Unknown",
              style: const TextStyle(
                fontSize: 50.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.black,
                height: 2,
                thickness: 2,
              ),
            ),
            const SizedBox(height: 38.0,),
            //phone
            InfoDesignUIWidget(
              textInfo: onlineDriverData.phone ?? "Unknown",
              iconData: Icons.phone_iphone,
            ),
            //email
            InfoDesignUIWidget(
              textInfo: onlineDriverData.email ?? "Unknown",
              iconData: Icons.email,
            ),
            InfoDesignUIWidget(
              textInfo: (onlineDriverData.car_color ?? "Unknown") + " " +
                  (onlineDriverData.car_model ?? "Unknown") + " " +
                  (onlineDriverData.car_number ?? "Unknown"),
              iconData: Icons.car_repair,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                fAuth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const MySplashScreen()));

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
