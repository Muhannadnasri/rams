import 'package:attendance/drawer.dart';
import 'package:flutter/material.dart';

import 'globle.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
          child: AppDrawer(
        selected: 'Profile',
      )),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.lightBlueAccent,
              height: 250,
            ),
          ),
          Positioned(
            top: 40,
            left: 120,
            child: CircleAvatar(
              radius: 70.0,
              backgroundImage: NetworkImage(
                  "https://cdn.imgbin.com/22/5/16/imgbin-computer-icons-user-profile-profile-ico-man-s-profile-illustration-M4UwtQzjtzd9LFP69LEzngUuR.jpg"),
              backgroundColor: Colors.transparent,
            ),
          ),
          Positioned(
            top: 210,
            right: 10,
            left: 10,
            child: Container(
              height: 100,
              child: Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text('1'),
                  ),
                  Container(
                    child: Text(loginJson['userName']),
                  ),
                  Container(
                    child: Text(loginJson['department']),
                  ),
                  Container(
                    child: Text(loginJson['designation']),
                  ),
                ],
              )),
            ),
          ),
          Positioned(
            top: 350,
            right: 10,
            left: 10,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.phone),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(loginJson['mobileNo']),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.email),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(loginJson['emaiL_ADDRESS']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // Column(
      //   children: <Widget>[
      //     Expanded(
      //       flex: 2,
      //       child: Container(
      //         child: Column(
      //           children: <Widget>[
      //             Center(
      //               child: CircleAvatar(
      //                 radius: 70.0,
      //                 backgroundImage: NetworkImage(
      //                     "https://cdn.imgbin.com/22/5/16/imgbin-computer-icons-user-profile-profile-ico-man-s-profile-illustration-M4UwtQzjtzd9LFP69LEzngUuR.jpg"),
      //                 backgroundColor: Colors.transparent,
      //               ),
      //             ),
      //             SizedBox(
      //               height: 30,
      //             ),
      //             Container(
      //               width: 200,
      //               child: Card(
      //                 child: Column(
      //                   children: <Widget>[
      //                     Container(
      //                       child: Text('1'),
      //                     ),
      //                     Container(
      //                       child: Text('ahmed'),
      //                     ),
      //                     Container(
      //                       child: Text('admin'),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //         width: 400,
      //         color: Colors.blue,
      //       ),
      //     ),
      //     Expanded(
      //       flex: 4,
      //       child: Container(
      //         width: 400,
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
