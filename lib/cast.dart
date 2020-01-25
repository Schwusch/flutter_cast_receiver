@JS('cast')
library framework;

import 'package:js/js.dart';

@JS('framework.CastReceiverContext')
class CastReceiverContext {
  external static CastReceiverContext getInstance();
  external void addEventListener(String type, void Function(Event e) cb);
  external void addCustomMessageListener(String channel, void Function(Event e) cb);
  external void start(CastReceiverOptions f);
}

@JS('framework.CastReceiverOptions')
class CastReceiverOptions {
  external set statusText(String s);
  external set maxInactivity(int t);
}

@JS('framework.system.EventType')
class EventType {
  external static String get READY;
  external static String get SENDER_CONNECTED;
  external static String get SENDER_DISCONNECTED;
  external static String get ERROR;
}

@JS('framework.system.Event')
class Event {
  external dynamic get data;
}