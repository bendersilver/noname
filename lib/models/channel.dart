import 'package:m3u/m3u.dart';
import 'package:noname/models/database.dart';

class CH {
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

  CH({
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

  static int sort(CH a, b, String field) {
    int val;
    switch (field) {
      case "num":
        val = a.number.compareTo(b.number);
        break;
      case "name":
        val = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        break;
      default:
        val = a.id.compareTo(b.id);
    }
    return val;
  }

  // bool get isAdult => (DateTime.now().year - birthYear) > 18;

  factory CH.fromEntry(M3uGenericEntry e) => new CH(
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

  factory CH.fromMap(Map<String, dynamic> json) => new CH(
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

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "url": url,
      "logo": logo,
      "groupCh": group,
      "player": player,
      "newCh": newCh ? 1 : 0,
      "hideCh": hideCh ? 1 : 0,
      "delCh": delCh ? 1 : 0,
      "number": number,
    };
  }

  Future<void> updateDB() async {
     final db = await DBProvider.db.database;
     await db.update("PlaylistItem",
        {
          "player": this.player,
          "newCh": this.newCh ? 1 : 0,
          "hideCh": this.hideCh ? 1 : 0,
          "number": this.number,
        },
        where: 'id = ?', whereArgs: [this.id]);
  }
}
