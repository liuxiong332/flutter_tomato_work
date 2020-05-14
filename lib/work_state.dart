import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/tomato_bloc.dart';
import './counter.dart';

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
        return OnWorkStatusView();
      case TomatoStatus.OnRest:
        return OnRestStatusView();
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
    return Column(
      children: [
        Counter(
          duration: duration,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
          ),
        ),
        BlocBuilder<ActiveTomatoBloc, Tomato>(
          builder: (context, state) => SizedBox(
            width: 100,
            height: 30,
            child: RaisedButton(
              child: Text(
                "取消",
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
  @override
  Widget build(BuildContext context) {
    return DoingStatusView(
      duration: Duration(minutes: 20),
      text: "你需要在 11:07 - 11:32完成如下事情，享受沉浸式工作，加油哦^_^",
    );
  }
}


class OnRestStatusView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DoingStatusView(
      duration: Duration(minutes: 20),
      text: "你正在休息，尽情享受美好时光吧~",
    );
  }
}