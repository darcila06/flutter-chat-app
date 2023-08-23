import 'package:chatapp/helpers/mostrar_alerta.dart';
import 'package:chatapp/services/socket_services.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_services.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(
                    title: 'Registro',
                  ),
                  _Form(),
                  const Labels(
                    route: 'login',
                    title: '¿Ya tienes una cuenta?',
                    subtitle: 'Ingresa ahora',
                  ),
                  const Text(
                    "Términos y condiciones de uso",
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final userCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          icon: Icons.perm_identity,
          hint: "Nombre",
          textController: userCtrl,
        ),
        CustomInput(
          icon: Icons.email,
          hint: "Email",
          textController: emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        CustomInput(
          icon: Icons.lock_outline,
          hint: "Password",
          textController: passCtrl,
          isPassword: true,
        ),
        CustomButton(
          text: "Registarse",
          onPressed: authService.autenticate
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final registerResp = await authService.register(
                      userCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passCtrl.text.trim());
                  if (registerResp == true) {
                    socketService.connect();
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, 'usuarios');
                  } else {
                    // ignore: use_build_context_synchronously
                    mostrarAlerta(context, "Error", await registerResp);
                  }
                },
        )
      ]),
    );
  }
}
