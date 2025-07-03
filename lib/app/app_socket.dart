import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class AppSocket {
  IOWebSocketChannel? _channel;

  ValueChanged<String>? result;

  static AppSocket? _instance;

  factory AppSocket.getInstance() {
    if (null == _instance) {
      _instance = new AppSocket._internal();
    }
    return _instance!;
  }

  AppSocket._internal();

  AppSocket.connectVoice({this.result}) {
    String url = '';
    //String u = XfUtil.getAuthUrl(_host2, _apiKey, _apiSecret, type: "iat");
    _channel = IOWebSocketChannel.connect(url);
    _channel?.stream.listen((message) {}, onError: (e) {
      print("websocket error $e");
    });
  }

  close([int status = status.goingAway]) {
    _channel?.sink.close(status);
  }
}
