import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/tomato_bloc.dart';
import 'package:mywork/work_state.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tomatoBloc = BlocProvider.of<TomatoBloc>(context);

    return Scaffold(
      // appBar: AppBar(title: Text('工作中')),
      body: BlocBuilder<TomatoBloc, List<Tomato>>(
        builder: (context, tomatos) {
          return Center(
            child: WorkState(tomatos.last),
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
