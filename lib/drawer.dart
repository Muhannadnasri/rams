import 'package:attendance/attendance.dart';
import 'package:attendance/profile.dart';
import 'package:attendance/report.dart';
import 'package:attendance/users.dart';
import 'package:flutter/material.dart';

import 'addGeofence.dart';
import 'geofences.dart';
import 'globle.dart';

class AppDrawer extends StatelessWidget {
  final String selected;

  const AppDrawer({Key key, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Ahmed',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      child: Text(
                        'Admin',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            enabled: selected != 'Attendance',
            leading: Icon(
              Icons.home,
              color: selected == 'Attendance' ? Colors.blue : Colors.grey,
            ),
            title: Text("Attendance"),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/attendance', (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            enabled: selected != 'Report',
            leading: Icon(
              Icons.apps,
              color: selected == 'Report' ? Colors.blue : Colors.grey,
            ),
            title: Text("Reports"),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/report', (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            enabled: selected != 'Profile',
            leading: Icon(
              Icons.people,
              color: selected == 'Profile' ? Colors.blue : Colors.grey,
            ),
            title: Text("My Profile"),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/profile', (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            enabled: selected != 'AddGeofence',
            leading: Icon(
              Icons.location_on,
              color: selected == 'AddGeofence' ? Colors.blue : Colors.grey,
            ),
            title: Text("Add Geofence"),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/addGeofence', (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            enabled: selected != 'Geofences',
            leading: Icon(
              Icons.feedback,
              color: selected == 'Geofences' ? Colors.blue : Colors.grey,
            ),
            title: Text("Geofence List"),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/geofences', (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            enabled: selected != 'Users',
            leading: Icon(
              Icons.monetization_on,
              color: selected == 'Users' ? Colors.blue : Colors.grey,
            ),
            title: Text("Users List"),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/users', (Route<dynamic> route) => false);
            },
          ),
          Divider(
            thickness: 2,
            indent: 0,
            endIndent: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.grey,
            ),
            title: Text(
              "Logout",
            ),
            onTap: () {
              logOut(context);
              // logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
