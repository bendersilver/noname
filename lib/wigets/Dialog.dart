import 'package:flutter/material.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/M3UItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:noname/wigets/ListM3U.dart';

class DialogAction extends StatefulWidget {
  DialogAction({Key key, this.ch}) : super(key: key);

  final M3UItem ch;

  @override
  _DialogAction createState() => _DialogAction();
}

class _DialogAction extends State<DialogAction> {
  ProgrammItem p;
  @override
  void initState() {
    p = Core.cls.curProgramm[widget.ch.id];
    if (p == null) p = new ProgrammItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(widget.ch.hideCh
                      ? Icons.visibility
                      : Icons.visibility_off),
                  title:
                      Text((widget.ch.hideCh ? "Show" : "Hide") + " channel"),
                  onTap: () {
                    widget.ch.hideCh = !widget.ch.hideCh;
                    Core.cls.toggleHide(widget.ch.id, widget.ch.hideCh);
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text(widget.ch.name),
                  leading: SizedBox(
                    height: 64.0,
                    width: 64.0,
                    child: CachedNetworkImage(
                      imageUrl: widget.ch.logo,
                      placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.image)),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  subtitle: ProgrammWidget(item: widget.ch),
                ),
                p.desc != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(p.desc),
                      )
                    : SizedBox.shrink(),
                p.icon != null ? Image.network(p.icon) : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<T> showDialogAction<T>({BuildContext context, M3UItem ch}) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogAction(ch: ch);
      });
}
