import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/M3UItem.dart';
import 'package:noname/wigets/Dialog.dart';
import 'package:noname/wigets/Player.dart';
import 'package:noname/wigets/ProgressIndicator.dart';

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
  ListViewM3U({Key key, this.item, this.onTap}) : super(key: key);

  final M3UItem item;
  final Function onTap;

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
          if (widget.onTap == null) {
            Navigator.pushNamed(context, M3UPlayer.routeName,
                arguments: {"ch": widget.item});
          } else {
            widget.onTap();
          }
        },
        onLongPress: () async {
          await showDialogAction(context: context, ch: widget.item);
          setState(() {});
        },
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.item.pExists) return SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.item.p.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Progress(item: widget.item),
    ]);
  }
}
