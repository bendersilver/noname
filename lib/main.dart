import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/M3UItem.dart';
import 'package:noname/models/channel.dart';
import 'package:noname/models/database.dart';
import 'package:noname/wigets/ListM3U.dart';
import 'package:noname/wigets/PlaylistItem.dart';
import 'package:noname/wigets/player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      Player.routeName: (BuildContext context) => new Player(),
    };
    return MaterialApp(
      title: 'NoNapmeApp',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Planeta playlist'),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new BaseListView()
        );
  }
}
