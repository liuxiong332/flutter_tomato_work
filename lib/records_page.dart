import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/tomato_bloc.dart';
import './utils.dart';

class RecordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("任务记录"),
      ),
      body: BlocBuilder<TomatoRecordBloc, List<Tomato>>(
        builder: (context, tomatos) {
          return ListView.builder(
              itemCount: tomatos.length,
              // itemExtent: 50.0, //强制高度为50.0
              itemBuilder: (BuildContext context, int index) {
                Tomato tomato = tomatos[index];
                var startStr = dateTimeToHM(tomato.startTime);
                var endStr = dateTimeToHM(tomato.startTime
                    .add(tomato.workDuration + tomato.restDuration));
                if (tomato.stopTime == null) {
                  return ListTile(
                    title: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      color: Color(0xFFdff0d8),
                      child: Text(
                        "任务: 【${tomato.name}】 时间$startStr - $endStr，恭喜你按时完成！",
                        style: TextStyle(
                          color: Color(0xFF468847),
                        ),
                      ),
                    ),
                  );
                } else {
                  var stopStr = dateTimeToHM(tomato.stopTime);
                  return ListTile(
                    title: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      color: Color(0xFFf2dede),
                      child: Text(
                        "任务: 【${tomato.name}】 时间$startStr - $endStr，但你【停止】于：$stopStr",
                        style: TextStyle(
                          color: Color(0xFFb94a48),
                        ),
                      ),
                    ),
                  );
                }
              });
        },
      ),
    );
  }
}
