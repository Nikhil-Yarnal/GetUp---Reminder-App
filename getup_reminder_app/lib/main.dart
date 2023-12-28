// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'DisplayBox.dart';

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

  late Timer timer;
  int remainingTime = 0; // time is in seconds
  int originalTime = 0;

  bool button1Enabled = true;
  bool button2Enabled = true;
  bool button3Enabled = true;
  bool button4Enabled = true;

  void startTimer(int duration) {
    remainingTime = duration * 60;
    originalTime = remainingTime;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          showNotification();
          remainingTime = originalTime;
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
        return AlertDialog(
          title: Text("Time Up"),
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
  }

  Future<void> onButtonPressPopup() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Button Pressed"),
            content: Text("Are you sure, stop the timer ? "),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    setState(() {
                      enableallButtons();
                      timer.cancel();
                      remainingTime = 0;
                      originalTime = 0;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "YES",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  void disableOtherButton(int buttonNumber) {
    button1Enabled = buttonNumber == 1 ? true : false;
    button2Enabled = buttonNumber == 2 ? true : false;
    button3Enabled = buttonNumber == 3 ? true : false;
    button4Enabled = buttonNumber == 4 ? true : false;
  }

  void enableallButtons() {
    button1Enabled = true;
    button2Enabled = true;
    button3Enabled = true;
    button4Enabled = true;
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: remainingTime);

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.pink,
        child: Column(
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
                    isEnable: button1Enabled,
                    onPressed: () {
                      setState(() {
                        if (button1Enabled && button2Enabled) {
                          disableOtherButton(1);
                          startTimer(1);
                        } else if (button1Enabled && !button2Enabled) {
                          onButtonPressPopup();
                        }
                      });
                    },
                  ),
                  DisplayBox(
                    name: "Recomended",
                    time: "30:00",
                    isEnable: button2Enabled,
                    onPressed: () {
                      setState(() {
                        if (button2Enabled && button3Enabled) {
                          disableOtherButton(2);
                          startTimer(1);
                        } else if (button2Enabled && !button3Enabled) {
                          onButtonPressPopup();
                        }
                      });
                    },
                  ),
                  DisplayBox(
                    name: "Acceptable",
                    time: "40:00",
                    isEnable: button3Enabled,
                    onPressed: () {
                      setState(() {
                        if (button3Enabled && button1Enabled) {
                          disableOtherButton(3);
                          startTimer(1);
                        } else if (button3Enabled && !button1Enabled) {
                          onButtonPressPopup();
                        }
                      });
                    },
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
                mainAxisAlignment: MainAxisAlignment.end,
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
                          onChanged: button4Enabled
                              ? (int? newValue) {
                                  setState(() {
                                    dropDownValue = newValue ?? 1;
                                    startTimer(dropDownValue);
                                    disableOtherButton(0);
                                  });
                                }
                              : null,
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
                  Column(
                    children: [
                      Text(
                        originalTime == 0 ? "Select Time" : "Notifying in..",
                      ),
                      Text(
                        printDuration(duration),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      setState(() {
                        enableallButtons();
                        timer.cancel();
                        remainingTime = 0;
                        originalTime = 0;
                        dropDownValue = 1;
                      });
                    },
                    child: Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
