import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noname/models/channel.dart';
import 'package:mx_player_plugin/mx_player_plugin.dart';
import 'package:noname/wigets/Dialog.dart';
import 'package:noname/wigets/player.dart';

class PlaylistItem extends StatefulWidget {
  PlaylistItem({Key key, this.ch}) : super(key: key);

  final CH ch;

  @override
  _PlaylistItem createState() => _PlaylistItem();
}

class _PlaylistItem extends State<PlaylistItem> {
  @override
  Widget build(BuildContext context) {
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
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.ch.group),
        LinearProgressIndicator(
          minHeight: 2,
          value: 0.9,
        ),
      ]),
      onLongPress: () async {
        await showDialogAction(context: context, ch: widget.ch);
        setState(() {
          print("object");
        });
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
                arguments: {"id": widget.ch.id});
        }
      },
    );
  }
}

// ListTile(
//                 onTap: () async {
//                   switch (ch.player) {
//                     case "vlc":
//                       await PlayerPlugin.openWithVlcPlayer(ch.url);
//                       break;
//                     case "mx":
//                       await PlayerPlugin.openWithMxPlayer(ch.url, "");
//                       break;
//                     default:
//                       Navigator.pushNamed(context, Player.routeName,
//                           arguments: {"id": ch.id});
//                   }
//                 },
//                 key: UniqueKey(),
//                 title: Text(
//                   ch.name,
//                   style: TextStyle(
//                     color: ch.hideCh ? Colors.grey : null,
//                     fontWeight: FontWeight.w500,
//                     decoration: ch.hideCh ? TextDecoration.lineThrough : null,
//                   ),
//                 ),
//                 trailing: IconButton(
//                     icon: Icon(Icons.more_vert),
//                     onPressed: () {
//                       chDialog(context, ch, setState);
//                     }),
//                 leading: SizedBox(
//                   height: 64.0,
//                   width: 64.0,
//                   child: Image.network(ch.logo),
//                 ),
//               );