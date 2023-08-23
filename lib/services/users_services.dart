import 'package:http/http.dart' as http;

import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/users.response.dart';
import 'package:chatapp/services/auth_services.dart';

import 'package:chatapp/models/usuario.dart';

class UsersService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp =
          await http.get(Uri.parse('${Enviroment.apiUrl}/users'), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ''
      });

      final usuarioResponse = usersResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
