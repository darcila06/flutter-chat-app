import 'dart:io';

import 'package:chatapp/models/messages_response.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/chat_services.dart';
import 'package:chatapp/services/socket_services.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textCrtl = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  final List<ChatMessage> _messages = [];
  bool _writing = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara!.uid);
  }

  void _cargarHistorial(String uid) async {
    List<Message> chat = await chatService.getChat(uid);
    final history = chat.map((m) => ChatMessage(
          text: m.message,
          uid: m.de,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward(),
        ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage message = ChatMessage(
        text: data['mensaje'],
        uid: data['de'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 12,
              child: Text(
                usuarioPara!.nombre.substring(0, 2),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) => _messages[i],
              itemCount: _messages.length,
              reverse: true,
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textCrtl,
              onSubmitted: _handleSubmit,
              onChanged: (texto) {
                setState(() {
                  if (texto.trim().isNotEmpty) {
                    _writing = true;
                  } else {
                    _writing = false;
                  }
                });
              },
              decoration:
                  const InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _writing
                        ? () => _handleSubmit(_textCrtl.text.trim())
                        : null,
                    child: const Text("Enviar"),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        onPressed: _writing
                            ? () => _handleSubmit(_textCrtl.text.trim())
                            : null,
                        icon: const Icon(Icons.send),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;

    _focusNode.requestFocus();
    _textCrtl.clear();

    final newMessage = ChatMessage(
      text: text,
      uid: authService.usuario!.uid,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });

    socketService.emit('mensaje-personal', {
      'de': authService.usuario?.uid,
      'para': chatService.usuarioPara?.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
