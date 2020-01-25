@JS('cast')
library framework;

import 'package:js/js.dart';

@JS('framework.CastReceiverContext')
class CastReceiverContext {
  external static CastReceiverContext getInstance();
  external set onReady(Function cb);
  external set onSenderConnected(Function cb);
  external set onSenderDisconnected(Function cb);
  external void addCustomMessageListener(String channel, void Function(Event e) cb);
  external void start(CastReceiverOptions f);
}

@JS('framework.CastReceiverOptions')
class CastReceiverOptions {
  external set statusText(String s);
  external set maxInactivity(int t);
}

@JS('framework.system.Event')
class Event {
  external dynamic get data;
}