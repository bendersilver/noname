import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:m3u/m3u.dart';
import 'package:xml/xml_events.dart';

import 'package:noname/models/M3UItem.dart';


const M3U_URL = "http://ott.tv.planeta.tc/plst.m3u?4k";
const XMLTV_URL =
    "http://ott.tv.planeta.tc/epg/program.xml?fields=desc&fields=icon";

class Core {
  Database _database;
  List<M3UItem> items = [];
  Function wigetUpdate;
  Timer _timer;
  int _timestamp;

  Core._();
  static final Core cls = Core._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    String path = p.join(dir.path, "PlanetaM3U.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE PlaylistItem ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT NOT NULL,"
          "url TEXT NOT NULL,"
          "logo TEXT NOT NULL,"
          "groupCh TEXT,"
          "player TEXT DEFAULT 'default',"
          "newCh INTEGER NOT NULL DEFAULT 1,"
          "hideCh INTEGER NOT NULL DEFAULT 0,"
          "delCh INTEGER NOT NULL DEFAULT 0,"
          "number INTEGER NOT NULL DEFAULT 0"
          ")");
      await db.execute("CREATE TABLE XMLTv ("
          "start BIGINT NOT NULL,"
          "stop BIGINT NOT NULL,"
          "channel INTEGER NOT NULL,"
          "title TEXT NOT NULL,"
          "desc TEXT,"
          "icon TEXT"
          ")");
      await db.execute("CREATE TABLE settings ("
          "key TEXT PRIMARY KEY,"
          "val TEXT NOT NULL"
          ")");
    });
  }

  bool contains(int id) {
    for (final e in items) {
      if (e.id == id) return true;
    }
    return false;
  }

  Future<void> fetchM3U() async {
    final response = await http.get(M3U_URL);
    if (response.statusCode == 200) {
      final db = await database;
      var res = await db.query("PlaylistItem");
      items = res.isNotEmpty ? res.map((c) => M3UItem.fromMap(c)).toList() : [];
      int count = items.length;
      if (count > 0) {
        wigetUpdate();
      }

      final m3u = await M3uParser.parse(response.body);
      Batch batch = db.batch();
      for (final e in m3u) {
        M3UItem item = M3UItem.fromEntry(e);
        if (contains(item.id)) {
          batch.update("PlaylistItem",
              item.updateMap(),
              where: 'id = ?',
              whereArgs: [item.id]);
        } else {
          count++;
          batch.insert('PlaylistItem', item.createMap(count));
          items.add(item);
        }
      }
      await batch.commit(noResult: true);
    } else {
      print(response.statusCode);
    }
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) => updateProgramm());
  }
  
  Future<void> updateProgramm() async {
    print("updateProgramm");
    _timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
    final db = await database;
    var res = await db.query("XMLTv",
        where: "stop >= ? AND start <= ?",
        whereArgs: [_timestamp, _timestamp],
        orderBy: "start");
    if (res.isEmpty) {
      fetchXMLTv();
      return ;
    }
    res.forEach((e) {
      ProgrammItem p = ProgrammItem.fromMap(e);
      for (var i in items) {
        if (i.id == p.channel) {
          i.programm = p;
          if (i.wigetUpdate != null) i.wigetUpdate();
        }
      }
    });
  }

  Future<void> fetchXMLTv() async {
    final request = await HttpClient().getUrl(Uri.parse(XMLTV_URL));
    final response = await request.close();
    if (response.statusCode == 200) {
      final db = await database;
      Batch batch = db.batch();
      batch.delete("XMLTv");
      response
          .transform(utf8.decoder)
          .toXmlEvents()
          .selectSubtreeEvents((event) => event.name == "programme")
          .toXmlNodes()
          .flatten()
          .forEach((node) {
        batch.insert('XMLTv', {
          "start": toTimestamp(node.getAttribute("start")),
          "stop": toTimestamp(node.getAttribute("stop")),
          "channel": node.getAttribute("channel"),
          "title": node.getElement('title').text,
          "desc": node.getElement('desc')?.text,
          "icon": node.getElement('icon')?.getAttribute("src"),
        });
      });
      await batch.commit(noResult: true);
    } else {
      print(response.statusCode);
    }
  }

  int toTimestamp(String s) {
    return (DateTime.parse(s.substring(0, 8) + 'T' + s.substring(8))
            .millisecondsSinceEpoch / 1000).truncate();
  }
}