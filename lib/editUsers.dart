import 'package:attendance/users.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

import 'globle.dart';

class EditUser extends StatefulWidget {
  final String userId;
  final String name;
  final String username;
  final String password;
  final int role;
  final String email;
  final String managerId;

  EditUser({
    Key key,
    this.userId,
    this.name,
    this.username,
    this.password,
    this.role,
    this.email,
    this.managerId,
  }) : super(key: key);

  State<StatefulWidget> createState() => new _State();
}

class _State extends State<EditUser> {
  final _editFormUsers = GlobalKey<FormState>();

  String userId;
  String name;
  String username;
  String password;
  int role;
  String email;
  String managerId;

  @override
  void initState() {
    super.initState();

    // setState(() {
    //   switch (widget.role) {
    //     case 'admin':
    //       role = 0;
    //       break;
    //     case 'Employee':
    //       role = 1;
    //       break;
    //     default:
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            child: GestureDetector(
          onTap: () {
            setState(() {
              if (_editFormUsers.currentState.validate()) {
                _editFormUsers.currentState.save();
              } else {
                return;
              }

              editUsers();
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
                    key: _editFormUsers,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          enabled: false,
                          initialValue: widget.userId,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.contacts),
                            hintText: 'Please enter user id',
                            labelText: 'UserId',
                          ),
                          onSaved: (String value) {
                            userId = value;
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
                          initialValue: widget.name.toString(),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.add_location),
                            hintText: 'Please enter your name',
                            labelText: 'Name',
                          ),
                          onSaved: (String value) {
                            setState(() {
                              name = value;
                            });
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                        ),
                        TextFormField(
                          enabled: false,
                          initialValue: widget.username.toString(),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.edit_location),
                            hintText: 'Please enter employee no',
                            labelText: 'Employee No',
                          ),
                          onSaved: (String value) {
                            setState(() {
                              username = value;
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
                          initialValue: widget.password.toString(),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.line_style),
                            hintText: 'Please enter your password',
                            labelText: 'Password',
                          ),
                          onSaved: (String value) {
                            setState(() {
                              password = value;
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
                        Container(
                          //check box
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Text('Role Name'),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 30,
                                child: ToggleSwitch(
                                  minWidth: 90.0,
                                  initialLabelIndex: widget.role,

                                  cornerRadius: 10.0,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  labels: ['Admin', 'Empolyee'],
                                  // icons: [
                                  //   FontAwesomeIcons.mars,
                                  //   FontAwesomeIcons.venus
                                  // ],
                                  activeBgColors: [Colors.red, Colors.green],
                                  onToggle: (index) {
                                    // setState(() {
                                    role = index;
                                    // });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          initialValue: widget.email.toString(),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.line_style),
                            hintText: 'Please enter your email',
                            labelText: 'Email',
                          ),
                          onSaved: (String value) {
                            setState(() {
                              email = value;
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
                          initialValue: widget.managerId.toString(),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.line_style),
                            hintText: 'Please enter manager id',
                            labelText: 'Manager Id',
                          ),
                          onSaved: (String value) {
                            setState(() {
                              managerId = value;
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
                      ],
                    ),
                  ),
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
                    editUsers();
                  },
                  child: new Text('Please try again'),
                ),
              ],
            ),
          );
        });
  }

  Future editUsers() async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.post(
        Uri.encodeFull('http://bellpepper.ae/apiLogin/api/Users/UpdateUsers/'),
        // encoding: ,
        // headers: {
        //   'Content-Type': 'application/json',
        // },
        body: {
          'username': username,
          'password': password,
          'emailid': email,
          'userid': userId,
          'managerid': managerId,
          'name': name,
          'rolename': role == 0 ? 'admin' : 'Employee',
          'mode': "Edit",
        },
      );

      if (response.statusCode == 200) {
        setState(
          () {
            // editGeofencesJson = json.decode(response.body);
            // userLvl = int.parse(loginJson['lvl']);
            // Navigator.pop(context);
            // Future.delayed(Duration(seconds: 1), () {
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/users', (Route<dynamic> route) => false);
            // });
            // Navigator.popUntil(context, ModalRoute.withName('/attendance'));
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Users(),
            //   ),
            // );
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/users', (Route<dynamic> route) => false);
          },
        );
        _showLoading(false);
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('username', username);
        // prefs.setString('password', password);
        loggedin = true;
      } else if (response.statusCode != 200) {
        _showLoading(false);
      }
    } catch (x) {
      print(x);
      _showError();
    }
  }
}
