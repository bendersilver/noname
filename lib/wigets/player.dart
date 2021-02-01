import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/channel.dart';
import 'package:noname/wigets/ListM3U.dart';
import 'package:noname/wigets/PlaylistItem.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:noname/models/M3UItem.dart';

class Player extends StatefulWidget {
  static const String routeName = "/Player";
  @override
  _PlayerState createState() => new _PlayerState();
}

class _PlayerState extends State<Player> {
  bool showMeau = false;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Wakelock.disable();
    _controller.dispose();
    super.dispose();
  }

  void toggleControls() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments as Map;
    M3UItem ch = arg["ch"];
    if (_controller == null) {
      _controller = VideoPlayerController.network(ch.url);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(1);
      _controller.addListener(() {
        if (!_controller.value.isPlaying) {
          if (_controller.value.errorDescription != null) {
            scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text(_controller.value.errorDescription),
              duration: Duration(seconds: 10),
            ));
          }
          // Timer(const Duration(seconds: 1), () {
          //   _controller.play();
          // });
        }
      });
      SystemChrome.setEnabledSystemUIOverlays([]);
      Wakelock.enable();
    }
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _controller.play();
            return Scaffold(
              backgroundColor: Colors.black,
              body: GestureDetector(
                onTap: () {
                  showMeau = !showMeau;
                  setState(() {});
                },
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: AspectRatio(
                        aspectRatio: 16.0 / 9.0,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    topBar(),
                    bottomBar(showMeau, context, ch),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget topBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 70,
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            // Navigator.pop(ctx);
                          },
                        ),
                        Text(
                          "_item.title",
                          style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 2.0,
                                  color: Colors.black,
                                ),
                              ],
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          // rewind(controller);
                        },
                        child: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        // onTap: play,
                        child: Icon(
                          // controller.value.isPlaying
                          // ? Icons.play_circle_outline
                          Icons.pause_circle_outline,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // fastForward(controller: controller);
                        },
                        child: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget bottomBar(bool showMeau, BuildContext ctx, M3UItem ch) {
  ProgrammItem _item = Core.cls.curProgramm[ch.id];
  return showMeau
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Text(
                        _item.title,
                        style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Colors.black,
                              ),
                            ],
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                      // VideoProgressIndicator(
                      //   controller,
                      //   allowScrubbing: true,
                      //   colors: VideoProgressColors(
                      //       playedColor: Color.fromARGB(250, 0, 255, 112)),
                      //   padding: EdgeInsets.only(left: 5.0, right: 5),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(ctx);
                              },
                            ),
                            // Text(
                            //   "videoSeek",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white),
                            // ),
                            // Text(
                            //   "videoDuration",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white),
                            // ),
                          ],
                        ),
                      ),
                      LinearProgressIndicator(
                        semanticsLabel: "------",
                        minHeight: 4,
                        value: _item.progress > 0 ? _item.progress : null,
                      ),
                    ],
                  ),
                  Center(
                    // alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: () {
                              // rewind(controller);
                            },
                            child: Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          InkWell(
                            // onTap: play,
                            child: Icon(
                              // controller.value.isPlaying
                              // ? Icons.play_circle_outline
                              Icons.pause_circle_outline,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // fastForward(controller: controller);
                            },
                            child: Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      : Container();
}
