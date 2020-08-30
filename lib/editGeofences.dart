import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'globle.dart';

const CameraPosition _kInitialPosition =
    CameraPosition(target: LatLng(-33.852, 151.211), zoom: 11.0);

class EditGeofences extends StatefulWidget {
  final int id;
  final String latitude;
  final String longitude;
  final String geoFenceName;
  final String radius;

  EditGeofences({
    Key key,
    this.id,
    this.latitude,
    this.longitude,
    this.geoFenceName,
    this.radius,
  }) : super(key: key);
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<EditGeofences> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  Map editGeofencesJson = {};
  final _editForm = GlobalKey<FormState>();

  String geoFenceName = '';
  String latitude;
  String longitude;
  String radius;
  GoogleMapController mapController;

  LatLng _lastTap;
  Position _currentPosition;

  String geofenceName = '';
  Set<Marker> _markers = {};

  _handleTap(LatLng point, String title) {
    setState(() {
      _markers = {};
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: title,
        ),
      ));
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: point,
            tilt: 50.0,
            bearing: 45.0,
            zoom: 16.0,
          ),
        ),
      );
    });
    _latitude.text = point.latitude.toString();
    _longitude.text = point.longitude.toString();
  }

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
    _latitude.text = widget.latitude.toString();
    _longitude.text = widget.longitude.toString();
    _initCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            child: GestureDetector(
          onTap: () {
            setState(() {
              if (_editForm.currentState.validate()) {
                _editForm.currentState.save();
              } else {
                return;
              }

              editGeofences();
            });
          },
          child: Material(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Submit",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        )),
        appBar: AppBar(
          title: Text('Edit Geofences'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Card(
                child: Container(
                  child: Form(
                    key: _editForm,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.geoFenceName,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.contacts),
                            hintText: 'Please enter geofence name',
                            labelText: 'Geofence Name',
                          ),
                          onSaved: (String value) {
                            geoFenceName = value;
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          // validator: (String value) {
                          //   return value.contains('@')
                          //       ? 'Do not use the @ char.'
                          //       : null;
                          // },
                        ),
                        TextFormField(
                          controller: _latitude,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.add_location),
                            hintText: 'Please enter latitude',
                            labelText: 'Latitude',
                          ),
                          onSaved: (String value) {
                            setState(() {
                              latitude = value;
                            });
                            // This optional block of code can be used to run
                            // code when the user saves the form.
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
                            setState(() {
                              longitude = value;
                            });
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          // validator: (String value) {
                          //   return value.contains('@')
                          //       ? 'Do not use the @ char.'
                          //       : null;
                          // },
                        ),
                        TextFormField(
                          initialValue: widget.radius.toString(),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.line_style),
                            hintText: 'Please enter radius metres',
                            labelText: 'Radius(metres)',
                          ),
                          onSaved: (String value) {
                            setState(() {
                              radius = value;
                            });
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          // validator: (String value) {
                          //   return value.contains('@')
                          //       ? 'Do not use the @ char.'
                          //       : null;
                          // },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            child: RaisedButton(
                              onPressed: () {
                                _handleTap(
                                    LatLng(double.parse(_latitude.text),
                                        double.parse(_longitude.text)),
                                    geoFenceName);
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text('Check on Map'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: GoogleMap(
                  markers: _markers,
                  myLocationEnabled: true,
                  onMapCreated: onMapCreated,
                  initialCameraPosition: _kInitialPosition,
                  onLongPress: (LatLng) {
                    setState(() {
                      _handleTap(LatLng, geoFenceName);
                      _latitude.text = LatLng.latitude.toString();
                      _longitude.text = LatLng.longitude.toString();
                    });
                  },
                  zoomGesturesEnabled: true,
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
                    editGeofences();
                  },
                  child: new Text('Please try again'),
                ),
              ],
            ),
          );
        });
  }

  Future editGeofences() async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.put(
          Uri.encodeFull(
              'http://94.206.79.138/apiLogin/api/GeoFence/UpdateGeofence'),
          // encoding: ,
          // headers: {
          //   'Content-Type': 'application/json',
          // },
          body: {
            'Id': widget.id.toString(),
            'GeoFenceName': geoFenceName,
            'Latitude': latitude,
            'Longitude': longitude,
            'Radius': radius,
          });

      if (response.statusCode == 200) {
        setState(
          () {
            // editGeofencesJson = json.decode(response.body);
            // userLvl = int.parse(loginJson['lvl']);
            _showLoading(false);

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/geofences', (Route<dynamic> route) => false);
          },
        );
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('username', username);
        // prefs.setString('password', password);
        print(editGeofencesJson);
        loggedin = true;
      } else if (response.statusCode != 200) {
        _showLoading(false);
      }
    } catch (x) {
      print(x);
      _showError();
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }
}
