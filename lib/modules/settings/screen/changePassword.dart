import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mqtt/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';

class changePassword extends StatefulWidget {
  const changePassword({Key? key}) : super(key: key);

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  @override
  final TextEditingController _newpassTextController = TextEditingController();
  final TextEditingController _oldpassTextController = TextEditingController();
  final TextEditingController _confirmpassTextController =
      TextEditingController();
  late MQTTManager _manager;
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff8000ff),
                Color.fromARGB(255, 199, 153, 241),
                Color.fromARGB(255, 147, 45, 248),
              ],
            ),
          ),
        ),
      ),
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
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xe5ffffff), Color(0x33ffffff)],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Change Password",
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
                            TextField(
                                controller: _oldpassTextController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 0, bottom: 0, top: 0, right: 0),
                                  labelText: "Old Password",
                                )),
                            TextFormField(
                                controller: _newpassTextController,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.only(
                                      left: 0, bottom: 0, top: 0, right: 0),
                                  labelText: "New Password",
                                )),
                            TextFormField(
                                controller: _confirmpassTextController,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.only(
                                      left: 0, bottom: 0, top: 0, right: 0),
                                  labelText: "Confirm Password",
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
                                    _manager.subScribeTo('python_backend');
                                    if (_oldpassTextController.text ==
                                        _newpassTextController.text) {
                                      String message =
                                          "{OldPassword:${_oldpassTextController.text},Newpassword:${_newpassTextController.text}}";
                                      _manager.publish(message);
                                      _manager.unSubscribeFromCurrentTopic();
                                      Navigator.pushNamed(context, '/room');
                                    }
                                    const snackBar =
                                        SnackBar(content: Text('please retry'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  child: Text("Change")),
                            ),
                          ],
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
    );
  }
}
