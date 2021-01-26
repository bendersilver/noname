import 'package:flutter/material.dart';
import 'package:noname/models/channel.dart';
import 'package:noname/models/playlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoNapmeApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Planeta playlist'),
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
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
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
                                        title: Text(
                                            (ch.hideCh ? "Show" : "Hide") +
                                                " channel"),
                                        onTap: () {
                                          ch.hideCh = !ch.hideCh;
                                          Playlist.cls.dumpChannels();
                                          setState(() {
                                            _setState(() {});
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
                      },
                    );
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
                  leading: SizedBox(
                      height: 64.0,
                      width: 64.0,
                      child: Image.network(ch.logo)));
            },
          );
        },
      ),
    );
  }
}
