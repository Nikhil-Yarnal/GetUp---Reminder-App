// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DisplayBox extends StatelessWidget {
  const DisplayBox({
    super.key,
    required this.name,
    required this.time,
    required this.onPressed,
    required this.isEnable,
  });

  final String name;
  final String time;
  final bool isEnable;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.white),
        onPressed: isEnable ? onPressed : null,
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
