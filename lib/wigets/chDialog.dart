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
                      leading: Icon(
                          ch.hideCh ? Icons.visibility : Icons.visibility_off),
                      title: Text((ch.hideCh ? "Show" : "Hide") + " channel"),
                      onTap: () {
                        ch.hideCh = !ch.hideCh;
                        Playlist.cls.dumpChannels();
                        setState(() {
                          _setState(() {});
                        });
                      },
                    ),
                    ListTile(title: Text(ch.name),
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