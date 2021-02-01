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
      home: MyHomePage(),
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
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: Core.cls.initial(),
          builder: (ctx, s) {
            if (s.hasData) {
              return new BaseListView();
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
