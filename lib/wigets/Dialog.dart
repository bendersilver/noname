import 'package:flutter/material.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/M3UItem.dart';
import 'package:noname/wigets/ListM3U.dart';

class DialogAction extends StatefulWidget {
  DialogAction({Key key, this.ch}) : super(key: key);

  final M3UItem ch;

  @override
  _DialogAction createState() => _DialogAction();
}

class _DialogAction extends State<DialogAction> {
  @override
  void initState() {
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
                    child: Image.network(widget.ch.logo),
                  ),
                  subtitle: ProgrammWidget(item: widget.ch),
                ),
                widget.ch.p.desc != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(widget.ch.p.desc),
                      )
                    : SizedBox.shrink(),
                widget.ch.p.icon != null
                    ? Image.network(widget.ch.p.icon)
                    : SizedBox.shrink(),
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
