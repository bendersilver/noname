import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/M3UItem.dart';
import 'package:noname/wigets/Dialog.dart';
import 'package:noname/wigets/player.dart';

class BaseListView extends StatefulWidget {
  @override
  _BaseListView createState() => _BaseListView();
}

class _BaseListView extends State<BaseListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Core.cls.items.length,
        itemBuilder: (ctx, ix) {
          M3UItem item = Core.cls.items[ix];
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.hideCh || widget.item.delCh) return SizedBox.shrink();
    return ListTile(
        onTap: () {
          Navigator.pushNamed(context, Player.routeName,
              arguments: {"ch": widget.item});
        },
        onLongPress: () async {
          await showDialogAction(context: context, ch: widget.item);
          setState(() {});
        },
        leading: SizedBox(
          height: 64.0,
          width: 64.0,
          child: CachedNetworkImage(
            imageUrl: widget.item.logo,
            placeholder: (context, url) => CircleAvatar(
                backgroundColor: Colors.transparent, child: Icon(Icons.image)),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(
          widget.item.name,
          style: TextStyle(
            color: widget.item.hideCh ? Colors.grey : null,
            fontWeight: FontWeight.w600,
            decoration: widget.item.hideCh ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: ProgrammWidget(item: widget.item));
  }
}

class ProgrammWidget extends StatefulWidget {
  ProgrammWidget({Key key, this.item}) : super(key: key);

  final M3UItem item;

  @override
  _ProgrammWidget createState() => _ProgrammWidget();
}

class _ProgrammWidget extends State<ProgrammWidget> {
  Timer _timer;
  ProgrammItem _item;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  update() {
    if (_item != Core.cls.curProgramm[widget.item.id]) {
      setState(() {
        _item = Core.cls.curProgramm[widget.item.id];
      });
    }
  }

  @override
  void initState() {
    update();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      update();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_item == null) return SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        _item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      LinearProgressIndicator(
        minHeight: 3,
        value: _item.progress > 0 ? _item.progress : null,
      ),
    ]);
  }
}
