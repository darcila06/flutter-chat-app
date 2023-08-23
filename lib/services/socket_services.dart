import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  late io.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;

  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {
    final token = await AuthService.getToken();
    // Dart client
    _socket = io.io(Enviroment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    // socket.on("connect_error", (err) {
    //   print(err);
    // });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
