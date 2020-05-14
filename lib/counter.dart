import 'package:flutter/material.dart';
import './utils.dart';

class Counter extends StatefulWidget {
  Counter({@required this.duration, this.isActive = false});

  final Duration duration;
  final bool isActive;

  @override
  State<StatefulWidget> createState() => CounterState();
}

class CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    final minutes = widget.duration.inSeconds ~/ 60;
    final secs = widget.duration.inSeconds % 60;
    final showTime = "${twoDigits(minutes)}:${twoDigits(secs)}";
    return Column(
      children: [
        Text(
          showTime,
          style: TextStyle(
            fontSize: 160,
            color: widget.isActive ?? false ? Color(0xFF3C8CFF) : Color(0xFF999999),
          ),
        ),
        LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          value: widget.isActive ?? false ? null : 0,
        )
      ],
    );
  }
}
