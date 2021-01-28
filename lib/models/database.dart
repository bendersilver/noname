import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:noname/models/channel.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:m3u/m3u.dart';
import 'package:xml/xml.dart';

const M3U_URL = "http://ott.tv.planeta.tc/plst.m3u?4k";


class DBProvider {
  Database _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

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
    });
  }

  Future<Map<int, bool>> idsM3U() async {
    final db = await database;
    var res = await db.rawQuery("SELECT id FROM PlaylistItem");
    if (res.isEmpty) return {};
    return Map.fromIterable(res, key: (v) => v["id"], value: (_) => true);
  }

  parseDate(String s) {
    return DateTime.parse(s.substring(0, 8) +
            'T' +
            s.substring(8))
        .millisecondsSinceEpoch / 1000;
  }

  Future<void> httpXMLTvUpdate(Map<int, bool> ids) async {
    // for (int id in ids.keys) {
      // final response = await http.get(
      //   "http://ott.tv.planeta.tc/epg/program.xml?fields=desc&fields=icon",
      //   );
        
      // if (response.statusCode == 200) {
      //   var doc =  XmlDocument.parse(utf8.decode(response.bodyBytes));
      //   var nods =doc.findAllElements('programme');
      //   for (var node in nods) {
      //     print(parseDate(node.getAttribute("start")));
      //     // print(DateFormat('yyyyMMddHHmmss +5000').parse(node.getAttribute("start")));
      //     // DateFormat('HH:mm a');
      //   // print(node.getAttribute("start"));
      //   // print(node.getAttribute("stop"));
      //   // print(node.getAttribute("channel"));
      //     // print(node.getElement('title').text);
      //     // print(node.getElement('desc').text);
      //     // print(node.getElement('icon').getAttribute("src"));
      //   }
      // }
    // }
  }

  httpM3UUpdate() async {
    final response = await http.get(M3U_URL);
    if (response.statusCode == 200) {
      final db = await database;
      Map<int, bool> ids = await idsM3U();
      httpXMLTvUpdate(ids);
      int order = ids.length;

      final m3u = await M3uParser.parse(response.body);
      Batch batch = db.batch();
      for (final e in m3u) {
        CH ch = CH.fromEntry(e);
        if (ids.containsKey(ch.id)) {
          batch.update("PlaylistItem",
            {
              "name": ch.name,
              "url": ch.url,
              "logo": ch.logo,
              "groupCh": ch.group
            },
            where: 'id = ?', whereArgs: [ch.id]);
        } else {
          print(order);
          order++;
          batch.insert('PlaylistItem',
          {
            "id": ch.id,
            "name": ch.name,
            "url": ch.url,
            "logo": ch.logo,
            "groupCh": ch.group,
            "number": order,
          });
        }
        ids[ch.id] = true;
      }
      await batch.commit(noResult: true);
    } else {
      print(response.statusCode);
    }
  }
}