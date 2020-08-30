import 'dart:async';
import 'package:attendance/globle.dart';
import 'package:http/http.dart' as http;

import 'package:attendance/drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

const CameraPosition _kInitialPosition =
    CameraPosition(target: LatLng(-33.852, 151.211), zoom: 15.0);

class AttendanceMark extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<AttendanceMark> {
  GoogleMapController mapController;
  LatLng _lastTap;
  Position _currentPosition;
  double attendanceLatitude;
  double attendanceLongitude;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Set<Marker> _markers = {};

  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  final dateNow = TextEditingController();
  final timeNow = TextEditingController();
  final dateSend = TextEditingController();
  final timeSend = TextEditingController();
  Set<Circle> circles = {};

  _initCurrentLocation() {
    // _showLoading(true);

    Geolocator()
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        //
      });
    setState(() {
      _currentPosition = null;
    });

    setState(() {
      StreamSubscription<Position> positionStream = Geolocator()
          .getPositionStream(locationOptions)
          .listen((Position position) {
        _markers.clear();
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(position.toString()),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
              title: 'I am a here',
            ),
            // icon:
            //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
          ));
        });

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              // tilt: 30.0,
              // bearing: 70.0,
              zoom: 16.0,
            ),
          ),
        );
        attendanceLatitude = position.latitude;
        attendanceLongitude = position.longitude;

        circles = Set.from([
          Circle(
              circleId: CircleId("myCircle"),
              radius: 100,
              // center: _createCenter,
              center: LatLng(position.latitude, position.longitude),
              fillColor: Colors.blue[100],
              strokeColor: Colors.green,
              onTap: () {
                print('circle pressed');
              })
        ]);
        // _showLoading(false);

        // print(position == null
        //     ? 'Unknown'
        //     : position.latitude.toString() +
        //         ', ' +
        //         position.longitude.toString());
      });
    });
    // Geolocator().getPositionStream();

    // _markers.add(Marker(
    //   markerId: MarkerId(_currentPosition.toString()),
    //   position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
    //   infoWindow: InfoWindow(
    //     title: 'I am a here',
    //   ),
    //   // icon:
    //   //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    // ));
    // mapController.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
    //       tilt: 50.0,
    //       bearing: 45.0,
    //       zoom: 16.0,
    //     ),
    //   ),
    // );
  }

  void _getTime() {
    // final DateTime now = DateTime.now();

    DateTime nowDate = DateTime.now();
    final String formattedDate = DateFormat('yyyy/MM/dd').format(nowDate);
    final String sendDate = DateFormat('yyyyMMdd').format(nowDate);

    final String formattedTime = DateFormat('H:mm').format(nowDate);
    final String sendTime = DateFormat('Hmmss').format(nowDate);

    setState(() {
      dateNow.text = formattedDate;
      dateSend.text = sendDate;
      timeSend.text = sendTime;

      timeNow.text = formattedTime;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initCurrentLocation();

    // _timeString = _formatDateTime(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  Widget build(BuildContext context) {
    final String lastTap = 'Tap:\n${_lastTap ?? ""}\n';
    return Scaffold(
        key: _scaffoldKey,
        drawer: SafeArea(
          child: AppDrawer(
            selected: 'Attendance',
          ),
        ),
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/notification');
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     '/notification', (Route<dynamic> route) => false);
                },
                child: Container(
                  child: Icon(Icons.notifications_active),
                ),
              ),
            )
          ],
          title: Text('Home'),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       _getUserLocation();
        //     });
        //   },
        // ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text('Date:'),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Text(dateNow.text),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text('Time:'),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Text(timeNow.text),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                sendAttendace();
                              });
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text('Mark My Attendance'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: GoogleMap(
                      circles: circles,
                      markers: _markers,
                      myLocationEnabled: true,
                      onMapCreated: onMapCreated,
                      initialCameraPosition: _kInitialPosition,
                      // onTap: _handleTap,
                      // (LatLng pos) {
                      // setState(() {
                      // _handleTap();
                      // _lastTap = pos;
                      // });
                      // print(lastTap);
                      // },
                    ),
                  ),
                ),
              ],
            )));
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }

  void _showLoading(isLoading) {
    if (isLoading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () {},
              child: new AlertDialog(
                  content: new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: new CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: new Text('Please Wait...'),
                  )
                ],
              )),
            );
          });
    } else {
      Navigator.pop(context);
    }
  }

  void _showError() {
    _showLoading(false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: new AlertDialog(
              content: new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: new Icon(Icons.signal_wifi_off),
                  ),
                  new Text("Unable to connect")
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    sendAttendace();
                  },
                  child: new Text('Please try again'),
                ),
              ],
            ),
          );
        });
  }

  Future sendAttendace() async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.post(
        Uri.encodeFull(
            'http://bellpepper.ae/apiLogin/api/GeoFence/MarkAttendance'),
        body: {
          "attDate": dateSend.text.toString(),
          // dateNow.text,
          "attTime": timeSend.text.toString(),
          "empNo": loginJson['userName'].toString(),
          "latitude": attendanceLatitude.toString(),
          "longitude": attendanceLongitude.toString(),
          "radius": "16",
          "mobileNo": loginJson['mobileNo'].toString(),
          // "geoFenceId":
        },
      );
      if (response.statusCode == 200) {
        setState(
          () {
            _showLoading(false);

            switch (response.body) {
              case "\"Attendance Marked Successfully\"":
                {
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text("Attendance Marked Successfully")));
                }

                break;
              default:
                {
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text(
                          "Internal Server Error. Please try again.")));
                }
            }

            // reportJson = json.decode(response.body);

            // for (String prop in reportStatusJson) {
            //   if (prop == "Pending") {
            //     _isChecked = false;
            //   } else if (prop == "Approved") {
            //     _isChecked = true;
            //   }
            // }
            // x.forEach((n) {});

            // inputs = json.decode(response.body)['presentStatus'];

            // Navigator.pushNamed(context, '/geofences');

            // Navigator.push(
            //   context,
            //   new MaterialPageRoute(builder: (context) => Geofences()),
            // );

            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/geofences', (Route<dynamic> route) => false);

            // Navigator.of(context).push(
            //   new MaterialPageRoute(builder: (_) => new Geofences()),
            // );

            // Navigator.of(context).pushNamed('/geofences');
          },
        );
      } else {
        _showError();
      }
    } catch (x) {
      print(x);
      _showError();
    }
  }
}
