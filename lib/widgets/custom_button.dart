import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
