import 'package:flutter/material.dart';
import 'package:flutter_mqtt/modules/message/screen/enter_room.dart';
import 'package:flutter_mqtt/modules/message/screen/room.dart';
import 'package:flutter_mqtt/modules/message/screen/create_room.dart';
import 'package:flutter_mqtt/modules/settings/screen/changePassword.dart';
import 'package:flutter_mqtt/modules/settings/screen/signin.dart';
import 'package:flutter_mqtt/modules/settings/screen/signup.dart';
import 'package:flutter_mqtt/splash_screen.dart';
import 'package:provider/provider.dart';

import 'modules/core/managers/MQTTManager.dart';
import 'modules/helpers/screen_route.dart';
import 'modules/helpers/service_locator.dart';
import 'modules/message/screen/message_screen.dart';
import 'modules/settings/screen/settings_screen.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MQTTManager>(
      create: (context) => service_locator<MQTTManager>(),
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/splash_screen',
          routes: {
            '/': (BuildContext context) => MessageScreen(),
            '/splash_screen': (context) => Splash_Screen(),
            '/create_room': (context) => Subscribe_Screen(),
            '/enter_room': (context) => Enter_room(),
            '/setting': (BuildContext context) => SettingsScreen(),
            '/signup': (BuildContext context) => SignUp(),
            '/signin': (context) => SignIn(),
            '/room': (context) => Room(),
            '/changepass': (context) => changePassword(),
          }),
    );
  }
}
