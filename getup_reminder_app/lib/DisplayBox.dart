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
          child: Opacity(
            opacity: isEnable ? 1.0 : 0.5,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  color: Color(0xFFfefae0),
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF283618),
                      ),
                    ),
                    Text(
                      time,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
