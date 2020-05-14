import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  Counter({@required this.duration, this.isActive = false});

  final Duration duration;
  final bool isActive;

  @override
  State<StatefulWidget> createState() => CounterState(duration, isActive);
}

class CounterState extends State<Counter> {
  CounterState(this.duration, this.isActive);

  final Duration duration;
  bool isActive = false;

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  @override
  Widget build(BuildContext context) {
    final minutes = duration.inSeconds ~/ 60;
    final secs = duration.inSeconds % 60;
    final show_time = "${twoDigits(minutes)}:${twoDigits(secs)}";
    return Column(
      children: [
        Text(
          show_time,
          style: TextStyle(
            fontSize: 160,
            color: isActive ?? false ? Color(0xFF3C8CFF) : Color(0xFF999999),
          ),
        ),
        LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(Colors.blue),
          value: isActive ?? false ? null : 0,
        )
      ],
    );
  }
}
