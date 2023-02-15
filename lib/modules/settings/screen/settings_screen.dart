import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mqtt/modules/core/managers/MQTTManager.dart';
import 'package:flutter_mqtt/modules/core/models/MQTTAppState.dart';
import 'package:flutter_mqtt/modules/core/widgets/status_bar.dart';
import 'package:flutter_mqtt/modules/helpers/status_info_message_utils.dart';
import 'package:flutter_mqtt/modules/message/screen/message_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _userTextController = TextEditingController();
  final TextEditingController _portTextController = TextEditingController();
  late MQTTManager _manager;
  MessageScreen _msg = new MessageScreen();

  @override
  void dispose() {
    _hostTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
        appBar: _buildAppBar(context) as PreferredSizeWidget?,
        body: _manager.currentState == null
            ? CircularProgressIndicator()
            : _buildColumn(_manager));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings'),
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
    );
  }

  Widget _buildColumn(MQTTManager manager) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff7f00ff), Colors.white],
      )),
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
      padding: const EdgeInsets.all(10.0),
      child: Container(
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
          children: <Widget>[
            _buildTextFieldWith(_hostTextController, 'Enter broker address'),
            _buildTextFieldWith(_userTextController, 'User Name'),
            _buildTextFieldWith(_portTextController, 'Port Number'),
            const SizedBox(height: 10),
            _buildConnecteButtonFrom(currentAppState.getAppConnectionState),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWith(
    TextEditingController controller,
    String hintText,
  ) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Container(
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
          color: Colors.transparent,
          child: const Text('Connect'),
          onPressed: () {
            _manager.disconnect();
            int a = int.parse(_portTextController.text);
            _manager.initializeMQTTClient(
                host: _hostTextController.text,
                identifier: _userTextController.text,
                port: a);
            _manager.connect();
          } //
          ),
    );
  }

  void _configureAndConnect() {
    // TODO: Use UUID
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    int a = int.parse(_portTextController.text);
    _manager.initializeMQTTClient(
        host: _hostTextController.text,
        identifier: _userTextController.text,
        port: a);
    _manager.connect();
    // _msg.getIdentifier(
    //   identifier: _userTextController.text,
    // );
  }

  void _disconnect() {
    _manager.disconnect();
  }
}
