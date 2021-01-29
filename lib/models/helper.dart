import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

Future<Stream<XmlNode>> xmlStream(String u) async {
   final url = Uri.parse(u);
  final request = await HttpClient().getUrl(url);
  final response = await request.close();
  
  final stream = response.transform(utf8.decoder);
  return stream
        .toXmlEvents()
        .selectSubtreeEvents((event) => event.name == "programme")
      .toXmlNodes()
      .flatten();
      // .forEach((node) => print(node.getElement('title').text));
    // .forEach(print);
}