import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cast_web/cast.dart';
import 'package:js/js.dart';

void main() {
  final manager =
      Receiver
      .castReceiverManager
      .getInstance();
  runApp(MyApp(manager));
}

class MyApp extends StatelessWidget {
  final CastReceiverManager manager;

  MyApp(this.manager);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(manager: manager),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.manager}) : super(key: key);

  final CastReceiverManager manager;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String info = "This is a casted app";
  CastMessageBus bus;

  @override
  void initState() {
    widget.manager.onReady = allowInterop((event) => setState(() {
          final eventString = jsonEncode(event);
          print(eventString);
          info = "Ready!\n$eventString";
        }));
    widget.manager.onSenderConnected = allowInterop((event) => setState(() {
          final eventString = jsonEncode(event);
          print(eventString);
          info = "Sender connected!\n$eventString";
        }));
    widget.manager.onSenderDisconnected = allowInterop((event) => setState(() {
          final eventString = jsonEncode(event);
          print(eventString);
          info = "Sender disconnected...\n$eventString";
        }));
    bus = widget.manager.getCastMessageBus(
        'urn:x-cast:com.schwusch.chromecast-example', 'JSON');
    bus.onMessage = allowInterop((event) => setState(() {
          final eventString = jsonEncode(event);
          print(eventString);
          info = "New event!\n$eventString";
        }));

    widget.manager.start(Options("Application is staharting"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(info),
          ],
        ),
      ),
    );
  }
}
