import 'package:chatapp/helpers/mostrar_alerta.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(
                    title: "Messenger",
                  ),
                  _Form(),
                  Labels(
                    route: 'register',
                    title: '¿No tienes cuenta?',
                    subtitle: 'Crea una ahora',
                  ),
                  Text(
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
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
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
          text: "Ingrese",
          onPressed: authService.autenticate
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final loginResp = await authService.login(
                      emailCtrl.text.trim(), passCtrl.text.trim());
                  if (loginResp) {
                    Navigator.pushReplacementNamed(context, 'usuarios');
                  } else {
                    //Mostrar alerta
                    mostrarAlerta(
                        context, 'Login Incorrecto', 'Credenciales Invalidas');
                  }
                },
        )
      ]),
    );
  }
}
