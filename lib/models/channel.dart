import 'package:m3u/m3u.dart';

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
        group: json["group"],
        player: json["player"],
        newCh: json["newCh"],
        hideCh: json["hideCh"],
        delCh: json["delCh"],
        number: json["number"],
      );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "url": url,
      "logo": logo,
      "group": group,
      "player": player,
      "newCh": newCh,
      "hideCh": hideCh,
      "delCh": delCh,
      "number": number,
    };
  }
}
