import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username = '';
String password = '';
Map loginJson = {};

bool loggedin = false;

void logOut(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: new AlertDialog(
            content: new Row(
              children: <Widget>[new Text('Are you sure you want logout ?')],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Cancel'),
              ),
              new FlatButton(
                onPressed: () async {
                  username = '';
                  password = '';
                  loggedin = false;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  prefs.setString('username', username);
                  prefs.setString('password', password);
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, "/");
                },
                child: new Text('Ok'),
              ),
            ],
          ),
        );
      });
}
