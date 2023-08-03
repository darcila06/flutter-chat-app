import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
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
                    title: 'Registro',
                  ),
                  _Form(),
                  Labels(
                    route: 'login',
                    title: '¿Ya tienes una cuenta?',
                    subtitle: 'Ingresa ahora',
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
  final userCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
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
          onPressed: () {},
          text: "Ingrese",
        )
      ]),
    );
  }
}
