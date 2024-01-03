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
      child: GestureDetector(
          onTap: isEnable ? onPressed : null,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: isEnable ? Colors.white : Colors.grey,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      //color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
