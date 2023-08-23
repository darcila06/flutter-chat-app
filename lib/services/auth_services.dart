// import 'package:chatapp/models/usuario.dart';
import 'dart:convert';

import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/login_response.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  Usuario? usuario;
  bool _autenticate = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticate => _autenticate;
  set autenticate(bool value) {
    _autenticate = value;
    notifyListeners();
  }

  //Getters token

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future login(String email, String password) async {
    autenticate = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post(Uri.parse('${Enviroment.apiUrl}/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    autenticate = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticate = true;

    final data = {"nombre": nombre, "email": email, "password": password};

    final resp = await http.post(
      Uri.parse('${Enviroment.apiUrl}/login/new'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    autenticate = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

  Future isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';
    final resp = await http.get(Uri.parse('${Enviroment.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(token);
      return true;
    } else {
      logout();
      return false;
    }
  }
}
