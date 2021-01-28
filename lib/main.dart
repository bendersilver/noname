import 'package:flutter/material.dart';
import 'package:noname/models/channel.dart';
import 'package:noname/models/database.dart';
import 'package:noname/models/playlist.dart';
import 'package:noname/wigets/PlaylistItem.dart';
// import 'package:noname/wigets/chDialog.dart';
import 'package:noname/wigets/player.dart';
// import 'package:mx_player_plugin/mx_player_plugin.dart';

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
        primarySwatch: Colors.blue,
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
  List<CH> _items;

  @override
  void initState() {
    super.initState();
    _items = [];
    getItems();
  }

  Future<void> getItems() async {
    final db = await DBProvider.db.database;
    DBProvider.db.httpM3UUpdate();
    var res = await db.query("PlaylistItem", orderBy: "name");
    _items = res.isNotEmpty ? res.map((c) => CH.fromMap(c)).toList() : [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: getBody()
        );
  }

  Widget getBody() {
    if (_items.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (ctx, ix) {
        CH ch = _items[ix];
        return PlaylistItem(ch: ch);
      },
    );
  }
}
