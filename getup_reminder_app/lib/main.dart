// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:async';

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

import 'package:window_size/window_size.dart';
import 'DisplayBox.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await windowManager.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(Size(1000, 640));
  }
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
          title: Text(
            "Time Up",
            style: TextStyle(
                color: Color(0xFF283618),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          content: Text("Take a quick break.",
              style: TextStyle(color: Color(0xFF283618), fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () => {
                stopAlaram(),
                Navigator.of(context).pop(),
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF283618),
              ),
              child: Text(
                "OK",
                style: TextStyle(color: Color(0xFFfefae0)),
              ),
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
            backgroundColor: Color(0xFFfefae0),
            title: Text(
              "Alert",
              style: TextStyle(
                  color: Color(0xFF283618),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Are you sure, stop the timer ?",
              style: TextStyle(color: Color(0xFF283618), fontSize: 18),
            ),
            actions: [
              TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Color(0xFF283618)),
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
                    style: TextStyle(color: Color(0xFFfefae0)),
                  )),
              TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Color(0xFF283618)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "NO",
                    style: TextStyle(color: Color(0xFFfefae0)),
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
      appBar: AppBar(
        title: Text(
          "Get up - Reminder App",
          style: TextStyle(
            color: Color(0xFFfefae0),
          ),
        ),
        backgroundColor: Color(0xFF283618),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Container(
            //color: Color(0xFF97A74D),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF485A29),
                  Color(0xFF97A74D),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  DisplayBox(
                                    name: "Good",
                                    time: "20:00",
                                    isEnable: button1Enabled,
                                    onPressed: () {
                                      setState(() {
                                        if (button1Enabled && button2Enabled) {
                                          disableOtherButton(1);
                                          startTimer(20);
                                        } else if (button1Enabled &&
                                            !button2Enabled) {
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
                                          startTimer(30);
                                        } else if (button2Enabled &&
                                            !button3Enabled) {
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
                                          if (button3Enabled &&
                                              button1Enabled) {
                                            disableOtherButton(3);
                                            startTimer(40);
                                          } else if (button3Enabled &&
                                              !button1Enabled) {
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
                                child: Opacity(
                                  opacity: button4Enabled ? 1.0 : 0.5,
                                  child: Container(
                                    color: Color(0xFFfefae0),
                                    height: 190,
                                    width: 190,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Custom Time",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF283618),
                                            //color: Colors.white,
                                          ),
                                        ),
                                        //Text("Time"),
                                        DropdownButton<int>(
                                          value: dropDownValue,
                                          onChanged: button4Enabled
                                              ? (int? newValue) {
                                                  setState(() {
                                                    dropDownValue =
                                                        newValue ?? 1;
                                                    startTimer(dropDownValue);
                                                    disableOtherButton(0);
                                                  });
                                                }
                                              : null,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF283618)),
                                          iconSize: 38,
                                          iconEnabledColor: Color(0xFF283618),
                                          dropdownColor: Color(0xFFfefae0),
                                          items: List.generate(60, (index) {
                                            return DropdownMenuItem(
                                              value: index + 1,
                                              child: Text(
                                                "${index + 1} mins",
                                                style: TextStyle(
                                                  color: Color(0xFF283618),
                                                ),
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    ),
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
                                              speed:
                                                  Duration(milliseconds: 150),
                                            )
                                          : TypewriterAnimatedText(
                                              "Notifying in..",
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                              speed:
                                                  Duration(milliseconds: 150),
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
                                      fontSize: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Color(0xFFfefae0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: isTimerPaused
                                        ? resumeTimer
                                        : pauseTimer,
                                    child: Text(
                                      isTimerPaused ? "Resume" : "Pause",
                                      style: TextStyle(
                                          color: Color(0xFF283618),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
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
                                    backgroundColor: Color(0xFFfefae0),
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
                                            stopAlaram();
                                          });
                                        }
                                      : null,
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: Color(0xFF283618),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                        // fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFdda15e),
                                Color(0xFFbc6c25),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                          //color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Activities during your break",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Stretch your neck and shoulder.",
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(
                                "Take your eyes of the screen and look away.",
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(
                                "Take a short walk.",
                                style: TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
