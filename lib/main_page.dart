import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/active_work.dart';
import 'package:mywork/counter.dart';
import 'package:mywork/head_title.dart';
import './tomato_bloc.dart';
import './work_state.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tomatoBloc = BlocProvider.of<TomatoRecordBloc>(context);

    return Scaffold(
      // appBar: AppBar(title: Text('工作中')),
      body: BlocBuilder<ActiveTomatoBloc, Tomato>(
        builder: (context, tomato) {
          return SingleChildScrollView(
            child: Column(
              children: [
                HeadTitle(),
                Counter(
                  duration: tomato != null ? tomato.workDuration : Duration(minutes: 20),
                ),
                WorkForm(),
                // WorkState(tomatos.last),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                tomatoBloc.add(AddTomatoEvent(Tomato(name: "Tomato1")));
              },
            ),
          ),
        ],
      ),
    );
  }
}
