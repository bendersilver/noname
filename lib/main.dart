import 'package:flutter/material.dart';
import 'package:noname/models/channel.dart';
import 'package:noname/models/playlist.dart';
import 'package:noname/wigets/chDialog.dart';
import 'package:noname/wigets/player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      Player.routeName: (BuildContext context) =>
          new Player(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: Playlist.cls.getData(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snap.data.length,
            itemBuilder: (ctx, ix) {
              CH ch = snap.data[ix];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, Player.routeName, arguments: {"id": ch.id});
                },
                  key: UniqueKey(),
                  title: Text(
                    ch.name,
                    style: TextStyle(
                      color: ch.hideCh ? Colors.grey : null,
                      fontWeight: FontWeight.w500,
                      decoration: ch.hideCh ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      chDialog(context, ch, setState);
                    }
                  ),
                  leading: SizedBox(
                      height: 64.0,
                      width: 64.0,
                      child: Image.network(ch.logo),
                    ),
                  );
            },
          );
        },
      ),
    );
  }
}



class MyItemsPage extends StatefulWidget {
  MyItemsPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/MyItemsPage";

  final String title;

  @override
  _MyItemsPageState createState() => new _MyItemsPageState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   MyItemsPage.routeName: (BuildContext context) => new MyItemsPage(title: "MyItemsPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, MyItemsPage.routeName);
///

class _MyItemsPageState extends State<MyItemsPage> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) print(arguments['id']);

    var button = new IconButton(
        icon: new Icon(Icons.arrow_back), onPressed: _onButtonPressed);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[new Text('Item1'), new Text('Item2'), button],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _onFloatingActionButtonPressed() {}

  void _onButtonPressed() {
    Navigator.pop(context);
  }
}
