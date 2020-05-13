import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mywork/tomato_bloc.dart';

enum TomatoStatus {
  OnWork, // 正在工作中
  OnRest, // 正在休息中
  End, // 结束
}

class WorkState extends StatefulWidget {
  WorkState(this.tomato);

  final Tomato tomato;

  @override
  State<StatefulWidget> createState() => WorkStateState(tomato);
}

class WorkStateState extends State<WorkState> {
  WorkStateState(Tomato tomato) : tomato = tomato {
    updateStatus();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        updateStatus();
      });
    });
  }

  final Tomato tomato;
  int expireSecs = 0;
  TomatoStatus status;

  Timer timer;

  void updateStatus() {
    var secs = DateTime.now().second - tomato.startTime.second;
    if (secs < tomato.workDuration.inSeconds) {
      status = TomatoStatus.OnWork;
      expireSecs = secs;
    } else if (secs <
        tomato.workDuration.inSeconds + tomato.restDuration.inSeconds) {
      status = TomatoStatus.OnRest;
      expireSecs = secs - tomato.workDuration.inSeconds;
    } else {
      status = TomatoStatus.End;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TomatoStatus.OnWork:
        return Column(
          children: [
            Text(
              "你正在应用任务",
              style: TextStyle(
                color: Color.fromARGB(255, 200, 200, 0),
                fontSize: 40,
              ),
            ),
            Text(
              "您已经工作${expireSecs ~/ 60}:${expireSecs % 60}",
              style: TextStyle(
                color: Color(0xFF8c0032),
                fontSize: 42,
              ),
            ),
            Text(
              "享受沉浸式工作",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color(0xFF003c8f),
              ),
            ),
          ],
        );
      case TomatoStatus.OnRest:
        return Column(
          children: [
            Text("你正在休息"),
            Text("您已经休息${expireSecs ~/ 60}:${expireSecs % 60}"),
            Text("尽情休息吧"),
          ],
        );
      case TomatoStatus.End:
        return Column(
          children: [
            Text("当前任务已经结束"),
          ],
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
