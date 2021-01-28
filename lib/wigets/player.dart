import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:video_player/video_player.dart';

import 'package:noname/models/channel.dart';
import 'package:noname/models/playlist.dart';

class Player extends StatefulWidget {
  static const String routeName = "/Player";
  @override
  _PlayerState createState() => new _PlayerState();
}

class _PlayerState extends State<Player> {
  bool showMeau = false;
  Timer _timerNav;
  CH _ch;
  VideoPlayerController _ctrl;
  Future<void> _initPlayer;

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _timerNav.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void toggleControls() {
    showMeau = true;
    if (_timerNav != null) _timerNav.cancel();
    _timerNav = Timer(Duration(seconds: 3), () {
      setState(() {
        showMeau = false;
      });
    });
    setState(() {
      showMeau = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ctrl == null) {
      final Map arg = ModalRoute.of(context).settings.arguments as Map;
      _ch = Playlist.cls.getCh(arg["id"]);
      _ctrl = VideoPlayerController.network(_ch.url);
      _initPlayer = _ctrl.initialize();
      _ctrl.setLooping(true);
      _ctrl.setVolume(1);
      Wakelock.enable();
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
    return Scaffold(
      body: FutureBuilder(
        future: _initPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _ctrl.play();
            return Scaffold(
              backgroundColor: Colors.black,
              body: GestureDetector(
                onTap: () {
                  toggleControls();
                },
                child: Stack(
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: AspectRatio(
                          aspectRatio: 16.0 / 9.0,
                          child: VideoPlayer(_ctrl),
                        )),
                    bottomBar(showMeau, _ch, context),
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
}

Widget bottomBar(bool showMeau, CH ch, BuildContext ctx) {
  return showMeau
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 48,
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: [
                  Column(
                    children: [
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
                            Text(
                              ch.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
        )
      : Container();
}
