import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mqtt/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _userTextController = TextEditingController();
  final TextEditingController _dobTextController = TextEditingController();
  final TextEditingController _designationTextController =
      TextEditingController();
  final TextEditingController _OrganizationTextController =
      TextEditingController();
  late MQTTManager _manager;

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    final _formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff7f00ff), Colors.white],
          )),
          child: Center(
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ChatMQ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xe5ffffff), Color(0x33ffffff)],
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter user name';
                                      }
                                    },
                                    controller: _userTextController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 0, bottom: 0, top: 0, right: 0),
                                      labelText: "Name",
                                    )),
                                TextFormField(
                                    controller: _dobTextController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 0, bottom: 0, top: 0, right: 0),
                                      labelText: "Date Of Birth",
                                    )),
                                TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Organization Name';
                                      }
                                    },
                                    controller: _OrganizationTextController,
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 0,
                                            bottom: 0,
                                            top: 0,
                                            right: 0),
                                        labelText: "Organization")),
                                TextFormField(
                                    controller: _designationTextController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Designation';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 0, bottom: 0, top: 0, right: 0),
                                      labelText: "Designation",
                                    )),
                                TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Password';
                                      }
                                    },
                                    controller: _passwordTextController,
                                    decoration: InputDecoration(
                                      // border: OutlineInputBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(10)),
                                      contentPadding: const EdgeInsets.only(
                                          left: 0, bottom: 0, top: 0, right: 0),
                                      labelText: "Password",
                                    )),
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x0c000000),
                                        blurRadius: 16,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color.fromARGB(255, 131, 35, 228),
                                        Color.fromARGB(255, 252, 220, 252)
                                      ],
                                    ),
                                  ),
                                  child: FlatButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          // _manager.subScribeTo('CHMQ_0_sign_up');
                                          // String message =
                                          //     "{name:${_userTextController.text},dob:${_dobTextController.text},Designation:${_designationTextController.text},Organization:${_OrganizationTextController.text},password:${_passwordTextController.text}}";
                                          // _manager.publish(message);
                                          // _manager.unSubscribeFromCurrentTopic();
                                          // _manager.currentState.clearText();
                                          _manager
                                              .subScribeTo('CHMQ_0_sign_up');
                                          String messge =
                                              ' {"Username":"usertttname","DOB": "07/12/22", "Email": "bala@gmail.com","Organization":"Organization", "Designation":"Designation", "Password":"word" }';
                                          _manager.publish(messge);
                                          print(_manager
                                              .currentState.getReceivedText);
                                          _manager
                                              .unSubscribeFromCurrentTopic();
                                          _manager.currentState.clearText();
                                          print(_manager
                                              .currentState.getReceivedText
                                              .toString());
                                          print(_manager.currentState
                                              .getAppConnectionState);

                                          _manager.subScribeTo(
                                              'CHMQ_0_sign_up_res');
                                          print(_manager
                                              .currentState.getReceivedText);
                                          // Navigator.pushNamed(context, '/room');
                                          Timer(Duration(seconds: 15),
                                              () async {
                                            print('hi bala fhx');
                                            print(_manager.currentState
                                                    .getReceivedText +
                                                'dht');
                                            if (_manager.currentState
                                                    .getReceivedText ==
                                                'ok') {
                                              _manager
                                                  .unSubscribeFromCurrentTopic();
                                              await prefs.setBool(
                                                  'LogedIn', true);
                                              await prefs.setString(
                                                  'identifier', 'ans');
                                              Navigator.pushNamed(
                                                  context, '/room');
                                            } else {
                                              _manager
                                                  .unSubscribeFromCurrentTopic();
                                              print(_manager.currentState
                                                  .getReceivedText);
                                              const snackBar =
                                                  SnackBar(content: Text(''));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          });
                                        }
                                      },
                                      child: Text("sign up")),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already on ChatMQ?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/signin');
                                      },
                                      child: Text(
                                        "Sign in",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
