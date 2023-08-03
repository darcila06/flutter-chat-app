import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String title;
  final String subtitle;

  const Labels(
      {super.key,
      required this.route,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 10),
          GestureDetector(
            child: Text(
              subtitle,
              style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
          )
        ],
      ),
    );
  }
}
