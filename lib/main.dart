import 'package:flutter/material.dart';

import 'package:chatapp/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      initialRoute: 'login',
      routes: app_routes,
    );
  }
}
