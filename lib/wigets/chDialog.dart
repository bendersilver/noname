import 'package:flutter/material.dart';
import 'package:noname/models/channel.dart';
import 'package:noname/models/playlist.dart';

chDialog(BuildContext ctx, CH ch, Function setState) {
  showDialog(
      context: ctx,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, _setState) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(ch.hideCh
                            ? Icons.visibility
                            : Icons.visibility_off),
                        title: Text((ch.hideCh ? "Show" : "Hide") + " channel"),
                        onTap: () {
                          ch.hideCh = !ch.hideCh;
                          Playlist.cls.dumpChannels();
                          setState(() {
                            _setState(() {});
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.play_circle_outline),
                        trailing: DropdownButton<String>(
                          value: ch.player,
                          items: <String>['default', 'vlc', 'mx']
                              .map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (v) async {
                            ch.player = v;
                            _setState(() {});
                            Playlist.cls.dumpChannels();
                            setState(() {});
                          },
                        ),
                        title: Text("Player"),
                        onTap: () async {
                          ch.hideCh = !ch.hideCh;

                          setState(() {
                            _setState(() {});
                            Playlist.cls.dumpChannels();
                          });
                        },
                      ),
                      ListTile(
                        title: Text(ch.name),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      });
}
