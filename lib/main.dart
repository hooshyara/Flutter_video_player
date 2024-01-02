import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final VideoPlayerController _controller =
      VideoPlayerController.asset('assets/file.mp4')
        ..initialize()
        ..setLooping(true)
        ..play();

  Timer? timer;

  bool showControlPanel = false;

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: GestureDetector(
                onTap: () {
                  if (!showControlPanel) {
                    setState(() {
                      showControlPanel = true;
                    });
                    initControlPanelTimer();
                  }
                },
                child: VideoPlayer(_controller))),
        if (showControlPanel)
          VideoControlPanel(
            controller: _controller,
            gestureTapCallback: () {
              setState(() {
                showControlPanel = false;
              });
              timer?.cancel();
            },
          )
      ]),
    );
  }

  void initControlPanelTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        showControlPanel = false;
      });
    });
  }
}

class VideoControlPanel extends StatefulWidget {
  const VideoControlPanel({
    Key? key,
    required VideoPlayerController controller,
    required this.gestureTapCallback,
  })  : _controller = controller,
        super(key: key);

  final VideoPlayerController _controller;
  final GestureTapCallback gestureTapCallback;

  @override
  State<VideoControlPanel> createState() => _VideoControlPanelState();
}

class _VideoControlPanelState extends State<VideoControlPanel> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: GestureDetector(
      onTap: widget.gestureTapCallback,
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 48, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 60,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset('assets/profile.jpg'))),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'James Bytheway',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          '@jamesbtw',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All The Damn Vampires',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'saturday',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  VideoProgressIndicator(
                    widget._controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                        playedColor: Colors.white,
                        backgroundColor: Colors.white10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget._controller.value.position.toMinutesSeconds(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          widget._controller.value.duration.toMinutesSeconds(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget._controller.seekTo(Duration(
                                milliseconds: widget._controller.value.position
                                        .inMilliseconds -
                                    2000));
                            setState(() {});
                          },
                          iconSize: 24,
                          icon: const Icon(
                            CupertinoIcons.backward_fill,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget._controller.value.isPlaying) {
                              widget._controller.pause();
                              setState(() {});
                            } else {
                              widget._controller.play();
                              setState(() {});
                            }
                          },
                          iconSize: 56,
                          icon: Icon(
                            widget._controller.value.isPlaying
                                ? CupertinoIcons.pause_circle_fill
                                : CupertinoIcons.play_circle_fill,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget._controller.seekTo(Duration(
                                milliseconds: widget._controller.value.position
                                        .inMilliseconds +
                                    2000));
                            setState(() {});
                          },
                          iconSize: 24,
                          icon: const Icon(
                            CupertinoIcons.forward_fill,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String toMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
