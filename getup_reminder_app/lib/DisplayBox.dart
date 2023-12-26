// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DisplayBox extends StatelessWidget {
  const DisplayBox({super.key, required this.name, required this.time});

  final String name;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        color: Colors.blue,
        height: 150,
        width: 150,
        child: Column(
          children: [
            Text(name),
            Text(time),
          ],
        ),
      ),
    );
  }
}
