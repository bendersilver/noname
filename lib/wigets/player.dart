import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noname/models/channel.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

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
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Wakelock.disable();
    _controller.dispose();
    super.dispose();
  }

  void toggleControls() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      final Map arg = ModalRoute.of(context).settings.arguments as Map;
      CH ch = arg["ch"];
      _controller = VideoPlayerController.network(ch.url);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(1);
      _controller.addListener(() {
        if (!_controller.value.isPlaying) {
          if (_controller.value.errorDescription != null) {
            scaffoldKey.currentState
                .showSnackBar(new SnackBar(
                  content: Text(_controller.value.errorDescription),
                  duration: Duration(seconds: 10),
                  ));
          }
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
                        )),
                        bottomBar(showMeau, context),
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

Widget bottomBar(bool showMeau, BuildContext ctx) {
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
                            // Text(
                            //   "videoDuration",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white),
                            // ),
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
