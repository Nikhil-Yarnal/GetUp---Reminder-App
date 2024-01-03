// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:async';
import 'dart:ffi';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'DisplayBox.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  AudioPlayer audioPlayer = AudioPlayer();

  Timer? timer;

  bool isTimerPaused = false;
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
        if (!isTimerPaused) {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            showNotification();
            playAlaram();
            remainingTime = originalTime;
          }
        }
      });
    });
  }

  void stopAlaram() async {
    audioPlayer.stop();
  }

  void playAlaram() {
    audioPlayer.play(UrlSource("assets/Time_up.mp3"));
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
                stopAlaram(),
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
                      timer?.cancel();
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

  void pauseTimer() {
    setState(() {
      isTimerPaused = true;
    });
  }

  void resumeTimer() {
    setState(() {
      isTimerPaused = false;
    });
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        setState(
                          () {
                            if (button3Enabled && button1Enabled) {
                              disableOtherButton(3);
                              startTimer(1);
                            } else if (button3Enabled && !button1Enabled) {
                              onButtonPressPopup();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        color: Colors.blue,
                        height: 200,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Custom Time",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                //color: Colors.white,
                              ),
                            ),
                            //Text("Time"),
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
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedTextKit(
                          animatedTexts: [
                            originalTime == 0
                                ? TypewriterAnimatedText(
                                    "Select time",
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                    speed: Duration(milliseconds: 150),
                                  )
                                : TypewriterAnimatedText(
                                    "Notifying in..",
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                    speed: Duration(milliseconds: 150),
                                  ),
                          ],
                          repeatForever: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          printDuration(duration),
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isTimerPaused ? resumeTimer : pauseTimer,
                          child: Text(
                            isTimerPaused ? "Resume" : "Pause",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: timer != null
                            ? () {
                                setState(() {
                                  enableallButtons();
                                  timer?.cancel();
                                  remainingTime = 0;
                                  originalTime = 0;
                                  dropDownValue = 1;
                                });
                              }
                            : null,
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
