import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywork/active_work.dart';
import 'package:mywork/additional_ui.dart';
import 'package:mywork/counter.dart';
import 'package:mywork/head_title.dart';
import './tomato_bloc.dart';
import './work_state.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final tomatoBloc = BlocProvider.of<TomatoRecordBloc>(context);

    return Scaffold(
      // appBar: AppBar(title: Text('工作中')),
      body: BlocBuilder<ActiveTomatoBloc, Tomato>(
        builder: (context, tomato) {
          return SingleChildScrollView(
            child: Column(
              children: [
                HeadTitle(),
                ActiveWork(),
                AdditionalUI(),
                // WorkState(tomatos.last),
              ],
            ),
          );
        },
      ),
    );
  }
}
