import 'dart:io';
import 'package:flutter_mqtt/modules/settings/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mqtt/modules/core/managers/MQTTManager.dart';
import 'package:flutter_mqtt/modules/core/models/MQTTAppState.dart';
import 'package:flutter_mqtt/modules/core/widgets/status_bar.dart';
import 'package:flutter_mqtt/modules/helpers/screen_route.dart';
import 'package:flutter_mqtt/modules/helpers/status_info_message_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
  // late String _identifier;
  // void getIdentifier({
  //   required String identifier,
  // }) {
  //   _identifier = identifier;
  // }
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _controller = ScrollController();
  late SettingsScreen _screen;

  late MQTTManager _manager;
  // String? _identifier;
  Future change_screen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('LogedIn', false);
    Navigator.pushNamed(context, '/signin');
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _topicTextController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // void getIdentifier({
  //   required String identifier,
  // }) {
  //   _identifier = identifier;
  // }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    // if (_controller.hasClients) {
    //   _controller.jumpTo(_controller.position.maxScrollExtent);
    // }
    bool a = false;
    return WillPopScope(
      onWillPop: () async {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Alert'),
            content: const Text('Are You Leaving The Room'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _manager.unSubscribeFromCurrentTopic();
                  // _manager.currentState.clearText();
                  Navigator.pushNamed(context, '/room');
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return a;
      },
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
    String tdata = DateFormat("hh:mm a").format(DateTime.now());
    String a = _manager.currentState.getHistoryText;
    List lis = a.split('\n');
    int len = lis.length;
    print(lis);
    if (len == 1 || len == 0) {
      lis.removeAt(0);
    } else if (lis[1].toString().length > 5 &&
        lis[1].toString().substring(0, 5) == '{name' &&
        lis[0].toString() == '' &&
        len >= 2) {
      lis.removeAt(0);
      lis.removeAt(0);
    } else if (lis[0].toString() == '') lis.removeAt(0);
    len = lis.length;

    int j = 1;
    return Container(
      height: double.maxFinite,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 176, 105, 247),
          Color.fromARGB(255, 253, 240, 253)
        ],
      )),
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                  child: ListView.builder(
                      itemCount: ((len) / 2).toInt(),
                      itemBuilder: (BuildContext context, int index) {
                        print(a.substring(1, 4));
                        if (index == 0) {
                          j = 0;
                        }
                        if ((index == 0 || index == 1) &&
                            a.substring(1, 4) == 'ok') {
                          j = 1;
                          return Text('Message sent from $tdata');
                        }
                        if (index == 0 && a.substring(1, 7) == '{"Room') {
                          j = 2;
                          return Text('Message sent from $tdata');
                        } else if (len == 0 || len == 1)
                          return Text('You can start to send message');
                        else {
                          print(lis);
                          return _buildScrollableTextWith(lis[j++], lis[(j++)]);
                        }
                      }))),
          _buildPublishMessageRow(manager.currentState),
        ],
      ),
    );
  }

  // Widget _buildEditableColumn(MQTTAppState currentAppState) {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Column(
  //       children: <Widget>[
  //         Expanded(
  //             child: Container(
  //                 child: ListView.builder(
  //                     itemCount: 5,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return _buildScrollableTextWith(
  //                           currentAppState.getHistoryText);
  //                     }))),
  //         _buildPublishMessageRow(currentAppState),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPublishMessageRow(MQTTAppState currentAppState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(_messageTextController, 'Enter a message',
              currentAppState.getAppConnectionState),
        ),
        _buildSendButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connectedSubscribed) {
      shouldEnable = true;
    } else if ((controller == _topicTextController &&
        (state == MQTTAppConnectionState.connected ||
            state == MQTTAppConnectionState.connectedUnSubscribed))) {
      shouldEnable = true;
    }
    return TextField(
        enabled: true,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colors.green,
      disabledColor: Colors.grey,
      textColor: Colors.white,
      disabledTextColor: Colors.black38,
      child: const Text('Send'),
      onPressed: state == MQTTAppConnectionState.connectedSubscribed
          ? () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('LogedIn', true);
              var identifier = await prefs.getString('identifier');
              _publishMessage(
                '$identifier\n' +
                    _messageTextController.text, /*widget._identifier*/
              );
            }
          : null, //
    );
  }

  Widget _buildTopicSubscribeRow(MQTTAppState currentAppState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(
              _topicTextController,
              'Enter a topic to subscribe or listen',
              currentAppState.getAppConnectionState),
        ),
        _buildSubscribeButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildSubscribeButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colors.green,
      disabledColor: Colors.grey,
      textColor: Colors.white,
      disabledTextColor: Colors.black38,
      child: state == MQTTAppConnectionState.connectedSubscribed
          ? const Text('Unsubscribe')
          : const Text('Subscribe'),
      onPressed: (state == MQTTAppConnectionState.connectedSubscribed) ||
              (state == MQTTAppConnectionState.connectedUnSubscribed) ||
              (state == MQTTAppConnectionState.connected)
          ? () {
              _handleSubscribePress(state);
            }
          : null, //
    );
  }

  Widget _buildScrollableTextWith(String text1, String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(text1),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10),
            child: Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
              ),
              child: Text(text),
            ),
          ),
        ],
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
        _showDialog("Please enter a topic.");
      }
    }
  }

  void _publishMessage(
    String text,
    /*String identifier*/
  ) {
    // String osPrefix = identifier;

    final String message = text; //osPrefix + ' says: ' +
    _manager.publish(message);
    _messageTextController.clear();
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
