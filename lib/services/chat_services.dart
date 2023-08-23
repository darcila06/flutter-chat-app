import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/messages_response.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  Usuario? usuarioPara;

  Future getChat(String usuarioID) async {
    final resp = await http
        .get(Uri.parse('${Enviroment.apiUrl}/messages/$usuarioID'), headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() ?? ''
    });

    final messageResponse = messagesResponseFromJson(resp.body);

    return messageResponse.messages;
  }
}
