import 'package:flutter/material.dart';

class HeadTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "Timer App",
            style: TextStyle(fontSize: 50),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            "之番茄工作法",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }
}
