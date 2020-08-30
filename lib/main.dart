import 'package:attendance/attendance.dart';

import 'package:attendance/login.dart';
import 'package:attendance/notification.dart';
import 'package:attendance/profile.dart';
import 'package:attendance/report.dart';
import 'package:attendance/users.dart';
import 'package:flutter/material.dart';

import 'addGeofence.dart';
import 'geofences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int lang = 1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return new
            //  Directionality(
            // textDirection: lang == 2 ? TextDirection.rtl : TextDirection.ltr,
            // child:
            Builder(
          builder: (BuildContext context) {
            return new MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child,
            );
          },
        );
        // );
      },

      title: "Fit at Home Trainers",
      theme: ThemeData(
        //fontFamily: 'Hdtc',
        // primaryColor: Color.fromARGB(255, 110, 200, 0),
        primaryColorBrightness: Brightness.dark,
        // accentColor: Color.fromARGB(255, 110, 200, 0),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/attendance': (context) => AttendanceMark(),
        '/report': (context) => Report(),
        '/profile': (context) => Profile(),

        '/addGeofence': (context) => AddGeofence(),

        '/geofences': (context) => Geofences(),
        '/users': (context) => Users(),
        '/notification': (context) => Notifications(),
        // '/payments-form': (context) => PaymentForm(),
        // '/users-form': (context) => UserForm(),
        // '/sessions-form': (context) => SessionForm(),
        // '/locations-form': (context) => LocationForm(),
      },
    );
  }

  // switchLang() {
  //   setState(() {
  //     if (lang == 1)
  //       lang = 2;
  //     else
  //       lang = 1;
  //   });
  // }
}
