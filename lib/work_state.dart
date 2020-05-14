import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/tomato_bloc.dart';
import './counter.dart';
import './utils.dart';

enum TomatoStatus {
  OnWork, // 正在工作中
  OnRest, // 正在休息中
  End, // 结束
}

class WorkState extends StatefulWidget {
  WorkState(this.tomato);

  final Tomato tomato;

  @override
  State<StatefulWidget> createState() => WorkStateState();
}

class WorkStateState extends State<WorkState> {
  WorkStateState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        updateStatus();
      });
    });
  }

  int leftSecs = 0;
  TomatoStatus status;

  Timer timer;

  void updateStatus() {
    final tomato = widget.tomato;
    var secs = DateTime.now().millisecondsSinceEpoch ~/ 1000 - tomato.startTime.millisecondsSinceEpoch ~/ 1000;
    if (secs < tomato.workDuration.inSeconds) {
      status = TomatoStatus.OnWork;
      leftSecs = tomato.workDuration.inSeconds - secs;
    } else if (secs <
        tomato.workDuration.inSeconds + tomato.restDuration.inSeconds) {
      status = TomatoStatus.OnRest;
      leftSecs =
          tomato.workDuration.inSeconds + tomato.restDuration.inSeconds - secs;
    } else {
      status = TomatoStatus.End;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TomatoStatus.OnWork:
        return OnWorkStatusView(
          leftDuration: Duration(seconds: leftSecs),
          startTime: widget.tomato.startTime,
          duration: widget.tomato.workDuration,
        );
      case TomatoStatus.OnRest:
        return OnRestStatusView(duration: Duration(seconds: leftSecs));
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

class DoingStatusView extends StatelessWidget {
  DoingStatusView({this.duration, this.text});

  final Duration duration;
  final String text;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<ActiveTomatoBloc>(context);
    print("duration ${duration.inSeconds}");
    return Column(
      children: [
        Counter(
          duration: duration,
          isActive: true,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ),
        BlocBuilder<ActiveTomatoBloc, Tomato>(
          builder: (context, state) => SizedBox(
            width: 100,
            height: 30,
            child: RaisedButton(
              child: Text(
                "停止",
                style: TextStyle(fontSize: 14),
              ),
              color: Color(0xFF006dcc),
              highlightColor: Color(0xFF0044cc),
              textColor: Colors.white,
              onPressed: () => bloc.add(ResetActiveTomatoEvent()),
            ),
          ),
        ),
      ],
    );
  }
}

class OnWorkStatusView extends StatelessWidget {
  OnWorkStatusView({this.leftDuration, this.duration, this.startTime});

  final Duration leftDuration;

  final DateTime startTime;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return DoingStatusView(
      duration: leftDuration,
      text:
          "你需要在 ${dateTimeToHM(startTime)} - ${dateTimeToHM(startTime.add(duration))}完成如下事情，享受沉浸式工作，加油哦^_^",
    );
  }
}

class OnRestStatusView extends StatelessWidget {
  OnRestStatusView({this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return DoingStatusView(
      duration: duration,
      text: "休息，休息一下，尽情享受美好时光吧^_^",
    );
  }
}
