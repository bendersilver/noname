import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noname/models/M3UItem.dart';

class Progress extends StatefulWidget {
  Progress({Key key, this.item}) : super(key: key);

  final M3UItem item;

  @override
  _Progress createState() => _Progress();
}

class _Progress extends State<Progress> {
  Timer _timer;
  double _progress;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _setProgress();
    });
  }

  _setProgress() {
    final int curr = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
    _progress = (curr - widget.item.p.start) /
        (widget.item.p.stop - widget.item.p.start);
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.item.pExists)
      return LinearProgressIndicator(
        minHeight: 3,
      );
    return LinearProgressIndicator(
      minHeight: 3,
      value: _progress,
    );
  }
}
