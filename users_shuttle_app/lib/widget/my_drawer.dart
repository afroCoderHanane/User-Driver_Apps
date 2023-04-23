
import 'package:flutter/material.dart';
import 'package:users_app/AboutMePage/infos_screen.dart';
import 'package:users_app/profile/profile_screen.dart';

import '../global/global.dart';
import '../schedulescreen/schedule_view.dart';
import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({this.name, this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 165,
            color: Colors.red[900],
            child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.name.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.email.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
          //drawer body
          GestureDetector(
            onTap: () {
              Navigator.push(
                   context, MaterialPageRoute(builder: (c) => const ScheduleView()));
             },
            child: const ListTile(
              leading: Icon(Icons.schedule, color: Colors.black),
              title: Text(
                "Schedule",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => ProfileScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text(
                "My Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => AboutAppPage()));
            },
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: Text(
                "About",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
