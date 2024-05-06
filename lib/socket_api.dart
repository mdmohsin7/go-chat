import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'application/chat_bloc/chat_bloc.dart';

class SocketApi {
  late WebSocketChannel socket;
  ChatBloc chatBloc;

  SocketApi(this.chatBloc) {
    connect();
  }

  void connect() {
    if (kIsWeb) {
      socket = HtmlWebSocketChannel.connect('wss://echo.websocket.org');
    } else {
      socket = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org/'));
    }

    socket.stream.listen((event) {
      print('Received: $event');
      chatBloc.add(GetMessage(event));
    });
  }

  void sendMessage(String message) {
    socket.sink.add(message);
  }

  void dispose() {
    socket.sink.close();
  }
}
