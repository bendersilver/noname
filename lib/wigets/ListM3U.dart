import 'package:flutter/material.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/M3UItem.dart';

class BaseListView extends StatefulWidget {

  @override
  _BaseListView createState() => _BaseListView();
}


class _BaseListView extends State<BaseListView> {

  @override
  void initState() {
    super.initState();
    Core.cls.wigetUpdate = update;
    Core.cls.fetchM3U();
  }

  void update() {
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    if (Core.cls.items.isEmpty)
      return Center(child: CircularProgressIndicator());
    return  ListView.builder(
      itemCount: Core.cls.items.length,
      itemBuilder: (ctx, ix) {
        M3UItem item = Core.cls.items[ix];
        if (item.hideCh || item.delCh) return SizedBox.shrink(); 
        return new ListViewM3U(item: item);
      });
  }
}

class ListViewM3U extends StatefulWidget {
  ListViewM3U({Key key, this.item}) : super(key: key);

  final M3UItem item;

  @override
  _ListViewM3U createState() => _ListViewM3U();
}

class _ListViewM3U extends State<ListViewM3U> {

  @override
  void initState() {
    super.initState();
    widget.item.wigetUpdate = update;
  }

  void update() {
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    if (Core.cls.items.isEmpty) return Center(child: CircularProgressIndicator());
    return ListTile(
          leading: SizedBox(
              height: 64.0,
              width: 64.0,
              child: Image.network(widget.item.logo),
            ),
            title: Text(
              widget.item.name,
              style: TextStyle(
                color: widget.item.hideCh ? Colors.grey : null,
                fontWeight: FontWeight.w600,
                decoration:
                    widget.item.hideCh ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: widget.item.programm?.title == null ?
                        SizedBox.shrink() :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.item.programm.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            LinearProgressIndicator(
                              minHeight: 2,
                              value: widget.item.programm.progress > 0 ? widget.item.programm.progress : null,
                            ),
                          ]
                    ),
        );
  }
}