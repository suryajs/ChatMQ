import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mqtt/modules/core/managers/MQTTManager.dart';
import 'package:flutter_mqtt/modules/core/models/MQTTAppState.dart';
import 'package:flutter_mqtt/modules/core/widgets/status_bar.dart';
import 'package:flutter_mqtt/modules/helpers/screen_route.dart';
import 'package:flutter_mqtt/modules/helpers/status_info_message_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Enter_room extends StatefulWidget {
  const Enter_room({Key? key}) : super(key: key);

  @override
  State<Enter_room> createState() => _Enter_roomState();
}

class _Enter_roomState extends State<Enter_room> {
  final TextEditingController _topicTextController = TextEditingController();
  late MQTTManager _manager;

  bool isLoding = false;
  Future change_screen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('LogedIn', false);
    Navigator.pushNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          appBar: _buildAppBar(context) as PreferredSizeWidget?,
          body: _manager.currentState == null
              ? CircularProgressIndicator()
              : _buildColumn(_manager)),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
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
      actions: [
        PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Text("Edit connection"),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text("App info"),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: Text("Change password"),
            ),
            PopupMenuItem<int>(
              value: 3,
              child: Text("Logout"),
            ),
          ];
        }, onSelected: (value) {
          if (value == 0) {
            Navigator.pushNamed(context, '/setting');
          } else if (value == 1) {
            print("Settings menu is selected.");
          } else if (value == 2) {
            Navigator.pushNamed(context, '/changepass');
          } else if (value == 3) {
            change_screen();
          }
        }),
      ],
    );
  }

  Widget _buildColumn(MQTTManager manager) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff8000ff), Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildEditableColumn(manager.currentState),
        ],
      ),
    );
  }

  Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTopicSubscribeRow(currentAppState),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTopicSubscribeRow(MQTTAppState currentAppState) {
    return Container(
      width: 350,
      height: 265,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0x0c000000),
            blurRadius: 18,
            offset: Offset(2, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xe5ffffff), Color(0x33ffffff)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Join Room",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
          _buildTextFieldWith(_topicTextController, 'Room Name',
              currentAppState.getAppConnectionState),
          _buildSubscribeButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = true;
    return TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter Rome Name';
          }
        },
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildSubscribeButtonFrom(MQTTAppConnectionState state) {
    return Container(
      width: 200,
      height: 50,
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
        color: Colors.transparent,
        textColor: Colors.white,
        disabledTextColor: Colors.black38,
        child: isLoding ? CircularProgressIndicator() : Text('Subscribe'),
        onPressed: (state == MQTTAppConnectionState.connectedSubscribed) ||
                (state == MQTTAppConnectionState.connectedUnSubscribed) ||
                (state == MQTTAppConnectionState.connected)
            ? () async {
                setState(() {
                  isLoding = true;
                });
                final prefs = await SharedPreferences.getInstance();
                _manager.subScribeTo('CHMQ_0_enter_room');
                String? identifier = prefs.getString('identifier');
                String message =
                    '{"Room_name": "${_topicTextController.text}","Username":"$identifier"}';
                _manager.publish(message);
                _manager.unSubscribeFromCurrentTopic();
                _manager.currentState.clearText();
                print(_manager.currentState.getReceivedText + 'fhcgjvh');
                _manager.subScribeTo('CHMQ_0_enter_room_res');
                print(_manager.currentState.getReceivedText);
                // Navigator.pushNamed(context, '/room');
                Timer(Duration(seconds: 10), () async {
                  print(_manager.currentState.getReceivedText);
                  if (_manager.currentState.getReceivedText == 'ok') {
                    _handleSubscribePress(state);
                    setState(() {
                      isLoding = false;
                    });
                    Navigator.pushNamed(context, '/');
                  } else {
                    setState(() {
                      isLoding = false;
                    });
                    _manager.unSubscribeFromCurrentTopic();
                    print('df' + _manager.currentState.getReceivedText);
                    const snackBar =
                        SnackBar(content: Text('Room Not Created'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              }
            : null, //
      ),
    );
  }

  void _handleSubscribePress(MQTTAppConnectionState state) {
    if (state == MQTTAppConnectionState.connectedSubscribed) {
      _manager.unSubscribeFromCurrentTopic();
    } else {
      String enteredText = _topicTextController.text;
      if (enteredText != null && enteredText.isNotEmpty) {
        _manager.subScribeTo(_topicTextController.text);
      } else {
        SnackBar(content: Text("Please enter a topic."));
      }
    }
  }
}
