import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mqtt/modules/core/managers/MQTTManager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  bool login = true;
  late MQTTManager _manager;
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _manager.initializeMQTTClient(
          host: 'broker.hivemq.com', identifier: 'anf', port: 1883);
      _manager.connect();
    });
    getLogin().whenComplete(() async {
      Timer(Duration(seconds: 5),
          () => Navigator.pushNamed(context, login ? '/room' : '/signin'));
    });
  }

  Future getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var login1 = await prefs.getBool('LogedIn').toString();
    setState(() {
      login = login1.toLowerCase() == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Container(
        color: Colors.yellow,
        child: FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}
