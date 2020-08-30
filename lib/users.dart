import 'dart:convert';
import 'package:attendance/globle.dart';
import 'package:http/http.dart' as http;

import 'package:attendance/drawer.dart';
import 'package:flutter/material.dart';

import 'addUsers.dart';
import 'editUsers.dart';

class Users extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Users> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var seachCnt = TextEditingController();
  String selectedName = "";
  List itemsToShow = [];

  List itemsJson = [];
  @override
  void initState() {
    getUsers();
    selectedName = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SafeArea(
            child: AppDrawer(
          selected: 'Users',
        )),
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Card(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: seachCnt,

                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Please enter employee number',
                          labelText: 'Employee Number',
                        ),
                        onChanged: (x) {
                          setState(() {
                            selectedName = x;
                            searchItems();
                          });
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddUsers(),
                                ),
                              );
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text('Add New'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 6,
                child: Container(
                  child: ListView.builder(
                      itemCount: itemsToShow.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return buildItems(index);
                      }),
                )),
          ],
        ));
  }

  buildItems(index) {
    return Card(
      child: Container(
        child: ListTile(
          trailing: Column(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUser(
                          userId: itemsJson[index]['userid'],
                          name: itemsJson[index]['name'].toString(),
                          username: itemsJson[index]['username'].toString(),
                          password: itemsJson[index]['password'].toString(),
                          role:
                              itemsJson[index]['role_name'] == 'admin' ? 0 : 1,
                          email: itemsJson[index]['email_id'].toString(),
                          managerId: itemsJson[index]['managerid'].toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(child: Icon(Icons.edit))),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child:
                    Text('User ID:' + itemsToShow[index]['userid'].toString()),
              ),
              Container(
                child: Text('Name:' + itemsToShow[index]['name'].toString()),
              ),
              Container(
                child: Text(
                    'UserName:' + itemsToShow[index]['username'].toString()),
              ),
              Container(
                child: Text(
                    'employee No:' + itemsToShow[index]['userid'].toString()),
              ),
              Container(
                child:
                    Text('Role:' + itemsToShow[index]['role_name'].toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchItems() {
    setState(() {
      itemsToShow = itemsJson.where((i) {
        if (selectedName != "" &&
            !i['userid'].toString().contains(selectedName)) {
          return false;
        } else {
          return true;
        }
        // if(archive==0){}
      }).toList();
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
                    getUsers();
                  },
                  child: new Text('Please try again'),
                ),
              ],
            ),
          );
        });
  }

  Future getUsers() async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });

    try {
      final response = await http.post(
        Uri.encodeFull('http://bellpepper.ae/apiLogin/api/Users/GetUsers/'),
        body: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        setState(
          () {
            itemsJson = json.decode(response.body);
            itemsToShow = itemsJson;
            selectedName = '';
            seachCnt.text = '';
          },
        );

        _showLoading(false);
      } else {
        _showError();
      }
    } catch (x) {
      _showError();
    }
  }
}
