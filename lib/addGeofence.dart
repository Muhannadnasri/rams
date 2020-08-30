import 'package:http/http.dart' as http;

import 'package:attendance/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

const CameraPosition _kInitialPosition =
    CameraPosition(target: LatLng(-33.852, 151.211), zoom: 11.0);

class AddGeofence extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<AddGeofence> {
  GoogleMapController mapController;
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();

  final _addFormGeofence = GlobalKey<FormState>();

  // final zoom = mapController.getCameraPosition().zoom;

  LatLng _lastTap;
  Position _currentPosition;
  String latitude = '';
  String longitude = '';
  double radius = 0;
  String geofenceName = '';
  Set<Marker> _markers = {};
  Set<Circle> circles = {};

  _handleTap(LatLng point) {
    setState(() {
      _markers = {};
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'I am a here',
        ),
        // icon:
        //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });

    _latitude.text = point.latitude.toString();
    _longitude.text = point.longitude.toString();

    //   final circles = Set.from(
    //     [
    //       Circle(
    //         circleId: CircleId('circle'),
    //         center: LatLng(
    //             double.parse(_latitude.text), double.parse(_longitude.text)),
    //         radius: radius,
    //       )
    //     ],
    //   );
  }

  _radius() {
    circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: radius,
          // center: _createCenter,
          center: LatLng(
              double.parse(_latitude.text), double.parse(_longitude.text)),
          fillColor: Colors.blue[100],
          strokeColor: Colors.green,
          onTap: () {
            print('circle pressed');
          })
    ]);
  }
  // _radius() {
  //   Set<Circle> circles = Set.from([
  //     Circle(
  //       circleId: CircleId('circle'),
  //       fillColor: Color.fromRGBO(171, 39, 133, 0.1),
  //       strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
  //       center:
  //           LatLng(double.parse(_latitude.text), double.parse(_longitude.text)),
  //       radius: radius,
  //     )
  //   ]);
  // }

  _initCurrentLocation() {
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final String lastTap = 'Tap:\n${_lastTap ?? ""}\n';

    return Scaffold(
        drawer: SafeArea(
            child: AppDrawer(
          selected: 'AddGeofence',
        )),
        appBar: AppBar(
          title: Text('Add Geofence'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Card(
                child: Container(
                  child: Form(
                    key: _addFormGeofence,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.contacts),
                            hintText: 'Please enter geofence name',
                            labelText: 'Geofence Name',
                          ),
                          onSaved: (String value) {
                            geofenceName = value;
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                        ),
                        TextFormField(
                          controller: _latitude,
                          onChanged: (lastTap) {},
                          decoration: const InputDecoration(
                            icon: Icon(Icons.add_location),
                            hintText: 'Please enter latitude',
                            labelText: 'Latitude',
                          ),
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                            latitude = value;
                          },
                        ),
                        TextFormField(
                          controller: _longitude,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.edit_location),
                            hintText: 'Please enter longitude',
                            labelText: 'Longitude',
                          ),
                          onSaved: (String value) {
                            longitude = value;
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.line_style),
                            hintText: 'Please enter radius metres',
                            labelText: 'Radius(metres)',
                          ),
                          onSaved: (String value) {
                            radius = double.parse(value);

                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    if (_addFormGeofence.currentState
                                        .validate()) {
                                      _addFormGeofence.currentState.save();
                                    } else {
                                      return;
                                    }

                                    _radius();
                                  });
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text('Check on Map'),
                              ),
                            ),
                            Container(
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    if (_addFormGeofence.currentState
                                        .validate()) {
                                      _addFormGeofence.currentState.save();
                                    } else {
                                      return;
                                    }

                                    addGeofence();
                                  });
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: Text('AddGeofence'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: GoogleMap(
                  markers: _markers,
                  myLocationEnabled: true,
                  onMapCreated: onMapCreated,
                  initialCameraPosition: _kInitialPosition,
                  onTap: _handleTap,

                  circles: circles,
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
        ));
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
                    addGeofence();
                  },
                  child: new Text('Please try again'),
                ),
              ],
            ),
          );
        });
  }

  Future addGeofence() async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.post(
        Uri.encodeFull(
            'http://bellpepper.ae/apiLogin/api/GeoFence/RegisterGeofence'),
        body: {
          'GeoFenceName': geofenceName,
          'Latitude': latitude,
          'Longitude': longitude,
          'Radius': radius.toString(),
          'CreatedDate': DateTime.now().toString()
        },
      );
      if (response.statusCode == 200) {
        setState(
          () {
            _showLoading(false);

            // Navigator.pushNamed(context, '/geofences');

            // Navigator.push(
            //   context,
            //   new MaterialPageRoute(builder: (context) => Geofences()),
            // );

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/geofences', (Route<dynamic> route) => false);

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
      _showError();
    }
  }
}
