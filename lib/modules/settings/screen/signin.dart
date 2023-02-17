import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mqtt/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _userTextController = TextEditingController();

  late MQTTManager _manager;
  bool isLoding = false;
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
                          height: 450,
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
                                    controller: _userTextController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Name';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 0, bottom: 0, top: 0, right: 0),
                                      labelText: "Name",
                                    )),
                                TextFormField(
                                    controller: _passwordTextController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Password';
                                      }
                                    },
                                    obscureText: true,
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
                                          setState(() {
                                            isLoding = true;
                                          });
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setBool('LogedIn', true);
                                          await prefs.setString('identifier',
                                              '${_userTextController.text}');
                                          _manager
                                              .subScribeTo('CHMQ_0_sign_in');
                                          String message =
                                              '{"Username":"${_userTextController.text}","Password":"${_passwordTextController.text}"}';
                                          _manager.publish(message);
                                          print(_manager
                                              .currentState.getReceivedText);
                                          _manager
                                              .unSubscribeFromCurrentTopic();
                                          _manager.currentState.clearText();
                                          print(_manager.currentState
                                                  .getReceivedText +
                                              'fhcgjvh');
                                          _manager.subScribeTo(
                                              'CHMQ_0_sign_in_res');
                                          print(_manager
                                              .currentState.getReceivedText);

                                          Timer(Duration(seconds: 5),
                                              () async {
                                            print(_manager
                                                .currentState.getReceivedText);
                                            setState(() {
                                              isLoding = false;
                                            });
                                            if (_manager.currentState
                                                    .getReceivedText ==
                                                'ok') {
                                              _manager
                                                  .unSubscribeFromCurrentTopic();
                                              await prefs.setBool(
                                                  'LogedIn', true);
                                              await prefs.setString(
                                                  'identifier',
                                                  '${_userTextController.text}');
                                              Navigator.pushNamed(
                                                  context, '/room');
                                            } else if (_manager.currentState
                                                    .getReceivedText ==
                                                'Na') {
                                              _manager
                                                  .unSubscribeFromCurrentTopic();
                                              print('df' +
                                                  _manager.currentState
                                                      .getReceivedText);
                                              const snackBar = SnackBar(
                                                  content: Text(
                                                      'Incorrect Username or Password'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              _manager
                                                  .unSubscribeFromCurrentTopic();
                                              print('df' +
                                                  _manager.currentState
                                                      .getReceivedText);
                                              const snackBar = SnackBar(
                                                  content:
                                                      Text('Network Issue'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          });
                                        }
                                      },
                                      child: isLoding
                                          ? CircularProgressIndicator()
                                          : Text("Sign In")),
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
                                        Navigator.pushNamed(context, '/signup');
                                      },
                                      child: Text(
                                        "Sign Up",
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
