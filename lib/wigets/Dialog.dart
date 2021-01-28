import 'package:flutter/material.dart';
import 'package:noname/models/channel.dart';

class DialogAction extends StatefulWidget {
  DialogAction({Key key, this.ch}) : super(key: key);

  final CH ch;

  @override
  _DialogAction createState() => _DialogAction();
}

class _DialogAction extends State<DialogAction> {
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
                    setState(() {});
                  },
                ),
                ListTile(
                  title: Text(widget.ch.name),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<T> showDialogAction<T>({BuildContext context, CH ch}) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogAction(ch: ch);
      });
}
