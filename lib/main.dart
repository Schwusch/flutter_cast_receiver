import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cast_web/cast.dart';
import 'package:js/js.dart';

void main() {
  CastDebugLogger.getInstance().setEnabled(true);
  runApp(
    MaterialApp(
      home: MyHomePage(manager: CastReceiverContext.getInstance()),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.manager}) : super(key: key);

  final CastReceiverContext manager;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String info = "This is a casted app";

  @override
  void initState() {
    widget.manager.addEventListener(
      EventType.READY,
      allowInterop((event) => setState(() {
            final eventString = jsonEncode(event);
            print(eventString);
            info = "Ready!\n$eventString";
          })),
    );
    widget.manager.addEventListener(
      EventType.SENDER_CONNECTED,
      allowInterop((event) => setState(() {
            final eventString = jsonEncode(event);
            print(eventString);
            info = "Sender connected!\n$eventString";
          })),
    );
    widget.manager.addEventListener(
      EventType.SENDER_DISCONNECTED,
      allowInterop((event) => setState(() {
            final eventString = jsonEncode(event);
            print(eventString);
            info = "Sender disconnected...\n$eventString";
          })),
    );

    widget.manager.addCustomMessageListener(
      'urn:x-cast:com.schwusch.chromecast-example',
      allowInterop((ev) {
        final eventString = jsonEncode(ev.data);
        print(eventString);
        info = "Custom event:\n$eventString";
      }),
    );

    widget.manager.start(
      CastReceiverOptions()
        ..statusText = "Application is staharting"
        ..maxInactivity = 3600, // for development only
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(info),
            ],
          ),
        ),
      );
}
