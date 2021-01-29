import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noname/models/channel.dart';
import 'package:mx_player_plugin/mx_player_plugin.dart';
import 'package:noname/wigets/Dialog.dart';
import 'package:noname/wigets/player.dart';

import 'package:noname/models/database.dart';

class PlaylistItem extends StatefulWidget {
  PlaylistItem({Key key, this.ch}) : super(key: key);

  final CH ch;

  @override
  _PlaylistItem createState() => _PlaylistItem();
}

class _PlaylistItem extends State<PlaylistItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.ch.hideCh || widget.ch.delCh) return SizedBox.shrink(); 
    return ListTile(
      leading: SizedBox(
        height: 64.0,
        width: 64.0,
        child: Image.network(widget.ch.logo),
      ),
      title: Text(
        widget.ch.name,
        style: TextStyle(
          color: widget.ch.hideCh ? Colors.grey : null,
          fontWeight: FontWeight.w500,
          decoration: widget.ch.hideCh ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: PlaylistItemProgress(ch: widget.ch),
      onLongPress: () async {
        await showDialogAction(context: context, ch: widget.ch);
        widget.ch.updateDB();
        setState(() {});
      },
      onTap: () async {
        switch (widget.ch.player) {
          case "vlc":
            await PlayerPlugin.openWithVlcPlayer(widget.ch.url);
            break;
          case "mx":
            await PlayerPlugin.openWithMxPlayer(widget.ch.url, "");
            break;
          default:
            Navigator.pushNamed(context, Player.routeName,
                arguments: {"ch": widget.ch});
        }
      },
    );
  }
}


class PlaylistItemProgress extends StatefulWidget {
  PlaylistItemProgress({Key key, this.ch}) : super(key: key);

  final CH ch;

  @override
  _PlaylistItemProgress createState() => _PlaylistItemProgress();
}

class _PlaylistItemProgress extends State<PlaylistItemProgress> {

  Timer _timer;
  double _value = 0;
  String _title = "test";

  @override
  void dispose() {
   _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    updateData();
    _timer = new Timer.periodic(
        new Duration(seconds: 10),
        (Timer t) async => await updateData()
        );
    super.initState();
  }

  Future<void> updateData() async {
    // if (widget.ch.id == null) print(widget.ch);
    // var map = await DBProvider.db.getProg(widget.ch.id);
    // if (map != null) {
    //   // print(map["start"]);
    //   _title = map["title"];
    //   var curr =  DateTime.now().millisecondsSinceEpoch / 1000;
    //   _value = 1 * (map["stop"] - curr)  / (map["stop"] - map["start"]);
    //   if (_value < 0) {
    //     print("$curr $map");
    //   }
    // }
    // 100 / map["stop"] - map["start"] =
    // x / (map["stop"] - DateTime.now().millisecondsSinceEpoch / 1000);
    // final db = await DBProvider.db.database;
    // var res = await db.query("XMLTv",
    //   where: "channel = ? AND start <= ?",
    //   whereArgs: [widget.ch.id, DateTime.now().millisecondsSinceEpoch / 1000],
    //   orderBy: "start");
    // final item = res.isNotEmpty ? res.first : {};
    // _title = item["title"];
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_title == null) return SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_title, style: TextStyle(
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        LinearProgressIndicator(
          minHeight: 2,
          value: _value,
        ),
      ]);
  }
}
