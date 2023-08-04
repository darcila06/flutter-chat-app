import 'dart:io';

import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textCrtl = TextEditingController();
  final _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  bool _writing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                'TS',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 12,
            ),
            SizedBox(height: 3),
            Text(
              "Melisa Flores",
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1),

            //TODO: Caja de Texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textCrtl,
              onSubmitted: _handleSubmit,
              onChanged: (texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _writing = true;
                  } else {
                    _writing = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _writing
                        ? () => _handleSubmit(_textCrtl.text.trim())
                        : null,
                    child: Text("Enviar"),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        onPressed: _writing
                            ? () => _handleSubmit(_textCrtl.text.trim())
                            : null,
                        icon: Icon(Icons.send),
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
    if (text.length == 0) return;

    print(text);
    _focusNode.requestFocus();
    _textCrtl.clear();

    final newMessage = ChatMessage(
      text: text,
      uid: '1as23',
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });
  }

  @override
  void dispose() {
    // TODO: Off socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
