import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

mostrarAlerta(BuildContext context, String title, String subtitle) {
  Platform.isAndroid
      ? showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: [
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text("OK"),
              )
            ],
          ),
        )
      : showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text(title),
                content: Text(subtitle),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
}
