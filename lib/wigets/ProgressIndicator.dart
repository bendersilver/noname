import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noname/models/Core.dart';
import 'package:noname/models/M3UItem.dart';

class Progress extends StatefulWidget {
  Progress({Key key, this.id}) : super(key: key);

  final int id;

  @override
  _Progress createState() => _Progress();
}

class _Progress extends State<Progress> {
  Timer _timer;
  ProgrammItem _item;

  update() {
    if (_item != Core.cls.curProgramm[widget.id]) {
      setState(() {
        _item = Core.cls.curProgramm[widget.id];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      update();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
