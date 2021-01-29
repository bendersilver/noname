
import 'package:m3u/m3u.dart';

class M3UItem {
  
  int id;
  String name;
  String url;
  String logo;
  String group;
  String player;
  bool newCh;
  bool hideCh;
  bool delCh;
  int number;
  ProgrammItem programm;
  Function wigetUpdate; 

  M3UItem({
    this.id,
    this.name,
    this.url,
    this.logo,
    this.group,
    this.player,
    this.newCh,
    this.hideCh,
    this.delCh,
    this.number,
  });
  
  Map<String, dynamic> updateMap() {
    return {
      "name": name,
      "url": url,
      "logo": logo,
      "groupCh": group,
    };
  }

  Map<String, dynamic> createMap(int n) {
    Map<String, dynamic> item = updateMap();
    item["id"] = id;
    item["number"] = n;
    return item;
  }

  factory M3UItem.fromEntry(M3uGenericEntry e) => new M3UItem(
        id: int.tryParse(e.attributes["tvg-id"]),
        name: e.title,
        url: e.link,
        logo: e.attributes["tvg-logo"],
        group: e.attributes["group-title"],
        player: 'default',
        newCh: true,
        hideCh: false,
        delCh: false,
      );

  factory M3UItem.fromMap(Map<String, dynamic> json) => new M3UItem(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        logo: json["logo"],
        group: json["groupCh"],
        player: json["player"],
        newCh: json["newCh"] == 1,
        hideCh: json["hideCh"] == 1,
        delCh: json["delCh"] == 1,
        number: json["number"],
      );
}


class ProgrammItem {
  int channel;
  int start;
  int stop;
  String title;
  String desc;
  String icon;
  Function fn;
  
  ProgrammItem({
    this.channel,
    this.start,
    this.stop,
    this.title,
    this.desc,
    this.icon,
  });

  double get progress {
    final curr = DateTime.now().millisecondsSinceEpoch / 1000;
    return (this.stop - curr) / (this.stop - this.start);
  }

  update(Map<String, dynamic> json) {
    this.start = json["start"];
    this.stop = json["stop"];
    this.title = json["title"];
    this.desc = json["desc"];
    this.icon = json["icon"];
    if (fn != null) fn();
  }


  factory ProgrammItem.fromMap(Map<String, dynamic> json) => new ProgrammItem(
        channel: json["channel"],
        start: json["start"],
        stop: json["stop"],
        title: json["title"],
        desc: json["desc"],
        icon: json["icon"],
      );
}