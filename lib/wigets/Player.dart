import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/wigets/ListM3U.dart';

import 'package:video_player/video_player.dart';
import 'package:noname/models/M3UItem.dart';
import 'package:wakelock/wakelock.dart';

class M3UPlayer extends StatefulWidget {
  static const String routeName = "/M3UPlayer";
  @override
  _M3UPlayerState createState() => new _M3UPlayerState();
}


class _M3UPlayerState extends State<M3UPlayer> {

  M3UItem _item;
  VideoPlayerController _ctrl;
  Future<void> _initPlayer;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  void _update() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    setState(() {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
      if (_item == null) {
        final Map arg = ModalRoute.of(context).settings.arguments as Map;
        _item = arg["ch"];
        _ctrl = VideoPlayerController.network(_item.url);
        _initPlayer = _ctrl.initialize();
        _ctrl.setLooping(true);
        _ctrl.setVolume(1);
      }
    });
  }

  void _updateCtrl(M3UItem item) {
      if (item == _item) return;
      final oldController = _ctrl;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
      await oldController.dispose();
    });
      _item = item;
      _initPlayer = null;
      _ctrl = VideoPlayerController.network(_item.url);
      _initPlayer = _ctrl.initialize();
      _ctrl.setLooping(true);
      _ctrl.setVolume(1);
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _update();
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: PlayerLandscape(
            ctrl: _ctrl,
            initPlayer: _initPlayer,
            id: _item.id,
        ),
      );
    }
    return  Scaffold(
      body: Column(
        children: [
          PlayerPortrait(ctrl: _ctrl, initPlayer: _initPlayer, id: _item.id,),
          ListTile(
            title: Text(_item.name),
            
            leading: SizedBox(
              height: 64.0,
              width: 64.0,
              child: Image.network(_item.logo),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: Core.cls.items.length,
              itemBuilder: (ctx, ix) {
                M3UItem item = Core.cls.items[ix];
                return ListViewM3U(
                  item: item,
                   onTap: () {
                     _updateCtrl(item);
                  },
                  // subtitle: ProgrammWidget(item: _item),
                );
              }
            ),)
          // BaseListView(),
        ],
      ),
    );
  }
}

class PlayerLandscape extends StatelessWidget {
  final VideoPlayerController ctrl;
  final int id;
  final Future<void> initPlayer;
  
  Timer _timer;
  bool _showNaw = false;
  ProgrammItem _item;
  

  PlayerLandscape({@required this.ctrl, @required this.initPlayer, @required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_timer != null) _timer.cancel();
        _item = Core.cls.curProgramm[id];
        _showNaw = true;
        (context as Element).markNeedsBuild();
        _timer = Timer(Duration(seconds: 5), () {
          _showNaw = false;
          (context as Element).markNeedsBuild();
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
              aspectRatio: 16.0 / 9.0,
                  child: FutureBuilder(
                      future: initPlayer,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          ctrl.play();
                          return VideoPlayer(ctrl);
                        }
                        return CircularProgressIndicator();
                      })),
            ),
            _showNaw
                ? Align(
                  alignment: Alignment.topCenter,
                  child:  Column(
              children: [
                 ListTile(
                  leading: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
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
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                  child: Column(
                    children: [
                         VideoProgress(id: id),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat(' HH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              _item.start * 1000)),
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
                                          fontSize: 16),
                                    ),
                                    Text(
                                      DateFormat('HH:mm')
                                          .format(DateTime.now()),
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
                                          fontSize: 22),
                                    ),
                                    Text(
                                      DateFormat('HH:mm ').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              _item.stop * 1000)),
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
                                          fontSize: 16),
                                    ),
                                  ])
                    ],
                  ),
                ),
             
              ],
            )) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class PlayerPortrait extends StatelessWidget {
  final VideoPlayerController ctrl;
  final int id;
  final Future<void> initPlayer;

  PlayerPortrait({@required this.ctrl, @required this.initPlayer, @required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 9 / 16,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Center(
                child: FutureBuilder(
                    future: initPlayer,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        ctrl.play();
                        return VideoPlayer(ctrl);
                      }
                      return CircularProgressIndicator();
                    })),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgress(id: id),
          )
        ],
      ),
    );
  }
}