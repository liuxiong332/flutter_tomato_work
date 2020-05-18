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
  TomatoStatus status = TomatoStatus.OnWork;
  TomatoStatus prevStatus = TomatoStatus.OnWork;

  Timer timer;

  void updateStatus() {
    final tomato = widget.tomato;
    prevStatus = status;
    var secs = DateTime.now().millisecondsSinceEpoch ~/ 1000 -
        tomato.startTime.millisecondsSinceEpoch ~/ 1000;
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
  void initState() {
    updateStatus();
    super.initState();
  }

  void cancelWork() {
    // ignore: close_sinks
    final bloc = BlocProvider.of<ActiveTomatoBloc>(context);
    // ignore: close_sinks
    final listbloc = BlocProvider.of<TomatoRecordBloc>(context);

    bloc.add(ResetActiveTomatoEvent());
    widget.tomato.stopTime = DateTime.now();
    listbloc.add(AddTomatoEvent(widget.tomato));
  }

  void showAlert() {
    Future.delayed(
      Duration.zero,
      () => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("恭喜你，你又完成了一个番茄任务，继续加油哦^_^"),
            actions: [
              FlatButton(
                child: Text("确定"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      ),
    );

    Future.delayed(Duration(minutes: 1), () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    if (prevStatus != status) {
      showAlert();
      if (status == TomatoStatus.End) {
        Future.delayed(Duration(seconds: 0), () {
          // ignore: close_sinks
          final listbloc = BlocProvider.of<TomatoRecordBloc>(context);
          listbloc.add(AddTomatoEvent(widget.tomato));
        });
      }
    }

    switch (status) {
      case TomatoStatus.OnWork:
        return OnWorkStatusView(
          leftDuration: Duration(seconds: leftSecs),
          startTime: widget.tomato.startTime,
          duration: widget.tomato.workDuration,
          workContent: widget.tomato.name,
          onStop: cancelWork,
        );
      case TomatoStatus.OnRest:
        return OnRestStatusView(
          duration: Duration(seconds: leftSecs),
          onStop: cancelWork,
        );
      case TomatoStatus.End:
        return EndWorkView();
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}

class DoingStatusView extends StatelessWidget {
  DoingStatusView({this.duration, this.text, this.workContent, this.onStop});

  final Duration duration;
  final String text;
  final String workContent;
  final Function onStop;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<ActiveTomatoBloc>(context);
    // ignore: close_sinks
    final listbloc = BlocProvider.of<TomatoRecordBloc>(context);
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
        if (workContent != null)
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 20),
            child: Text(
              workContent,
              style: TextStyle(fontSize: 24, color: Colors.blue[400]),
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
              onPressed: () => onStop(),
            ),
          ),
        ),
      ],
    );
  }
}

class OnWorkStatusView extends StatelessWidget {
  OnWorkStatusView(
      {this.leftDuration,
      this.duration,
      this.startTime,
      this.workContent,
      this.onStop});

  final Duration leftDuration;

  final DateTime startTime;
  final Duration duration;
  final String workContent;
  final Function onStop;

  @override
  Widget build(BuildContext context) {
    return DoingStatusView(
      duration: leftDuration,
      text:
          "你需要在 ${dateTimeToHM(startTime)} - ${dateTimeToHM(startTime.add(duration))}完成如下事情，享受沉浸式工作，加油哦^_^",
      workContent: workContent,
      onStop: onStop,
    );
  }
}

class OnRestStatusView extends StatelessWidget {
  OnRestStatusView({this.duration, this.onStop});

  final Duration duration;
  final Function onStop;

  @override
  Widget build(BuildContext context) {
    return DoingStatusView(
      duration: duration,
      text: "休息，休息一下，尽情享受美好时光吧^_^",
      onStop: onStop,
    );
  }
}

class EndWorkView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<ActiveTomatoBloc>(context);
    return Flex(
      direction: Axis.vertical,
      children: [
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "当前任务已经结束",
                  style: TextStyle(fontSize: 32, color: Colors.orangeAccent),
                )),
          ],
        ),
        RaisedButton(
          child: Text(
            "重新开始任务",
            style: TextStyle(fontSize: 14),
          ),
          color: Color(0xFF006dcc),
          highlightColor: Color(0xFF0044cc),
          textColor: Colors.white,
          onPressed: () => bloc.add(ResetActiveTomatoEvent()),
        )
      ],
    );
  }
}
