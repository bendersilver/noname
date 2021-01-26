import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m3u/m3u.dart';
import 'package:noname/models/channel.dart';

import 'package:shared_preferences/shared_preferences.dart';

const PLAYLIST_URL = "http://ott.tv.planeta.tc/plst.m3u?4k";
// const PLAYLIST_URL = "http://188.226.52.142/plst.m3u";

class Playlist {
  SharedPreferences _prefs;
  Map<int, CH> _allMap;

  Playlist._();

  static final Playlist cls = Playlist._();

  Future<List<CH>> getData() async {
    if (_allMap == null) await _initAll();
    return _allMap.values.toList();
  }

  _initAll() async {
    _prefs = await SharedPreferences.getInstance();
    String data = _prefs.getString("channels");
    _allMap = {};
    if (data != null) {
      for (Map<String, dynamic> i in jsonDecode(data)) {
        CH ch = CH.fromMap(i);
        _allMap[ch.id] = ch;
      }
    }
    await httpUpdate();
  }

  httpUpdate() async {
    final response = await http.get(PLAYLIST_URL);
    if (response.statusCode == 200) {
      final m3u = await M3uParser.parse(response.body);
      int order = _allMap.length;
      for (final entry in m3u) {
        CH ch = CH.fromEntry(entry);
        if (!_allMap.containsKey(ch.id)) {
          order++;
          ch.number = order;
          _allMap[ch.id] = ch;
        } else {
          _allMap[ch.id].name = ch.name;
          _allMap[ch.id].logo = ch.logo;
          _allMap[ch.id].url = ch.url;
        }
        ch = null;
      }
      List<dynamic> d = [];
      _allMap.forEach((k, v) {
        d.add(v.toMap());
      });
      _prefs.setString("channels", jsonEncode(d));
    } else {
      print(response.statusCode);
    }
  }
}
