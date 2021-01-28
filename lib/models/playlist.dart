import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m3u/m3u.dart';
import 'package:noname/models/channel.dart';

import 'package:shared_preferences/shared_preferences.dart';

const PLAYLIST_URL = "http://ott.tv.planeta.tc/plst.m3u?4k";

class Playlist {
  SharedPreferences _prefs;
  Map<int, CH> _allMap;
  String sortedField;

  Playlist._();

  static final Playlist cls = Playlist._();

  int len() {
    if (_allMap != null) return _allMap.length;
    return 0;
  }

  Future<List<CH>> getData() async {
    if (_allMap == null) await _initAll();
    return _allMap.values.toList();
    // data.sort((a, b) => CH.sort(a, b, sortedField));
    // return data;
  }

  CH getCh(int id) {
    return _allMap[id];
  }

  _initAll() async {
    _prefs = await SharedPreferences.getInstance();
    sortedField = _prefs.getString("sortedField");
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

  dumpChannels() async {
    List<dynamic> d = [];
    _allMap.forEach((k, v) {
      d.add(v.toMap());
    });
    _prefs.setString("channels", jsonEncode(d));
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
      dumpChannels();
    } else {
      print(response.statusCode);
    }
  }
}
