// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'DisplayBox.dart';
import 'package:win_toast/win_toast.dart';

void main() {
  runApp(const mainApp());
}

class mainApp extends StatelessWidget {
  const mainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int dropDownValue = 1;

  late WinToast toastAfterTime;
  late Timer timer;
  int remainingtime = 1 * 60;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingtime > 0) {
          remainingtime--;
        } else {
          timer.cancel();
          showNotification();
        }
      });
    });
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minuts = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minuts:$seconds";
  }

  Future<void> showNotification() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("THe title"),
              content: Text("Get the fuck up"),
              actions: [
                TextButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: remainingtime);

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                DisplayBox(
                  name: "Good",
                  time: "20:00",
                ),
                DisplayBox(
                  name: "Recomended",
                  time: "30:00",
                ),
                DisplayBox(
                  name: "Acceptable",
                  time: "40:00",
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: Colors.blue,
                  height: 150,
                  width: 150,
                  child: Column(
                    children: [
                      Text("Custom"),
                      Text("Time"),
                      DropdownButton<int>(
                        value: dropDownValue,
                        onChanged: (int? newValue) {
                          setState(() {
                            dropDownValue = newValue ?? 1;
                          });
                        },
                        items: List.generate(60, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text("${index + 1} mins"),
                          );
                        }),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    startTimer();
                  },
                  child: Text("adaw"),
                ),
                Text(
                  printDuration(duration),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
