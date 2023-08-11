import 'dart:io';

class Enviroment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.60.101:3000/api/v1'
      : 'http://localhost:3000/api/v1';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.60.101:3000'
      : 'http://localhost:3000';
}
