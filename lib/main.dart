import 'dart:convert';
import 'dart:js';

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
  String info = "This is a locally hosted cast app";

  @override
  void initState() {

    widget.manager.addCustomMessageListener(
      'urn:x-cast:com.schwusch.chromecast-example',
      allowInterop((ev) {
        final String user = toMap(ev)['o']['data']['user'] as String;
        print(user);
        setState(() {
          info = "Showig user:\n$user";
        });
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

Map<String, dynamic> toMap(dynamic obj) => jsonDecode(
    context['JSON'].callMethod(
        'stringify',
        [obj]
    )
) as Map<String, dynamic>;