import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/chat_services.dart';
import 'package:chatapp/services/socket_services.dart';
import 'package:chatapp/services/users_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = UsersService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<dynamic> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final usuario = authService.usuario;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            usuario!.nombre,
            style: const TextStyle(color: Colors.black54),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.amber,
            ),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: socketService.serverStatus == ServerStatus.online
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue[400],
                    )
                  : Icon(
                      Icons.offline_bolt,
                      color: Colors.red[400],
                    ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue[400]!,
          ),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length,
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(300)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
