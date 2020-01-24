@JS('cast')
library framework;

import 'package:js/js.dart';

@JS('receiver')
class Receiver {
  @JS('CastReceiverManager')
  external static CastReceiverManager get castReceiverManager;
}

@JS()
class CastReceiverManager {
  external CastReceiverManager getInstance();
  external set onReady(Function cb);
  external set onSenderConnected(Function cb);
  external set onSenderDisconnected(Function cb);
  external CastMessageBus getCastMessageBus(String channel, String type);
  external void start(Options f);
}

@JS()
@anonymous
class Options {
  Options(this.statusText);
  String statusText;
}

@JS()
class CastMessageBus {
  external set onMessage(Function cb);
}
