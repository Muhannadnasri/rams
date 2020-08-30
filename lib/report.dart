import 'dart:convert';

import 'package:attendance/drawer.dart';
import 'package:attendance/globle.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Report extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Report> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // DateTime selectedDate = DateTime.now();
  // String selectedDatee = '';
  Map locationReportJson = {};
  final _reportFormKey = GlobalKey<FormState>();
  bool _isChecked = true;
  String fromDateSend;
  String toDateSend;

  List reportStatusJson = [];
  List reportJson = [];
  // DateTime fromDate;
  var fromDateText = TextEditingController();
  var toDateText = TextEditingController();
  DateTime ifValue;
  // var toDate = TextEditingController();
  final DateFormat format = DateFormat('yyyy-MM-dd');
  final DateFormat formatSend = DateFormat('yyyyMMdd');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Future<Null> _selectDate(BuildContext context, var date) async {
  //   final DateTime pickedDate = await showDatePicker(
  //     initialDatePickerMode: DatePickerMode.day,
  //     // locale: Local,
  //     context: context,
  //     initialDate: date == fromDate
  //         ? DateTime.now().subtract(Duration(days: selectedDate.day))
  //         : DateTime.now(),
  //     firstDate: DateTime(2018, 8),
  //     lastDate: DateTime(2404),
  //   );

  //   final DateFormat formatter = DateFormat('yyyy-MM-dd');

  //   if (pickedDate != null && pickedDate != selectedDate)
  //     setState(() {
  //       selectedDate = pickedDate;
  //       selectedDatee = formatter.format(selectedDate);

  //       // date = pickedDate;

  //       date.text = selectedDatee;
  //       // '${selectedDate.year}${selectedDate.month}${selectedDate.day}';
  //     });
  //   // if (pickedTime != null && pickedTime != selectedTime)
  //   //   setState(() {
  //   //     selectedTime = pickedTime;
  //   //     date.text = '$selectedTime';
  //   //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
          child: AppDrawer(
        selected: 'Report',
      )),
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Expanded(
              flex: 3,
              child: Form(
                key: _reportFormKey,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            // minTime: DateTime(2018, 3, 5),
                            maxTime: DateTime.now(),
                            theme: DatePickerTheme(
                                headerColor: Colors.blue,
                                backgroundColor: Colors.blue,
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            //     onChanged: (date) {
                            //   print('change $date in time zone ' +
                            //       date.timeZoneOffset.inHours.toString());
                            // },
                            onConfirm: (date) {
                          setState(() {
                            ifValue = date;
                            fromDateSend = formatSend.format(date);
                            fromDateText.text = format.format(date);

                            //  fromDate.toString();
                            // formatsend
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        // _selectDate(context, fromDate);

                        // setState(() {
                        //   isEditing = true;
                        // });
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: new InputDecoration(
                            icon: new Icon(Icons.date_range),
                            labelText: "From Date",
                          ),
                          controller: fromDateText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            // minTime: DateTime(2018, 3, 5),
                            minTime: ifValue,
                            maxTime: DateTime.now(),
                            theme: DatePickerTheme(
                                headerColor: Colors.blue,
                                backgroundColor: Colors.blue,
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onConfirm: (date) {
                          toDateSend = formatSend.format(date);
                          toDateText.text = format.format(date);
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                        // _selectDate(context, toDate);
                        // setState(() {
                        //   isEditing = true;
                        // });
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: new InputDecoration(
                            icon: new Icon(Icons.date_range),
                            labelText: "To Date",
                          ),
                          controller: toDateText,

                          // validator: (x) => x.isEmpty ? "Please enter date" : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  if (_reportFormKey.currentState.validate()) {
                                    _reportFormKey.currentState.save();
                                  } else {
                                    return;
                                  }
                                  // print(fromDateSend);
                                  // print(fromDateText.text);

                                  // print(toDate.text);
                                  // print(selectedDatee);
                                  getReport();
                                });
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text('Load Report'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  // approveReport();
                                });
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text('Approve Attendance'),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: reportJson.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text('Emp No: '),
                              ),
                              Container(
                                child: Text(reportJson[index]['employeE_NUMBER']
                                    .toString()),
                              ),
                              Container(
                                child: Text('Date: '),
                              ),
                              Container(
                                child:
                                    Text(reportJson[index]['date'].toString()),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text('Time: '),
                                  ),
                                  Container(
                                    child: Text(
                                        reportJson[index]['timeIn'].toString()),
                                  ),
                                  Container(
                                    child: Text('Status: '),
                                  ),
                                  Container(
                                    child: Text(
                                      reportJson[index]['presentStatus']
                                          .toString(),
                                      style: TextStyle(
                                          color: reportJson[index]
                                                      ['presentStatus'] ==
                                                  'Pending'
                                              ? Colors.blue
                                              : Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: RaisedButton(
                                  elevation: 5,
                                  onPressed: () {},
                                  child: const Text('View in Map',
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Checkbox(
                            value: reportStatusJson[index]['presentStatus'] ==
                                    'Pending'
                                ? false
                                : true,
                            onChanged: (val) {
                              setState(() {
                                switch (val) {
                                  case false:
                                    {
                                      // reportStatusJson[index]
                                      //     ['presentStatus'] = 'Pending';
                                      // approveReport(index);
                                    }
                                    break;
                                  case true:
                                    {
                                      approveReport(index);
                                      getReport();
                                      reportStatusJson[index]['presentStatus'] =
                                          'Approved';
                                      // val = null;
                                    }
                                    break;
                                  default:
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
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
                    getReport();
                  },
                  child: new Text('Please try again'),
                ),
              ],
            ),
          );
        });
  }

  Future getReport() async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.post(
        Uri.encodeFull(
            'http://bellpepper.ae/apiLogin/api/Geofence/GetEmployeeAttendance'),
        body: {
          'empId': loginJson['userName'],
          'fromDt': fromDateSend,
          'toDt': toDateSend,
          'Status': 'List',
        },
      );
      if (response.statusCode == 200) {
        setState(
          () {
            _showLoading(false);

            reportJson = json.decode(response.body);
            reportStatusJson = json.decode(response.body);

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

  Future approveReport(int index) async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.post(
        Uri.encodeFull(
            'http://bellpepper.ae/apiLogin/api/Geofence/UpdateEmployeeAttendance'),
        body: {
          'ids': reportStatusJson[index]['id'].toString(),
          'empId': loginJson['userName'],
          'fromDt': fromDateSend,
          'toDt': toDateSend,
          'Status': 'Approve',
        },
      );
      if (response.statusCode == 200) {
        setState(
          () {
            _showLoading(false);

            // reportJson = json.decode(response.body);
            // reportStatusJson = json.decode(response.body);

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

  Future locationReport(int index) async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.post(
        Uri.encodeFull(
            'http://bellpepper.ae/apiLogin/api/Geofence/GetGeofenceById/${reportJson[index]['id']}'),
        body: {
          'ids': reportStatusJson[index]['presentStatus'],
          'empId': loginJson['userName'],
          // 'fromDt': fromDate.text,
          // 'toDt': toDate.text,
          'Status': 'List',
        },
      );
      if (response.statusCode == 200) {
        setState(
          () {
            _showLoading(false);

            locationReportJson = json.decode(response.body);

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

  _launchURL(latitude, longitude) async {
    if (await canLaunch(
        "comgooglemaps://?center=$latitude,$longitude&zoom=14")) {
      await launch("comgooglemaps://?center=$latitude,$longitude&zoom=14");
    } else {
      throw 'Could not launch';
    }
  }
}
